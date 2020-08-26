#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export VISUAL='editor'
export EDITOR=$VISUAL
# http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='no=00:fi=00:di=01;32:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;35:*.cmd=01;35:*.exe=01;35:*.com=01;35:*.btm=01;35:*.bat=01;35:*.sh=01;35:*.csh=01;35:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:'

f() {
	\fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null)"
	rm "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null
}
export -f f

alias fff='f'
alias less='less -x2'
alias ls='ls -hlA --color=auto'
alias rm='rm -d'
alias pm='sudo pacman'
alias pa='pacaur'
alias c='clear'
alias q='exit'
alias v='vim'
alias vi='vim'
alias mutt='neomutt'
alias m='neomutt'
alias mocp='mocp -T /home/isaacelenbaas/dotfiles/mocp-theme 2>/dev/null'
alias ln='ln -s'
alias ping='ping -c 5'
alias dirsize='du -sh -- .'
shopt -s autocd
PS1='[\u@\h \W]\$ '

