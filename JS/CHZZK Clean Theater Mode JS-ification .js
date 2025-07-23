// ==UserScript==
// @name         CHZZK Clean Theater Mode with ESC function restore
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20250409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function() {
    'use strict';

    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' || event.keyCode === 27) {
            console.log('ESC key pressed. Attempting to click "좁은 화면" button.');
            const wideScreenButtonSelector = 'button[aria-label="좁은 화면"]';
            const wideScreenButton = document.querySelector(wideScreenButtonSelector);

            if (wideScreenButton) {
                wideScreenButton.click();
                console.log('"좁은 화면" button clicked.');
            } else {
                console.log('"좁은 화면" button not found.');
            }
        }
    });
})();


(function() {
    'use strict';

    const cssUrl = 'https://userstyles.world/api/style/13773.user.css';

    GM_xmlhttpRequest({
        method: 'GET',
        url: cssUrl,
        onload: function(response) {
            if (response.status === 200) {
                let cssContent = response.responseText;
                cssContent = cssContent.replace(/\/\*\s*==UserStyle==[\s\S]*?==\/UserStyle==\s*\*\/\n*/, '');
                const mozDocMatch = cssContent.match(/@-moz-document domain\("chzzk\.naver\.com"\)\s*\{\s*([\s\S]*)\s*\}/);
                if (mozDocMatch && mozDocMatch[1]) {
                    cssContent = mozDocMatch[1];
                } else {
                    console.warn('CSS 파일에 @-moz-document 규칙이 없거나 형식이 예상과 다릅니다. 전체 내용을 사용합니다.');
                }
                const style = document.createElement('style');
                style.textContent = cssContent;
                const linkTags = document.head.querySelectorAll('link[rel="stylesheet"]');
                let insertionPoint = document.head.firstChild;

                if (linkTags.length > 0) {
                    insertionPoint = linkTags[linkTags.length - 1].nextSibling;
                }

                document.head.insertBefore(style, insertionPoint);
                console.log('외부 CSS가 성공적으로 처리되고 적용되었습니다.');

                // 렌더링 강제 시도
                // const originalDisplay = document.body.style.display;
                // document.body.style.display = 'none';
                // requestAnimationFrame(() => {
                //     document.body.style.display = originalDisplay;
                // });

            } else {
                console.error('CSS 파일을 불러오는 데 실패했습니다. 상태 코드:', response.status);
            }
        },
        onerror: function(error) {
            console.error('CSS 파일을 불러오는 중 오류 발생:', error);
        }
    });
})();
