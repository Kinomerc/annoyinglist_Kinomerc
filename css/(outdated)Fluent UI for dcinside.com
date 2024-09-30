/* ==UserStyle==
@name       dcinside.com Fluent UI
@version    20240927
@namespace  ?
==/UserStyle== */
@-moz-document domain("dcinside.com") {
/* --------------------*/
/* 플루언트 디자인 적용 */
/* 반투명 */
textarea[id^="memo_"],
.btn_lightblue,
.btn_white,
.issuebox.gallery_box.open,
.top_search.clear, /* 최상단 검색창 */
.auto_wordwrap, /* 최상단 검색창 하단 검색결과*/
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */
/* newvisit_history.vst, */ /* 최근방문 */
.visit_bookmark#visit_history, /* 최근방문 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.tabcon_bottom, /* 최근방문 ↓ 선택시 나오는 창의 전체삭제 */
.img_box, /* 실베 이미지 4칸 */
.txt_box, /* 실베 이미지 4칸 하단 제목 */
.login_wrap, /* 로그인 박스 */
#login_box, /* 로그인 박스 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.pop_wrap.type3, /* 로그인 박스 안 알림 박스 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.pop_wrap,  /* 흥한갤 전체순위 */
.page_head.clear, /* 갤러리 명 */
.pop_info, /* 연관갤러리 및 설명 */
.issue_contentbox.clear,  /* 갤러리 설명 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box, /* 갤러리 설명 - 흥한갤 */
.subject_morelist, /* 추가 말머리 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실베추, 공유, 신고 박스 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.user_data_list, /* 유저 정보 */
.bottom_search.fl.clear, /* 하단 검색창 */
.select_box.bottom_array.fl, /* 하단 검색창 왼쪽 말머리 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */ {
    background: rgba(255, 255, 255, 0.3); /* 반투명 배경 */
}

/* 흐림 */
.issuebox.gallery_box.open,
.top_search.clear, /* 최상단 검색창 */
.auto_wordwrap, /* 최상단 검색창 하단 검색결과*/
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */
/* newvisit_history.vst, */ /* 최근방문 */
/* .visit_bookmark#visit_history, */ /* 최근방문 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.tabcon_bottom, /* 최근방문 ↓ 선택시 나오는 창의 전체삭제 */
.img_box, /* 실베 이미지 4칸 */
.txt_box, /* 실베 이미지 4칸 하단 제목 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.pop_wrap.type3, /* 로그인 박스 안 알림 박스 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.pop_wrap,  /* 흥한갤 전체순위 */
.page_head.clear, /* 갤러리 명 */
.pop_info, /* 연관갤러리 및 설명 */
.issue_contentbox.clear,  /* 갤러리 설명 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box, /* 갤러리 설명 - 흥한갤 */
#hot_rank_pop2, /* 갤러리 설명 - 흥한갤 전제순위 */
.subject_morelist, /* 추가 말머리 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실추, 공유, 신고 박스 */
.list_bottom.btn_blue,  /* 하단 전체글 */
.list_bottom.btn_white, /* 하단 개념글 */
#btn_write, /* 하단 글쓰기 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.user_data_list, /* 유저 정보 */
.bottom_search.fl.clear, /* 하단 검색창 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */{
    backdrop-filter: blur(4px); /* 흐림 효과 */
}

/* 그림자 */
textarea[id^="memo_"],
.btn_white,
.user_info_input.id, 
#tx_attach_div *,
.issuebox.gallery_box.open,
.top_search.clear, /* 최상단 검색창 */
.auto_wordwrap, /* 최상단 검색창 하단 검색결과*/
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */
/* newvisit_history.vst, /* 최근방문 */
/* .visit_bookmark#visit_history, */ /* 최근방문 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.tabcon_bottom, /* 최근방문 ↓ 선택시 나오는 창의 전체삭제 */
.login_wrap, /* 로그인 박스 */
#login_box, /* 로그인 박스 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.pop_wrap.type3, /* 로그인 박스 안 알림 박스 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.hot_gall_box, /* 흥한갤 */
.box_head.clear, /* 흥한갤 제목만 */
.pop_wrap,  /* 흥한갤 전체순위 */
.page_head.clear, /* 갤러리 명 */
.pop_info, /* 연관갤러리 및 설명 */
.issue_contentbox.clear,  /* 갤러리 설명 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box, /* 갤러리 설명 - 흥한갤 */
#hot_rank_pop2, /* 갤러리 설명 - 흥한갤 전제순위 */
.subject_morelist, /* 추가 말머리 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실추, 공유, 신고 박스 */
.list_bottom.btn_blue,  /* 하단 전체글 */
.list_bottom.btn_white, /* 하단 개념글 */
#btn_write, /* 하단 글쓰기 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.user_data_list, /* 유저 정보 */
.bottom_search.fl.clear, /* 하단 검색창 */
.select_box.bottom_array.fl, /* 하단 검색창 왼쪽 말머리 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */{
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}

/* 배경색상전환 */
textarea[id^="memo_"],
.btn_white,
.user_info_input.id, 
#tx_attach_div *,
.issuebox.gallery_box.open,
.top_search.clear, /* 최상단 검색창 */
.auto_wordwrap, /* 최상단 검색창 하단 검색결과*/
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */

.login_wrap, /* 로그인 박스 */
#login_box, /* 로그인 박스 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.pop_wrap.type3, /* 로그인 박스 안 알림 박스 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.hot_gall_box, /* 흥한갤 */
.box_head.clear, /* 흥한갤 제목만 */
.pop_wrap,  /* 흥한갤 전체순위 */
.pop_info, /* 연관갤러리 및 설명 */
#hot_rank_pop2, /* 갤러리 설명 - 흥한갤 전제순위 */
.subject_morelist, /* 추가 말머리 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실추, 공유, 신고 박스 */
.list_bottom.btn_blue,  /* 하단 전체글 */
.list_bottom.btn_white, /* 하단 개념글 */
#btn_write, /* 하단 글쓰기 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.user_data_list, /* 유저 정보 */
.bottom_search.fl.clear, /* 하단 검색창 */
.select_box.bottom_array.fl, /* 하단 검색창 왼쪽 말머리 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */{
    transition: background 0.3s ease; /* 배경 색상 전환 효과 */
    border: 1px solid #d5d5d5; /* 검정색 1px 테두리 추가 */
}

/* 테두리 제거 */
.user_info_input,
.cmt_textarea_label,
textarea[id^="memo_"],
.btn_white,
#tx_attach_div *,
.btn_grey, .btn_blue,
.btn_grey, .btn_blue,
.issuebox.gallery_box.open,
.btn_apply,
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */
/* newvisit_history.vst, /* 최근방문 */
/* .visit_bookmark#visit_history, /* 최근방문 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.tabcon_bottom, /* 최근방문 ↓ 선택시 나오는 창의 전체삭제 */
.img_box, /* 실베 이미지 4칸 */
.txt_box, /* 실베 이미지 4칸 하단 제목 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.hot_gall_box, /* 흥한갤 */
.box_head.clear, /* 흥한갤 제목 */
.mgall_list_wrap, /* 흥한갤 제목 2 */
#heung_gall_all_lyr,  /* 흥한갤 전체순위 */
.issue_wrap,  /* 갤러리 설명 */
.pop_info, /* 연관갤러리 및 설명 */
.issue_contentbox.clear,  /* 갤러리 설명 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box, /* 갤러리 설명 - 흥한갤 */
#hot_rank_pop2, /* 갤러리 설명 - 흥한갤 전제순위 */
.subject_morelist, /* 추가 말머리 */
.select_area,  /* 1페이지 글 개수 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실베추, 공유, 신고 박스 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.user_data_list /* 유저 정보 */ {
    border: none; 
}

li.type-image.tx-existed.tx-clicked {
    border: 1px solid #0078d4 !important; /* 블루 테두리 */
    margin-left: -1px; /* 왼쪽으로 2px 이동 */
}


.btn_white,
.btn_write.txt, /* 1페이지 글 개수 목록박스 옆 글쓰기 */
#btn_write /* 하단 글쓰기 */ {
    border: 1px solid #3b4890; /* 검정색 1px 테두리 추가 */
}

    
/* 둥근모서리 */
.user_nick,
.cmt_textarea_label,
textarea[id^="memo_"],
.btn_white,
.user_info_input.id, 
#tx_attach_div *,
.btn_grey, .btn_blue,
.btn_blue.small,
.btn_add,
.btn_apply,
.user_data_list,
.top_search.clear, /* 최상단 검색창 */
.auto_wordwrap, /* 최상단 검색창 하단 검색결과*/
.word_tit, /* 최상단 검색창 하단 검색결과의 타이틀 */
/* newvisit_history.vst, */ /* 최근방문 */
/* .visit_bookmark#visit_history, */ /* 최근방문 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.tabcon_bottom, /* 최근방문 ↓ 선택시 나오는 창의 전체삭제 */
.login_wrap, /* 로그인 박스 */
.hot_mgall_box,
.box_head.clear,
#login_box, /* 로그인 박스 */
.user_option.four, /* 로그인 창 계정정보 아래 바로가기 칸 */
.pop_wrap.type3, /* 로그인 박스 안 알림 박스 */
.content_box.hotlive.gall_rank#rank_gall, /* 실북갤 */
.box_bottom.rank_more, /* 실북갤 순위탭 변경 */
.content_box.hot, /* 흥한갤 */
.box_bottom.hot_more, /* 흥한갤 순위탭 변경 */
.hot_gall_box, /* 흥한갤 */
#heung_gall_all_lyr,  /* 흥한갤 전체순위 */
.page_head.clear, /* 갤러리 명 */
.issue_contentbox.clear,  /* 갤러리 설명 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box, /* 갤러리 설명 - 흥한갤 */
#hot_rank_pop2, /* 갤러리 설명 - 흥한갤 전제순위 */
.array_tab button, /* 상단 전체글, 개념글, 공지 */
.subject_morelist, /* 추가 말머리 */
.select_area,  /* 1페이지 글 개수 */
#listSizeLayer, /* 1페이지 글 개수 목록박스 */
.btn_write.txt /* 1페이지 글 개수 목록박스 옆 글쓰기 */,
.btn_recommend_box.recomuse_n.morebox, /* 추천, 비추천, 실베추, 공유, 신고 박스 */
.list_bottom.btn_blue,  /* 하단 전체글 */
.list_bottom.btn_white, /* 하단 개념글 */
#btn_write, /* 하단 글쓰기 */
.guide_txtbox, /* 디시콘 옆 ? 설명창 2 */
.bottom_search.fl.clear, /* 하단 검색창 */
.select_box.bottom_array.fl, /* 하단 검색창 왼쪽 말머리 */
span.inner, /* 하단 검색창 왼쪽 말머리 ↓ 아이콘 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */ {
    border-radius: 8px; /* 둥근 모서리 */
}

