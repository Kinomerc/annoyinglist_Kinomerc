// ==UserScript==
// @name         CHZZK Clean Theater Mode add-on
// @namespace    https://userstyles.world/style/13773/default-slug
// @version      20250409.14.54
// @description  Using it in dark mode is recommended.
// @match        https://chzzk.naver.com/*
// @grant        GM_xmlhttpRequest
// ==/UserScript==

// 다시보기 스트리머 명 표시
(() => {
    'use strict';
    function update() {
        const largeSection = document.querySelector('section[class*="_is_large_"]');
        if (!largeSection) {
            document.querySelectorAll('.custom-streamer-info').forEach(info => {
                const parent = info.parentElement;
                if (parent) {
                    parent.style.removeProperty('display');
                    parent.style.removeProperty('align-items');
                    parent.style.removeProperty('gap');
                }
                info.remove();
            });
            return;
        }
        const title = largeSection.querySelector('p[class^="_title"]');
        const icon = largeSection.querySelector('a[class^="_thumbnail_"] img');
        const name = largeSection.querySelector('div[class^="_name_"] span[class^="_text_"]');
        if (!title || !icon || !name) return;
        const titleParent = title.parentElement;
        titleParent.style.setProperty('display', 'flex', 'important');
        let info = titleParent.querySelector('.custom-streamer-info');
        if (!info) {
            info = document.createElement('div');
            info.className = 'custom-streamer-info';
            info.innerHTML = '<img class="custom-icon" src=""><span class="custom-name"></span>';
            title.before(info);
        }
        const imgEl = info.querySelector('.custom-icon');
        const nameEl = info.querySelector('.custom-name');
        const currentSrc = icon.currentSrc || icon.src;
        const currentName = name.textContent.trim();
        if (imgEl.src !== currentSrc) imgEl.src = currentSrc;
        if (nameEl.textContent !== currentName) nameEl.textContent = currentName;
    }
    const style = document.createElement('style');
    style.textContent = [
        '.custom-streamer-info{display:flex!important;align-items:center!important;gap:7px!important;',
        'margin-left:12px!important;margin-right:0!important;position:relative!important;top:8px!important;}',
        '.custom-streamer-info img{width:32px!important;height:32px!important;border-radius:50%!important;',
        'object-fit:cover!important;display:block!important;flex-shrink:0!important;}',
        '.custom-streamer-info .custom-name{line-height:28px!important;margin-left:2px!important;white-space:nowrap!important;',
        'text-shadow:0.5px 0 0.5px #000,0 0.5px 0.5px #000,-0.5px 0 0.5px #000,0 -0.5px 0.5px #000,0.5px 0.5px 0.5px #000;}'
    ].join('');
    document.head.appendChild(style);
    let debounceTimer;
    new MutationObserver(() => { clearTimeout(debounceTimer); debounceTimer = setTimeout(update, 100); })
        .observe(document.body, { childList: true, subtree: true });
})();

// 팔로우 자동 확장
(function() {
    'use strict';
    function clickMoreButtonOnce() {
        const moreButton = document.querySelector('[id="sidebar"] button[aria-label="더보기"][aria-expanded="false"]');
        if (moreButton) { moreButton.click(); return true; }
        return false;
    }
    document.addEventListener('mouseup', (event) => {
        const menuButton = event.target.closest('button[aria-label="메뉴 확장"][aria-expanded="false"]');
        if (menuButton && event.isTrusted) {
            let attempts = 0;
            const maxAttempts = 50;
            const checkInterval = setInterval(() => {
                if (attempts < maxAttempts) {
                    if (clickMoreButtonOnce()) clearInterval(checkInterval);
                    attempts++;
                } else clearInterval(checkInterval);
            }, 100);
        }
    });
})();

//  치지직 확장 CSS
(function() {
    'use strict';
    const cssUrl = 'https://userstyles.world/api/style/13773.user.css';
    GM_xmlhttpRequest({
        method: 'GET', url: cssUrl,
        onload: function(response) {
            if (response.status !== 200) return;
            let cssContent = response.responseText.replace(/\/\*\s*==UserStyle==[\s\S]*?==\/UserStyle==\s*\*\/\n*/, '');
            const m = cssContent.match(/@-moz-document domain\("chzzk\.naver\.com"\)\s*\{\s*([\s\S]*)\s*\}/);
            if (m && m[1]) cssContent = m[1];
            const style = document.createElement('style');
            style.textContent = cssContent;
            const links = document.head.querySelectorAll('link[rel="stylesheet"]');
            document.head.insertBefore(style, links.length ? links[links.length - 1].nextSibling : document.head.firstChild);
        }
    });
})();

