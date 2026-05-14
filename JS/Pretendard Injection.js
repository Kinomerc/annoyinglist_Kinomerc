// ==UserScript==
// @name        Font Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @include     *://*
// @exclude     *://noonnu.cc/*
// @grant       none
// @version     1.2
// @author      -
// @description Load custom fonts on any website
// ==/UserScript==

(function() {
    'use strict';

  if (document.getElementById('font-priority-fix')) return;
  /* const target = document.head || document.documentElement; */

  const fontUrl = 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css';
  const link = document.createElement('link');
  link.rel = 'stylesheet';
  link.href = fontUrl;
  link.crossOrigin = 'anonymous';
  (document.head || document.documentElement).appendChild(link);  
  
  const isChzzk = window.location.hostname.includes('chzzk.naver.com');
  const strokeStyle = isChzzk ? '' : '-webkit-text-stroke: 0.015em currentColor !important;';
  
  const style = document.createElement('style');
  style.id = 'font-priority-fix';
  style.textContent = `

    html body *:not(i, svg, [class*="icon" i], [class*="fa-" i], [class*="fas" i], [class*="far" i], [class*="fab" i], [class*="fal" i], [class*="mdi" i], .material-icons, [class*="symbol" i]) {            font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
        ${strokeStyle}
        letter-spacing: -0.02em !important;
        text-rendering: optimizeSpeed;
    }
    ::selection {
        -webkit-text-stroke: 0 !important;
     }
    input, button, textarea, select {
        font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
        }
    `;

    document.documentElement.appendChild(style);
})();
