// ==UserScript==
// @name        Font Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @include     *://*
// @exclude     *://noonnu.cc/*
// @grant       none
// @version     1.15
// @author      -
// @description Load custom fonts on any website
// ==/UserScript==

(function() {
    'use strict';

  if (document.getElementById('font-priority-fix')) return;

  const fontUrl =
    'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css';

  const link = document.createElement('link');
  link.rel = 'preload';
  link.as = 'style';
  link.href = fontUrl;
  link.onload = () => (link.rel = 'stylesheet');
  document.head.appendChild(link);

  const style = document.createElement('style');
  style.id = 'font-priority-fix';

  style.textContent = `

    html body *:not(i, svg, [class*="icon" i], [class*="fa-" i], [class*="fas" i], [class*="far" i], [class*="fab" i], [class*="fal" i], [class*="mdi" i], .material-icons, [class*="symbol" i]) {            font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
            font-weight: 500 !important;
            letter-spacing: -0.02em !important;
            text-rendering: optimizeSpeed;
        }

        input, button, textarea, select {
            font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
        }
    `;

    document.documentElement.appendChild(style);
})();
