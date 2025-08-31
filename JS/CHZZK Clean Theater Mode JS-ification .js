// ==UserScript==
// @name         CHZZK Clean Theater Mode with etc function
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20250409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==



// 자동으로 확장
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

// 통나무 무료 채취
setInterval(() => {
    const btn = document.querySelector('div[class*="live_chatting_power_container__"] button');
    if (btn && !btn.disabled) {
        console.log('통나무 파워 클릭');
        btn.click();
    }
}, 3000); //3초


// '더보기' 버튼을 찾아서 클릭
(function() {
    'use strict';
    function clickMoreButtonOnce() {
        const selector = '[class^="navigation_bar_box"] button[aria-label="더보기"][aria-expanded="false"]';
        const moreButton = document.querySelector(selector);
        if (moreButton) {
            const event = new MouseEvent('click', {
                view: window,
                bubbles: true,
                cancelable: true,
            });
            moreButton.dispatchEvent(event);
            console.log('✅ "더보기" 버튼이 MouseEvent로 자동 클릭되었습니다.');
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



// "후원하기" 텍스트를 찾아 제거
(function() {
    'use strict';
    console.log('UserScript: "후원하기 텍스트 숨기기" 스크립트 로드됨 (setInterval 버전).');
    function hideDonationText(button) {
        let textRemoved = false;
        for (let i = button.childNodes.length - 1; i >= 0; i--) {
            const childNode = button.childNodes[i];
            if (childNode.nodeType === Node.ELEMENT_NODE && childNode.tagName.toLowerCase() === 'svg') {
                continue;
            }
            if (childNode.nodeType === Node.TEXT_NODE || childNode.nodeType === Node.ELEMENT_NODE) {
                const nodeContent = childNode.nodeType === Node.TEXT_NODE ? childNode.nodeValue : childNode.textContent;
                if (nodeContent && nodeContent.includes('후원하기')) {
                    console.log('UserScript: "후원하기" 텍스트를 포함하는 노드 발견 및 제거:', childNode);
                    childNode.remove();
                    textRemoved = true;
                }
            }
        }
        if (textRemoved) {
            console.log('UserScript: 최종: 버튼에서 "후원하기" 텍스트 숨기기 성공!', button);
            return true;
        }
        return false;
    }
    const intervalId = setInterval(() => {
        const buttons = document.querySelectorAll('[class^="live_chatting_input_donation_text__"]');
        if (buttons.length > 0) {
            buttons.forEach(button => {
                hideDonationText(button);
            });
        } else {
        }
    }, 500);
    console.log('UserScript: 주기적인 버튼 스캔 시작 (0.5초 간격).');
})();



//강제 치지직 CSS 삽입
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
