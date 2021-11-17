#!/bin/bash

[ ! -d /sys/class/power_supply/BAT0 ] && { xrandr --setprovideroutputsource modesetting NVIDIA-0; xset s off -dpms; }
xrandr --auto

# merge in defaults
[ -f $sysresources ] && xrdb -merge /etc/X11/xinit/.Xresources
[ -f "$userresources" ] && xrdb -merge ~/.Xresources

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && source "$f"
	done
	unset f
fi

# restarting and not enabling because with my laptop I often restart X to turn on/off GPU
# these ignore xpra and run on DISPLAY
[ -f "$HOME/.config/systemd/user/keyrepeat.service" ] && systemctl --user restart keyrepeat
[ -f "$HOME/.config/systemd/user/mocp.service" ]      && systemctl --user restart mocp
if modprobe --dry-run --first-time nvidia &>/dev/null; then
	systemctl --user stop osu-keysounds
	systemctl --user stop steam
else
	[ -f "$HOME/.config/systemd/user/osu-keysounds.service" ] && systemctl --user restart osu-keysounds
	[ -f "$HOME/.config/systemd/user/steam.service" ]         && systemctl --user restart steam
fi
[ -f "$HOME/.config/systemd/user/xbindkeys.service" ] && systemctl --user restart xbindkeys
#[ -f "$HOME/.config/systemd/user/vnc.service" ]       && systemctl --user restart vnc
[ -f /usr/lib/systemd/user/dunst.service ]            && systemctl --user restart dunst

{ [ -d /sys/class/power_supply/BAT0 ] && printf "power off\nexit" || printf "power on\nexit"; } | bluetoothctl

systemctl is-active --user --quiet xpra-server && export XPRA_DISPLAY=":10" && systemctl --user restart xpra-client
unclutter -idle 2 -root &
exec herbstluftwm --locked
