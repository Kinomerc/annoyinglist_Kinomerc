// ==UserScript==
// @name         make site AAPL
// @namespace    https://github.com/Kinomerc/annoyinglist_Kinomerc
// @version      1.6
// @description  Load 프리텐다드 JP on any website
// @author       Kinomerc
// @match        *://*/*
// @exclude      *://noonnu.cc/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    if (document.getElementById('font-priority-fix')) return;

    const target = document.head || document.documentElement;

    const targetSites = ['chzzk.naver.com', 'twitch.tv'];
    const isTargetSite = targetSites.some(site => window.location.hostname.includes(site));
    const strokeStyle = isTargetSite ? '' : '-webkit-text-stroke: 0.02em currentColor !important;';

    const style = document.createElement('style');
    style.id = 'font-priority-fix';
    style.textContent = `
    html body *:not(a, i, code *, pre *, svg, canvas, kbd, samp, [class*="icon" i], [class*="fa-" i], [class*="fas" i], [class*="far" i], [class*="fab" i], [class*="fal" i], [class*="mdi" i], .material-icons, [class*="symbol" i]) {
        font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
        ${strokeStyle}
        letter-spacing: -0.05em !important;
    }
    ::selection {
        -webkit-text-stroke: 0 !important;
     }
    input, button, textarea, select {
        font-family: "Pretendard JP Variable", "Pretendard JP", sans-serif !important;
    }
    `;
    document.documentElement.appendChild(style);

    const fontUrl = 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css';
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = fontUrl;
    link.crossOrigin = 'anonymous';
    target.appendChild(link);

})();
