// ==UserScript==
// @name        youtube-playlist-randomizer
// @description Browser end of my osumer script for Linux
// @match       *://osu.ppy.sh/beatmapsets/*
// @grant       none
// ==/UserScript==

if(!window.location.toString().includes("download"))
	window.location.replace(window.location.toString().match('.*osu\.ppy\.sh/beatmapsets/[0-9]*') + '/download?noVideo=1');

