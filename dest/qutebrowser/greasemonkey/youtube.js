// ==UserScript==
// @name        youtube
// @description Add next/prev ids so they can be clicked by :click-element
// @match       *://*.youtube.com/watch*
// @grant       none
// ==/UserScript==

console.log("Youtube Script Loaded");
document.getElementsByClassName("ytp-next-button")[0].id = "ytp-next-button";
document.getElementsByClassName("ytp-prev-button")[0].id = "ytp-prev-button";
