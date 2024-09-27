// ==UserScript==
// @name        filter mobile 추가 필터
// @namespace   https://github.com/Kinomerc
// @match       https://hitomi.la/*
// @grant       none
// @version     1.0
// @author      Kinomerc
// @description 2024. 9. 18. 오후 10:05:11
// ==/UserScript==


const selectors = [
        '.drop-button',
        'nav',
    ];

selectors.forEach(selector => {
    const elements = document.querySelectorAll(selector);
    elements.forEach(el => {
        el.style.border = 'none';
        el.style.borderRadius = '8px';
        el.style.backgroundColor = 'rgba(255, 255, 255, 0)';
        el.style.backdropFilter = 'blur(8px)';
        el.style.overflow = 'hidden';
        if (selector === '.list-title' || selector === '.drop-button' || selector === 'nav.active') {
            el.style.boxShadow = '0 4px 10px rgba(0, 0, 0, 0.2)';
            el.style.border = '1px solid white';
        } else if (selector === '.anime' || selector === '.cg' || selector === '.acg' || selector === '.imageset' || selector === '.manga' || selector === '.dj') {
            el.style.border = '1px solid #ccc';
        }
    });
});
