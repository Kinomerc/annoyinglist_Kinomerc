// ==UserScript==
// @name         make site AAPL
// @namespace    https://github.com/Kinomerc/annoyinglist_Kinomerc
// @match        *://*/*
// @exclude      *://noonnu.cc/*
// @exclude      *font*
// @grant        none
// @run-at       document-start
// @version      1.4
// @author       -
// @description  Load custom fonts on any website
// ==/UserScript==

(function () {
    'use strict';

    const STYLE_ID = 'font-priority-fix';

    if (document.getElementById(STYLE_ID)) return;

    const hostname = location.hostname;

    const isTargetSite =
        hostname === 'chzzk.naver.com' ||
        hostname.endsWith('.chzzk.naver.com') ||
        hostname === 'twitch.tv' ||
        hostname.endsWith('.twitch.tv');

    const strokeStyle = isTargetSite
        ? ''
        : '-webkit-text-stroke: 0.015em currentColor !important;';

    const fontUrl =
        'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css';

    const parent = document.head || document.documentElement;

    /* CDN 연결 준비 */
    const preconnect = document.createElement('link');
    preconnect.rel = 'preconnect';
    preconnect.href = 'https://cdn.jsdelivr.net';
    preconnect.crossOrigin = 'anonymous';
    parent.appendChild(preconnect);

    /* 폰트 CSS */
    const fontLink = document.createElement('link');
    fontLink.rel = 'stylesheet';
    fontLink.href = fontUrl;
    parent.appendChild(fontLink);

    /* 전역 스타일 */
    const style = document.createElement('style');
    style.id = STYLE_ID;

    style.textContent = `
        html,
        body {
            font-family:
                "Pretendard JP Variable",
                "Pretendard JP",
                sans-serif !important;

            letter-spacing: -0.02em !important;
            ${strokeStyle}
            text-rendering: optimizeSpeed;
        }

        input,
        button,
        textarea,
        select {
            font-family:
                "Pretendard JP Variable",
                "Pretendard JP",
                sans-serif !important;
        }

        ::selection {
            -webkit-text-stroke: 0 !important;
        }
    `;

    parent.appendChild(style);
})();