/* 둥글게만 적용 */
label,
.newvisit_history.vst,
.visit_history,
.visit_bookmark,
.visit_bookmark#visit_history {
    border-radius: 8px; /* 둥글게 적용 */
    border: 1px solid #d5d5d5; /* 검정색 1px 테두리 추가 */
}
    
/* 일부 둥근모서리 */
.pop_wrap.gray1px, /* 최근방문 ↓ 선택시 나오는 창 */
.auto_wordwrap /* 최상단 검색창 하단 검색결과*/ {
    border-bottom-left-radius: 8px; /* 하단 왼쪽 둥글게 */
    border-bottom-right-radius: 8px; /* 하단 오른쪽 둥글게 */
}

.inner {
    border-top-left-radius: 8px; /* 좌상단 둥글게 */
    border-bottom-left-radius: 8px; /* 좌하단 둥글게 */
}

.youtube_search .inner {
    border-radius: 8px; /* 전체 둥글게 */
    overflow: hidden; /* 자식 요소가 둥글게 잘리도록 */
}

#searchSubmit  /* 최상단 검색아이콘 둥글게*/ {
    border-top-right-radius: 8px; /* 오른쪽 상단 둥글게 */
    border-bottom-right-radius: 8px; /* 오른쪽 하단 둥글게 */
    margin-top: 1px; /* 2px 아래로 내리기 */
}

