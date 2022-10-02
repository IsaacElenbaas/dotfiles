// ==UserScript==
// @name        cleanup
// @description Cleanup for random sites
// @match       *
// @grant       none
// ==/UserScript==

function removeId(name) {
	var elem = document.getElementById(name);
	if(elem !== null)
		elem.remove();
}
function removeClass(name) {
	var elems = document.getElementsByClassName(name);
	for(var i = 0; i < elems.length; i++) {
		elems[i].remove();
	}
}

var bgStyle = document.head.appendChild(document.createElement("style"));
bgStyle.innerHTML = ".video-ads { display: none !important; }";
