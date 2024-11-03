// ==UserScript==
// @name         Auto Click Confirm Button
// @version      1.0
// @description  Automatically clicks the confirm button in the popup dialog.
// @match        *://chzzk.naver.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 팝업의 "확인" 버튼 클릭
    const confirmInterval = setInterval(() => {
        const confirmButton = document.querySelector('button.button_primary__b63Y7');

        if (confirmButton) {
            confirmButton.click(); // 버튼 클릭
            clearInterval(confirmInterval); // 반복 중지
        }
    }, 1000); // 1초마다 확인
})();
