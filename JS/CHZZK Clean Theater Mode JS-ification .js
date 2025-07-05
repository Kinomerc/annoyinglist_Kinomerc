// ==UserScript==
// @name         CHZZK Clean Theater Mode
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20250409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // 여기에 적용하고 싶은 CSS 코드를 작성해주세요.
    const customCss = `
        /*--새 메시지 도착 애니메이션--*/
@keyframes newMessage
{
    from
    {
        transform: translateX(10px);
        opacity: 0;
    }
    to
    {
        transform: translateX(0);
        opacity: 1;
    }
}

div[class^="live_chatting_message_container__"]
{
    opacity: 1;
    animation: newMessage 200ms ease-in forwards;
}

/* Hide Scrollbar */
section[class*="vod_is_large__"]::-webkit-scrollbar
{
    display: none;
}

/* Firefox */
section[class*="vod_is_large__"]
{
    scrollbar-width: none;
}

/* White Mode */
html[style*="color-scheme: light;"]
{
    section[class*="live_is_large__"],
    section[class*="vod_is_large__"]
    {
        /*-- 가로모드일 때 --*/
        @media (orientation: landscape)
        {
            span[class*="live_chatting_message_text__"],
            pre[class^="live_chatting_input_input__"]
            {
                color: #dfe2ea;
            }
        }
    }
}

section[class*="live_is_large__"],
section[class*="vod_is_large__"]
{
    /*-- 가로모드일 때 --*/
    @media (orientation: landscape)
    {
        /*채팅창 오른쪽에 붙게*/
        aside[class^="live_chatting_container__"],
        div[class*="vod_chatting__"]
        {
            position: fixed;
            right: 0px;
            top: 0px;
            height: 100%;
        }

        div[class^="live_chatting_message_container__"] div[class^="live_chatting_message_chatting_message__"]
        {
            text-align: right;
        }

        /*span[class^="live_chatting_username_nickname__"],*/
        div[class^="live_chatting_guide_container__"]
        {
            text-shadow: 1px 0 1px #000, 0 1px 1px #000, -1px 0 1px #000,
            0 -1px 1px #000, 1px 1px 1px #000, -1px 1px 1px #000,
            -1px -1px 1px #000, 1px -1px 1px #000, 2px 2px 2px #000;
        }

        /*--채팅 내용 내부--*/
        span[class^="live_chatting_username_container__"]
        {
            padding: 4px 7px!important;
            margin-top: -6px!important;
            margin-bottom: -6px!important;
            right: -7px;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 7px;
        }

        span[class^="live_chatting_message_text__"]
        {
            text-shadow: 2px 0 1px #000, 0 2px 1px #000, -2px 0 1px #000,
            0 -2px 1px #000, 2px 2px 1px #000, -2px 2px 1px #000,
            -2px -2px 1px #000, 2px -2px 1px #000, 3px 3px 3px #000;
        }

        /*플레이어 버튼들*/
        .pzp-pc__bottom,
        .player_header,
        .pzp-pc-ui-bottom-shadow,
        div[class*="pzp-pc__setting"],
        .pzp-pc-settings
        {
            margin-right: 350px;
        }

        .pzp-pc-seeking-preview
        {
            left: -175px;
        }

        /*채팅입력창*/
        div[class^="live_chatting_area__"]
        {
            background-color: transparent;
        }

        div[class*="live_chatting_input_is_active"]
        {
            background-color: #141517cc;
        }

        div[class^="live_chatting_input_container__"]
        {
            background-color: #2e303366;
            transition: border .1s ease, background-color .1s ease;
        }

        video.webplayer-internal-video
        {
            max-width: 100%;
            width: auto!important;
        }
        div[class^="live_chatting_guide_inner__"],
        button[class^="live_chatting_scroll_button_chatting__"]
        {
            background-color: #0e0f1088
        }
    }

    @media (orientation: portrait)
    {
        /* 세로모드 치지직 자체 버그로 인해 추가해둔 것 */
        div[class^="vod_chatting__"]
        {
            height: 0px;
        }
    }

    /* 미션창, 상단고정메시지 */
    div[class^="live_chatting_list_fixed__"]
    {
        top: 30px;
        margin: 0px 30px 0px 30px;
    }

    /*채팅창 배경 및 왼쪽 테두리*/
    aside[class^="live_chatting_container__"],
    aside[class^="live_chatting_container__"]::before,
    div[class^="vod_chatting__"]
    {
        background-color: transparent;
    }

    /*채팅창 해더*/
    h2[class^="live_chatting_header_title__"],
    div[class^="vod_chatting_header__"]
    {
        background-color: transparent;
        border: 0px;
        z-index: 0;
    }

    /*채팅창 상단 고정 메시지*/
    div[class^="live_chatting_list_fixed__"]
    {
        background-color: transparent;
    }

    div[class^="live_chatting_ranking_container__"]
    {
        display: none;
    }

    /* 상단 고정 메시지 뒷 배경 그라디언트 */
    div[class^="live_chatting_fixed_container"]::before
    {
        background: transparent;
    }
}

span[class^="live_chatting_message_text__"]
{
    font-size: 1.25rem;
    line-height: 1.5rem;
    font-weight: bold;
    padding: 4px;
}

/* 뱃지 세로 가운데 정렬
span[class^="live_chatting_username_wrapper__"]
{
    display: flex;
    align-items: center;
} */
span[class^="live_chatting_username_nickname__"]
{
    font-size: 1rem;
}

/*ID와 채팅 사이 줄 바꾸기*/
span[class^="live_chatting_username_container__"],
span[class^="live_chatting_message_text__"]
{
    display: block;
}

/* 오른쪽 정렬이 이상해져서 추가 */
button[class^="live_chatting_message_wrapper__"],
/* 세로모드 때문에 추가 */
div[class^="live_chatting_list_wrapper__"]
{
    width: 100%;
}
    `;

    // style 태그를 생성하여 CSS를 삽입합니다.
    const styleSheet = document.createElement('style');
    styleSheet.type = 'text/css';
    styleSheet.innerText = customCss;
    document.head.appendChild(styleSheet);
})();
