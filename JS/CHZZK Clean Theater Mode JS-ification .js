// ==UserScript==
// @name         CHZZK Clean Theater Mode
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20250409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function() {
    'use strict';

    const cssUrl = 'https://userstyles.world/api/style/13773.user.css';

    GM_xmlhttpRequest({
        method: 'GET',
        url: cssUrl,
        onload: function(response) {
            if (response.status === 200) {
                let cssContent = response.responseText; // 불러온 원본 CSS 내용

                // 1. UserStyle 메타데이터 블록 제거
                // '/* ==UserStyle=='로 시작하여 '==/UserStyle== */'로 끝나는 블록을 찾아서 제거합니다.
                cssContent = cssContent.replace(/\/\*\s*==UserStyle==[\s\S]*?==\/UserStyle==\s*\*\/\n*/, '');

                // 2. @-moz-document 규칙 제거 및 내부 CSS 추출
                // @-moz-document domain("chzzk.naver.com") { ... } 블록을 찾아서 안의 내용만 추출합니다.
                const mozDocMatch = cssContent.match(/@-moz-document domain\("chzzk\.naver\.com"\)\s*\{\s*([\s\S]*)\s*\}/);
                if (mozDocMatch && mozDocMatch[1]) {
                    cssContent = mozDocMatch[1]; // 괄호 안의 순수한 CSS 내용만 사용
                } else {
                    // 만약 @-moz-document가 없거나 형식이 다르면 전체 내용을 그대로 사용
                    console.warn('CSS 파일에 @-moz-document 규칙이 없거나 형식이 예상과 다릅니다. 전체 내용을 사용합니다.');
                }

                // 최종적으로 처리된 CSS 내용을 <style> 태그에 삽입
                const style = document.createElement('style');
                style.textContent = cssContent;

                // <head> 태그 내의 마지막 <link> 태그 뒤에 삽입 (이전 시도에서 가장 적절했던 위치)
                const linkTags = document.head.querySelectorAll('link[rel="stylesheet"]');
                let insertionPoint = document.head.firstChild;

                if (linkTags.length > 0) {
                    insertionPoint = linkTags[linkTags.length - 1].nextSibling;
                }

                document.head.insertBefore(style, insertionPoint);

                console.log('외부 CSS가 성공적으로 처리되고 적용되었습니다.');

                // 렌더링 강제 시도 (필요하다면 활성화)
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