.box_head.clear  /* 흥한갤 제목 */ {
    border-top-left-radius: 8px; /* 좌상단 둥글게 */
    border-top-right-radius: 8px; /* 우상단 둥글게 */
}

.tit, /* 갤러리 념글 */
.info /* 갤러리 념글 */ {
    padding-left: 5px; /* 왼쪽에 2px 여유 추가 */
}

.sp_img.bnt_search {
    border-top-right-radius: 8px; /* 상단 우측 둥글게 */
    border-bottom-right-radius: 8px; /* 하단 우측 둥글게 */
}

 /* 실베 랭킹 버튼 둥글게 */
.btn_dcbest_rank_tab[data="hit"] {
    border-top-left-radius: 8px; /* 좌상단 둥글게 */
    border-bottom-left-radius: 8px; /* 좌하단 둥글게 */
}

.btn_dcbest_rank_tab[data="comment"]  {
    border-top-right-radius: 8px; /* 우상단 둥글게 */
    border-bottom-right-radius: 8px; /* 우하단 둥글게 */
}

.icon_mgall_dcp {
    border-top-right-radius: 8px; /* 우상단 모서리 둥글게 */
}

/* 유저 정보테두리 제거 및 좌우간격 */
.user_data_list, /* 유저 정보 외각 */
.user_data_list li /* 유저 정보 */{
    border: none; /* 부모 요소의 테두리 제거 */
    margin: 2px 2px; /* 상하 2px, 좌우 0px 간격 */
    border-radius: 6px; /* 모서리 둥글게 */
}