(function() {
    'use strict';
    function init() {
        const s = document.createElement('style');
        s.textContent = [
            '@keyframes cfFadeOnly{from{opacity:0;}to{opacity:1;}}',
            '@keyframes newMessage{from{opacity:0;}to{opacity:1;}}',
            'aside[id="aside-chatting"] div[class^="_item_"],',
            'aside[id="vod-aside"] div[class^="_item_"],',
            'aside[class^="vod_aside__"] div[class*="_item_"],',
            'div[class^="vod_chatting__"] div[class*="_item_"]{',
            'animation:cfFadeOnly 300ms ease-out forwards!important;',
            'will-change:opacity!important;transform:none!important;}'
        ].join('');
        document.head.appendChild(s);
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, { once: true });
    else init();
})();

// 채팅 타임스탬프
(function() {
    'use strict';
    function init() {
        const ROW_SEL = '[class*="chatting_message"]';
        const style = document.createElement('style');
        style.textContent = [
        '.cf-chat-stamp{flex:none!important;white-space:nowrap!important;user-select:none!important;',
        'font-size:11px!important;font-weight:400!important;opacity:1!important;color:rgba(255,255,255,.75)!important;',
        'font-variant-numeric:tabular-nums!important;',
        'background:transparent!important;padding:0!important;border-radius:0!important;box-shadow:none!important;',
        'text-shadow:1px 0 0 #000,0 1px 0 #000,-1px 0 0 #000,0 -1px 0 #000!important;}',
          'button[class^="_nickname_"]:has(> .cf-chat-stamp){display:flex!important;',
          'justify-content:space-between!important;align-items:baseline!important;gap:12px!important;width:100%!important;',
         'background:transparent!important;padding:0!important;}',
         'button[class^="_nickname_"]:has(> .cf-chat-stamp) > :not(.cf-chat-stamp){',
         'background:rgba(0,0,0,0.6)!important;border-radius:7px!important;padding:6px 6px 3px 6px!important;}',
          'button[class^="_nickname_"] .cf-chat-stamp{margin-left:auto!important;}',
          'section[class*="_is_large_"] button[class^="_nickname_"]:has(> .cf-chat-stamp){',
          'justify-content:flex-end!important;text-align:right!important;}',
          'section[class*="_is_large_"] button[class^="_nickname_"] .cf-chat-stamp{margin-left:0!important;position:relative!important;top:2px!important;}',
          'section[class*="_is_large_"] aside[id="aside-chatting"] div[class^="_chatting_message_"] button[class^="_nickname_"] > span.cf-chat-stamp{',
           'text-shadow:1px 0 0 #000,0 1px 0 #000,-1px 0 0 #000,0 -1px 0 #000,1px 1px 0 #000,-1px 1px 0 #000,-1px -1px 0 #000,1px -1px 0 #000!important;',
           'opacity:1!important;background:transparent!important;}',
           'html body section[class*="_is_large_"] aside[id="aside-chatting"] div[class^="_chatting_message_"]{',
            'text-align:right!important;align-items:flex-end!important;justify-content:flex-end!important;}',
           'html body section[class*="_is_large_"] aside[id="aside-chatting"] div[class^="_chatting_message_"] > span[class^="_text_"]{',
            'text-align:right!important;display:block!important;width:100%!important;margin-left:auto!important;margin-right:0!important;}',
          'html body section[class*="_is_large_"] aside[id="aside-chatting"] button[class^="_nickname_"]{',
           'margin-left:auto!important;margin-right:0!important;}'

          
        ].join('');
        document.head.appendChild(style);

        const pad2 = (n) => String(n).padStart(2, '0');
        const fmt = (ms) => { const d = new Date(ms); return pad2(d.getHours())+':'+pad2(d.getMinutes())+':'+pad2(d.getSeconds()); };
        function readMsg(startEl) {
            for (let el = startEl; el && el !== document.body; el = el.parentElement) {
                let k = null;
                try { k = Object.keys(el).find((x) => x.indexOf('__reactFiber$') === 0); } catch (e) { continue; }
                if (!k) continue;
                const stack = el[k] && el[k].child ? [el[k].child] : [];
                let steps = 0;
                while (stack.length && steps < 500) {
                    const n = stack.pop(); steps++;
                    if (!n) continue;
                    const cm = n.memoizedProps && n.memoizedProps.chatMessage;
                    if (cm && cm.type !== undefined) return cm;
                    if (n.child) stack.push(n.child);
                    if (n.sibling) stack.push(n.sibling);
                }
            }
            return null;
        }
        function textElOf(row) {
            const all = row.querySelectorAll('[class*="_text_"]');
            for (const t of all) { if (!t.closest('[class*="_nickname_"]')) return t; }
            return null;
        }
        function unwrapBody(textEl) {
            const body = textEl.querySelector(':scope > .cf-chat-body');
            if (!body) return;
            while (body.firstChild) textEl.insertBefore(body.firstChild, body);
            body.remove();
        }
        function proc(row) {
            let m = null;
            try { m = readMsg(row); } catch (e) { return; }
            if (!m || !m.time) return;
            const textEl = textElOf(row);
            const nickBtn = row.querySelector('button[class^="_nickname_"]');
            if (!textEl || !nickBtn) return;
            row.querySelectorAll(':scope > .cf-chat-stamp').forEach((s) => s.remove());

            unwrapBody(textEl);
            textEl.querySelectorAll(':scope > .cf-chat-stamp').forEach((s) => s.remove());
            const blind = (m.status === 'BLIND' || m.status === 'CBOTBLIND') && typeof m.content === 'string' && !!m.content;
            if (blind && textEl.textContent !== m.content) textEl.textContent = m.content;

            let stamp = nickBtn.querySelector(':scope > .cf-chat-stamp');
            if (!stamp) {
                stamp = document.createElement('span');
                stamp.className = 'cf-chat-stamp';
                nickBtn.appendChild(stamp);
            }
            const t = fmt(m.time);
            if (stamp.textContent !== t) stamp.textContent = t;
        }
        function procAll() {
            if (!location.pathname.includes('/live/') && !location.pathname.includes('/video/')) return;
            document.querySelectorAll(ROW_SEL).forEach(proc);
        }
        new MutationObserver(procAll).observe(document.body, { childList: true, subtree: true, characterData: true });
        setInterval(procAll, 2000);
        procAll();
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, { once: true });
    else init();
})();

