/* ==UserStyle==
@name       Fluent UI for google.com
@version    20240930.13.16
@namespace  kinomerc
==/UserStyle== */

@-moz-document url-prefix("") {
/* ==UserStyle==
@name       Fluent UI for google.com
@version    20240930
@namespace  kinomerc
*/
}

@-moz-document domain("google.com") {


/* google data / store */
div[role="navigation"] a[class="MV3Tnb"]{
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[role="navigation"] a[class="MV3Tnb"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}

/* gmail / image */
a[aria-label^="Gmail"] {
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[aria-label^="Gmail"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
a[href^="https://www.google.com/imghp?"] {
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
a[href^="https://www.google.com/imghp?"]:hover {
    text-decoration: none !important;
    color: #007bff !important;
}

/* search bar */
form[action="/search"] div{
    background-color: transparent ;
    transition: background-color 0.2s, border-color 0.2s, box-shadow 0.2s ;
}
form[action="/search"] div[jsmodel] div[jscontroller] div[jscontroller] div[jsname="aajZCb"] {
    background-color: transparent ;
    backdrop-filter: blur(10px) ;
    transition: background-color 0.2s, box-shadow 0.2s ;
}
form[action="/search"] div[jsmodel] div[jscontroller] div[jscontroller] {
    background-color: transparent ;
    border-radius: 15px;
    transition: background-color 0.2s, box-shadow 0.2s ;
}
form[action="/search"] div[jsmodel] div[jscontroller] div[jscontroller]:hover {
    box-shadow: 0 1px 3px rgba(128, 128, 128, .3);    
    background-color: transparent ;
    border-radius: 15px ;
    text-decoration: none;
}
li[class$="sbhl"]{
    box-shadow: 0 1px 3px rgba(128, 128, 128, .3);    
    background-color: rgba(0, 0, 0, 0) ;
    text-decoration: none;
    transition: color 0.2s, box-shadow 0.2s ;
}
li[class$="sbhl"]:hover {
    box-shadow: 0 1px 3px rgba(128, 128, 128, .3);    
    background-color: rgba(0, 0, 0, .15) ;
    text-decoration: none;
}

/* search button, feeling lucky button */
form[action="/search"] div[jsmodel] div[jscontroller] div[class] center input[type="submit"]{
    border: 1px solid rgba(0, 0, 0, 0.1) ;
    border-radius: 10px ;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) ;
    transition: background-color 0.2s, box-shadow 0.2s ;
}
form[action="/search"] div[jsmodel] div[jscontroller] div[class] center input[type="submit"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) ;    
    border-radius: 10px ;
    text-decoration: none;
}

/* footer */
div[role="contentinfo"]{
    background-color: rgba(128, 128, 128, .1) ;
    border: 1px solid rgba(0, 0, 0, 0.1) ;
    border-radius: 10px ;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) ;
    margin-bottom: 10px ;
    transition: background-color 0.2s, box-shadow 0.2s ;
}
div[role="contentinfo"]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3);
}
div[role="contentinfo"] div[class] a[class] {
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[role="contentinfo"] div[class] a[class]:hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
}
div[role="contentinfo"] div[class] span {
    text-decoration: none; 
    transition: background-color 0.2s, box-shadow 0.2s, color 0.3s ease !important;
}
div[role="contentinfo"] div[class] span span g-popup div:hover {
    text-decoration: none !important;
    color: #007bff !important;
}
/*
{
    background-color: rgba(255, 255, 255, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    border-radius: 10px !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    margin-top: 10000px !important;
    transform: translateX(2px) !important;
    transition: background-color 0.2s, color 0.2s border-color 0.2s, box-shadow 0.2s !important;
}
div[jsname] div[jsname] div[class] div[role="listitem"]

/* at search result page, more*/
div[role="listitem"] g-popup[jsname] div[jsname] div[jsname] {
    background-color: rgba(255, 255, 255, 0)!important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0) !important;
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[role="listitem"] g-popup[jsname] div[jsname] div[jsname] div[class="LtmTod"]{
    background-color: rgba(255, 255, 255, 0)!important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    backdrop-filter: blur(10px) !important;
    border-radius: 10px !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[role="listitem"] g-popup[jsname] div[jsname] div[jsname] div[class="LtmTod"]:hover {
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 10px !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
}

/* at search result page, link hover*/
div[id="search"] div div[class]  div[jscontroller] div[class] div[class] div[class] div span[jscontroller] a[jsname]:hover {
    text-decoration: none !important;
    color: #007bff !important;
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 1px 3px rgba(128, 128, 128, .3) !important;
    transition: color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[jsname] div div[jscontroller] div a div[role="heading"] div div span:hover {
    text-decoration: none !important;
    color: #007bff !important;
    background-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 1px 3px rgba(128, 128, 128, .3) !important;
    transition: color 0.2s, background-color 0.2s, box-shadow 0.2s !important;
}
div[class] g-more-link[class] a[class] div[class] {
    border: 1px solid rgba(0, 0, 0, 0.1) ;
    border-radius: 15px ;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) ;
    transition: background-color 0.2s, box-shadow 0.2s ;
}
div[class] g-more-link[class] a[class] div[class]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) ;
    background-color: rgba(241, 243, 244, .9) ;
    border-radius: 15px ;
    text-decoration: none;
}


