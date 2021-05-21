#!/bin/bash

[ ! -e /sys/class/power_supply/BAT0 ] && { xrandr --setprovideroutputsource modesetting NVIDIA-0; xset s off -dpms; }
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

keyrepeat # X resets them
{ [ -e /sys/class/power_supply/BAT0 ] && printf "power off\nexit" || printf "power on\nexit"; } | bluetoothctl
tabletsetup

xbindkeys
unclutter -idle 2 -root &
dunst &

exec herbstluftwm --locked