.btn_inout.logout /* 로그아웃 */ {
    border-radius: 8px; /* 둥글게 만들기 */
}

.subject_list li.sel {
    position: relative; /* 위치 조정 */
}

.subject_list li.sel::after {
    content: '';
    position: absolute;
    border-radius: 8px; /* 둥글게 처리 */
    top: 0; left: 0; right: 0; bottom: 0;
    box-shadow: 0 0 10px white; /* 반전된 그림자 효과 */
    filter: invert(1); /* 그림자 반전 */
}

.cmt_write,
.btn_white,
.repley_add_vote {
    border-radius: 8px !important; /* 강제로 모서리를 8px 만큼 둥글게 */
}
    
.checkbox {
    cursor: pointer; /* 커서 모양 변경 */
}

.checkmark {
    width: 20px; /* 체크마크 너비 */
    height: 20px; /* 체크마크 높이 */
    border: 1px solid #ccc; /* 테두리 */
    border-radius: 5px; /* 둥근 모서리 */
    background: rgba(255, 255, 255, 0.3); /* 반투명 배경 */
    margin-right: 10px; /* 오른쪽 여백 */
    position: relative; /* 위치 조정 */
    transition: background 0.3s, border 0.3s; /* 전환 효과 */
}

.checkbox input[type="checkbox"]:checked + .checkmark {
    background: rgba(0, 150, 255, 0.5); /* 체크 시 배경색 */
    border-color: rgba(0, 150, 255, 1); /* 체크 시 테두리 색 */
}
.radiobox input[type="radio"]:checked + .checkmark {
    background: rgba(0, 150, 255, 0.5); /* 체크 시 배경색 */
    border-color: rgba(0, 150, 255, 1); /* 체크 시 테두리 색 */
}

.checkbox input[type="checkbox"]:checked + .checkmark:after {
    content: ''; /* 체크 표시 */
    position: absolute;
    left:5px; /* 위치 조정 */
    top: 1.5px; /* 위치 조정 */
    width: 3px; /* 체크 표시 너비 */
    height: 7px; /* 체크 표시 높이 */
    border: solid white; /* 체크 표시 색 */
    border-width: 0 2px 2px 0; /* 체크 표시 형태 */
    transform: rotate(45deg); /* 체크 표시 회전 */
}

label[for="calendarInput"] {
    border-radius: 4px; /* 둥근 모서리 */
    display: inline-block; /* 크기 적용을 위해 블록으로 설정 */
    cursor: pointer; /* 커서 모양 변경 */
}

label[for="calendarInput"] {
    position: relative;
    top: -7px; /* 위로 이동 */
}


.dayin,
.select_box,
.fl .btn_white.small,
.btn_box .btn_cancle,
.btn_box .btn_apply {
    background: rgba(255, 255, 255, 0.8); /* 반투명 배경 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    transition: background 30s ease; /* 배경 색상 전환 효과 */
    border-radius: 8px; /* 둥근 모서리 */
}