div[data-fbevent="fastbutton" ]{
    transition: color 0.2s, box-shadow 0.2s ;
}
div[data-fbevent="fastbutton" ]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) ;
    background-color: rgba(241, 243, 244, .9) ;
    border-radius: 15px ;
    text-decoration: none;
}
div[data-audio-play-tts="true"] div{
    transition: background-color 0.2s, box-shadow 0.2s ;
}
div[data-audio-play-tts="true"] div:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) ;
    background-color: rgba(66, 133, 244, .9) ;
    border-radius: 150px ;
    text-decoration: none;
}

}

@-moz-document url-prefix("https://ogs.google.com/u/0/widget/app") {
/* google apps*/
div[role="complementary"] div[jsaction]{
    background-color: transparent !important;
    backdrop-filter: blur(10px) ;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
div[role="complementary"] div[jsaction]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}
div[role="complementary"] div[jsaction] div[class]{
    background-color: transparent;
}
div[role="complementary"] div div div div ul li {
    transition: background-color 0.2s, background-color 0.2s, box-shadow 0.2s, color 0.3s ease;
    text-shadow: -1px -1px 0 #FFF, 1px -1px 0 #FFF, -1px 1px 0 #FFF, 1px 1px 0 #FFF;
}
div[role="complementary"] div div div div ul li a{
    transition: background-color 0.2s, background-color 0.2s, box-shadow 0.2s, color 0.3s ease;
    text-shadow: -1px -1px 0 #FFF, 1px -1px 0 #FFF, -1px 1px 0 #FFF, 1px 1px 0 #FFF;       
}
div[role="complementary"] div div div div ul li :hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
}
div[role="complementary"] div div div div ul li a:hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
}
div[role="complementary"] div div div a[href="https://about.google/products/"] {
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s, color 0.3s ease;
}
div[role="complementary"] div div div a[href="https://about.google/products/"]:hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}
}

@-moz-document url-prefix("https://ogs.google.com/u/0/widget/account") {
html body div c-wiz[jsrenderer] div[class] div[jsname]{
    background-color: transparent;
    backdrop-filter: blur(10px) ;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
    transition: background-color 0.2s, box-shadow 0.2s !important;
}
html body div c-wiz[jsrenderer] div[class] div[jsname]:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] span[class] a {
    transition: border-color 0.2s, background-color 0.2s, box-shadow 0.2s, color 0.3s ease;
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] span[class] a:hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] span[class] a:hover {
    text-decoration: none !important;
    color: rgba(0, 123, 255, .9) !important;
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}

html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] div[class] span[class] a {
    transition: color 2s, box-shadow 0.2s !important;
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] div[class] span[class] a:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] div[class] span[class] span[class] a {
    transition: color 2s, box-shadow 0.2s !important;
}
html body div c-wiz[jsrenderer] div[class] div[jsname] div[class] div[class] div[class] div[data-ogamc] div[class] div[class] span[class] span[class] a:hover {
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3)!important;    
}

}
