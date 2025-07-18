// ==UserScript==
// @name        Pretendard Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @include     *://dcinside.com/*
// @include     *://naver.com/*
// @include     *://namu.wiki/*
// @include     *://arca.live/*
// @include     *://youtube.com/*
// @include     *://kone.gg/*
// @include     *://inven.co.kr/*
// @include     *://dlsite.com/*
// @include     *://reddit.com/*
// @include     *://reddit.com/*
// @grant       none
// @version     1.0
// @author      -
// @description Load custom fonts on any website
// ==/UserScript==

(function() {
    'use strict';
    const style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard-jp.min.css');
        head, body, div, span, p, li, ol, ul, a, strong {
            font-family: "Pretendard JP Variable", "Pretendard JP", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif !important;
            font-weight: 600 !important; /* Semibold 두께 */
        }
    `;
  (document.head || document.getElementsByTagName('head')[0]).appendChild(style);
})();
