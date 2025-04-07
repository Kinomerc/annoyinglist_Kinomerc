/* ==UserStyle==
@name       Fluent UI for dcinside.com
@version    20241109
@namespace  kinomerc
==/UserStyle== */
@-moz-document domain("dcinside.com") {
/* 디시인사이드 첫 페이지 좌상단 -> 우하단으로 */
/*
img[src^="https://nstatic.dcinside.com/dc/logo_day/special/"] {
    filter: invert(100%) grayscale(100%) sepia(100%) !important;
}

img[class^=logo_img] {
    filter: invert(100%) grayscale(100%) sepia(100%) !important;
}
*/
/*
background-color: rgba(64, 66, 75, 0.1) !important;

    text-shadow: -1px -1px 0 white, 1px -1px 0 white, -1px 1px 0 white, 1px 1px 0 white; 
*/

/* 최상단 검색창 */
div[class*="top_search clear"] {
    display: block !important;
    background-color: rgba(0, 0, 0, 0) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class*="top_search clear"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class*="top_search clear"] div[class="inner_search"] input[class="in_keyword"] {
    border-radius: 8px !important;
}
div[class="inner_search"] {
    border-radius: 10px !important;
}
button[class$="bnt_search"] {
    border-radius: 0 10px 10px 0 !important;
    margin: 1px 0 1px 0;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class$="bnt_search"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="auto_wordwrap"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="auto_wordwrap"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
h3[class="word_tit"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
h3[class="word_tit"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class="word_list"] {
    margin-left: 10px !important;
    margin-right: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
h3[class="word_list"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
li[class="search_key"] {
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
li[class="search_key"]:hover {
    background-color: rgba(128, 128, 128, 0.3) !important;
    backdrop-filter: blur(60px) !important;
}
div[class="word_close"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 0 0 10px 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}

 /* 갤러리 마이너갤 미니갤 인물갤 갤로그 */
div[class="gnb_bar"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="gnb_bar"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
a[href="https://gall.dcinside.com"] {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://gall.dcinside.com"]:hover {
    text-decoration: none !important;
    color: rgba(255, 237, 68, .9);
}
a[href="//gall.dcinside.com/m"] {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="//gall.dcinside.com/m"]:hover {
    text-decoration: none !important;
    color: rgba(255, 237, 68, .9);
}
a[href="//gall.dcinside.com/n"] {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="//gall.dcinside.com/n"]:hover {
    text-decoration: none !important;
    color: rgba(255, 237, 68, .9);
}
a[href="//gall.dcinside.com/p"] {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="//gall.dcinside.com/p"]:hover {
    text-decoration: none !important;
    color: rgba(255, 237, 68, .9);
}
a[href="https://gallog.dcinside.com"] {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://gallog.dcinside.com"]:hover {
    text-decoration: none !important;
    color: rgba(255, 237, 68, .9);
}

 /* 최근방문 */
div[id="visit_history"] {
    margin-top: 10px !important; 
    border: none !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
 /* 최근방문 첫페이지 문제 있음? */
div[id="visit_history"]:hover {
    box-shadow: 0 2px 4px rgba(128, 128, 128, 0.3) !important;
}
div[class="newvisit_history vst"] { 
    background-color: rgba(255, 255, 255, 0.3) !important;
    border-top: 1px solid #d5d5d5 !important;
    border-left: none !important;
    border-right: none !important;
    border-bottom: none !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
li[class^="lately_gall_"] a[class="lately_log"]  {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li[class^="lately_gall_"] a[class="lately_log"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
button[class="bnt_newvisit_more"] {
    color: rgba(202, 203, 251) !important;
    text-decoration: none; 
    transition: color 0.3s ease !important;
}
button[class="bnt_newvisit_more"]:hover {
    text-decoration: none; 
    color: rgba(202, 203, 251, .9) !important;
}

/* 최근방문 ↓ 아이콘 */
em[class="sp_img icon_listmore"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
em[class="sp_img icon_listmore"]:hover {
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 8px rgba(, 0.2) !important;
}

/* 최근방문 ↓ 선택시 나오는 창 */
div[class="pop_wrap gray1px"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 10px !important;
}
div[class="pop_wrap gray1px"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

 /* 실베 */
header[class="con_head"][id="time_best_head_tab"] {
    border: none !important;
}
a[href="https://gall.dcinside.com/board/lists/?id=dcbest"][class="allview_go"] {
    transform: translateY(1px) !important;
}
button[type="button"][class^="btn_rank btn_dcbest_rank_tab"] {
    transform: translateY(0.2px) !important;
}
div[id="dcbest_list_page_top"][class="pageing"] {
    transform: translateY(3px) !important;
}
li {
    border: none !important;
    border-radius: 10px !important;
}
li span {
    border: none !important;
    border-radius: 5px !important;
}
div[class="txt_box"] strong[class="tit"]{
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="txt_box"] strong[class="tit"]:hover {
    text-decoration: none !important;
    color: rgba(128, 128, 128, .9) !important;
}
div[class="box bestimg"] {
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="box bestimg"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
div[class="box besttxt"] p{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="box besttxt"] p:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
div[class="box besttxt"] span[class="num"]{
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="box besttxt"] span[class="num"]:hover {
    text-decoration: none !important;
    color: rgba(227, 81, 40, .9);
}
div[class="txt_box"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    color: white !important;
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black!important;
}
span[class="cover"] {
    background-color: rgba(255, 255, 255, .15)!important;
    border-radius: 10px !important;
}
div[class="info"] {
    color: white !important;
}
button[class^="sp_main btn_prev realtime_prev"] {
    border-top-left-radius: 10px !important; 
    border-bottom-left-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class^="sp_main btn_next realtime_next"] {
    border-top-right-radius: 10px !important; 
    border-bottom-right-radius: 10px !important; 
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="box best_info"] span { display: inline-block; transform: translateY(3px) !important; }
button[class="btn_rank_close sp_main"]{
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transform: scale(0.90) translateY(3px) !important;
    border-radius: 100%;
}
button[class^="btn_dcbest_rank_tab"][data="hit"] {
    border-top-left-radius: 10px !important; 
    border-bottom-left-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class^="btn_dcbest_rank_tab"][data="hit"]:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class^="btn_dcbest_rank_tab"][data="recom"]:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class^="btn_dcbest_rank_tab"][data="comment"] {
    border-top-right-radius: 10px !important; 
    border-bottom-right-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class^="btn_dcbest_rank_tab"][data="comment"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
span[class="rank_num"] em {
    position: relative !important;
    top: 1px !important;
}
span[class="rank_txt"] {
    position: relative !important;
    top: 1px !important;
}
span[class="rank_state"] {
    position: relative !important;
    top: 1px !important;
}

 /* 로그인정보 */
div[id="login"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[id="login_box"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[d="login_boxr"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="log_inr"]{
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="log_inr"]:hover {
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
span[class^="sp_loginout ip ssl_icon"] {
    border-radius: 5px !important; 
}
span[class^="ssl_icon sp_loginout ip"] {
    border-radius: 5px !important; 
}

div[class="input_box"] {
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
div[class="input_box"]:focus {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254) !important;
    outline: none !important;
}
input[name="user_id"] {
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
input[name="user_id"]:focus {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254);
    outline: none !important;
}
input[name="user_id"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254);
    outline: none !important;
}
input[name="user_id"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254);
    outline: none !important;
}
input[name="pw"] {
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
input[name="pw"]:focus {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254);
    outline: none !important;
}
input[name="pw"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    border-color: rgba(98, 205, 254);
    outline: none !important;
}
div[class="logon_option"] a {
    border-radius: 5px !important;
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="logon_option"] a:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
button[class="btn_blue small btn_wfull"] {
    border: 1px solid rgba(0, 0, 0, 0.2) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
button[class="btn_blue small btn_wfull"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[id="login_ok"]{
    margin-top: 10px !important;
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[id="login_ok"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class="clear"] li span {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
ul[class="clear"] li span:hover {
    background-color: rgba(243, 243, 243, .9)!important;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
}
ul[class="clear"] li span a:hover {
    text-decoration: none !important;
}
button[class="btn_inout logout"]{
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_inout logout"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="options"] a{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="options"] a:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
span[class^="sp_loginout noti"] {
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
span[class^="sp_loginout noti"]:hover {
    background-color: rgba(51, 51, 51, .1) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

div[class="user_option"] a {
    text-decoration: none !important; 
    transition: border-color 0.2s, box-shadow 0.2s !important;
}

div[class="user_option"] a:hover {
    text-decoration: none !important;
}
.user_option {
    border-radius: 0 0 10px 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
.user_option a {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
.user_option a:hover {
    text-decoration: none !important;
    background-color: rgba(51, 51, 51, .1) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="user_info newarea"] {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="user_info newarea"]:hover {
    text-decoration: none !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="user_option four"] {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="user_option four"]:hover {
    text-decoration: none !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="btn_box"] button[class="btn_white"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="btn_box"] button[class="btn_white"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}    
    
div[class="btn_box"]  button[class="btn_grey"] {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="btn_box"]  button[class="btn_grey"]:hover {
    background-color: rgba(102, 102, 102, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[id="bestConConf"] {
    background-color: rgba(255, 255, 255, 0.3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.3s !important;
    margin-top: 10px !important;
}
div[id="bestConConf"] div[class="pop_content gallercon_ly"] {

    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    transition: background-color 0.2s, box-shadow 0.3s !important;
    margin-top: 10px !important;
}
div[id="bestConConf"] div[class="pop_content gallercon_ly"]:hover {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}   
    
    
    
    
    
    
    
    
    
    
    
    
    
/* 체크마크 */
.checkmark {
    transform: scale(0.90) translateX(-1px) !important;
    width: 20px;
    height: 20px; 
    border: 1px solid #ccc; 
    border-radius: 5px; 
    background: rgba(255, 255, 255, 0.3); 
    margin-right: 10px; 
    position: relative; 
    transition: background 0.3s, border 0.3s; 
}
.checkbox input[type="checkbox"]:checked + .checkmark {
    background: rgba(0, 150, 255, 0.5); 
    border-color: rgba(0, 150, 255, 1); 
}
.radiobox input[type="radio"]:checked + .checkmark {
    background: rgba(0, 150, 255, 0.5); 
    border-color: rgba(0, 150, 255, 1); 
}
.checkbox input[type="checkbox"]:checked + .checkmark:after {
    content: '';
    position: absolute;
    left:5px; 
    top:2px;
    width: 3px; 
    height: 7px; 
    border: solid white; 
    border-width: 0 2px 2px 0; 
    transform: rotate(45deg);
}

 /* 알림 */
div[id="alarmList"] {
    background-color: rgba(255, 255, 255, 0.3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.3s !important;
    margin-top: 10px !important;
}
div[id="alarmList"]:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
em[class="sp_img icon_bgblueclose"] {
    border-radius: 50% !important;
    transform: translate(-6px, 8px) scale(0.75) !important; 
}
div[class^="alarmPopup"] {
    background-color: rgba(255, 255, 255, 0.3)!important;
    backdrop-filter: blur(10px) !important;
    border: 2px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.3s !important;
    margin-top: 10px !important;
}
div[class^="alarmPopup"]:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[href^="https://gall.dcinside.com/board/view/"] {
    transform: translateX(4px) translateY(0px) !important;
}
div[class^="alarmPopup"] div a
{
    transform: translateX(6px) translateY(0px) !important;
    transition: color 0.2s !important;
}
em[class="sp_img icon_bword_del"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    transform: translateY(-1px) !important;
}
span[class="new"] {
    display: none !important; /* 요소 숨기기 */
}
div[class="refresher-toast"] {
    background-color: rgba(255, 255, 255, 0.3)!important;
    backdrop-filter: blur(10px) !important;
    border: 2px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.3s;
}
 div[class^="refresher-toast"]:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}


/* 실북 흥한갤 */
div[class="content_box hotlive gall_rank"][id="rank_gall"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="content_box hotlive gall_rank"][id="rank_gall"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="box_bottom rank_more"]{
    border-radius: 0 0 10px 10px !important;
}
a[class*="rank_gall rank_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_gall rank_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(59, 72, 144, .9) !important;
}
a[class*="rank_mgall rank_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_mgall rank_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(255, 102, 0, .9) !important;
}
a[class*="rank_mini rank_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_mini rank_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(111, 109, 217, .9) !important;
}
a[class*="rank_person rank_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_person rank_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(79, 190, 23, .9) !important;
}
a[class*="rank_gall hot_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_gall hot_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(59, 72, 144, .9) !important;
}
a[class*="rank_mgall hot_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_mgall hot_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(255, 102, 0, .9) !important;
}
a[class*="rank_mini hot_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_mini hot_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(111, 109, 217, .9) !important;
}
a[class*="rank_person hot_tab_clk"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class*="rank_person hot_tab_clk"]:hover {
    text-decoration: none !important;
    color: rgba(79, 190, 23, .9) !important;
}
div[class="box_bottom rank_more" ]{
    border-radius: 0 0 10px 10px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="box_bottom hot_more" ]{
    border-radius: 0 0 10px 10px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="content_box hot"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="content_box hot"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="box_bottom hot_more"]{
    border-radius: 0 0 10px 10px !important;
}
em[class="sp_img icon_hotgall"] {
    display: none !important;
}
span[class="rank_txt"]{
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
span[class="rank_txt"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
/* 
a[section_code="main_minor_count"] span[class="rank_txt"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}

a[section_code="main_minor_count"] span[class="rank_txt"]:hover {
    padding: 4px!important;
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    display: inline-block !important;
    position: relative !important;
    left: -1px !important; 
    top: -3px !important;
    text-decoration: none !important;
}

a[section_code="main_count"] span[class="rank_txt"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}

a[section_code="main_count"] span[class="rank_txt"]:hover {
    padding: 4px!important;
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    display: inline-block !important;
    position: relative !important;
    left: 12px !important; 
    top: -18px !important;
    text-decoration: none !important;
}
*/
a[href="https://www.dcinside.com/company"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://www.dcinside.com/company"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href="https://www.dcinside.com/company#alliance"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://www.dcinside.com/company#alliance"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href="https://nstatic.dcinside.com/dc/dcad/w/index.html"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://nstatic.dcinside.com/dc/dcad/w/index.html"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/policy_index.html"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/policy_index.html"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/privacy_index.html"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/privacy_index.html"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/youth_policy.html"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href="https://nstatic.dcinside.com/dc/w/policy/youth_policy.html"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}

/* gall.dcinside.com */
li a[href="https://gall.dcinside.com/"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href="https://gall.dcinside.com/"]:hover {
    color: #007bff !important;
}
li a[href="https://gall.dcinside.com/m"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href="https://gall.dcinside.com/m"]:hover {
    color: #007bff !important;
}
li a[href="https://gall.dcinside.com/n"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href="https://gall.dcinside.com/n"]:hover {
    color: #007bff !important;
}
li a[href="https://gall.dcinside.com/p"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href="https://gall.dcinside.com/p"]:hover {
    color: #007bff !important;
}
li a[href="https://gallog.dcinside.com"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href="https://gallog.dcinside.com"]:hover {
    color: #007bff !important;
}
li a[href^="https://mall.dcinside.com/"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href^="https://mall.dcinside.com/"]:hover {
    color: #007bff !important;
}
a[class="darkonoff"]{
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[class="darkonoff"]:hover {
    color: #007bff !important;
}
li a[href^="https://gallog.dcinside.com/"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href^="https://gallog.dcinside.com/"]:hover {
    color: #007bff !important;
}
li a[href^="https://sign.dcinside.com/myinfo/"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[href^="https://sign.dcinside.com/myinfo/"]:hover {
    color: #007bff !important;
}
li a[onclick="myFavorite('50%')"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[onclick="myFavorite('50%')"]:hover {
    color: #007bff !important;
}
li a[id="my_minor_btn_h"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[id="my_minor_btn_h"]:hover {
    color: #007bff !important;
}
li a[onclick="alarmList($('.icon_noti', this), 'new','H')"] {
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
li a[onclick="alarmList($('.icon_noti', this), 'new','H')"]:hover {
    color: #007bff !important;
}
a[class="btn_top_loginout"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
a[class="btn_top_loginout"]:hover {
    background-color: rgba(59, 72, 144, .9);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

em[class^="sp_img icon_blueprev"] {
    border-top-left-radius: 10px !important; 
    border-bottom-left-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
em[class^="sp_img icon_bluenext"]{
    border-top-right-radius: 10px !important; 
    border-bottom-right-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class^="hot_gall_box"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class^="hot_gall_box"] {
    background-color: rgba(255, 255, 255, 0.3);
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
header[class="box_head clear"] {
    background-color: rgba(255, 255, 255, 0) !important;
    border-top-left-radius: 10px !important; 
    border-top-right-radius: 10px !important; 
}
button[class="btn_white_round btn_hotgall_allview"]{
    transform: translateY(-1px) !important;
}

/* gall.dcinside.com/m */
div[class="mgall_list_wrap clear"] {
    background-color: rgba(255, 255, 255, 0.3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="mgall_list_wrap clear"]:hover {
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_white_round btn_hotgall_allview"]{
    transform: translateY(-1px) !important;
}
a[class="btn_red mgall_make_go round"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}

a[class="btn_red mgall_make_go round"]:hover {
    background-color: rgba(255, 153, 0, 0.9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

/* gall.dcinside.com/gallery */
div[class="fl clear"]{
    transform: translateY(-4px) !important;
}

div[class="fr gall_issuebox"]{
    margin-top: -11px !important;
}
div[class="issue_wrap"]{
    border: none !important;
}
div[class="concept_wrap"]{
    background-color: rgba(255, 255, 255, 0.3)!important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[id="gallery_info"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_white_round btn_hotgall_allview"] {
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_white_round btn_hotgall_allview"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="imgbox"] {
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[class="imgbox"] :hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[id="hot_rank_pop"] {
    background-color: rgba(255, 255, 255, .8)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 10px !important;
}
div[id="relation_popup"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[id="relation_popup"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pop_info"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
}
div[class="pop_head"]{
    border: none !important;
    border-bottom: 2px solid rgba(255, 255, 255, .3) !important;
}
div[class="follower inner"]{
    border: none !important;
    border-left: 2px solid rgba(0, 0, 0, 0.3) !important;
}
ul[class="list_box clear"] li a[href^="/board/lists?id="]{
    transition: color 0.4s ease;
}
ul[class="list_box clear"] li a[href^="/board/lists?id="]:hover {
    text-decoration: none; 
    color: #007bff;
}
ul[class="list_box clear"] li a[href^="/mini/board/lists?id"]{
    transition: color 0.4s ease;
}
ul[class="list_box clear"] li a[href^="/mini/board/lists?id="]:hover {
    text-decoration: none; 
    color: #007bff;
}
div[class="concept_wrap"] {
    transition: box-shadow 0.2s ease, background-color 0.2s ease !important;
}
div[class="concept_wrap"]:hover {
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pageing_box"] {
    width: calc(100% - 10px);
    margin-top: 10px !important;
}
ul[class="concept_txtlist"]{
     transform: scale(0.9)
}
div[class="concept_img"]{
    transform: scale(0.9)
}
div[id="pop_manage_report_list"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="pop_content mng_reportlist"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="pop_content mng_reportlist"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="minor_ranking_box"] {
    border: none !important;
}
div[class="fr"] button[class="btn_grey small"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="fr"] button[class="btn_grey small"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[href^="https://gall.dcinside.com/board/view/?"] {
    border: none !important;
    transform: translateX(-1px) !important;
}
a[href^="https://gall.dcinside.com/board/view/?id="] {
    border-radius: 5px !important;
    text-decoration: none !important; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href^="https://gall.dcinside.com/board/view/?id="]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
div[class="list_array_option clear"] {
    border: none !important;
    position: relative;
    top: -5px !important; 
}
div[class="array_tab left_box"] button[class="on"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="array_tab left_box"] button[class="on"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="array_tab left_box"] button{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="array_tab left_box"] button:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
.select_area a {
    display: inline-block; 
    text-decoration: none; 
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease;
}
div[class="right_box"] div[class="select_box array_num"] div[class="select_area"]{
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="right_box"] div[class="select_box array_num"] div[class="select_area"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[class="btn_write txt"] {
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
a[class="btn_write txt"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="output_array clear"] {
    position: relative;
    top: -4px !important;
}
a[view-msg] {
    transition: color 0.4s ease;
}
a[view-msg]:hover {
    text-decoration: none; 
    color: #007bff;
}
a[target="_blank"] {
    transition: color 0.4s ease;
}
a[target="_blank"]:hover {
    text-decoration: none; 
    color: #007bff;
}
a[class="reply_numbox"] {
    transition: color 0.4s ease;
}
a[class="reply_numbox"]:hover {
    text-decoration: none; 
    color: #007bff;
}
span[class="reply_num"]{
    transition: color 0.4s ease;
}
span[class="reply_num"]:hover {
    text-decoration: none; 
    color: #007bff;
}
ul[id="listSizeLayer"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 3px !important;
}
ul[id="listSizeLayer"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class="user_data_list"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 10px !important;
}
ul[class="user_data_list"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
li a[href^="//gallog.dcinside.com/"] {
    background-color: rgba(255, 255, 255, 0)!important;
    transition: color 0.3s !important;
}
li a[href^="//gallog.dcinside.com/"]:hover {
    text-decoration: none; 
    color: #007bff;
}
li[class="bg_grey"] {
    background-color: rgba(255, 255, 255, 0)!important;
    transition: color 0.3s !important;
}
li a[href^="/board/lists/?"] {
    transition: color 0.3s !important;
}
li a[href^="/board/lists/?"]:hover {
    text-decoration: none; 
    color: #007bff;
}
li a[href^="/mgallery/board/lists/?"] {
    transition: color 0.3s !important;
}
li a[href^="/mgallery/board/lists/?"]:hover {
    text-decoration: none; 
    color: #007bff;
}
li[class="bg_jingrey"] {
    background-color: rgba(255, 255, 255, 0)!important;
    text-shadow: 1px 0 1px #000, 0 1px 1px #000, -1px 0 1px #000,
    0 -1px 1px #000, 1px 1px 1px #000, -1px 1px 1px #000,
    -1px -1px 1px #000, 1px -1px 1px #000, 1px 1px 1px #000;
    transition: color 0.3s !important;
}
li a[href^="javascript:ub_save_conf_one"] {
    transition: color 0.3s !important;
}
li a[href^="javascript:ub_save_conf_one"]:hover {
    text-decoration: none; 
    color: #007bff;
}
a[href^="/board/lists/?id="] {
    transition: color 0.3s !important;
}
a[href^="/board/lists/?id="]:hover {
    text-decoration: none; 
    color: rgba(255, 153, 0, 0.9) !important;
}
a[class="sp_pagingicon page_first"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
a[class="sp_pagingicon page_first"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[class="sp_pagingicon page_prev"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
a[class="sp_pagingicon page_prev"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

a[class="sp_pagingicon page_next"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
a[class="sp_pagingicon page_next"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[class="sp_pagingicon page_end"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
a[class="sp_pagingicon page_end"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="user_option "]{
    background-color: rgba(255, 255, 255, 0.3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 0 0 10px 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="fl"] button[class="list_bottom btn_blue"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fl"] button[class="list_bottom btn_blue"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="fl"] button[class="list_bottom btn_white"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fl"] button[class="list_bottom btn_white"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="fr"] button[class="btn_blue write"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fr"] button[class="btn_blue write"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="select_box bottom_array fl"] {
    display: block !important;
    background-color: rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="select_area"] span[class="inner"] {
    border-radius: 8px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="select_area"] span[class="inner"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[id="searchTypeLayer"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 8px !important;
}
ul[id="searchTypeLayer"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="bottom_search fl clear"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="bottom_search fl clear"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
input[class="in_keyword"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
input[class="in_keyword"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="sp_img bnt_search"]{
    transform: scale(1.03) translateY(-1px) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class="sp_img bnt_search"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

/* gall.dcinside.com/mgallery */
div[class="issue_contentbox clear"]{
    background-color: rgba(255, 255, 255, 0.3)!important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="issue_contentbox clear"]:hover {
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[class="mintro_imgbox in_img "]{
    background-color: rgba(255, 255, 255, 0.3)!important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    transform: scale(0.9) translateX(5px) ;
}
a[class="mintro_imgbox in_img "]:hover {
    background-color: rgba(255, 255, 255, 0.3)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pop_tipbox setting_list"] {
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="pop_tipbox setting_list"] div[class="inner"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="pop_tipbox setting_list"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
li[id="ai_easy"] span[class="checkbox"] em[class="checkmark"] {
    transform: translate(16px, -9px) !important;
}
em[class="icon_mgall_dcp sp_img"] {
    border-top-right-radius: 10px !important;
}
div[class="minor_ranking_box"]{
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
}
em[class="sp_img icon_prev"] {
    border-radius: 10px !important;
}
em[class="sp_img icon_next"] {
    border-radius: 10px !important;
}
div[class="center_box"] div[class="inner"] {
    position: relative;
    top: -4px !important;
}
div[class="center_box" ] div[class="inner"] ul li a {
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[class="center_box" ] div[class="inner"] ul li a:hover {
    text-decoration: none !important;
    color: #007bff;
}
button[class="btn_hotall_list sp_img"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_hotall_list sp_img"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pop_wrap type2"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 10px !important;
}
div[class="pop_wrap type2"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="inner"] div[class="subject_morelist"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
    margin-top: 3px !important;
    transform: translateX(35px) !important;
}
div[class="inner"] div[class="subject_morelist"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
a[href^="javascript:listDisp("] {
    transition: color 0.2s, box-shadow 0.2s !important;
}
a[href^="javascript:listDisp("]:hover {
    text-decoration: none !important;
    color: #007bff;
}

/* gall.dcinside.com/mini */
div[class="fl"] button[class="list_bottom btn_lightpurple"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fl"] button[class="list_bottom btn_lightpurple"]:hover {
    background-color: rgba(111, 109, 217, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="fl"] button[class="list_bottom btn_whitepurple"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fl"] button[class="list_bottom btn_whitepurple"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="fr"] button[class="btn_lightpurple write"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    margin-right: 2px;
}
div[class="fr"] button[class="btn_lightpurple write"]:hover {
    background-color: rgba(111, 109, 217, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div a[href^="/mini/board/lists/?"] {
    transition: color 0.3s !important;
}
div a[href^="/mini/board/lists/?"]:hover {
    text-decoration: none; 
    color: rgba(255, 153, 0, 0.9) !important;
}

/* gall.dcinside.com/person */
div[class="img_contbox"] div[class="network_box"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
    transform: scale(0.90) translateX(3px) !important;
}
div[class="btm_contbox"] div[class="rt"] {
    transform: translateX(-18px) translateY(-8px) !important;
}
div[class="img_contbox"] div[class="network_box"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="network_box"] a[class="top"] {
   border-top-left-radius: 10px !important;
    border-top-right-radius: 10px !important;
}

div[class*="person"] div[class="wrap_inner "] section[class="left_content"] article div[class="issue_wrap"] div[class="issuebox gallery_box"] div[class="pop_wrap type3"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[class*="person"] div[class="wrap_inner "] section[class="left_content"] article div[class="issue_wrap"] div[class="issuebox gallery_box"] div[class="pop_wrap type3"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pop_content network_map_ly"] div[class="pop_head bg"] {
    border-top-left-radius: 10px !important;
    border-top-right-radius: 10px !important;
}
div[class="center"] div[class="thumbox"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[class="center"] div[class="thumbox"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class^="mapcont_lst"] li[class^="no"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
ul[class^="mapcont_lst"] li[class^="no"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class^="mapcont_lst"] li[class^="no"] a div[class="thumimg"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
ul[class^="mapcont_lst"] li[class^="no"] a {
    border: none !important;
    border-radius: 10px !important;
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[class="btm_contbox"] div[class="pop_wrap type3"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="pop_content mng_history_ly"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class*="person"] div[class="wrap_inner "] section[class="left_content"] article div[class="issue_wrap"] div[class="issuebox gallery_box"] div[class="issue_contentbox clear"] div[class="minor_intro_box clear"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
}
div[class="profile_form"] div[class="profile_form_box"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="draggable ui-sortable"] div[class="profile_form_box rt"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}

/* gallog.dcinside.com */
div[class="top_bar"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="top_bar"] div[id="top_bg"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[id="calendar_layer"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="tab_menubox gallogset_tab"] button {
    border: none !important;
    transition: color .2s !important;
}
div[class="tab_menubox gallogset_tab"] button:hover {
    text-decoration: none !important;
    color: rgba(205, 206, 255, .9) !important;
}
div[class="pop_content gallog_setting three"] div[class="pop_head bg"] {
    border-top-left-radius: 10px !important;
    border-top-right-radius: 10px !important;
}
div[class="gallog_set_box rbox"] div[class="pop_wrap type3"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="gallog_set_box rbox"] div[class="pop_wrap type3"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="tabcontent gallog_blockset"] div[class="pop_info"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
}
div[class="sehbox"] button[class="btn_enroll"]  {
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
}
div[class="set_cont"] div[class="inner"] div[id="topbg_img"] div[class="fl"] div[class="up_bgimg"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-left-radius: 10px !important;
    border-bottom-left-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="set_cont"] div[class="inner"] div[id="topbg_img"] div[class="fl"] div[class="up_bgimg"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="set_cont"] div[class="inner"] div[id="topbg_img"] div[class="fl bg_fileup"] button[class="btn_fileup"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
} 
div[class="set_cont"] div[class="inner"] div[id="bg_img"] div[class="fl"] div[class="up_bgimg"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-left-radius: 10px !important;
    border-bottom-left-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="set_cont"] div[class="inner"] div[id="bg_img"] div[class="fl"] div[class="up_bgimg"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="set_cont"] div[class="inner"] div[id="bg_img"] div[class="fl bg_fileup"] button[class="btn_fileup"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
} 
div[class="inner bg_colorbox"] div[class="gallog_set bg_color clear"] div[class="fl int"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
} 
div[class="palette"] ul[class="clear"] li[class="color"] button[type="button"]  {
    border: none !important;
    border-radius: 2px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
} 
div[class="palette"] ul[class="clear"] li[class="color"] button[type="button"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="inner"] div[class="setting_onoff"] button[class*="sp_img"] {
    border-radius: 10px !important
}
div[class="set_cont"] div[class="inner"] div[id="profile_img"] div[class="fl"] div[class="up_bgimg"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-left-radius: 10px !important;
    border-bottom-left-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="set_cont"] div[class="inner"] div[id="profile_img"] div[class="fl"] div[class="up_bgimg"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="set_cont"] div[class="inner"] div[id="profile_img"] div[class="fl bg_fileup"] button[class="btn_fileup"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
} 
div[class="pop_content gallog_setting three"] div[class="btn_box"] button[class="btn_apply"]{
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="pop_content gallog_setting three"] div[class="btn_box"] button[class="btn_apply"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class="gallog_menu"] li a {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden;
}
ul[class="gallog_menu"] li a:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    text-decoration: none; 
}
div[class="option_sort gallog"] div[class="select_box select_arraybox ul_selectric"] ul[class="option_box"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}

div[class="gallog_cont postings"] div[class="cont_head clear"] div[class="search_wrap"] div[class="search_box"] div[class="search clear"] form[name="f_search"] button[class="sp_img bnt_search"]  {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    transform: translateY(-1px) !important;
}
div[class="gallog_cont postings"] div[class="cont_head clear"] div[class="search_wrap"] div[class="search_box"] div[class="search clear"] form[name="f_search"] div[class="inner_search"] {
    transform: translateX(-10px) !important;
}
div[class="select_box select_arraybox ul_selectric"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="select_box select_arraybox ul_selectric"] ul[id="conf_sel_gall"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="select_box select_arraybox ul_selectric"] ul[id="conf_sel_gall"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

/* board/write */
div[lass="issuebox gallery_box"] div[class="issue_contentbox clear"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="minor_intro_box clear"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="minor_ranking_box"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class^="user_guide_popup"]  {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border: none !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class^="user_guide_popup"] div[class="pop_content gall_guide"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class^="user_guide_popup"] div[class="pop_content gall_guide"] div[class="caption_box"]{
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="write_subject clear"] {
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    background: rgba(255, 255, 255, 0.3); 
    border-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="write_subject clear"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
.write_subject {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
.subject_list li.sel {
    position: relative;
}
.subject_list li.sel::after {
    content: '';
    position: absolute;
    border-radius: 10px;
    top: 0; left: 0; right: 0; bottom: 0;
    box-shadow: 0 0 5px white; 
    filter: invert(1); 
}
.put_inquiry {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden; 
}
.put_inquiry:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_temporary_save"]{
    border: 1px solid rgba(0, 0, 0, 0) !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}

button[class="btn_temporary_save"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

div[class="temporary_save_box"] div[id="tmp_layer"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="temporary_save_box"] div[id="tmp_layer"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
em[class="sp_img icon_saveclose"] {
    border-radius: 50% !important;
    transform: translate(-6px, 8px) scale(0.75) !important; 
}
ul[class="save_list"] li[data-idx] {
    display: flex; /* flexbox로 설정하여 한 줄로 나열 */
    align-items: center; /* 수직 정렬 */
}
div[class="temsave_info_box"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="editor_wrap"]{
    border: none;
}
.write_infobox {
    display: none; 
}
div[id="tx_sidebar"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-top-left-radius: 10px; 
    border-top-right-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important
}
div[class="tx-sidebar-boundary"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-top-left-radius: 10px; 
    border-top-right-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important
}
div[id="tx_toolbar_basic"]  {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
}
article[id="write_wrap"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px; 
}
div[id="tx_canvas" ] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-bottom-left-radius: 10px; 
    border-bottom-right-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    overflow: hidden;  
}
div[id="tx_canvas"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[id="tx_attach_div"] div[id="tx_attach_box"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_attach_div"] div[id="tx_attach_box"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[id="tx_attach_div"] div[id="tx_attach_box"] div[class="tx-attach-box-inner"]  div[id="tx_attach_preview"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-top-left-radius: 10px; 
    border-bottom-left-radius: 10px; 
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_attach_div"] div[id="tx_attach_box"] div[class="tx-attach-box-inner"]  div[class="tx-attach-main"] ul[id="tx_attach_list"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
img[src^="https://nstatic.dcinside.com/dc/w/images/editor/icon/"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
img[src^="https://dcimg2.dcinside.co.kr/viewimage.php"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
img[src^="https://dcimg4.dcinside.co.kr/viewimage.php"] {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}    
li[id="tx_attach_delete"] a {
    background-color: rgba(255, 255, 255, .3)!important;
    border: none !important;
    border-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
    
    
    
    
textarea[id="tx_canvas_source"]{
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-bottom-left-radius: 10px; 
    border-bottom-right-radius: 10px; 
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
    outline: none;
}
/* 다크모드 시 켬    
div[class="tx-sidebar-boundary"] ul[class^="tx-bar"] a[class^="tx-text"] {
    filter: invert(1);
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
*/
div[class="tx-sidebar-boundary"] ul[class^="tx-bar"] a[class^="tx-text"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    text-decoration: none; 
}
/* 다크모드 시 켬    
a[title="글꼴"],
a[title="글자크기"] {
    background-color: #000 !important;
}
*/
div[id="tx_fontfamily_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_fontfamily_menu"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    text-decoration: none; 
}
div[id="tx_fontfamily_menu"] ul[class="tx-menu-list"] {
    background-color: rgba(255, 255, 255, 0) !important;
    border-radius: 10px !important;
}
div[id="tx_fontfamily_menu"] ul[class="tx-menu-list"] li[class="tx-menu-list-item"] a {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_fontfamily_menu"] ul[class="tx-menu-list"] li[class="tx-menu-list-item"] a:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(128, 128, 128, 0.3) !important;
    transform: translateX(-1px) !important;
}
div[id="tx_fontsize_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_fontsize_menu"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    text-decoration: none; 
}

div[id="tx_fontsize_menu"] ul[class="tx-menu-list"] {
    background-color: rgba(255, 255, 255, 0) !important;
    border-radius: 10px !important;
}
div[id="tx_fontsize_menu"] ul[class="tx-menu-list"] li[class="tx-menu-list-item"] a {
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_fontsize_menu"] ul[class="tx-menu-list"] li[class="tx-menu-list-item"] a:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(128, 128, 128, 0.3) !important;
}
div[id="tx_forecolor_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_forecolor_menu"] div[class="tx-menu-inner"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
input[class="tx-color-value"] {
    border: none !important;
    border-radius: 10px;
}
/*
li[class="tx-list"] div{
    filter: invert(1);
}
/* 다크모드 시 켬
p[class="tx-pallete-revert"] a {
    filter: invert(1);
}
p[class="tx-pallete-more"] a[class="tx-more-down"] {
    filter: invert(1);
}
p[class="tx-pallete-more"] a[class="tx-more-up"] {
    filter: invert(1);
}
*/
div[id="tx_backcolor_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_lineheight_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_lineheight_menu"] ul li a:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(128, 128, 128, 0.3) !important;
    transform: translateX(-1px) !important;
}
div[id="tx_styledlist_menu"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transform: translateX(2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[id="tx_styledlist_menu"] ul li a:hover {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 2px 4px rgba(128, 128, 128, 0.3) !important;
    transform: translateX(-1px) !important;
}
div button[class="btn_add"]{     
    background-color: rgba(255, 255, 255, .3)!important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div button[class="btn_add"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
form[name="fileupload"] div[id="signmark_layer"] {
    margin-top: 6px;
}
div[id="signmark_layer"] span[class="checkbox"] label[for="signmark"] {
    position: relative; 
    bottom: -1px !important;
}
div[id="signmark_layer"] span[class="sp_img icon_qmark"] {
    position: relative; 
    bottom: -1px !important;
}

div button[class="btn_cancle"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div button[class="btn_cancle"]:hover {
    background-color: rgba(102, 102, 102, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div button[class="btn_apply"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div button[class="btn_apply"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="local_search"] div fieldset div[class*="top_search clear"] {
    transform: scale(0.95) translateY(4px) !important;
}
div[class="inr"] button[class="btn_blue small"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="inr"] button[class="btn_blue small"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
ul[class="file_upbox files"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
ul[class="file_upbox files"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="youtube_search"] div[class="inner"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="youtube_search"] div[class="inner"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="youtube_search"] div[class="inner"] input[ class="in_keyword"] {
    border-top-left-radius: 10px !important;
    border-bottom-left-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="youtube_search"] div[class="inner"] [class="bnt_ytube_up"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
textarea[placeholder="소스입력"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
textarea[placeholder="소스입력"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
textarea[placeholder="소스입력"]:focus{
    outline: none !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
input[title="컨텐츠 링크입력"]{
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
input[title="컨텐츠 링크입력"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
input[title="컨텐츠 링크입력"]:focus{
    outline: none !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
textarea[id="urls"] {
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
textarea[id="urls"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
textarea[id="urls"]:focus{
    outline: none !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div button[class="btn_white small"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div button[class="btn_white small"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div button[class="btn_blue small"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div button[class="btn_blue small"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class^="vote_categorybox file"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class^="vote_categorybox file"] input[class="catetxt_input"] {
    outline: none;
}
div[class="votetxt_addbox"]{
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="votetxt_addbox"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
li[class="tx-list"] div[id="tx_dccon"] div[class="pop_wrap type3"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transform: translateX(-2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
.tx-resize-bar-bg,
#tx_resizer {
    border: none !important;
    outline: none !important;
    box-shadow: none !important;
}
    button[class="btn_grey modify"] {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_grey modify"]:hover {
    background-color: rgba(102, 102, 102, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_grey cancle"] {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_blue write"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_blue write"] {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_grey cancle"]:hover {
    background-color: rgba(102, 102, 102, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_blue btn_svc write"] {
    border: none !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
button[class="btn_blue btn_svc write"]:hover {
    background-color: rgba(59, 72, 144, .9)!important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
img[src^="//dcimg5.dcinside.com"]{
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
img[src^="//dcimg5.dcinside.com"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="sp_img bnt_dccon_search"]{
    border-radius: 10px !important; 
    transition: border-color 0.2s, box-shadow 0.2s !important;
    transform: translateX(2px)!important;
}
div[class="option_sort fr dccon"] div[class="select_box select_arraybox ul_selectric"] ul[class="option_box"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-bottom: 10px !important;
    transform: translateX(2px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="option_sort fr dccon"] div[class="select_box select_arraybox ul_selectric"] ul[class="option_box"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    text-decoration: none;
}
div[class="option_sort fr dccon"] div[class="select_box select_arraybox ul_selectric"] ul[class="option_box"] li {
    transition: color 0.2s, box-shadow 0.2s !important;
}
div[class="option_sort fr dccon"] div[class="select_box select_arraybox ul_selectric"] ul[class="option_box"] li:hover {
    text-decoration: none; 
    color: #007bff;
}
/* 글내부 */
img[src^="https://dcimg8.dcinside.co.kr/"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="btn_recommend_box recomuse_y morebox"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="btn_recommend_box recomuse_y morebox"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important; /* 호버 시 그림자 효과 */
}
.btn_silbechu, .btn_snsmore, .btn_report {
    background: rgba(255, 255, 255, 0.3); /* 원하는 투명도 설정 */
    border: none; /* 기본 테두리 제거 */
    color: #000; /* 글자 색상 설정 */
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
.btn_silbechu:hover, .btn_snsmore:hover, .btn_report:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important; /* 호버 시 그림자 효과 */
}
.btn_silbechu em, .btn_snsmore em, .btn_report em {
    position: relative;
    z-index: 1; /* 아이콘을 최상위로 */
}
div[class="pop_content hitup_ly silbechu_ly"] div[class="pop_head bg"] {
    border-top-left-radius: 10px !important;
    border-top-right-radius: 10px !important;
}
button[class="btn_grey small user_dcbest_lyr_close"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class="btn_grey small user_dcbest_lyr_close"]:hover {
    background-color: rgba(102, 102, 102, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_blue small user_dcbest_ok"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class="btn_blue small user_dcbest_ok"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="pop_content nlist_sns"] div[class="pop_head bg"] {
    border-top-left-radius: 10px !important;
    border-top-right-radius: 10px !important;
}
div[class="urlcopy_box btn_clip" ] input[id="exid"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-top-left-radius: 10px !important;
    border-bottom-left-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="urlcopy_box btn_clip" ] label[for="exid"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-top-right-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class^="adult_report"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class^="gall_report "] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class^="video_report"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="cmt_write_box clear"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
div[class="user_info_input id"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
label[for="user_nick"] {
    border-radius: 10px !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="user_info_input id"] :hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
textarea[id^="memo"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
textarea[id^="memo"] {
    border-radius: 10px !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
textarea[id^="memo"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
button[class="btn_white small tx_dccon"] {
    background-color: rgba(255, 255, 255, 0.3) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
button[class="btn_white small tx_dccon"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[id="div_con"] {    
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10px !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="doublecon_wrap"] span[class="checkbox"] em[class="checkmark"] {
    transform: translate(14px, -8px) !important;
}
div[class="bgbox"] {    
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transform: translate(-9px, -8px) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="dccon_tab_btnbox fl clear"] {    
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
div[class="dccon_tab_btnbox fl clear"] li[class="li_pack on"] {    
    background-color: rgba(255, 255, 255, .3)!important;
    backdrop-filter: blur(10px) !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: border-color 0.2s, box-shadow 0.2s !important;
}
em[class="sp_img icon_guide_open"] {
    transform: translate(1px, 2px) !important;
}

div[class="cmt_write_box clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"] {
    transform: translate(1px, 3px) !important;
}
div[class="cmt_write_box clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_blue btn_svc small repley_add"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="cmt_write_box small clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_blue btn_svc small repley_add"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="cmt_write_box small clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_blue btn_svc small repley_add"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="cmt_write_box clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_blue btn_svc small repley_add"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="cmt_write_box clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_lightblue btn_svc small repley_add_vote"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="cmt_write_box clear"] div[class="cmt_txt_cont"] div[class="cmt_cont_bottm clear"] div[class="fr"]  button[class="btn_lightblue btn_svc small repley_add_vote"]:hover {
    background-color: rgba(98, 109, 166, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="view_bottom_btnbox clear"] div[class="fl"]  button[class="btn_blue concept"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="view_bottom_btnbox clear"] div[class="fl"]  button[class="btn_blue concept"]:hover {
    background-color: rgba(59, 72, 144, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="view_bottom_btnbox clear"] div[class="fl"]  button[class="btn_white concept"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="view_bottom_btnbox clear"] div[class="fl"]  button[class="btn_white concept"]:hover {
    background-color: rgba(255, 255, 255, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
/* 글삭제 */
div[class="empty_pagewrap"] div[class="pop_wrap type5"] {
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: box-shadow 0.3s ease, background-color 0.3s !important;
}
div[class="empty_pagewrap"] div[class="pop_wrap type5"]:hover {
    background-color: rgba(255, 255, 255, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
div[class="empty_pagewrap"] div[class="pop_wrap type5"] div[class="btn_box"] button {
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[class="empty_pagewrap"] div[class="pop_wrap type5"] div[class="btn_box"] button:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}
}
