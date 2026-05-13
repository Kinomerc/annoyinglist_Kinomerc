// ==UserScript==
// @name        Font Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @include     *://*
// @exclude     *://noonnu.cc/*
// @grant       none
// @version     1.0
// @author      -
// @description Load custom fonts on any website
// ==/UserScript==

(function() {
    'use strict';

    const fontUrls = [
        'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css',
    ];

    fontUrls.forEach(url => {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = url;
        link.crossOrigin = 'anonymous';
        document.head.appendChild(link);
    });

    const style = document.createElement('style');
    style.id = 'font-fast-fix';
    style.textContent = `
        html body, html body * {
            font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
            font-weight: 500 !important;
            text-rendering: optimizeSpeed;
            font-display: swap; 
        }
    `;

    document.documentElement.appendChild(style);
})();
