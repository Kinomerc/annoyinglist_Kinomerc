// ==UserScript==
// @name         CHZZK Clean Theater Mode with etc function
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20260409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

// '더보기' 버튼을 찾아서 클릭
(function() {
    'use strict';
    function clickMoreButtonOnce() {
        const selector = '[id="sidebar"] button[aria-label="더보기"][aria-expanded="false"]';
        const moreButton = document.querySelector(selector);
        if (moreButton) {
            moreButton.click();
            console.log('✅ "더보기" 버튼이 .click()으로 자동 클릭되었습니다.');
            return true; 
        }
        return false; 
    }
    document.addEventListener('mouseup', (event) => {
        const menuButton = event.target.closest('button[aria-label="메뉴 확장"][aria-expanded="false"]');
        if (menuButton && event.isTrusted) { 
            console.log('👉 문서에서 "메뉴 확장" 버튼의 클릭(mouseup)이 감지되었습니다. "더보기" 버튼 대기 시작.');
            let attempts = 0;
            const maxAttempts = 50;
            const intervalTime = 100; 
            const checkInterval = setInterval(() => {
                if (attempts < maxAttempts) {
                    if (clickMoreButtonOnce()) {
                        clearInterval(checkInterval); 
                    }
                    attempts++;
                } else {
                    console.log('❌ 최대 시도 횟수 초과: "더보기" 버튼을 찾을 수 없습니다.');
                    clearInterval(checkInterval);
                }
            }, intervalTime);
        }
    });
    console.log('✔️ 문서에 "메뉴 확장" 버튼 감지를 위한 리스너가 성공적으로 추가되었습니다.');
})();



// "초기 입장시 표시"되는 텍스트를 찾아 제거
(function() {
    'use strict';
    
    // 1. CSS를 이용해 1회성 적용 및 이후 생성 요소도 자동 숨김
    const style = document.createElement('style');
    style.innerHTML = `
        div[class*="item_"]:has(div[class*="filter_"]),
        div[class*="item_"]:has(div[class*="welcome_"]) {
            display: none !important;
        }
    `;
    document.head.appendChild(style);
    console.log('UserScript: 공지 및 웰컴 메시지 숨김 스타일이 적용되었습니다.');

    // 2. 초기 로드 시 1회성 확인 및 로그 출력 (0.3초 뒤 검사)
    setTimeout(() => {
        const filterEl = document.querySelector('div[class*="item_"]:has(div[class*="filter_"])');
        const welcomeEl = document.querySelector('div[class*="item_"]:has(div[class*="welcome_"])');

        if (filterEl) {
            console.log('UserScript: [로그] 공지 메시지가 존재하여 숨겨졌습니다.');
        } else {
            console.log('UserScript: [로그] 초기 스캔 시 공지 메시지를 찾지 못했습니다.');
        }

        if (welcomeEl) {
            console.log('UserScript: [로그] 웰컴 메시지가 존재하여 숨겨졌습니다.');
        } else {
            console.log('UserScript: [로그] 초기 스캔 시 웰컴 메시지를 찾지 못했습니다.');
        }
    }, 300);
})();



//강제 치지직 확장 CSS 삽입
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
