// ==UserScript==
// @name 네이버카페 읽은글 표시 
// @namespace ncr.newsickminza
// @version 1.3.0
// @description 읽음 뱃지 + 맨위로/전체글 버튼
// @match *://cafe.naver.com/*
// @match *://m.cafe.naver.com/*
// @run-at document-idle
// @grant none
// ==/UserScript==

(function () {
'use strict';

const TARGET_CAFE = 'newsickminza';
const TARGET_CLUB = '31780162';
const STORE_KEY = 'ncr_read_v1';
const READ_DELAY = 1200;

const loadStore = () => {
try { return JSON.parse(localStorage.getItem(STORE_KEY) || '{}'); }
catch { return {}; }
};
const saveStore = (s) => {
try { localStorage.setItem(STORE_KEY, JSON.stringify(s)); } catch {}
};

function getCafeKey() {
const href = location.href;
let m = href.match(/\/cafes\/(\d+)/) || href.match(/[?&]clubid=(\d+)/);
if (m) return 'club' + m[1];
m = href.match(/cafe\.naver\.com\/([a-zA-Z0-9_]+)/);
if (m && !['f-e', 'ca-fe', 'ArticleList', 'ArticleRead'].includes(m[1])) return m[1];
return TARGET_CAFE;
}

function extractId(str) {
if (!str) return null;
let m;
m = str.match(/articleid=(\d+)/i);
if (m) return m[1];
m = str.match(/\/articles\/(\d+)/);
if (m) return m[1];
m = str.match(/\/newsickminza\/(\d+)/);
if (m) return m[1];
m = str.match(/cafe\.naver\.com\/[a-zA-Z0-9_]+\/(\d{2,})/);
if (m) return m[1];
return null;
}

function isArticlePage() {
const id = extractId(location.href);
if (!id) return null;
if (/ArticleList|ArticleSearch/i.test(location.href)) {
if (!/\/articles\/\d+/.test(location.href) && !/\/newsickminza\/\d+/.test(location.href)) return null;
}
return id;
}

function markAsRead(id) {
const cafe = getCafeKey();
const store = loadStore();
store[cafe] = store[cafe] || {};
if (!store[cafe][id]) {
store[cafe][id] = Date.now();
const keys = Object.entries(store[cafe]).sort((a, b) => a[1] - b[1]);
while (keys.length > 8000) {
const [del] = keys.shift();
delete store[cafe][del];
}
saveStore(store);
}
}

function isRead(id) {
const store = loadStore();
return !!(store[getCafeKey()] && store[getCafeKey()][id]);
}

const st = document.createElement('style');
st.textContent = `
.ncr-read-link { opacity: .48 !important; }
#ncr-panel { position: fixed !important; right: 16px !important; bottom: 16px !important; z-index: 999999 !important;
display: flex !important; flex-direction: column !important; gap: 8px !important; }
#ncr-panel button { background: rgba(20,22,26,.92) !important; color: #fff !important;
border: 1px solid #444 !important; border-radius: 999px !important;
font-size: 13px !important; font-weight: 700 !important; padding: 10px 16px !important;
cursor: pointer !important; box-shadow: 0 4px 16px rgba(0,0,0,.3) !important; white-space: nowrap !important; }
#ncr-panel button:hover { background: #03c75a !important; border-color: #03c75a !important; }
`;
document.documentElement.appendChild(st);

const BADGE_STYLE = 'display:inline-block !important;font-size:11px !important;font-weight:700 !important;line-height:1 !important;padding:3px 6px !important;margin-right:6px !important;border-radius:999px !important;background:#03c75a !important;color:#fff !important;vertical-align:2px !important;white-space:nowrap !important;flex-shrink:0 !important;';

function findTitleNode(a) {
const t = a.querySelector('.title, .tit, [class*="title" i], [class*="subject" i], [class*="tit" i]');
if (t && t.textContent.trim().length > 1) {
const leaf = [...t.querySelectorAll('div, span, p, strong, em')]
.filter(el => el.children.length === 0 && el.textContent.trim().length > 1)
.sort((x, y) => y.textContent.trim().length - x.textContent.trim().length)[0];
return leaf || t;
}
const leaves = [...a.querySelectorAll('div, span, p, strong, em')]
.filter(el => el.children.length === 0 && el.textContent.trim().length > 1)
.sort((x, y) => y.textContent.trim().length - x.textContent.trim().length);
return leaves[0] || null;
}

function decorateLink(a) {
const href = a.getAttribute('href') || a.href || '';
const id = extractId(href);
if (!id) return;
if (!a.dataset.ncrDone) {
a.dataset.ncrDone = id;
a.addEventListener('click', () => markAsRead(id), { capture: true });
}
a.querySelectorAll('.ncr-badge').forEach(e => e.remove());
const row = a.closest('li, tr, div[class*="board"], div[class*="Article"], div[class*="list"], div[class*="item"]') || a;

if (isRead(id)) {
a.classList.add('ncr-read-link');
row.classList.add('ncr-is-read');
const host = findTitleNode(a);
const b = document.createElement('span');
b.className = 'ncr-badge';
b.textContent = '읽음';
b.style.cssText = BADGE_STYLE;
if (host) host.prepend(b);
else a.prepend(b);
} else {
a.classList.remove('ncr-read-link');
row.classList.remove('ncr-is-read');
}
}

function scanLists() {
document.querySelectorAll('a[href*="articleid="], a[href*="/articles/"], a[href*="newsickminza/"]').forEach(decorateLink);
}

function scrollToTop() {
try { top.scrollTo({ top: 0, behavior: 'smooth' }); } catch {}
window.scrollTo({ top: 0, behavior: 'smooth' });
document.documentElement.scrollTo?.({ top: 0, behavior: 'smooth' });
document.body.scrollTo?.({ top: 0, behavior: 'smooth' });
document.querySelectorAll('main, div').forEach(el => {
try { if (el.scrollTop > 200) el.scrollTo({ top: 0, behavior: 'smooth' }); } catch {}
});
}

function goAllArticles() {
const isMobile = location.hostname.startsWith('m.');
const target = isMobile ? 'https://m.cafe.naver.com/newsickminza' : 'https://cafe.naver.com/newsickminza';
if (location.href === target || location.href === target + '/') location.reload();
else location.href = target;
}

function ensurePanel() {
if (document.getElementById('ncr-panel')) return;
const p = document.createElement('div');
p.id = 'ncr-panel';
p.innerHTML = `<button id="ncr-top" type="button">맨위로</button><button id="ncr-all" type="button">전체글</button>`;
document.body.appendChild(p);
p.querySelector('#ncr-top').onclick = scrollToTop;
p.querySelector('#ncr-all').onclick = goAllArticles;
}

const curId = isArticlePage();
if (curId) {
setTimeout(() => {
if (document.body && document.body.innerText.length > 50) markAsRead(curId);
}, READ_DELAY);
}

let timer = null;
new MutationObserver(() => {
clearTimeout(timer);
timer = setTimeout(() => { scanLists(); ensurePanel(); }, 300);
}).observe(document.documentElement, { childList: true, subtree: true });
setInterval(() => { scanLists(); ensurePanel(); }, 2000);
scanLists();
ensurePanel();
})();
