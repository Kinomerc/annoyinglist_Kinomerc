/* ==UserStyle==
@name       Fluent UI for chzzk.naver.com
@version    20240930
@namespace  ?
==/UserStyle== */
@-moz-document domain("chzzk.naver.com") {
/* 햄버거 메뉴 */
/* 햄버거 메뉴 */
header[class^="header_area__"] button[class^="header_button"] svg:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s, color 0.3s;
    text-decoration: none !important;
    color: rgba(128, 128, 128, .9) !important;
}
div[class^="toolbar_section__"]
{
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}

/* 검색창 */
[class^="search_form__"]
{
    border: 1px solid rgba(0, 0, 0, 0.1)!important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    border-radius: 10px;
    padding: 8px;
    outline: none;
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="search_form__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    background-color: rgb(128, 128, 128, 0.1);
}
[class^="search_autocomplete__"]
{
    background-color: rgba(128, 128, 128, .3) !important;
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    border: 1px solid rgba(0, 0, 0, 0.1);
    margin-top: 5px!important;
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="search_autocomplete__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    background-color: rgb(128, 128, 128, 0.35);
}
[class^="search_off_button__"]
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="search_close_button__"]
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}

/* 검색창 오른쪽 아이콘 */
a[class^="toolbar_item__"]:hover
{
    background-color: rgba(128, 128, 128, .3) !important;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
a[class^="toolbar_item__"]:hover span[class^="toolbar_label__"]
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
div[class^="toolbar_item__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
div[class^="toolbar_item__"]:hover span[class^="toolbar_label__"]
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
div[class*="toolbar_profile__"]:hover
{
    border-radius: 50%;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
div[class*="toolbar_profile__"]:hover span[class^="toolbar_label__"]
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}

/* 최상단 프로필 클릭시*/
div[class^="profile_layer_container"]
{
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    background-color: rgba(128, 128, 128, .1);
    backdrop-filter: blur(10px);
    border-radius: 10px;
    border: 1px solid rgba(0, 0, 0, 0.1);
}
div[class^="profile_layer_container"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
    border: 1px solid rgba(0, 0, 0, 0.1);
    background-color: rgb(128, 128, 128, 0.15);
}
a[class^="profile_layer_area__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s, color 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}
li[class^="profile_layer_item__"] button[type="button"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
    text-decoration: none !important;
    color: rgba(128, 128, 128, .9) !important;
}

/* 사이드바 최상단 버튼*/
h[class^="navigator_button__"]
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
    text-decoration: none !important;
    color: rgba(128, 128, 128, .9) !important;
}
[class^="navigator_button__"] :hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
    text-decoration: none !important;
    color: rgba(128, 128, 128, .9) !important;
}

/* 사이드바 스트리머 큰틀*/
div[class^="navigator_header__"] h2[class="navigator_title__9RhVJ"]
{
    color: white;
}
a[class^="navigator_item__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
    border-color: rgb(128, 128, 128, 0.1);
}

/* 사이드바 확장*/
div[class*="header_is_expanded__"] div[class^="header_wrapper__"]
{
    /*
    background-color: rgba(128, 128, 128, .1);
    backdrop-filter: blur(10px);
    */
    border-radius: 10px;
    border: 1px solid rgba(0, 0, 0, 0.1);
}

/* 사이드바 - 호버시 보여지는 것*/
[class^="navigator_tooltip__"]
{
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    border: 1px solid rgba(0, 0, 0, 0.1);
}
[class^="navigator_inner__"]
{
    background-color: rgba(128, 128, 128, .3);
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
}
div[class^="navigator_tooltip"] div[class^="navigator_inner"] span
{
    color: #FFF;
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}

/* 사이드바 더보기 버튼 */
button[class^="navigator_button_more__"]
{
    border-radius: 10px;
    display: flex;
    align-items: center;
    color: white;
    transition: border-color 0.3s, background-color 0.3s, box-shadow 0.3s;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
}
button[class^="navigator_button_more__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, 0.3);
    border-color: rgb(128, 128, 128, 0.1);
    color: white;
}

/* 사용자 이름 및 스트리머 카테고리 */
div[class^="navigator_information"] strong[class^="navigator_name"] span[class^="name_ellipsis__"] [class^="name_text__"]
{
    color: white;
    transition: color 0.3s;
}
div[class^="navigator_information"] strong[class^="navigator_name"] span[class^="name_ellipsis__"] [class^="name_text__"]:hover
{
    color: rgba(255, 255, 255, .9);
}
div[class^="navigator_information"] span[class^="navigator_category"]
{
    color: rgba(255, 255, 255, .8);
    transition: color 0.3s;
}
div[class^="navigator_information"] span[class^="navigator_category"]:hover
{
    color: rgba(255, 255, 255, .7);
}
/* 로딩 이미지 */
div[class*="loading-indicator"]
{
    backdrop-filter: blur(10px);
    background-color: transparent;
    border-radius: 10px;
}
div[class*="loading-indicator"] svg
{
    backdrop-filter: blur(10px);
    border-radius: 10px;
}
div[class*="pzp-pc__loading-indicator"]
{
    backdrop-filter: blur(10px);
    background-color: transparent;
    border-radius: 10px;
}
div[class^="live_information_player__"]
{
        backdrop-filter: blur(10px) !important;
        border-radius: 10px !important;
        transition: border-color 0.2s, box-shadow 0.2s !important;
}


/* 알림 */
div[id^="onair_notification_section"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
    transform: translateY(30px) !important;
}
div[id^="onair_notification_section"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}


/* 채팅 설정 */
[class^="layer_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="layer_container__"] span
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="layer_container__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
[class^="layer_container__"] div[class^="layer_wrapper__"]
{
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="layer_container__"] div[class^="layer_wrapper__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}


/* 채팅내부 */
button[class^="live_chatting_message_wrapper__"] 
{
    transition: background-color 0.3s, box-shadow 0.3s;
}
/* 
button[class^="live_chatting_message_wrapper__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.1);
}
*/
button[class^="live_chatting_message_wrapper__"] span[class*="live_chatting_username_is_message__"]
{
    transition: background-color 0.3s, box-shadow 0.3s;
}
button[class^="live_chatting_message_wrapper__"] span[class*="live_chatting_username_is_message__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.1);
}

/* 닉네임 선택 시 표시메뉴 */
[class^="live_chatting_popup_profile_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_popup_profile_container__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
[class^="live_chatting_popup_profile_header__"]
{
    background-color: rgb(128, 128, 128, 0.3);
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
}
[class^="live_chatting_popup_profile_item__"]
{
    border-radius: 10px;
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_popup_profile_item__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.3);
}

[class^="live_chatting_scroll_button_chatting__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
}
[class^="live_chatting_scroll_button_chatting__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
/* 
    background-color: rgb(128, 128, 128, 0.1);
*/

/* 채팅 박스 */
[class^="live_chatting_input_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
    overflow: hidden;
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_input_container__"]:hover
{
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
/* 
[class^="live_chatting_input_container__"]::before
{
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: inherit;
    z-index: 0;
}
[class^="live_chatting_input_container__"]>*
{
    position: relative;
    z-index: 1;
}
*/
button[class^="live_chatting_input_setting_button__"]:hover
{
    background-color: rgba(128, 128, 128, .3) !important;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
}
button[class^="live_chatting_input_input_button__"]:hover
{
    background-color: rgba(128, 128, 128, .3) !important;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
}
button[class^="live_chatting_input_input__"]:focus [class^=live_chatting_input_container]
{
    background-color: rgba(128, 128, 128, .3) !important;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
}
.live_chatting_message_text {
    color: white !important;
}
.live_chatting_message_wrapper__xpYre {
    color: white !important;
}




/* 내 설정 */
[class^="live_chatting_popup_my_profile_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_popup_my_profile_container__"] *
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="live_chatting_popup_my_profile_contents__"]
{
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.1);
}
[class^="live_chatting_popup_my_profile_area__"]
{
    background-color: rgb(128, 128, 128, 0.3);
}
[class^="live_chatting_popup_my_profile_container__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
[class^="live_chatting_popup_my_profile_preview__"]
{
    border: 1px solid rgba(0, 0, 0, 0.1);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_popup_my_profile_preview__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
}
/* 치즈 */
[class^="live_chatting_popup_donation_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="live_chatting_popup_donation_container__"] *
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="live_chatting_popup_donation_container__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
[class^="live_chatting_popup_donation_button_close"]
{
        filter: invert(1);
}
[for="donation-money"]
{
    background-color: rgb(128, 128, 128, 0.3);
}
[for="donation-money"]
{
    background-color: rgb(128, 128, 128, 0.3);
}

/* 이모티콘 */
[class^="emoticon_container__"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3);
    transition: background-color 0.3s, box-shadow 0.3s;
}
[class^="emoticon_container__"] *
{
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black;
}
[class^="emoticon_container__"]:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
    background-color: rgb(128, 128, 128, 0.15);
}
[class^="emoticon_button_close__"]
{
        filter: invert(1);
}
[class^="emoticon_subtitle__"]
{
    background-color: rgb(128, 128, 128, 0.3);
}
[class^=flicking-arrow-prev], [class^=flicking-arrow-next]
{
    background-color: transparent !important;
}
[class^=flicking-arrow-prev], [class^=flicking-arrow-next] svg
{
        filter: invert(1);
}
}
