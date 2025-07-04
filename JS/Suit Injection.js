// ==UserScript==
// @name        Suit Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @match       *://*/*
// @exclude     *://github.com/*
// @exclude     *://noonnu.cc/*
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
        @import url('https://cdn.jsdelivr.net/gh/sun-typeface/SUIT@2/fonts/variable/woff2/SUIT-Variable.css');
        head, body, div, span, p, li, ol, ul, a, strong {
            font-family: "SUIT Variable", "Segoe UI Emoji", "Segoe UI Symbol", sans-serif !important;
            font-weight: 600 !important; /* Semibold 두께 */
        }
    `;
  (document.head || document.getElementsByTagName('head')[0]).appendChild(style);
})();
