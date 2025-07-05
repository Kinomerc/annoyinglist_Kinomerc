// ==UserScript==
// @name        Pretendard Injection
// @namespace   https://github.com/Kinomerc/annoyinglist_Kinomerc
// @match       *://*/*
// @exclude     *://github.com/*
// @exclude     *://noonnu.cc/*
// @grant       none
// @version     1.0
// @author      -
// @description Load custom fonts on any website
// ==/UserScript==

(function() {
    'use strict';
    const style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = `
@font-face {    
    font-family: "돋움";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Dotum";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "DotumChe";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "굴림";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Gulim";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "GulimChe";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "AppleGothic";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "맑은 고딕"; 
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Malgun Gothic";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "맑은고딕"; 
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "MalgunGothic";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "명조";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: Myeongjo;
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "나눔명조";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: NanumMyeongjo;
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "바탕";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Batang";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "바탕체";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "BatangChe";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "NanumBarunGothic";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "serif";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "sans-serif";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Helvetica";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Tahoma";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Geneva";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Arial";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Apple SD Gothic Neo";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "AppleSDGothicNeo-Regular";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Verdana";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Lato";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "FontAwesome";
    src: local("Noto Sans KR");
}
@font-face {
    font-family: "Helvetica Neue";
    src: local("Noto Sans KR");
}
    `;
  (document.head || document.getElementsByTagName('head')[0]).appendChild(style);
})();