.input_box,
.write_subject {
    backdrop-filter: blur(0px); /* 흐림 효과 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    transition: background 0.3s ease; /* 배경 색상 전환 효과 */
    border-radius: 8px; /* 둥근 모서리 */
    overflow: hidden; /* 자식 요소가 둥글게 잘리도록 */
    border: none; 
}

.put_inquiry {
    background: rgba(255, 255, 255, 0.3); /* 반투명 배경 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    transition: background 0.3s ease; /* 배경 색상 전환 효과 */
    border-radius: 8px; /* 둥근 모서리 */
}

.txt_placeholder {
    margin-top: 1px; /* 아래로 1px 내리기 */
}
    
.issue_contentbox.clear,
li /* 실베 이미지*/ {
    border-radius: 8px; /* 모서리 둥글게 */
    border: none !important; /* 부모 요소의 테두리 제거 */
    background-color: transparent !important;
}

li span /* 로그인 정보 버튼*/ {
    border-radius: 8px !important; /* 모서리 둥글게 */
}


/* 완전둥글게 */
.sp_img.icon_listmore,
.btn_rank_close.sp_main, /* 실베 랭킹 닫기 */
/* .btn_open,  /* 최근방문 ↓ 아이콘 */
.rank_num, /* 실북갤, 흥한갤 순위 아이콘 */
button.sp_main.btn_prev, /* 실베 페이지 앞페이지로 아이콘 */
button.sp_main.btn_next, /* 실베 페이지 뒷페이지로 아이콘 */
a.sp_img.btn_close  /* 최상단 창 하단 검색결과 하단 X */ {
    border-radius: 100%; /* 완전 둥글게 */
}

/* 여백추가 */
button.sp_main.btn_prev /* 실베 페이지 앞페이지로 아이콘 */ {
    margin-right: 3px; /* 여백 제거 */
}

.word_tit /* 최상단 검색창 하단 검색결과의 타이틀 */ {
    margin: 10px 10px 0; /* 좌우에 10px 여백 추가 */
}

.search_key /* 최상단 검색창 하단 검색결과 리스트 */ {
    margin: 0 10px; /* 좌우에 10px 여백 추가 */
}

.array_tab button /* 상단 전체글, 개념글, 공지 */ {
    margin: 0 3px; /* 좌우에 3px 여백 추가 */
}

.center_box,/* 말머리 */ 
.select_box.array_num /* 1페이지 글 개수 */,
.switch_btnbox /* 1페이지 글 개수 목록박스 옆 글쓰기 */ {
    position: relative; /* 상대 위치 지정 */
    top: -6px; /* 요소를 5px 위로 이동 */
}

#heung_gall_all_lyr  /* 흥한갤 전체순위 */ {
    margin-top: 10px; /* 하단으로 10px 이동 */
}


.auto_wordwrap /* 최상단 검색창 하단 검색결과*/ {
    margin-top: 8px; /* 하단으로 10px 이동 */
}

.pop_wrap.gray1px /* 최근방문 ↓ 선택시 나오는 창 */ {
    margin-top: 10px; /* 하단으로 10px 이동 */
}

#alarmList /* 로그인 박스 안 알림 박스 */ {
    transform: translateY(10px); /* 아래로 5px 이동 */
}

#listSizeLayer /* 1페이지 글 개수 목록박스 */ {
    margin-top: 3px; /* 아래로 3px 내리기 */
}

#relation_popup /* 연관 갤러리 */ {
    margin-top: 5px; /* 팝업을 아래로 5px 이동 */
}

.sp_img.icon_favorite /* 즐겨찾기 아이콘 */ {
    margin-top: 4px; /* 팝업을 아래로 5px 이동 */
}

.issue_contentbox /* 갤러리 설명 */ {
    margin-top: 10px; /* 요소를 2px 아래로 내림 */
}

/*.fl.clear /* 갤러리명 */ 
 /*    margin-left: 8px; /* 오른쪽으로 8px 이동 */
 /*    padding-top: 1.5px; /* 위쪽 여백 추가 */
 

.fr.gall_issuebox /* 갤러리 명 옆 기능 바로가기 */ {
    transform: translate(-12px, -2px); /* 왼쪽으로 5px, 위로 1px 이동 */
}

.subject_morelist /* 추가 말머리 */ {
    transform: translate(35px, 0); /* 오른쪽으로 50px 이동 */
}