// 라이브 딜레이
(function() {
    'use strict';
    function init() {
        const style = document.createElement('style');
        style.textContent = [
            '.cf-live-latency{display:inline-flex!important;align-items:center!important;',
            'height:36px!important;margin-left:6px!important;padding:0 2px!important;',
            'color:#fff!important;font-size:13px!important;font-variant-numeric:tabular-nums!important;',
            'white-space:nowrap!important;user-select:none!important;',
            'opacity:0!important;transition:opacity .2s!important;}',
            '.pzp-pc.pzp-pc--controls .cf-live-latency{opacity:1!important;}',
            '.cf-live-latency:empty{display:none!important;}'
        ].join('');
        document.head.appendChild(style);

        const pageCode = '(' + function() {
            var el = null;
            function log() {
                try { console.log.apply(console, ['[CF-latency]'].concat([].slice.call(arguments))); } catch (e) {}
            }
            function readMs() {
                try {
                    var fn = window.__getLiveInfo;
                    if (typeof fn === 'function') {
                        var ms = fn().latency;
                        if (typeof ms === 'number' && ms > 0) return { ms: ms, src: '__getLiveInfo' };
                    }
                } catch (e) {}
                try {
                    var vs = document.querySelectorAll('video');
                    for (var i = 0; i < vs.length; i++) {
                        try {
                            var v = vs[i];
                            if (v.buffered && v.buffered.length > 0 && isFinite(v.currentTime)) {
                                var end = v.buffered.end(v.buffered.length - 1);
                                var diff = end - v.currentTime;
                                if (diff > 0 && diff < 120) return { ms: Math.round(diff * 1000), src: 'video.buffered' };
                            }
                        } catch (e) {}
                    }
                } catch (e) {}
                return null;
            }
            function ensure() {
                if (!location.pathname.includes('/live/')) {
                    if (el) { el.remove(); el = null; }
                    return;
                }
                if (el && !el.isConnected) el = null;
                var old = !el && document.querySelector('.cf-live-latency');
                if (old) {
                    var pos = '';
                    try { pos = getComputedStyle(old).position; } catch (e) {}
                    if (pos === 'absolute' || old.parentElement === document.body) old.remove();
                    else el = old;
                }
                if (!el) {
                    el = document.querySelector('.cf-live-latency');
                    if (!el) {
                        var t = document.querySelector('.live_time') || document.querySelector('[class*="live_time"]');
                        if (!t) return;
                        el = document.createElement('span');
                        el.className = 'cf-live-latency';
                        el.title = '실제 생방송과 내 화면의 지연 시간';
                        t.insertAdjacentElement('afterend', el);
                        log('badge 삽입됨');
                    }
                }
                var r = readMs();
                var txt = r ? ((r.ms / 1000).toFixed(1) + 's') : '';
                if (el.textContent !== txt) {
                    el.textContent = txt;
                    log('update', txt, r ? r.src : 'no-signal');
                }
            }
            setInterval(ensure, 1000);
            new MutationObserver(ensure).observe(document.documentElement, { childList: true, subtree: true });
            ensure();
        }.toString() + ')();';

        var s = document.createElement('script');
        s.textContent = pageCode;
        (document.head || document.documentElement).appendChild(s);
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, { once: true });
    else init();
})();
