// ==UserScript==
// @name        FANDOM cleanup
// @description Remove all the garbage because this site is horrible
// @match       *://*.fandom.com/*
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

console.log("Making this site not horrible");
var bgStyle = document.head.appendChild(document.createElement("style"));
bgStyle.innerHTML = "body.background-dynamic.skin-oasis.background-fixed::after, body.background-dynamic.skin-oasis.background-fixed::before { display: none; }";
removeId("WikiaRail");
removeId("WikiaFooter");
removeClass("WikiaTopAds");
removeClass("wds-global-footer");
removeClass("aff-unit__wrapper");
document.getElementById("WikiaMainContent").style.width = "100%";