.sp_img.icon_bgblueclose /* 알림박스 닫기 아이콘 */ { 
    border-radius: 95%; /* 완전 둥글게 */
    transform: translate(-6px, 8px) scale(0.75); /* 좌 2px, 하단 2px */
}

.box.best_info .name /* 실베 글자 */ ,
.box.best_info .time /* 실베 글자 */ {
    margin-top: 20px; /* 글자 10px 아래로 내리기 */
}

#visit_history /* 최근방문 */ {
    margin-top: 5px; /* 아래로 5px 내리기 */
}

.newvisit_history.vst /* 최근방문 */ {    
    border-top: 1px solid #d5d5d5; /* 상단 테두리만 추가 */
    border-left: none; /* 왼쪽 테두리 제거 */
    border-right: none; /* 오른쪽 테두리 제거 */
    border-bottom: none; /* 하단 테두리 제거 */
    background-color: rgba(255, 255, 255, 0); /* 반투명 배경 */
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}

.sp_img.icon_listmore {
    border: none; /* 상단 테두리만 추가 */
    background-color: rgba(255, 255, 255, 0); /* 반투명 배경 */

    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}

.tx-resize-bar-bg,
#tx_resizer {
    border: none !important; /* 테두리 없애기 */
    outline: none !important; /* 아웃라인 없애기 */
    box-shadow: none !important; /* 박스 그림자 없애기 (필요시 추가) */
}

a[title="글꼴"],
a[title="글자크기"] {
    background-color: #000 !important;
}

.tx-bar-left .tx-text {
    filter: invert(1);
}

#write_wrap {
    border: none;
}

#tx_sidebar,
.tx-sidebar-boundary {
    border-top-left-radius: 10px; /* 좌상단 둥글게 */
    border-top-right-radius: 10px; /* 우상단 둥글게 */
}

#tx_canvas {
    border-bottom-left-radius: 10px; /* 좌하단 둥글게 */
    border-bottom-right-radius: 10px; /* 우하단 둥글게 */
}

.editor_wrap {
    border: none; /* 테두리 제거 */
}

.write_infobox {
    display: none; /* 요소를 완전히 숨김 */
}

/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* 플루언트 디자인의 글자 속성 적용 */
a[view-msg] {
    color: #333; /* 글자 색상 */
    font-weight: 400; /* 글자 두께 약간 줄임 */
    line-height: 1.4; /* 줄 높이 약간 낮춤 */
    text-decoration: none; /* 밑줄 제거 */
    font-family: 'Arial', sans-serif; /* 글꼴 설정 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 1s ease; /* 호버 효과 전환 1초 */
}

a[view-msg]:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    background-color: rgba(0, 123, 255, .06); /* 호버 시 배경 색상 추가 */
    border-radius: 8px; /* 그림자 둥글게 유지 */
    padding-top: 4px; /* 위쪽 패딩 */
    padding-bottom: 2px; /* 아래측 패딩 */
    padding-left: 4px; /* 좌측 패딩 */
    padding-right: 30px; /* 우측 패딩 */
    margin-top: -2px; /* 위쪽으로 올리기 */
    margin-left: -4px; /* 왼쪽으로 이동 */
}

a[view-msg]:hover + .reply_numbox {
    margin-top: 2px; /* 호버 시 2px 아래로 이동 */
    margin-left: -30px; /* 왼쪽으로 이동 */
}

.gall_writer:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    max-height: 22px; /* 최대 높이로 설정 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 1s ease; /* 호버 효과 전환 1초 */
}

