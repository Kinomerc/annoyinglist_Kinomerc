// ==UserScript==
// @name         치지직 그리드 우회
// @version      1.0
// @description  치지직 그리드 우회 최신방식을 사용합니다
// @author       Kinomerc
// @match        *://chzzk.naver.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 초기 유저 에이전트 설정
    const initialUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36";
    const newUserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36";

    // 유저 에이전트 변경
    Object.defineProperty(navigator, 'userAgent', {
        get: () => initialUserAgent,
    });

    // 버튼을 자동으로 클릭하는 함수
    function autoClickButton() {
        const buttons = document.querySelectorAll('button');
        const button = Array.from(buttons).find(btn => 
            btn.className.includes('button_container__') && 
            btn.className.includes('button_largest__') && 
            btn.className.includes('button_square__') && 
            btn.className.includes('button_highlight__') && 
            btn.className.includes('button_full_button__')
        );

        if (button) {
            button.click();
            console.log('버튼 클릭됨');
            // 유저 에이전트를 새로운 값으로 변경
            Object.defineProperty(navigator, 'userAgent', {
                get: () => newUserAgent,
            });
        }
    }

    // DOM 변화 감지
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.addedNodes.length) {
                const liveInfo = document.querySelector('.live_information_video_layer__Vd4JD');
                if (liveInfo) {
                    autoClickButton();
                }
            }
        });
    });

    // 감지할 DOM 노드 설정
    observer.observe(document.body, {
        childList: true,
        subtree: true,
    });

})();

})();
