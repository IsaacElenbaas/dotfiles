# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export VISUAL='editor'
export EDITOR=$VISUAL
# http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='no=00:fi=00:di=01;32:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;35:*.cmd=01;35:*.exe=01;35:*.com=01;35:*.btm=01;35:*.bat=01;35:*.sh=01;35:*.csh=01;35:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:'
export PROMPT_COMMAND="$([ -n "$PROMPT_COMMAND" ] && printf "%s" "$PROMPT_COMMAND;")tput cnorm" # vim can't handle guis run in it run in a screen lol https://groups.google.com/forum/#!topic/vim_dev/HhczoxAdcWE
export HISTCONTROL="ignorespace"
CDPATH=".:$HOME"

f() {
	\fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null)"
	rm "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null
}
export -f f

alias CAPSLOCK='xdotool key Caps_Lock'
alias c='clear'
alias cp='cp -ri'
alias ctl='systemctl'
alias dirsize='du -sh -- .'
alias fff='f'
alias fpg='ffmpeg'
alias fpr='ffprobe'
alias keysounds='systemctl --user restart osu-keysounds'
alias lapkeys='xinput enable "AT Translated Set 2 keyboard"; nokeyrepeat; { sudo tee /sys/class/leds/*::kbd_backlight/color <<< "2288ff" && sudo tee /sys/class/leds/*::kbd_backlight/brightness <<< "$(($(cat /sys/class/leds/*::kbd_backlight/max_brightness)*2/5))"; } > /dev/null'
alias less='less -x2'
alias ln='ln -s'
alias ls='ls -hl --color=auto'
alias m='neomutt'
alias mkdir='mkdir -p'
alias mocp='mocp -T ~/dotfiles/mocp-theme 2>/dev/null'
alias mutt='neomutt'
alias mv='mv -i'
alias nokeysounds='systemctl --user stop osu-keysounds'
alias nolapkeys='xinput disable "AT Translated Set 2 keyboard"; sudo tee /sys/class/leds/*::kbd_backlight/brightness <<< "0" > /dev/null'
alias noxpra='export DISPLAY="${REAL_DISPLAY:-"$DISPLAY"}";'
alias pa='yay'
alias ping='ping -c 5'
alias pm='sudo pacman'
alias q='exit'
alias qq='exit'
alias rm='rm -d'
alias sc='sc || exit'
alias stopx='rm -f /tmp/xpra-restartx && \stopx; exit'
alias switchx='touch /tmp/xpra-restartx && \stopx; exit'
alias v='vim'
alias vi='vim'

#{{{ mocp
alias mocp-add='mocp --append'
alias mocp-ash='mocp-only "$HOME/Music/A Short Hike"'
alias mocp-celeste='mocp-only "$HOME/Music/Celeste"'
alias mocp-crashlands='mocp-only "$HOME/Music/Crashlands"'
alias mocp-default='mocp-only "$HOME/Music/Default"'
alias mocp-hk='mocp-only "$HOME/Music/Hollow Knight"'
alias mocp-httyd1='mocp-only "$HOME/Music/HTTYD/1"'
alias mocp-httyd2='mocp-only "$HOME/Music/HTTYD/2"'
alias mocp-httyd3='mocp-only "$HOME/Music/HTTYD/3"'
alias mocp-httyd='mocp-only "$HOME/Music/HTTYD"'
alias mocp-maquia='mocp-only "$HOME/Music/Maquia"'
alias mocp-opus='mocp-only "$HOME/Music/Opus Magnum"'
alias mocp-ori-bf='mocp-only "$HOME/Music/Ori/BF Original" "$HOME/Music/Ori/BF Additional"'
alias mocp-ori-wotw='mocp-only "$HOME/Music/Ori/WotW"'
alias mocp-ori='mocp-only "$HOME/Music/Ori"'
alias mocp-poly1='mocp-only "$HOME/Music/Poly Bridge/1"'
alias mocp-poly2='mocp-only "$HOME/Music/Poly Bridge/2"'
alias mocp-poly='mocp-only "$HOME/Music/Poly Bridge"'
alias mocp-ror1='mocp-only "$HOME/Music/Risk of Rain/1"'
alias mocp-ror2='mocp-only "$HOME/Music/Risk of Rain/2"'
alias mocp-ror='mocp-only "$HOME/Music/Risk of Rain"'
#}}}

shopt -s autocd