.btn_write.txt,
.array_tab button {
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.array_tab button.on:hover {
    color: #fff; /* 호버 시 텍스트 색상 변경 */
    background-color: rgba(59, 72, 144, 0.8); /* 호버 시 배경 색상 변경 */
    margin-top: -1px; /* 아래로 이동 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

#tx_resize_holder {
    filter: invert(0.65); /* 색상 반전 */
}

li.type-image.tx-existed.tx-hovered .tx-button .tx-delete {
    display: none; /* 삭제 버튼 숨기기 */
}

li.type-image.tx-existed.tx-clicked .tx-button .tx-delete {
    display: inline; /* 삭제 버튼 보이기 */
}
    
li[data-idx] {
    display: flex; /* flexbox로 설정하여 한 줄로 나열 */
    align-items: center; /* 수직 정렬 */
}

.sp_img.icon_saveclose {
    position: relative; /* 상대 위치로 설정 */
    left: -8px; /* 왼쪽으로 5px 이동 */
    bottom: -7px; /* 아래로 5px 이동 */
}


.array_tab button:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    background-color: rgba(0, 123, 255, 0.06); /* 호버 시 배경 색상 추가 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
    margin-top: -1px; /* 아래로 이동 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.switch_btnbox .btn_write {
    display: inline-block; /* 버튼처럼 보이게 하기 */
    text-decoration: none; /* 밑줄 제거 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.switch_btnbox .btn_write:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    background-color: rgba(0, 123, 255, 0.06); /* 호버 시 배경 색상 추가 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

.sp_img.icon_listmore {
    display: inline-block; /* 요소를 블록으로 만들어 호버 효과 적용 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.sp_img.icon_listmore:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    background-color: rgba(0, 123, 255, 0.06); /* 호버 시 배경 색상 추가 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

#write_wrap {
    margin-right: 4px;
}

.select_area a {
    display: inline-block; /* 요소를 블록으로 만들어 호버 효과 적용 */
    text-decoration: none; /* 밑줄 제거 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.select_area a:hover {
    background-color: rgba(0, 0, 0, 0.06); /* 호버 시 배경 색상 추가 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

.list_bottom, .btn_blue.write {
    border: none; /* 기본 테두리 제거 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.btn_blue,
.btn_blue.concept, 
.list_bottom.btn_blue, .btn_blue.write {
    background-color: #3b4890; /* 기본 강조 색상 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}


textarea[id^="memo_"] {
    border-radius: 8px; /* 모서리를 8px 만큼 둥글게 */
    }

.btn_blue:hover,
.btn_blue.concept:hover,
.list_bottom.btn_blue:hover, .btn_blue.write:hover {
    background-color: rgba(59, 72, 144, 0.8); /* 호버 시 더 밝은 색상 변경 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

.btn_lightblue,
.btn_white,
.list_bottom.btn_white {
    border: 1px solid #ddd; /* 기본 테두리 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.btn_lightblu:hover,
.btn_white:hover,
.list_bottom.btn_white:hover {
    background-color: rgba(0, 123, 255, 0.1); /* 호버 시 배경 색상 변경 */
    color: #007bff; /* 호버 시 텍스트 색상 변경 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
}

.btn_hotall_list {
    border-radius: 15px; /* 호버 시 둥글게 처리 */
    cursor: pointer; /* 포인터 커서 */
    transition: background-color 0.4s ease, color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.btn_hotall_list:hover {
    background-color: rgba(0, 123, 255, 0.1); /* 호버 시 배경 색상 변경 */
    color: #007bff; /* 호버 시 텍스트 색상 변경 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
    border-radius: 15px; /* 호버 시 둥글게 처리 */
}

[class^="lately_gall_"] a {
    transition: color 0.4s ease; /* 텍스트 색상 전환 */
    text-decoration: none; /* 기본 밑줄 제거 */
}

[class^="lately_gall_"]:hover a {
    color: #007bff; /* 호버 시 텍스트 색상 변경 */
}

li a {
    transition: color 0.3s ease, background-color 0.3s ease, transform 0.3s ease; /* 부드러운 전환 효과 */
    text-decoration: none; /* 기본 밑줄 제거 */
    color: #333; /* 기본 텍스트 색상 */
}

li a:hover {
    background-color: rgba(0, 0, 0, .1); /* 호버 시 배경 색상 추가 */
    text-decoration: none; /* 호버 시 밑줄 제거 */
}

/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* ------------------------------ */
/* 플루언트 디자인의 버튼효과 
.list_bottom.btn_blue,  /* 하단 전체글 */
/* .list_bottom.btn_white /* 하단 개념글 */ 
/*     transition: background-color 0.3s ease, transform 0.3s; /* 전환 효과 추가 */
/* }
/* 
/* .list_bottom.btn_blue:hover,  /* 하단 전체글 */
/* .list_bottom.btn_white:hover /* 하단 개념글 */ 
/*     background-color: #e0e0e0; /* 호버 시 배경색 변경 */
/*     transform: scale(1.05); /* 호버 시 살짝 커짐 */ 
/* 
/* .list_bottom.btn_blue:focus,  /* 하단 전체글 */
/* .list_bottom.btn_white:focus /* 하단 개념글 */ 
/*     box-shadow: 0 0 0 2px rgba(0, 120, 211, 0.5); /* 포커스 효과 추가 */
/* }

/* ----------------*/
/* ----------------*/
/* ----------------*/
/* ----------------*/
/* ----------------*/
/* ----------------*/
/* 깨지는 부분 수정 */
/* 아이콘 크기 조정 */

span.inner /* 하단 검색창 왼쪽 말머리 ↓ 아이콘 */ {
    transform: scale(0.75); /* 크기 25% 줄이기 */
}


/* 아이콘 크기 조정 2 */
.mintro_imgbox.in_img, /* 갤러리 설명 - 갤러리 대문 */
.minor_ranking_box /* 갤러리 설명 - 흥한갤 */ {
    transform: scale(0.90); /* 크기 25% 줄이기 */
}

.select_area  /* 1페이지 글 개수 */ {
    overflow: hidden; /* 자식 요소가 둥글게 보이도록 */
}

.fl > em.sp_img.icon_hotgall /*흥한갤 앞 hot*/ {
    display: none; /* 아이콘 숨기기 */
}

.fl h2 /* 갤러리 명 */ {
    margin-left: 10px; /* 왼쪽으로 10px 이동 */
    margin-top: 2px;   /* 위쪽으로 2px 이동 */
}

/* 글씨 프리텐다드 강제로 */
@font-face {
    font-family: 'Pretendard-Medium';
    src: url('https://cdn.jsdelivr.net/gh/webfontworld/pretendard/Pretendard-Medium.woff') format('woff');
}

#hot_rank_pop2 /* 갤러리 설명 - 흥한갤 전제순위 */ {
    background-color: rgba(255, 255, 255, 0.9);
}

