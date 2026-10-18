// ==UserScript==
// @name         Nexon Live CSS Injector
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Fetch and apply external CSS from userstyles.world to live.nexon.com
// @author       You
// @match        *://live.nexon.com/*
// @grant        GM_xmlhttpRequest
// @connect      userstyles.world
// ==/UserScript==

(function() {
    'use strict';

    // 적용할 외부 CSS URL
    const cssUrl = 'https://userstyles.world/api/style/27065.user.css';

    GM_xmlhttpRequest({
        method: 'GET',
        url: cssUrl,
        onload: function(response) {
            if (response.status === 200) {
                let cssContent = response.responseText;

                // 1. UserStyle 메타데이터 제거
                cssContent = cssContent.replace(/\/\*\s*==UserStyle==[\s\S]*?==\/UserStyle==\s*\*\/\n*/, '');

                // 2. live.nexon.com 도메인 영역 추출
                // @-moz-document domain("live.nexon.com") 블록 내부의 내용만 가져옵니다.
                const mozDocMatch = cssContent.match(/@-moz-document\s+domain\("live\.nexon\.com"\)\s*\{([\s\S]*?)\}(?=\s*(@-moz-document|$))/);

                if (mozDocMatch && mozDocMatch[1]) {
                    cssContent = mozDocMatch[1].trim();
                } else {
                    console.warn('CSS 파일에서 live.nexon.com 도메인 규칙을 찾을 수 없습니다. 전체 내용을 적용합니다.');
                }

                // 3. style 태그 생성 및 삽입
                const style = document.createElement('style');
                style.textContent = cssContent;

                // 기존 스타일시트 뒤에 삽입하여 우선순위 확보
                const linkTags = document.head.querySelectorAll('link[rel="stylesheet"]');
                let insertionPoint = document.head.firstChild;

                if (linkTags.length > 0) {
                    insertionPoint = linkTags[linkTags.length - 1].nextSibling;
                }

                document.head.insertBefore(style, insertionPoint);
                console.log('Nexon Live 외부 CSS가 성공적으로 적용되었습니다.');

            } else {
                console.error('CSS 파일을 불러오는 데 실패했습니다. 상태 코드:', response.status);
            }
        },
        onerror: function(error) {
            console.error('CSS 파일을 불러오는 중 오류 발생:', error);
        }
    });
})();
