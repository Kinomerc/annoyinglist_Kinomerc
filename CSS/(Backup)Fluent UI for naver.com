/* ==UserStyle==
@name       Fluent UI for naver.com
@version    20240930
@namespace  ?
==/UserStyle== */
@-moz-document regexp(".*naver.com.*") {

.api_atcmp_wrap
{
    border: none !important;
    background-color: rgba(255, 255, 255, 0.1) !important;
    backdrop-filter: blur(10px) !important;
    transition: background-color 0.3s, box-shadow 0.3s;
}
.ly_atcmp
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px) !important;
}
.api_atcmp_wrap:hover
{
    box-shadow: 0 4px 10px rgba(128, 128, 128, .3) !important;
    background-color: rgb(128, 128, 128, 0.15);
}
.atcmp_plus._plus
{
    border: none !important;
}
.atcmp_fixer._atcmp_layer
{
    border: none !important;
}
.atcmp_footer
{
    border: none !important;
}
.ly_atcmp
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
.api_atcmp_wrap
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
.search_group
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
.search_group_inner
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
.search_input_box
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
.search_input
{
    border: none !important;
    border-bottom-left-radius: 10px !important;
    border-bottom-right-radius: 10px !important;
    background: transparent !important;
}
#search_area
{
    border: none !important;
    background: transparent !important;
    border-radius: 10px;
}
.Layout-module__column_right___wLgQj
{
    margin-left: 435px !important;
}
.layer_box
{
    backdrop-filter: blur(10px) !important;
    background-color: rgba(255, 255, 255, 0.1) !important;
    border: none !important;
    box-shadow: 0 1px 3px rgba(128, 128, 128, 0.3) !important;
}
.aside_header
{
    background-color: rgba(128, 128, 128, 0.5) !important;
    backdrop-filter: blur(10px);
}
html[class="web fzoom page_pc"]
{
    background-color: rgb(128, 128, 128, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 10px;
}
.wrap .aside_wrap::before {
    background: rgba(255, 255, 255, 0) !important; /* 기존 배경을 덮기 */
}
}