/* 안보이는 글자 보이게 */
.txt_box .tit /* 실베 이미지 4칸 하단 제목 */ {
    color: white; /* 글자를 하얀색으로 변경 */
    text-shadow: -1px -1px 0 black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black; }

.ad_bottom_list {
    clear: none;
    float: left;
    width: 840px;
    margin-top: 20px; /* 위쪽 여유 공간 추가 */
}
/* 알람 */
.alarmPopup {
    backdrop-filter: blur(10px); /* 흐림 효과 */
    background-color: rgba(255, 255, 255, 0.8); /* 반투명 배경 */
    border-radius: 15px; /* 둥근 모서리 */
    padding: 2px; /* 여백 추가 */
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* 그림자 효과 */
}

.new {
    display: none; /* 또는 visibility: hidden; */
}

.one_notice_txt {
    padding-left: 5px; /* 또는 margin-left: 5px; */
    margin-top: -1px;  /* 위로 1px 이동 */
    transition: color 0.4s ease, background-color 0.4s ease, box-shadow 0.4s ease; /* 부드러운 전환 효과 */
}

.one_notice_txt:hover {
    color: #007bff; /* 호버 시 색상 변경 */
    background-color: rgba(0, 123, 255, 0.06); /* 호버 시 배경 색상 추가 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 추가 */
    text-decoration: none; /* 호버 시에도 밑줄 제거 */
}

/* 위치 조정 */
/*.sp_img.btn_close /*최상단 검색창 하단 검색결과 하단 X */
    /* margin-top: 7px; /* 7px 아래로 이동 */
/* } 

/* fr 클래스의 요소 오른쪽 여백 추가 */
.fr.gall_issuebox /* ? */ {
    margin-right: 2px; /* 오른쪽 여백 2px 추가 */
}

/* .bottom_search fl.clear 1px 위로 올리기 */
.bottom_search.fl.clear /* 하단 검색창 */ {
    margin-top: -1px; /* 1px 위로 이동 */
}

 /* 하단 검색창 왼쪽 말머리 목록 박스 2px 아래로 이동 */
#searchTypeLayer.option_box /* 하단 검색창 왼쪽 말머리 목록 박스 */ {
    margin-top: 5px; /* 2px 아래로 이동 */
}
    
.imgwrap img,
.coment_dccon_img img,
.coment_dccon_img video {
    cursor: pointer;
    border-radius: 8px;
}
}
