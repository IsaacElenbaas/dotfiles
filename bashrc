# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export VISUAL='editor'
export EDITOR=$VISUAL
# http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='no=00:fi=00:di=01;32:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;35:*.cmd=01;35:*.exe=01;35:*.com=01;35:*.btm=01;35:*.bat=01;35:*.sh=01;35:*.csh=01;35:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:'
export PROMPT_COMMAND="$([ -n "$PROMPT_COMMAND" ] && printf "%s" "$PROMPT_COMMAND;")tput cnorm" # vim can't handle guis run in it run in a screen lol https://groups.google.com/forum/#!topic/vim_dev/HhczoxAdcWE
export HISTCONTROL="ignorespace"

f() {
	\fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null)"
	rm "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null
}
export -f f

alias c='clear'
alias cp='cp -ri'
alias CAPSLOCK='xdotool key Caps_Lock'
alias dirsize='du -sh -- .'
alias fff='f'
alias less='less -x2'
alias ln='ln -s'
alias ls='ls -hl --color=auto'
alias m='neomutt'
alias mkdir='mkdir -p'
alias mocp='mocp -T ~/dotfiles/mocp-theme 2>/dev/null'
alias mutt='neomutt'
alias mv='mv -i'
alias pa='pacaur'
alias ping='ping -c 5'
alias pm='sudo pacman'
alias sc='sc || exit'
alias q='exit'
alias qq='exit'
alias rm='rm -d'
alias v='vim'
alias vi='vim'

#{{{ mocp
alias mocp-add='mocp --append'
alias mocp-celeste='mocp-only "~/Music/Celeste"'
alias mocp-crashlands='mocp-only "~/Music/Crashlands"'
alias mocp-default='mocp-only "~/Music/Default"'
alias mocp-hk='mocp-only "~/Music/Hollow Knight"'
alias mocp-httyd='mocp-only "~/Music/HTTYD"'
alias mocp-httyd1='mocp-only "~/Music/HTTYD/1"'
alias mocp-httyd2='mocp-only "~/Music/HTTYD/2"'
alias mocp-httyd3='mocp-only "~/Music/HTTYD/3"'
alias mocp-maquia='mocp-only "~/Music/Maquia"'
alias mocp-opus='mocp-only "~/Music/Opus Magnum"'
alias mocp-ori='mocp-only "~/Music/Ori"'
alias mocp-ori-bf='mocp-only "~/Music/Ori/BF Original" "~/Music/Ori/BF Additional"'
alias mocp-ori-wotw='mocp-only "~/Music/Ori/WotW"'
alias mocp-poly='mocp-only "~/Music/Poly Bridge"'
alias mocp-poly1='mocp-only "~/Music/Poly Bridge/1"'
alias mocp-poly2='mocp-only "~/Music/Poly Bridge/2"'
#}}}

shopt -s autocd
