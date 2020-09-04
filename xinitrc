#!/bin/bash

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset s off -dpms
while
	xset r rate 150
	# xmodmap -pke
	xset -r 10 # 1
	xset -r 11 # 2
	xset -r 12 # 3
	xset -r 13 # 4
	xset -r 14 # 5
	xset -r 15 # 6
	xset -r 16 # 7
	xset -r 17 # 8
	xset -r 18 # 9
	xset -r 19 # 0
	xset -r 21 # =
	xset -r 34 # {
	xset -r 35 # }
	xset -r 49 # `
	xset -r 59 # ,
	xset -r 60 # .
	xset -r 65 # space
	inotifywait -q -e create -e delete /dev/input
do sleep 1; done &
xbindkeys &
tabletsetup
\mocp --server >/dev/null
\mocp --on shuffle --append /home/isaacelenbaas/Music/Default

exec herbstluftwm --locked

#twm &
#xclock -geometry 50x50-1+1 &
#xterm -geometry 80x50+494+51 &
#xterm -geometry 80x20+494-0 &
#exec xterm -geometry 80x66+0+0 -name login
