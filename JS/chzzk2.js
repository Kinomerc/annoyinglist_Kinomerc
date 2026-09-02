// ==UserScript==
// @name         CHZZK Enhanced
// @version      1.0.2
// @description  채팅 타임스탬프·블라인드 복원·라이브 딜레이·VOD KST
// @match        *://chzzk.naver.com/*
// @grant        none
// @inject-into  page
// @run-at       document-start
// ==/UserScript==

(() => {
"use strict";

/* =========================================================
공통
=======================================================*/

const reportOnceSet = new Set();

const reportOnce = (key, message, error) => {
if (reportOnceSet.has(key)) return;
reportOnceSet.add(key);

if (error) {
  console.error(`[Chzzk Core] ${message}`, error);
} else {
  console.error(`[Chzzk Core] ${message}`);
}

};

const isChzzkServiceApi = (url) =>
String(url).includes("api.chzzk.naver.com/service");

const isVideoDetailUrl = (url) =>
  isChzzkServiceApi(url) &&
  /\/service\/v\d+\/videos\/\d+(?:\?|$)/.test(String(url));

const endpointOf = (url) =>
String(url).split("?")[0];

const parseJsonText = (text, url) => {
try {
return JSON.parse(text);
} catch (error) {
reportOnce(
`json ${endpointOf(url)} ${error?.name ?? "-"}`,
`JSON 파싱 실패: ${endpointOf(url)}`,
error,
);
return null;
}
};

/* =========================================================
VOD 방송 시작시각
=======================================================*/

let vodBroadcastStartMs = null;

const captureVodBroadcastStart = (content, url) => {
const s = content && content.liveOpenDate;

if (s == null) {
  vodBroadcastStartMs = null;
  return;
}

if (
  typeof s !== "string" ||
  !/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/.test(s)
) {
  vodBroadcastStartMs = null;

  reportOnce(
    `liveOpenDate ${endpointOf(url)}`,
    `liveOpenDate 형식이 달라 KST 표시를 끕니다: ${endpointOf(url)}`,
  );

  return;
}

const ms = Date.parse(
  s.replace(" ", "T") + "+09:00",
);

if (Number.isNaN(ms)) {
  vodBroadcastStartMs = null;

  reportOnce(
    `liveOpenDate parse ${endpointOf(url)}`,
    `liveOpenDate 해석 실패: ${endpointOf(url)}`,
  );

  return;
}

vodBroadcastStartMs = ms;

};

const rewriteDetailText = (text, url) => {
const origin = parseJsonText(text, url);

if (!origin || !origin.content) {
  return text;
}

if (isVideoDetailUrl(url)) {
  captureVodBroadcastStart(
    origin.content,
    url,
  );

  return JSON.stringify(origin);
}

return text;

};

/* =========================================================
XHR 가로채기

VOD KST용 video-detail 응답만 처리
=======================================================*/

const NativeXHR = window.XMLHttpRequest;
const xhrOpen = NativeXHR.prototype.open;
const xhrSend = NativeXHR.prototype.send;

const xhrState = new WeakMap();

const getXhrState = (xhr) => {
let state = xhrState.get(xhr);

if (!state) {
  state = {
    url: "",
    hooked: false,
  };

  xhrState.set(xhr, state);
}

return state;

};

const clearOwnResponse = (xhr) => {
for (const name of [
"responseText",
"response",
]) {
try {
const desc =
Object.getOwnPropertyDescriptor(
xhr,
name,
);

    if (desc?.configurable) {
      delete xhr[name];
    }
  } catch (_) {}
}

};

const shadowResponse = (xhr, text) => {
Object.defineProperty(
xhr,
"responseText",
{
configurable: true,
get: () => text,
},
);

Object.defineProperty(
  xhr,
  "response",
  {
    configurable: true,
    get: () => text,
  },
);

};

const patchXhrResponse = (xhr) => {
const state = getXhrState(xhr);
const url = state.url;

if (!isVideoDetailUrl(url)) {
  return;
}

const responseType =
  xhr.responseType;

if (
  responseType !== "" &&
  responseType !== "text"
) {
  return;
}

let text;

try {
  text = xhr.responseText;
} catch (error) {
  reportOnce(
    `xhr read ${error?.name ?? "-"} ${endpointOf(url)}`,
    `XHR responseText 읽기 실패: ${endpointOf(url)}`,
    error,
  );

  return;
}

if (typeof text !== "string") {
  return;
}

const rewritten =
  rewriteDetailText(
    text,
    url,
  );

if (rewritten === text) {
  return;
}

try {
  shadowResponse(
    xhr,
    rewritten,
  );
} catch (error) {
  reportOnce(
    `xhr shadow ${error?.name ?? "-"} ${endpointOf(url)}`,
    `XHR 응답 교체 실패: ${endpointOf(url)}`,
    error,
  );
}

};

NativeXHR.prototype.open =
function (...args) {
const state =
getXhrState(this);

  clearOwnResponse(this);

  state.url =
    String(args[1] ?? "");

  if (!state.hooked) {
    state.hooked = true;

    const xhr = this;

    xhr.addEventListener(
      "readystatechange",
      () => {
        if (
          xhr.readyState === 4
        ) {
          patchXhrResponse(xhr);
        }
      },
    );

    xhr.addEventListener(
      "load",
      () => {
        patchXhrResponse(xhr);
      },
    );
  }

  return xhrOpen.apply(
    this,
    args,
  );
};

NativeXHR.prototype.send =
function (...args) {
getXhrState(this);

  return xhrSend.apply(
    this,
    args,
  );
};

/* =========================================================
fetch 가로채기

VOD KST용 video-detail 응답만 처리
=======================================================*/

const nativeFetch =
window.fetch.bind(window);

window.fetch =
async function (...args) {
const input = args[0];

  const url =
    typeof input === "string"
      ? input
      : input instanceof URL
        ? input.href
        : input &&
            typeof input.url === "string"
          ? input.url
          : "";

  const response =
    await nativeFetch(...args);

  if (!isVideoDetailUrl(url)) {
    return response;
  }

  try {
    const clone =
      response.clone();

    const text =
      await clone.text();

    const rewritten =
      rewriteDetailText(
        text,
        url,
      );

    if (rewritten === text) {
      return response;
    }

    return new Response(
      rewritten,
      {
        status:
          response.status,
        statusText:
          response.statusText,
        headers:
          response.headers,
      },
    );
  } catch (error) {
    reportOnce(
      `fetch rewrite ${error?.name ?? "-"} ${endpointOf(url)}`,
      `fetch 응답 처리 실패: ${endpointOf(url)}`,
      error,
    );

    return response;
  }
};

/* =========================================================
암호화 터널 가로채기

VOD KST용 video-detail 응답만 처리
=======================================================*/

const tunnelUrlByKey =
new WeakMap();

const originalSubtle =
globalThis.crypto?.subtle;

const installTunnelHook = () => {
const subtle =
originalSubtle;

if (!subtle) {
  reportOnce(
    "tunnel no subtle",
    "crypto.subtle을 찾지 못했습니다.",
  );

  return;
}

const proto =
  Object.getPrototypeOf(subtle);

const encDesc =
  Object.getOwnPropertyDescriptor(
    proto,
    "encrypt",
  );

const decDesc =
  Object.getOwnPropertyDescriptor(
    proto,
    "decrypt",
  );

if (
  !encDesc ||
  !decDesc
) {
  reportOnce(
    "tunnel no descriptor",
    "SubtleCrypto encrypt/decrypt를 찾지 못했습니다.",
  );

  return;
}

const nativeEncrypt =
  encDesc.value;

const nativeDecrypt =
  decDesc.value;

const decoder =
  new TextDecoder();

const patchedEncrypt =
  function (
    algorithm,
    key,
    data,
  ) {
    try {
      const bytes =
        data instanceof ArrayBuffer
          ? new Uint8Array(data)
          : new Uint8Array(
              data.buffer,
              data.byteOffset,
              data.byteLength,
            );

      const text =
        decoder.decode(bytes);

      if (
        text.startsWith("http")
      ) {
        tunnelUrlByKey.set(
          key,
          text,
        );
      }
    } catch (error) {
      reportOnce(
        `tunnel encrypt ${error?.name ?? "-"}`,
        "터널 URL 캡처 실패",
        error,
      );
    }

    return Reflect.apply(
      nativeEncrypt,
      this,
      arguments,
    );
  };

const patchedDecrypt =
  function (
    algorithm,
    key,
    data,
  ) {
    return Reflect.apply(
      nativeDecrypt,
      this,
      arguments,
    ).then((plain) => {
      const url =
        tunnelUrlByKey.get(
          key,
        );

      if (
        typeof url !== "string"
      ) {
        return plain;
      }

      if (
        !isVideoDetailUrl(url)
      ) {
        return plain;
      }

      try {
        const bytes =
          new Uint8Array(
            plain,
          );

        const text =
          decoder.decode(bytes);

        const rewritten =
          rewriteDetailText(
            text,
            url,
          );

        if (
          rewritten === text
        ) {
          return plain;
        }

        return new TextEncoder()
          .encode(rewritten)
          .buffer;
      } catch (error) {
        reportOnce(
          `tunnel decrypt ${error?.name ?? "-"}`,
          `터널 응답 처리 실패: ${endpointOf(url)}`,
          error,
        );

        return plain;
      }
    });
  };

try {
  Object.defineProperty(
    proto,
    "encrypt",
    {
      ...encDesc,
      value: patchedEncrypt,
    },
  );

  Object.defineProperty(
    proto,
    "decrypt",
    {
      ...decDesc,
      value: patchedDecrypt,
    },
  );
} catch (error) {
  reportOnce(
    "tunnel install",
    "암호화 터널 훅 설치 실패",
    error,
  );
}

};

installTunnelHook();

/* =========================================================
채팅 정리

시:분:초

BLIND / CBOTBLIND 원문 복원
=======================================================*/

const CHAT_ROW_SELECTOR =
'[class*="chatting_message"]';

const CHAT_FIBER_STEP_BUDGET =
500;

const pad2 = (n) =>
String(n).padStart(2, "0");

const formatTimestamp = (
ms,
) => {
const d = new Date(ms);

return `${pad2(d.getHours())}:${pad2(
  d.getMinutes(),
)}:${pad2(d.getSeconds())}`;

};

const readMessageFromItem = (
item,
) => {
const fiberKey =
Object.keys(item).find(
(key) =>
key.startsWith(
"__reactFiber$",
),
);

if (!fiberKey) {
  return null;
}

const root =
  item[fiberKey];

const stack =
  root?.child
    ? [root.child]
    : [];

let steps = 0;

while (
  stack.length &&
  steps <
    CHAT_FIBER_STEP_BUDGET
) {
  const node =
    stack.pop();

  steps++;

  if (!node) {
    continue;
  }

  const chatMessage =
    node.memoizedProps
      ?.chatMessage;

  if (
    chatMessage &&
    chatMessage.type !==
      undefined
  ) {
    return chatMessage;
  }

  if (node.child) {
    stack.push(
      node.child,
    );
  }

  if (node.sibling) {
    stack.push(
      node.sibling,
    );
  }
}

return null;

};

const getMessageTextEl = (
row,
) => {
const texts =
row.querySelectorAll(
'[class*="text"]',
);

for (const text of texts) {
  if (
    !text.closest(
      '[class*="_nickname_"]',
    )
  ) {
    return text;
  }
}

return null;

};

const isLivePage = () =>
location.pathname.includes(
"/live/",
);

const isVodPage = () =>
location.pathname.includes(
"/video/",
);

const isChatPage = () =>
isLivePage() ||
isVodPage();

const findChatScroller = () => {
const row =
document.querySelector(
CHAT_ROW_SELECTOR,
);

if (!row) {
  return null;
}

if (isVodPage()) {
  let el =
    row.parentElement;

  for (
    let i = 0;
    i < 8 &&
    el &&
    el !== document.body;
    i++
  ) {
    const overflowY =
      getComputedStyle(
        el,
      ).overflowY;

    if (
      overflowY ===
        "auto" ||
      overflowY ===
        "scroll"
    ) {
      return el;
    }

    el = el.parentElement;
  }

  return row.parentElement;
}

let el =
  row.parentElement;

for (
  let i = 0;
  i < 8 &&
  el &&
  el !== document.body;
  i++
) {
  if (
    el.scrollHeight >
    el.clientHeight + 40
  ) {
    return el;
  }

  el =
    el.parentElement;
}

return (
  row.parentElement
    ?.parentElement
    ?.parentElement ||
  row.parentElement
);

};

let chatScroller = null;
let chatObserver = null;

const getChatItem = (
node,
) => {
let el =
node?.nodeType === 1
? node
: node?.parentElement;

while (
  el &&
  el.parentElement
) {
  if (
    el.parentElement ===
    chatScroller
  ) {
    return el;
  }

  el =
    el.parentElement;
}

return null;

};

const processChatItem = (
item,
) => {
let msg;

try {
  msg =
    readMessageFromItem(
      item,
    );
} catch (error) {
  reportOnce(
    `chat read ${error?.name ?? "-"}`,
    "채팅 정보 읽기 실패",
    error,
  );

  return;
}

if (!msg) {
  return;
}

const row =
  item.querySelector(
    CHAT_ROW_SELECTOR,
  );

if (!row) {
  return;
}

/* 블라인드 원문 복원 */
if (
  msg.status === "BLIND" ||
  msg.status === "CBOTBLIND"
) {
  const original =
    msg.content;

  if (
    typeof original ===
      "string" &&
    original
  ) {
    const textEl =
      getMessageTextEl(
        row,
      );

    if (
      textEl &&
      textEl.textContent !==
        original
    ) {
      textEl.textContent =
        original;
    }
  }
}

/* 시:분:초 표시 */
if (
  msg.time &&
  !row.querySelector(
    ":scope > .cf-chat-stamp",
  )
) {
  const stamp =
    document.createElement(
      "span",
    );

  stamp.className =
    "cf-chat-stamp";

  stamp.textContent =
    formatTimestamp(
      msg.time,
    );

  row.insertBefore(
    stamp,
    row.firstChild,
  );
}

};

const handleChatMutations = (
mutations,
) => {
const items =
new Set();

for (
  const mutation of mutations
) {
  const onlyOwnStamp =
    mutation.type ===
      "childList" &&
    mutation.removedNodes
      .length === 0 &&
    mutation.addedNodes
      .length > 0 &&
    Array.from(
      mutation.addedNodes,
    ).every(
      (node) =>
        node.nodeType === 1 &&
        node.classList?.contains(
          "cf-chat-stamp",
        ),
    );

  if (onlyOwnStamp) {
    continue;
  }

  const targetEl =
    mutation.target
      .nodeType === 1
      ? mutation.target
      : mutation.target
          .parentElement;

  if (
    targetEl?.closest?.(
      ".cf-chat-stamp",
    )
  ) {
    continue;
  }

  for (
    const node of
      mutation.addedNodes
  ) {
    if (
      node.nodeType !== 1
    ) {
      continue;
    }

    const item =
      getChatItem(node);

    if (item) {
      items.add(item);
    }
  }

  const targetItem =
    getChatItem(targetEl);

  if (targetItem) {
    items.add(
      targetItem,
    );
  }
}

items.forEach(
  processChatItem,
);

};

const ensureChatObserver =
() => {
if (
chatScroller &&
!chatScroller.isConnected
) {
chatObserver?.disconnect();

    chatObserver = null;
    chatScroller = null;
  }

  if (!isChatPage()) {
    return;
  }

  if (
    chatScroller?.isConnected
  ) {
    return;
  }

  const scroller =
    findChatScroller();

  if (!scroller) {
    return;
  }

  chatObserver?.disconnect();

  chatScroller =
    scroller;

  chatObserver =
    new MutationObserver(
      handleChatMutations,
    );

  chatObserver.observe(
    scroller,
    {
      childList: true,
      subtree: true,
      characterData: true,
    },
  );

  Array.from(
    scroller.children,
  ).forEach(
    processChatItem,
  );
};

/* =========================================================
VOD 재생바 KST
=======================================================*/

let seekTimeObserver =
null;

let seekTimeEl = null;

const parseElapsed = (text) => {
  const parts = (text || "").trim().split(":");

  if (
    !parts.length ||
    parts.some((x) => !/^\d+$/.test(x))
  ) {
    return null;
  }

  return parts.reduce(
    (acc, x) => acc * 60 + parseInt(x, 10),
    0,
  );
};

const formatKstFromElapsed =
(elapsedSec) => {
if (
vodBroadcastStartMs ==
null
) {
return null;
}

  const d = new Date(
    vodBroadcastStartMs +
      elapsedSec * 1000 +
      9 *
        3600 *
        1000,
  );

  return (
    d.getUTCFullYear() +
    "-" +
    pad2(
      d.getUTCMonth() +
        1,
    ) +
    "-" +
    pad2(
      d.getUTCDate(),
    ) +
    " " +
    pad2(
      d.getUTCHours(),
    ) +
    ":" +
    pad2(
      d.getUTCMinutes(),
    ) +
    ":" +
    pad2(
      d.getUTCSeconds(),
    )
  );
};

const updateSeekKst = () => {
try {
if (!seekTimeEl?.isConnected) {
return;
}

// 기존 KST 표시 전부 제거
document
  .querySelectorAll(".cf-seek-kst")
  .forEach((el) => el.remove());

if (vodBroadcastStartMs == null) {
  return;
}

const elapsed = parseElapsed(
seekTimeEl.textContent,
);

if (elapsed == null) {
  return;
}

const kst = formatKstFromElapsed(
elapsed,
);

if (!kst) {
  return;
}

const kstEl =
document.createElement("div");

kstEl.className = "cf-seek-kst";
kstEl.textContent = kst;

seekTimeEl.insertAdjacentElement(
"afterend",
kstEl,
);

} catch (error) {
reportOnce(
`seek kst ${error?.name ?? "-"}`,
"VOD KST 표시 실패",
error,
);
}
};

const ensureVodSeekTimeObserver =
() => {
if (!isVodPage()) {
seekTimeObserver?.disconnect();

    seekTimeObserver = null;
    seekTimeEl = null;

    return;
  }

  if (
    seekTimeEl &&
    !seekTimeEl.isConnected
  ) {
    seekTimeObserver?.disconnect();

    seekTimeObserver = null;
    seekTimeEl = null;
  }

  if (
    seekTimeEl?.isConnected
  ) {
    return;
  }

  const el =
    document.querySelector(
      ".pzp-seeking-preview__time",
    );

  if (!el) {
    return;
  }

  seekTimeEl = el;

  seekTimeObserver =
    new MutationObserver(
      updateSeekKst,
    );

  seekTimeObserver.observe(
    el,
    {
      childList: true,
      characterData: true,
      subtree: true,
    },
  );

  updateSeekKst();
};

/* =========================================================
라이브 딜레이 표시
=======================================================*/

const LATENCY_REFRESH_MS =
1000;

let latencyEl = null;
let latencyTimer = null;

const readLiveLatencyMs =
() => {
const getLiveInfo =
window.__getLiveInfo;

  if (
    typeof getLiveInfo !==
    "function"
  ) {
    return null;
  }

  try {
    const info =
      getLiveInfo();

    const ms =
      info?.latency;

    if (
      typeof ms !==
        "number" ||
      !(ms > 0)
    ) {
      return null;
    }

    return ms;
  } catch (error) {
    reportOnce(
      `latency ${error?.name ?? "-"}`,
      "라이브 딜레이 조회 실패",
      error,
    );

    return null;
  }
};

const updateLiveLatency =
() => {
if (
!latencyEl?.isConnected
) {
return;
}

  const ms =
    readLiveLatencyMs();

  latencyEl.textContent =
    ms == null
      ? ""
      : `${(
          ms / 1000
        ).toFixed(1)}s`;
};

const ensureLiveLatency =
() => {
if (!isLivePage()) {
if (latencyTimer) {
clearInterval(
latencyTimer,
);

      latencyTimer =
        null;
    }

    latencyEl?.remove();
    latencyEl = null;

    return;
  }

  if (
    latencyEl?.isConnected
  ) {
    return;
  }

  let el =
    document.querySelector(
      ".cf-live-latency",
    );

  if (!el) {
    const liveTime =
      document.querySelector(
        ".live_time",
      );

    if (!liveTime) {
      return;
    }

    el =
      document.createElement(
        "span",
      );

    el.className =
      "cf-live-latency";

    liveTime.insertAdjacentElement(
      "afterend",
      el,
    );
  }

  latencyEl = el;

  if (!latencyTimer) {
    latencyTimer =
      setInterval(
        updateLiveLatency,
        LATENCY_REFRESH_MS,
      );
  }

  updateLiveLatency();
};

/* =========================================================
스타일
=======================================================*/

const style =
document.createElement(
"style",
);

style.textContent = `
.cf-chat-stamp {
color: #888888;
font-size: 0.85em;
margin-right: 4px;
font-variant-numeric: tabular-nums;
user-select: none;
flex-shrink: 0;
-webkit-text-stroke: 0.5px #aaa;
}

.cf-seek-kst {
  font-size: 12px;
  font-weight: 600;
  color: #ffffff;
  text-align: center;
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
  margin-top: 2px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.8);
}

.cf-live-latency {
  display: inline-flex;
  align-items: center;
  height: 36px;
  margin-left: 6px;
  padding: 0 2px;
  color: #ffffff;
  font-size: 13px;
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
  user-select: none;
  opacity: 0;
  transition: opacity 0.2s;
}

.pzp-pc.pzp-pc--controls .cf-live-latency {
  opacity: 1;
}

.cf-live-latency:empty {
  display: none;
}

`;

const installStyle = () => {
if (document.head) {
if (!document.head.contains(style)) {
document.head.appendChild(
style,
);
}
} else if (
document.documentElement
) {
if (
!document.documentElement.contains(
style,
)
) {
document.documentElement.appendChild(
style,
);
}
}
};

/* =========================================================
통합 MutationObserver
=======================================================*/

const startObserver =
() => {
installStyle();

  ensureChatObserver();
  ensureVodSeekTimeObserver();
  ensureLiveLatency();

  const observer =
    new MutationObserver(
      () => {
        installStyle();

        ensureChatObserver();
        ensureVodSeekTimeObserver();
        ensureLiveLatency();
      },
    );

  const target =
    document.body ||
    document.documentElement;

  if (target) {
    observer.observe(
      target,
      {
        childList: true,
        subtree: true,
      },
    );
  }
};

if (
document.readyState ===
"loading"
) {
document.addEventListener(
"DOMContentLoaded",
startObserver,
{ once: true },
);
} else {
startObserver();
}
})();
