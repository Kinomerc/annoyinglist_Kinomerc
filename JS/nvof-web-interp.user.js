// ==UserScript==
// @name         NVOF-Web · 브라우저 프레임 보간 (실험판)
// @namespace    https://github.com/mkyoon80-alt/nvof-potplayer
// @version      0.4.3
// @description  NVOF for PotPlayer의 방식(광학흐름 + Newton 역방향 워프 + 신뢰도 합성)을 WebGL2로 재구현한 브라우저용 프레임 보간기
// @author       (ported idea)
// @match        *://*/*
// @run-at       document-idle
// @grant        none
// ==/UserScript==

(function () {
  'use strict';
  if (window.__NWI_LOADED__) return;
  window.__NWI_LOADED__ = true;

  const VERSION = '0.4.3';
  const STORE_KEY = 'nwi.settings.v2';
  const DEFAULTS = {
    flowIter: 4,     // 레벨당 광학흐름 반복
    quality: 1,      // 0=성능, 1=균형, 2=품질
    conf: 40,        // 신뢰도 민감도
    sceneCut: true,
    auto: true,      // 페이지에서 영상이 재생되면 자동 시작
    panel: true,
  };
  const S = (() => {
    try { return Object.assign({}, DEFAULTS, JSON.parse(localStorage.getItem(STORE_KEY) || '{}')); }
    catch (_) { return Object.assign({}, DEFAULTS); }
  })();
  const saveS = () => { try { localStorage.setItem(STORE_KEY, JSON.stringify(S)); } catch (_) {} };

  const FLOW_BUDGET = [60000, 140000, 260000];
  const log = (...a) => { if (window.__NWI_DEBUG__) console.log('[NWI]', ...a); };

  /* ================================================================== *
   *  GLSL
   * ================================================================== */
  const VS = `#version 300 es
layout(location = 0) in vec2 aPos;
out vec2 vUv;
void main(){ vUv = aPos * 0.5 + 0.5; gl_Position = vec4(aPos, 0.0, 1.0); }`;

  const FS_LUMA = `#version 300 es
precision highp float;
uniform sampler2D uSrc;
in vec2 vUv; out vec4 o;
void main(){
  vec3 c = texture(uSrc, vUv).rgb;
  o = vec4(dot(c, vec3(0.299, 0.587, 0.114)), 0.0, 0.0, 1.0);
}`;

  const FS_DOWN = `#version 300 es
precision highp float;
uniform sampler2D uSrc;
uniform vec2 uTexel;
in vec2 vUv; out vec4 o;
void main(){
  float s = 0.0;
  s += texture(uSrc, vUv + vec2(-uTexel.x, -uTexel.y)).r;
  s += texture(uSrc, vUv + vec2( uTexel.x, -uTexel.y)).r;
  s += texture(uSrc, vUv + vec2(-uTexel.x,  uTexel.y)).r;
  s += texture(uSrc, vUv + vec2( uTexel.x,  uTexel.y)).r;
  o = vec4(s * 0.25, 0.0, 0.0, 1.0);
}`;

  const FS_UP = `#version 300 es
precision highp float;
uniform sampler2D uSrc;
in vec2 vUv; out vec4 o;
void main(){
  // 거친 레벨의 흐름(텍셀 단위)을 2배로 확장
  o = vec4(texture(uSrc, vUv).rg * 2.0, 0.0, 1.0);
}`;

  // 광학흐름 1회 반복 (Lucas-Kanade + 평탄 영역 정규화)
  const FS_FLOW = `#version 300 es
precision highp float;
uniform sampler2D uP;
uniform sampler2D uC;
uniform sampler2D uF;
uniform vec2  uTexel;
uniform float uStep;
uniform float uReg;
in vec2 vUv; out vec4 o;

void main(){
  vec2 uv = vUv;
  vec2 d  = texture(uF, uv).rg;
  vec2 pw = uv + d * uTexel;

  float A = 0.0, B = 0.0, C = 0.0, D0 = 0.0, D1 = 0.0;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 off = vec2(float(i), float(j)) * uTexel;
      vec2 q  = pw + off;
      vec2 qu = uv + off;
      // 각 샘플 위치에서의 기울기 (창 전체 구조 텐서)
      float gx = texture(uP, q + vec2(uTexel.x, 0.0)).r
               - texture(uP, q - vec2(uTexel.x, 0.0)).r;
      float gy = texture(uP, q + vec2(0.0, uTexel.y)).r
               - texture(uP, q - vec2(0.0, uTexel.y)).r;
      vec2 g = vec2(gx, gy) * 0.5;
      float it = texture(uC, qu).r - texture(uP, q).r;
      A += g.x * g.x;  B += g.x * g.y;  C += g.y * g.y;
      D0 += it * g.x;  D1 += it * g.y;
    }
  }

  float det = A * C - B * B;
  vec2 delta = vec2(0.0);
  if (det > 1e-8) delta = vec2(C * D0 - B * D1, A * D1 - B * D0) / det;

  float dl = length(delta);
  if (dl > uStep) delta *= uStep / dl;

  // 평탄 영역/에지(aperture problem)로 제약이 없는 곳은 넓은 이웃 흐름으로 확산
  vec2 navg = vec2(0.0);
  for (int j = -2; j <= 2; j++) {
    for (int i = -2; i <= 2; i++) {
      navg += texture(uF, uv + vec2(float(i), float(j)) * uTexel).rg;
    }
  }
  navg /= 25.0;

  vec2 nd = d + delta;
  float flatness = det / (det + 0.004);
  nd = mix(nd, navg, mix(uReg * 0.45, uReg, flatness));
  nd = clamp(nd, vec2(-256.0), vec2(256.0));
  o = vec4(nd, 0.0, 1.0);
}`;

  // 중간 프레임 합성: Newton 2회 정제 + 신뢰도 블렌딩
  const FS_SYNTH = `#version 300 es
precision highp float;
uniform sampler2D uA;
uniform sampler2D uB;
uniform sampler2D uF;
uniform vec2  uFlowTexel;
uniform vec2  uOff;
uniform vec2  uSize;
uniform float uT;
uniform float uK;
uniform float uOutside;
in vec2 vUv; out vec4 o;

void main(){
  vec2 uv = (vUv - uOff) / uSize;
  if (uOutside > 0.5) {
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
      o = vec4(0.0, 0.0, 0.0, 1.0); return;
    }
  } else {
    uv = clamp(uv, 0.0, 1.0);
  }

  vec2 f  = texture(uF, uv).rg * uFlowTexel;   // prev -> cur (역방향 흐름)
  vec2 xa = uv + uT * f;
  vec2 xb = xa - f;

  for (int i = 0; i < 2; i++) {
    vec2 f2 = texture(uF, clamp(xa, 0.0, 1.0)).rg * uFlowTexel;
    xa = uv + uT * f2;
    xb = xa - f2;
  }

  vec3 A = texture(uA, clamp(xa, vec2(0.0), vec2(1.0))).rgb;
  vec3 B = texture(uB, clamp(xb, vec2(0.0), vec2(1.0))).rgb;

  float la = dot(A, vec3(0.299, 0.587, 0.114));
  float lb = dot(B, vec3(0.299, 0.587, 0.114));
  float df = abs(la - lb);
  float conf = exp(-df * df * uK);

  vec3 mixed = mix(A, B, uT);
  vec3 nearv = (uT < 0.5) ? texture(uA, uv).rgb : texture(uB, uv).rgb;
  o = vec4(mix(nearv, mixed, conf), 1.0);
}`;

  const FS_BLIT = `#version 300 es
precision highp float;
uniform sampler2D uSrc;
uniform vec2 uOff, uSize;
uniform float uOutside;
in vec2 vUv; out vec4 o;
void main(){
  vec2 uv = (vUv - uOff) / uSize;
  if (uOutside > 0.5 && (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)) {
    o = vec4(0.0, 0.0, 0.0, 1.0);
  } else {
    o = vec4(texture(uSrc, clamp(uv, 0.0, 1.0)).rgb, 1.0);
  }
}`;

  const FS_STAT = `#version 300 es
precision highp float;
uniform sampler2D uP, uC;
in vec2 vUv; out vec4 o;
void main(){
  float s = 0.0;
  s += abs(texture(uP, vUv).r - texture(uC, vUv).r);
  s += abs(texture(uP, vUv + vec2(0.01, 0.0)).r - texture(uC, vUv + vec2(0.01, 0.0)).r);
  s += abs(texture(uP, vUv + vec2(0.0, 0.01)).r - texture(uC, vUv + vec2(0.0, 0.01)).r);
  s += abs(texture(uP, vUv - vec2(0.01, 0.0)).r - texture(uC, vUv - vec2(0.01, 0.0)).r);
  o = vec4(s * 0.25, 0.0, 0.0, 1.0);
}`;

  /* ================================================================== *
   *  GL helpers
   * ================================================================== */
  function compile(gl, type, src) {
    const sh = gl.createShader(type);
    gl.shaderSource(sh, src);
    gl.compileShader(sh);
    if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
      const info = gl.getShaderInfoLog(sh);
      gl.deleteShader(sh);
      throw new Error('Shader compile failed: ' + info);
    }
    return sh;
  }

  function makeProgram(gl, fsSrc) {
    const p = gl.createProgram();
    const vs = compile(gl, gl.VERTEX_SHADER, VS);
    const fs = compile(gl, gl.FRAGMENT_SHADER, fsSrc);
    gl.attachShader(p, vs);
    gl.attachShader(p, fs);
    gl.linkProgram(p);
    if (!gl.getProgramParameter(p, gl.LINK_STATUS)) {
      throw new Error('Program link failed: ' + gl.getProgramInfoLog(p));
    }
    gl.deleteShader(vs);
    gl.deleteShader(fs);
    const u = {};
    const n = gl.getProgramParameter(p, gl.ACTIVE_UNIFORMS);
    for (let i = 0; i < n; i++) {
      const info = gl.getActiveUniform(p, i);
      u[info.name] = gl.getUniformLocation(p, info.name);
    }
    return { p, u };
  }

  function makeTarget(gl, w, h, internal, format, type, filter) {
    const tex = gl.createTexture();
    gl.bindTexture(gl.TEXTURE_2D, tex);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, filter);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, filter);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    gl.texImage2D(gl.TEXTURE_2D, 0, internal, w, h, 0, format, type, null);
    const fbo = gl.createFramebuffer();
    gl.bindFramebuffer(gl.FRAMEBUFFER, fbo);
    gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, tex, 0);
    const status = gl.checkFramebufferStatus(gl.FRAMEBUFFER);
    gl.bindFramebuffer(gl.FRAMEBUFFER, null);
    if (status !== gl.FRAMEBUFFER_COMPLETE) {
      gl.deleteFramebuffer(fbo);
      gl.deleteTexture(tex);
      throw new Error('WebGL 프레임버퍼 생성 실패 (' + w + 'x' + h + ', status=' + status + ')');
    }
    return { tex, fbo, w, h, ok: true };
  }

  function disposeTarget(gl, t) {
    if (!t) return;
    gl.deleteTexture(t.tex);
    gl.deleteFramebuffer(t.fbo);
  }

  /* ================================================================== *
   *  Renderer (피라미드 광학흐름 + 합성)
   * ================================================================== */
  class Renderer {
    constructor(canvas) {
      this.canvas = canvas;
      const gl = canvas.getContext('webgl2', {
        alpha: false, antialias: false, depth: false, stencil: false,
        desynchronized: true, powerPreference: 'high-performance',
        preserveDrawingBuffer: false,
      });
      if (!gl) throw new Error('WebGL2 를 사용할 수 없습니다.');
      this.gl = gl;
      if (!gl.getExtension('EXT_color_buffer_float')) {
        throw new Error('EXT_color_buffer_float 확장이 없습니다.');
      }

      this.progLuma = makeProgram(gl, FS_LUMA);
      this.progDown = makeProgram(gl, FS_DOWN);
      this.progUp = makeProgram(gl, FS_UP);
      this.progFlow = makeProgram(gl, FS_FLOW);
      this.progSynth = makeProgram(gl, FS_SYNTH);
      this.progBlit = makeProgram(gl, FS_BLIT);
      this.progStat = makeProgram(gl, FS_STAT);

      const vao = gl.createVertexArray();
      gl.bindVertexArray(vao);
      const buf = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, buf);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
        -1, -1, 1, -1, -1, 1,
        -1, 1, 1, -1, 1, 1,
      ]), gl.STATIC_DRAW);
      gl.enableVertexAttribArray(0);
      gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
      this.vao = vao;

      this.w = 0; this.h = 0;
      this.fw = 0; this.fh = 0;
      this.frame = [null, null];
      this.pyr = [];
      this.flowL = [];
      this.levels = 1;
      this.statT = null;
      this.statPx = new Uint8Array(32 * 18 * 4);
      this.cur = 0; this.prev = 1;
      this.hasPair = false;
      this.cut = false;
      this.finalFlow = null;
      this.finalIdx = 0;
      this.stat = { uploads: 0, cuts: 0 };
    }

    ensure(w, h) {
      w = Math.max(64, Math.round(w));
      h = Math.max(36, Math.round(h));
      if (w === this.w && h === this.h) return;
      const gl = this.gl;

      [this.frame].flat().forEach(t => disposeTarget(gl, t));
      this.pyr.flat().forEach(t => disposeTarget(gl, t));
      this.flowL.flat().forEach(t => disposeTarget(gl, t));
      disposeTarget(gl, this.statT);
      this.frame = [null, null];
      this.pyr = []; this.flowL = [];

      this.w = w; this.h = h;
      this.canvas.width = w;
      this.canvas.height = h;

      const budget = FLOW_BUDGET[S.quality] || FLOW_BUDGET[1];
      const scale = Math.max(2, Math.round(Math.sqrt((w * h) / budget)));
      this.fw = Math.max(16, Math.ceil(w / scale));
      this.fh = Math.max(9, Math.ceil(h / scale));

      let m = Math.min(this.fw, this.fh);
      this.levels = 1;
      while ((m >> this.levels) > 20 && this.levels < 6) this.levels++;

      for (let i = 0; i < 2; i++) {
        this.frame[i] = makeTarget(gl, w, h, gl.RGBA8, gl.RGBA, gl.UNSIGNED_BYTE, gl.LINEAR);
      }
      for (let l = 0; l < this.levels; l++) {
        const sw = Math.max(8, this.fw >> l);
        const sh = Math.max(8, this.fh >> l);
        this.pyr[l] = [
          makeTarget(gl, sw, sh, gl.RGBA8, gl.RGBA, gl.UNSIGNED_BYTE, gl.LINEAR),
          makeTarget(gl, sw, sh, gl.RGBA8, gl.RGBA, gl.UNSIGNED_BYTE, gl.LINEAR),
        ];
        this.flowL[l] = [
          makeTarget(gl, sw, sh, gl.RGBA16F, gl.RGBA, gl.HALF_FLOAT, gl.LINEAR),
          makeTarget(gl, sw, sh, gl.RGBA16F, gl.RGBA, gl.HALF_FLOAT, gl.LINEAR),
        ];
      }
      this.statT = makeTarget(gl, 32, 18, gl.RGBA8, gl.RGBA, gl.UNSIGNED_BYTE, gl.NEAREST);
      this.hasPair = false;
      this.finalFlow = null;
      this.clearFlows();
      log('resize', w, h, 'flow', this.fw, this.fh, 'levels', this.levels);
    }

    clearFlows() {
      const gl = this.gl;
      this.flowL.flat().forEach(t => {
        if (!t) return;
        gl.bindFramebuffer(gl.FRAMEBUFFER, t.fbo);
        gl.clearColor(0, 0, 0, 1);
        gl.clear(gl.COLOR_BUFFER_BIT);
      });
      gl.bindFramebuffer(gl.FRAMEBUFFER, null);
      this.finalFlow = this.flowL[0] ? this.flowL[0][0].tex : null;
      this.finalIdx = 0;
    }

    draw(prog, target, setup) {
      const gl = this.gl;
      gl.bindFramebuffer(gl.FRAMEBUFFER, target ? target.fbo : null);
      gl.viewport(0, 0, target ? target.w : this.w, target ? target.h : this.h);
      gl.useProgram(prog.p);
      gl.bindVertexArray(this.vao);
      setup(prog.u);
      gl.drawArrays(gl.TRIANGLES, 0, 6);
    }

    bind(unit, tex) {
      const gl = this.gl;
      gl.activeTexture(gl.TEXTURE0 + unit);
      gl.bindTexture(gl.TEXTURE_2D, tex);
      return unit;
    }

    buildPyramid(idx) {
      const gl = this.gl;
      this.draw(this.progLuma, this.pyr[0][idx], u => {
        gl.uniform1i(u.uSrc, this.bind(0, this.frame[idx].tex));
      });
      for (let l = 1; l < this.levels; l++) {
        const t = 1 / Math.max(1, this.pyr[l - 1][idx].w);
        const ty = 1 / Math.max(1, this.pyr[l - 1][idx].h);
        this.draw(this.progDown, this.pyr[l][idx], u => {
          gl.uniform1i(u.uSrc, this.bind(0, this.pyr[l - 1][idx].tex));
          gl.uniform2f(u.uTexel, t, ty);
        });
      }
    }

    upload(video) {
      const gl = this.gl;
      const next = 1 - this.cur;
      gl.bindTexture(gl.TEXTURE_2D, this.frame[next].tex);
      gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
      try {
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA8, gl.RGBA, gl.UNSIGNED_BYTE, video);
      } finally {
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false);
      }

      this.buildPyramid(next);

      this.prev = this.cur;
      this.cur = next;

      this.cut = S.sceneCut ? this.detectCut(this.prev, this.cur) : false;
      if (this.cut) {
        this.stat.cuts++;
        this.clearFlows();
      } else if (this.hasPair) {
        this.computeFlow(this.prev, this.cur);
      }
      this.hasPair = true;
      this.stat.uploads++;
    }

    detectCut(prev, cur) {
      const gl = this.gl;
      this.draw(this.progStat, this.statT, u => {
        gl.uniform1i(u.uP, this.bind(0, this.pyr[0][prev].tex));
        gl.uniform1i(u.uC, this.bind(1, this.pyr[0][cur].tex));
      });
      gl.bindFramebuffer(gl.FRAMEBUFFER, this.statT.fbo);
      gl.readPixels(0, 0, 32, 18, gl.RGBA, gl.UNSIGNED_BYTE, this.statPx);
      gl.bindFramebuffer(gl.FRAMEBUFFER, null);
      let sum = 0;
      for (let i = 0; i < this.statPx.length; i += 4) sum += this.statPx[i];
      return sum / (this.statPx.length / 4) / 255 > 0.085;
    }

    computeFlow(prev, cur) {
      const gl = this.gl;
      const L = this.levels;
      const baseIter = Math.max(1, Math.min(8, S.flowIter | 0));
      let src = 0;

      // 가장 거친 레벨에서 0으로 시작
      gl.bindFramebuffer(gl.FRAMEBUFFER, this.flowL[L - 1][0].fbo);
      gl.clearColor(0, 0, 0, 1);
      gl.clear(gl.COLOR_BUFFER_BIT);
      gl.bindFramebuffer(gl.FRAMEBUFFER, null);
      src = 0;

      for (let l = L - 1; l >= 0; l--) {
        if (l < L - 1) {
          const coarse = this.flowL[l + 1][src];
          this.draw(this.progUp, this.flowL[l][0], u => {
            gl.uniform1i(u.uSrc, this.bind(0, coarse.tex));
          });
          src = 0;
        }
        const target = this.flowL[l];
        const texel = [1 / target[0].w, 1 / target[0].h];
        const iters = (l === L - 1) ? Math.min(16, baseIter * 3) : baseIter + 1;
        for (let i = 0; i < iters; i++) {
          const dst = 1 - src;
          this.draw(this.progFlow, target[dst], u => {
            gl.uniform1i(u.uP, this.bind(0, this.pyr[l][prev].tex));
            gl.uniform1i(u.uC, this.bind(1, this.pyr[l][cur].tex));
            gl.uniform1i(u.uF, this.bind(2, target[src].tex));
            gl.uniform2f(u.uTexel, texel[0], texel[1]);
            gl.uniform1f(u.uStep, 3.0);
            gl.uniform1f(u.uReg, 0.55);
          });
          src = dst;
        }
      }
      this.finalFlow = this.flowL[0][src].tex;
      this.finalIdx = src;
    }

    contentRect(cw, ch, vw, vh, fit) {
      const ca = cw / ch, va = vw / vh;
      let sx = 1, sy = 1;
      if (fit === 'cover') {
        if (va > ca) sx = va / ca; else sy = ca / va;
      } else if (fit === 'contain') {
        if (va > ca) sy = ca / va; else sx = va / ca;
      } else {
        return { off: [0, 0], size: [1, 1], outside: 0 };
      }
      return {
        off: [(1 - sx) * 0.5, (1 - sy) * 0.5],
        size: [sx, sy],
        outside: fit === 'cover' ? 0 : 1,
      };
    }

    render(t, fit) {
      const gl = this.gl;
      const rect = this.contentRect(this.w, this.h, this.videoW, this.videoH, fit);

      if (!this.hasPair || this.cut || !this.finalFlow) {
        this.draw(this.progBlit, null, u => {
          gl.uniform1i(u.uSrc, this.bind(0, this.frame[this.cur].tex));
          gl.uniform2f(u.uOff, rect.off[0], rect.off[1]);
          gl.uniform2f(u.uSize, rect.size[0], rect.size[1]);
          gl.uniform1f(u.uOutside, rect.outside);
        });
        return;
      }

      this.draw(this.progSynth, null, u => {
        gl.uniform1i(u.uA, this.bind(0, this.frame[this.prev].tex));
        gl.uniform1i(u.uB, this.bind(1, this.frame[this.cur].tex));
        gl.uniform1i(u.uF, this.bind(2, this.finalFlow));
        gl.uniform2f(u.uFlowTexel, 1 / this.fw, 1 / this.fh);
        gl.uniform2f(u.uOff, rect.off[0], rect.off[1]);
        gl.uniform2f(u.uSize, rect.size[0], rect.size[1]);
        gl.uniform1f(u.uT, t);
        gl.uniform1f(u.uK, S.conf);
        gl.uniform1f(u.uOutside, rect.outside);
      });
    }

    dispose() {
      const gl = this.gl;
      this.frame.flat().forEach(t => disposeTarget(gl, t));
      this.pyr.flat().forEach(t => disposeTarget(gl, t));
      this.flowL.flat().forEach(t => disposeTarget(gl, t));
      disposeTarget(gl, this.statT);
      gl.getExtension('WEBGL_lose_context')?.loseContext();
    }
  }

  /* ================================================================== *
   *  Interpolator
   * ================================================================== */
  class Interpolator {
    constructor(video) {
      this.video = video;
      this.active = true;
      this.frameDur = 1 / 30;
      this.phaseStart = 0;
      this.rafId = 0;
      this.rvfcId = 0;
      this.uploadError = null;
      this.outFps = 0;     // 렌더 루프가 실제로 그린 프레임 수
      this.srcFps = 0;     // 원본 영상 프레임 수 (업로드 기준)
      this.mixFps = 0;     // 0<t<1 로 실제 합성한 중간 프레임 수
      this._fpsT = performance.now();
      this._outN = 0;
      this._mixN = 0;
      this._upBase = 0;
      this.fit = 'contain';

      this._onFrame = this._onFrame.bind(this);
      this._loop = this._loop.bind(this);
      this._onResize = this._onResize.bind(this);

      this.canvas = document.createElement('canvas');
      this.canvas.className = 'nwi-canvas';
      Object.assign(this.canvas.style, {
        position: 'absolute',
        left: '0px', top: '0px', width: '1px', height: '1px',
        pointerEvents: 'none',
        background: '#000',
      });

      // 캔버스는 <video>와 같은 부모 안에서 <video> "바로 앞"에 넣는다.
      // 영상은 opacity:0으로 투명하므로 캔버스가 영상 아래에 있어도 보이고,
      // 이렇게 하면 플레이어가 나중에 그리는 컨트롤바/오버레이는 무조건 위에 온다.
      // (offsetParent에 appendChild 하면 DOM 구조에 따라 재생바를 덮어버린다)
      const host = video.parentElement || document.body;
      if (video.parentElement) host.insertBefore(this.canvas, video);
      else host.appendChild(this.canvas);

      // 절대배치 캔버스의 기준 상자 = 가장 가까운 positioned 조상
      this.container = this.canvas.offsetParent || video.offsetParent || document.body;
      const cs = getComputedStyle(this.container);
      if (cs.position === 'static') {
        this.container.style.position = 'relative';
        this._patchedPosition = true;
      }

      this.renderer = new Renderer(this.canvas);
      this.renderer.videoW = video.videoWidth || 1280;
      this.renderer.videoH = video.videoHeight || 720;

      this._origOpacity = {
        value: video.style.getPropertyValue('opacity'),
        priority: video.style.getPropertyPriority('opacity'),
      };
      video.style.setProperty('opacity', '0', 'important');

      this._layout(true);
      this._start();
    }

    _start() {
      const v = this.video;
      this._lastRvfc = performance.now();
      if ('requestVideoFrameCallback' in v) {
        const tick = (now, meta) => {
          if (!this.active) return;
          this._lastRvfc = performance.now();
          this._onFrame(now, meta);
          this.rvfcId = v.requestVideoFrameCallback(tick);
        };
        this.rvfcId = v.requestVideoFrameCallback(tick);
      }

      // rVFC 워치독: 백그라운드/합성 스킵/사이트 특성으로 콜백이 멈추면
      // currentTime 변화를 폴링해 프레임을 계속 집어온다.
      this._lastPollT = -1;
      this._wd = setInterval(() => {
        if (!this.active) return;
        if (performance.now() - this._lastRvfc < 300) return;
        if (v.paused || v.ended || !v.videoWidth) return;
        const t = v.currentTime;
        if (t === this._lastPollT) return;
        this._lastPollT = t;
        this._onFrame(performance.now(), { mediaTime: t });
      }, 15);

      this.rafId = requestAnimationFrame(this._loop);
      window.addEventListener('resize', this._onResize, true);
      if (window.ResizeObserver) {
        this._ro = new ResizeObserver(() => { try { this._layout(true); } catch (_) {} });
        this._ro.observe(v);
      }
      this._onFs = () => {
        try { this._layout(true); } catch (_) {}
        if (document.fullscreenElement === v && !this._fsNotified) {
          this._fsNotified = true;
          try { NWI.toast('이 사이트는 전체화면에서 오버레이가 숨겨질 수 있습니다'); } catch (_) {}
        }
      };
      document.addEventListener('fullscreenchange', this._onFs, true);
    }

    _onResize() { this._layout(true); }

    _layout(force) {
      const v = this.video;
      const vr = v.getBoundingClientRect();
      const w = Math.round(vr.width) || v.offsetWidth || v.clientWidth;
      const h = Math.round(vr.height) || v.offsetHeight || v.clientHeight;
      if (!w || !h) return;

      const cr = this.container.getBoundingClientRect();
      const cs = getComputedStyle(this.container);
      const bl = parseFloat(cs.borderLeftWidth) || 0;
      const bt = parseFloat(cs.borderTopWidth) || 0;
      const left = Math.round(vr.left - cr.left - bl);
      const top = Math.round(vr.top - cr.top - bt);

      if (!force && w === this._lw && h === this._lh && left === this._lx && top === this._ly) return;
      this._lw = w; this._lh = h; this._lx = left; this._ly = top;

      this.canvas.style.left = left + 'px';
      this.canvas.style.top = top + 'px';
      this.canvas.style.width = w + 'px';
      this.canvas.style.height = h + 'px';

      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      const rw = Math.min(this.renderer.videoW || w, Math.round(w * dpr));
      const rh = Math.min(this.renderer.videoH || h, Math.round(h * dpr));
      this.renderer.ensure(rw, rh);

      const fit = getComputedStyle(v).objectFit || 'contain';
      this.fit = (fit === 'fill' || fit === 'cover' || fit === 'contain') ? fit : 'contain';
    }

    _onFrame(now, meta) {
      const v = this.video;
      if (!v.videoWidth) return;
      if (v.style.getPropertyPriority('opacity') !== 'important' || v.style.getPropertyValue('opacity') !== '0') {
        v.style.setProperty('opacity', '0', 'important');   // 사이트가 되돌리는 경우 재적용
      }
      this._layout(false);

      if (v.videoWidth !== this.renderer.videoW || v.videoHeight !== this.renderer.videoH) {
        this.renderer.videoW = v.videoWidth;
        this.renderer.videoH = v.videoHeight;
        this._layout(true);
        return;
      }

      const prevStart = this.phaseStart;
      this.phaseStart = performance.now();
      const dt = (this.phaseStart - prevStart) / 1000;
      if (prevStart > 0 && dt > 0.002 && dt < 0.25) this.frameDur = dt;

      try {
        this.renderer.upload(v);
      } catch (e) {
        this.uploadError = String((e && e.message) || e);
        log('upload error', this.uploadError);
        NWI.failedVideos.add(v);   // DRM/CORS 영상은 재시도하지 않음
        this.active = false;
        setTimeout(() => NWI.disable(true), 0);
        return;
      }
    }

    _loop() {
      if (!this.active) return;
      const v = this.video;
      if (!v.videoWidth) { this.rafId = requestAnimationFrame(this._loop); return; }

      let t = 1;
      if (!v.paused && this.phaseStart) {
        const dt = (performance.now() - this.phaseStart) / 1000;
        t = Math.min(1, Math.max(0, dt / this.frameDur));
      }
      try {
        this.renderer.render(t, this.fit);
      } catch (e) {
        log('render error', e);
      }

      this._outN++;
      if (t > 0.02 && t < 0.98) this._mixN++;
      const tn = performance.now();
      if (tn - this._fpsT > 1000) {
        const el = (tn - this._fpsT) / 1000;
        this.outFps = Math.round(this._outN / el);
        this.mixFps = Math.round(this._mixN / el);
        const up = this.renderer.stat.uploads;
        this.srcFps = Math.round((up - this._upBase) / el);
        this._upBase = up;
        this._outN = 0; this._mixN = 0; this._fpsT = tn;
      }

      if (NWI.panel) NWI.updatePanel();
      this.rafId = requestAnimationFrame(this._loop);
    }

    destroy() {
      this.active = false;
      cancelAnimationFrame(this.rafId);
      if (this.fallbackTimer) clearInterval(this.fallbackTimer);
      if (this._wd) clearInterval(this._wd);
      if ('cancelVideoFrameCallback' in this.video && this.rvfcId) {
        try { this.video.cancelVideoFrameCallback(this.rvfcId); } catch (_) {}
      }
      window.removeEventListener('resize', this._onResize, true);
      if (this._ro) { try { this._ro.disconnect(); } catch (_) {} }
      if (this._onFs) document.removeEventListener('fullscreenchange', this._onFs, true);
      if (this._origOpacity.value) {
        this.video.style.setProperty('opacity', this._origOpacity.value, this._origOpacity.priority);
      } else {
        this.video.style.removeProperty('opacity');
      }
      try { this.renderer.dispose(); } catch (_) {}
      this.canvas.remove();
      if (this._patchedPosition) this.container.style.position = '';
    }
  }

  /* ================================================================== *
   *  패널 (Trusted Types 안전: innerHTML 사용 안 함)
   * ================================================================== */
  const PANEL_CSS = `
    :host { all: initial; }
    .box {
      font: 12px/1.5 ui-sans-serif, system-ui, -apple-system, 'Segoe UI', sans-serif;
      color: #e7ecf3; background: rgba(18,20,24,.93);
      border: 1px solid rgba(255,255,255,.12); border-radius: 10px;
      box-shadow: 0 8px 28px rgba(0,0,0,.45); padding: 10px 12px; width: 244px;
      backdrop-filter: blur(8px);
    }
    .hd { display:flex; align-items:center; justify-content:space-between; margin-bottom:6px; }
    .tt { font-weight:600; letter-spacing:.2px; }
    .dot { width:8px; height:8px; border-radius:50%; background:#5b6472; display:inline-block; margin-right:6px; }
    .row { display:flex; align-items:center; justify-content:space-between; gap:8px; margin:6px 0; }
    .right { display:flex; align-items:center; gap:6px; }
    input[type=range] { width:104px; }
    select { background:#1c2027; color:#e7ecf3; border:1px solid #333a45; border-radius:5px; padding:1px 4px; font-size:11px; }
    button { background:#2a3140; color:#e7ecf3; border:1px solid #3a4354; border-radius:6px; padding:3px 8px; cursor:pointer; font-size:11px; }
    button:hover { background:#333c4e; }
    .mut { color:#98a2b3; }
    .val { color:#7cc4ff; font-variant-numeric: tabular-nums; font-weight:600; }
    .ok { color:#3ddc84; } .off { color:#ff8a8a; }
    .ft { display:flex; justify-content:space-between; margin-top:8px; padding-top:6px;
          border-top:1px solid rgba(255,255,255,.1); font-size:11px; }
    .ft2 { margin-top:3px; font-size:11px; color:#98a2b3; }
  `;

  function h(tag, props, ...kids) {
    const n = document.createElement(tag);
    if (props) {
      for (const k in props) {
        const v = props[k];
        if (v === undefined || v === null) continue;
        if (k === 'text') n.textContent = v;
        else if (k === 'class') n.className = v;
        else if (k === 'style') n.style.cssText = v;
        else if (k.slice(0, 2) === 'on') n.addEventListener(k.slice(2), v);
        else if (k in n) { try { n[k] = v; } catch (_) { n.setAttribute(k, v); } }
        else n.setAttribute(k, v);
      }
    }
    for (const kid of kids) {
      if (kid === undefined || kid === null || kid === false) continue;
      n.appendChild(typeof kid === 'object' ? kid : document.createTextNode(String(kid)));
    }
    return n;
  }

  const panelHost = document.createElement('div');
  panelHost.style.cssText = 'position:fixed;right:14px;bottom:14px;z-index:2147483647;';
  const shadow = panelHost.attachShadow({ mode: 'open' });
  const ui = {};

  (function buildPanel() {
    const style = document.createElement('style');
    style.textContent = PANEL_CSS;
    shadow.appendChild(style);

    ui.dot = h('span', { class: 'dot' });

    const head = h('div', { class: 'hd' },
      h('span', { class: 'tt' }, ui.dot, 'NVOF-Web ', h('span', { class: 'mut' }, 'v' + VERSION)));

    ui.state = h('span', { class: 'val off' }, 'OFF');
    ui.power = h('button', {}, '끄기/켜기');
    ui.power.addEventListener('click', () => NWI.toggle());

    ui.q = h('select');
    [['0', '성능'], ['1', '균형'], ['2', '품질']].forEach(([v, t]) => ui.q.appendChild(h('option', { value: v }, t)));
    ui.q.addEventListener('change', e => { S.quality = +e.target.value; saveS(); NWI.reRender(); });

    ui.it = h('input', { type: 'range', min: 1, max: 8, step: 1 });
    ui.itv = h('span', { class: 'val' });
    ui.it.addEventListener('input', e => { S.flowIter = +e.target.value; ui.itv.textContent = S.flowIter; saveS(); });

    ui.cf = h('input', { type: 'range', min: 5, max: 120, step: 5 });
    ui.cfv = h('span', { class: 'val' });
    ui.cf.addEventListener('input', e => { S.conf = +e.target.value; ui.cfv.textContent = S.conf; saveS(); });

    ui.sc = h('input', { type: 'checkbox' });
    ui.sc.addEventListener('change', e => { S.sceneCut = e.target.checked; saveS(); });

    ui.auto = h('input', { type: 'checkbox' });
    ui.auto.addEventListener('change', e => {
      S.auto = e.target.checked;
      saveS();
      if (S.auto) { NWI.sessionOff = false; NWI.autoKick(); }
    });

    ui.st = h('span', { text: '대기 중' });
    ui.fps = h('span', { text: '–' });
    ui.mix = h('span', { text: '' });

    ui.body = h('div', {},
      h('div', { class: 'row' },
        h('span', { class: 'mut' }, '상태'),
        h('div', { class: 'right' }, ui.state, ui.power)),
      h('div', { class: 'row' }, h('span', { class: 'mut' }, '품질'), ui.q),
      h('div', { class: 'row' }, h('span', { class: 'mut' }, '흐름 반복'), ui.it, ui.itv),
      h('div', { class: 'row' }, h('span', { class: 'mut' }, '아티팩트 억제'), ui.cf, ui.cfv),
      h('div', { class: 'row' }, h('span', { class: 'mut' }, '장면 전환 감지'), ui.sc),
      h('div', { class: 'row' }, h('span', { class: 'mut' }, '자동 시작'), ui.auto),
      h('div', { class: 'ft mut' }, ui.st, ui.fps),
      h('div', { class: 'ft2' }, ui.mix));

    shadow.appendChild(h('div', { class: 'box' }, head, ui.body));
  })();

  function syncPanel() {
    if (!ui.q) return;
    ui.q.value = String(S.quality);
    ui.it.value = String(S.flowIter);
    ui.itv.textContent = S.flowIter;
    ui.cf.value = String(S.conf);
    ui.cfv.textContent = S.conf;
    ui.sc.checked = !!S.sceneCut;
    ui.auto.checked = !!S.auto;
  }

  /* 알림 배지 / 토스트 */
  const badgeEl = document.createElement('div');
  badgeEl.style.cssText = 'position:fixed;left:50%;top:16px;transform:translateX(-50%);'
    + 'background:rgba(18,20,24,.92);color:#e7ecf3;border:1px solid rgba(255,255,255,.14);'
    + 'padding:6px 12px;border-radius:999px;font:600 12px/1 system-ui;z-index:2147483647;'
    + 'pointer-events:none;opacity:0;transition:opacity .25s';
  let badgeTimer = 0;

  /* ================================================================== *
   *  NWI
   * ================================================================== */
  const NWI = {
    version: VERSION,
    interpolator: null,
    failedVideos: new WeakSet(),
    panel: false,
    sessionOff: false,
    lastError: null,
    _panelT: 0,

    get stats() {
      const it = this.interpolator;
      if (!it) return null;
      const r = it.renderer;
      return {
        video: [r.videoW, r.videoH],
        render: [r.w, r.h],
        flow: [r.fw, r.fh],
        levels: r.levels,
        uploads: r.stat.uploads,
        cuts: r.stat.cuts,
        outFps: it.outFps,
        srcFps: it.srcFps,
        mixFps: it.mixFps,
        error: it.uploadError,
      };
    },

    pickVideo() {
      const vids = [...document.querySelectorAll('video')].filter(v => {
        if (!v.videoWidth || v.videoWidth < 160) return false;
        const r = v.getBoundingClientRect();
        return r.width > 160 && r.height > 90;
      });
      if (!vids.length) return null;
      vids.sort((a, b) => {
        const ra = a.getBoundingClientRect(), rb = b.getBoundingClientRect();
        if ((!a.paused) !== (!b.paused)) return a.paused ? 1 : -1;
        return rb.width * rb.height - ra.width * ra.height;
      });
      return vids[0];
    },

    enable(video, silent, force) {
      const v = video || this.pickVideo();
      if (!v) {
        if (!silent) this.toast('재생 중인 <video>를 찾지 못했습니다');
        return false;
      }
      if (this.failedVideos.has(v) && !force) return false;
      if (force) this.failedVideos.delete(v);
      if (this.interpolator && this.interpolator.video === v) return true;
      if (this.interpolator) this.destroyInterp();
      if (!v.videoWidth) {
        if (!silent) this.toast('영상 정보를 기다리는 중…');
        return false;
      }
      try {
        this.interpolator = new Interpolator(v);
        this.lastError = null;
      } catch (e) {
        this.lastError = String((e && e.message) || e);
        this.failedVideos.add(v);
        console.error('[NWI]', e);
        this.showPanel(true);
        this.toast('시작 실패: ' + this.lastError);
        this.updatePanel(true);
        return false;
      }
      this.sessionOff = false;
      if (!silent) {
        this.showPanel(true);
        this.badge('보간 2× ON');
      }
      this.updatePanel(true);
      return true;
    },

    destroyInterp() {
      if (!this.interpolator) return;
      try { this.interpolator.destroy(); } catch (e) { console.warn(e); }
      this.interpolator = null;
    },

    disable(user) {
      this.destroyInterp();
      if (user) this.sessionOff = true;
      this.updatePanel(true);
    },

    toggle() {
      if (this.interpolator) {
        this.disable(true);
        this.badge('보간 OFF');
      } else {
        this.sessionOff = false;
        this.enable(null, false, true);   // 사용자가 직접 켠 경우 강제 재시도
      }
    },

    showPanel(on) {
      if (on === undefined) on = !this.panel;
      if (on) {
        if (!panelHost.isConnected) {
          try { document.documentElement.appendChild(panelHost); }
          catch (_) { document.body.appendChild(panelHost); }
        }
        this.panel = true;
        syncPanel();
        this.updatePanel(true);
      } else {
        panelHost.remove();
        this.panel = false;
      }
    },

    togglePanel() { this.showPanel(!this.panel); },

    reRender() {
      const it = this.interpolator;
      if (!it) return;
      const w = it.renderer.w, h = it.renderer.h;
      it.renderer.w = 0; it.renderer.h = 0;
      it.renderer.ensure(w || 1280, h || 720);
    },

    updatePanel(force) {
      if (!ui.state) return;
      const now = performance.now();
      if (!force && now - this._panelT < 250) return;
      this._panelT = now;

      const it = this.interpolator;
      const s = it ? this.stats : null;
      const err = s && s.error ? s.error : (!it ? this.lastError : null);

      ui.state.textContent = it ? (s && s.error ? '오류' : 'ON') : 'OFF';
      ui.state.className = 'val ' + (it && !(s && s.error) ? 'ok' : 'off');
      ui.dot.style.background = it ? (s && s.error ? '#ff5d5d' : '#3ddc84') : '#5b6472';

      if (it && s) {
        ui.st.textContent = s.error ? s.error.slice(0, 34) : `${s.flow[0]}×${s.flow[1]} · ${s.cuts}컷`;
        ui.fps.textContent = `${s.srcFps || 0}→${s.outFps || 0} fps`;
        if (s.error) {
          ui.mix.textContent = '';
        } else if (!s.srcFps) {
          ui.mix.textContent = '프레임 집계 중…';
        } else if (s.outFps < 15) {
          ui.mix.textContent = '렌더 루프 지연 · 탭을 활성화하세요';
        } else if (s.srcFps >= s.outFps - 4) {
          ui.mix.textContent = `원본이 ${s.srcFps}fps · 보간 효과 없음`;
        } else {
          ui.mix.textContent = `중간 프레임 ${s.mixFps}/s · 보간 작동 중`;
        }
      } else {
        ui.st.textContent = err ? '오류: ' + err.slice(0, 26) : '대기 중';
        ui.fps.textContent = '–';
        ui.mix.textContent = '';
      }
    },

    badge(msg) {
      badgeEl.textContent = msg;
      if (!badgeEl.isConnected) {
        try { document.documentElement.appendChild(badgeEl); } catch (_) {}
      }
      badgeEl.style.opacity = '1';
      clearTimeout(badgeTimer);
      badgeTimer = setTimeout(() => { badgeEl.style.opacity = '0'; }, 1600);
    },

    toast(msg) {
      const el = document.createElement('div');
      el.textContent = msg;
      el.style.cssText = 'position:fixed;left:50%;bottom:24px;transform:translateX(-50%);'
        + 'background:rgba(20,22,26,.94);color:#e7ecf3;border:1px solid rgba(255,255,255,.14);'
        + 'padding:8px 14px;border-radius:8px;font:13px system-ui;z-index:2147483647;'
        + 'pointer-events:none;transition:opacity .3s;opacity:1';
      (document.body || document.documentElement).appendChild(el);
      setTimeout(() => { el.style.opacity = '0'; }, 1400);
      setTimeout(() => el.remove(), 1800);
    },

    autoKick() {
      if (!S.auto || this.sessionOff || this.interpolator) return;
      const v = this.pickVideo();
      if (v) this.enable(v, true);
    },

    watch() {
      document.addEventListener('play', e => {
        const v = e.target;
        if (!v || v.tagName !== 'VIDEO') return;
        if (this.interpolator && this.interpolator.video !== v) this.enable(v, true);
        else if (!this.interpolator && S.auto && !this.sessionOff) this.enable(v, true);
      }, true);

      setInterval(() => {
        const it = this.interpolator;
        if (!it) return;
        if (!document.contains(it.video)) this.disable(false);
      }, 2000);
    },

    startAuto() {
      const kick = () => { try { this.autoKick(); } catch (_) {} };
      ['loadedmetadata', 'canplay', 'playing'].forEach(ev =>
        document.addEventListener(ev, () => setTimeout(kick, 80), true));
      setTimeout(kick, 500);
      setInterval(kick, 1500);
    },

    diagnose() {
      const v = this.pickVideo();
      let gl2 = false, float = false;
      try {
        const g = document.createElement('canvas').getContext('webgl2');
        gl2 = !!g;
        float = !!(g && g.getExtension('EXT_color_buffer_float'));
      } catch (_) {}
      // 영상 하단(플레이어 컨트롤바 자리)에 실제로 무엇이 그려지고 있는지 확인
      let bottomStack = null;
      const it = this.interpolator;
      if (it && it.canvas) {
        const cv = it.canvas;
        const r = cv.getBoundingClientRect();
        const prev = cv.style.pointerEvents;
        try {
          cv.style.pointerEvents = 'auto';
          bottomStack = document.elementsFromPoint(r.left + r.width / 2, r.bottom - 24)
            .slice(0, 5).map(e => e.tagName + '.' + String(e.className || '').split(' ')[0]);
        } catch (_) {} finally {
          cv.style.pointerEvents = prev;
        }
      }
      return {
        version: VERSION,
        enabled: !!this.interpolator,
        panel: this.panel,
        sessionOff: this.sessionOff,
        settings: Object.assign({}, S),
        video: v ? { w: v.videoWidth, h: v.videoHeight, paused: v.paused, t: +v.currentTime.toFixed(2) } : null,
        stats: this.stats,
        lastError: this.lastError,
        webgl2: gl2,
        floatColor: float,
        bottomStack,
      };
    },
  };

  syncPanel();
  NWI.watch();
  NWI.startAuto();
  window.__NWI = NWI;

  window.addEventListener('keydown', e => {
    if (!e.altKey || e.ctrlKey || e.metaKey || e.shiftKey) return;
    const code = e.code || '';
    const k = (e.key || '').toLowerCase();
    if (k === 'i' || code === 'KeyI') {
      e.preventDefault(); e.stopPropagation();
      NWI.toggle();
    } else if (k === 'o' || code === 'KeyO') {
      e.preventDefault(); e.stopPropagation();
      NWI.togglePanel();
    }
  }, true);

  log('loaded', VERSION);
})();
