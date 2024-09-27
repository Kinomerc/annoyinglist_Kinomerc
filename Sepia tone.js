// ==UserScript==
// @name        Sepia tone
// @namespace   https://github.com/Kinomerc
// @match       *://*/*
// @grant       none
// @version     1.0
// @author      Kinomerc
// @description 2024. 9. 18. 오후 10:05:11
// ==/UserScript==

(function () {
  const style = document.createElement('style');
  style.textContent = `
    html {
      filter: sepia(0.2);
      color: #343434;
      a {
        color: #0000ee;
      }
      @media (prefers-color-scheme: dark) {
        body {
          background: #121212;
          color: #bbb;
        }
        a {
          color: #e0f1ff;
        }
      }
    }
  `;
  document.head.appendChild(style);
}());
