#!/bin/bash

[ ! -d /sys/class/power_supply/BAT0 ] && { xrandr --setprovideroutputsource modesetting NVIDIA-0; xset s off -dpms; }
xrandr --auto

# merge in defaults and keymaps
sysresources=/etc/X11/xinit/.Xresources
[ -f $sysresources ] && xrdb -merge $sysresources
sysmodmap=/etc/X11/xinit/.Xmodmap
[ -f $sysmodmap ] && xmodmap $sysmodmap
userresources=$HOME/.Xresources
[ -f "$userresources" ] && xrdb -merge "$userresources"
usermodmap=$HOME/.Xmodmap
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && source "$f"
	done
	unset f
fi

# restarting and not enabling because with my laptop I often restart X to turn on/off GPU
[ -f "$HOME/.config/systemd/user/keyrepeat.service" ]     && systemctl --user restart keyrepeat
[ -f "$HOME/.config/systemd/user/mocp.service" ]          && systemctl --user restart mocp
[ -f "$HOME/.config/systemd/user/osu-keysounds.service" ] && systemctl --user restart osu-keysounds
[ -f "$HOME/.config/systemd/user/steam.service" ]         && systemctl --user restart steam
[ -f "$HOME/.config/systemd/user/vnc.service" ]           && systemctl --user restart vnc
[ -f /usr/lib/systemd/user/dunst.service ]                && systemctl --user restart dunst

{ [ -d /sys/class/power_supply/BAT0 ] && printf "power off\nexit" || printf "power on\nexit"; } | bluetoothctl

xbindkeys
unclutter -idle 2 -root &

exec herbstluftwm --locked
