#{{{ settings
	#{{{ history
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt sharehistory
setopt appendhistory
setopt hist_ignore_dups
setopt hist_reduce_blanks
	#}}}

	#{{{ completion
zstyle ':completion:*' completer _complete _ignored _correct
# case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# /h/i/do<Tab> -> /home/isaacelenbaas/Downloads
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

autoload -Uz compinit && compinit
	#}}}

setopt autocd
setopt correct
unsetopt beep
bindkey -e
#}}}

#{{{ functions
	#{{{ f
f() {
	\fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null)"
	rm "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null
}
	#}}}
#}}}

#{{{ aliases
alias c='clear'
alias dirsize='du -sh -- .'
alias fff='f'
alias less='less -x2'
alias ln='ln -s'
alias ls='ls -hlA --color=auto'
alias m='neomutt'
alias mocp='mocp -T /home/isaacelenbaas/dotfiles/mocp-theme 2>/dev/null'
alias mutt='neomutt'
alias pa='pacaur'
alias ping='ping -c 5'
alias pm='sudo pacman'
alias q='exit'
alias rm='rm -d'
alias v='vim'
alias vi='vim'

	#{{{ files
alias -s mkv="mpv"
alias -s mp3="mpv"
alias -s mp4="mpv"
alias -s mpeg="mpv"
alias -s ogg="mpv"
	#}}}
#}}}

#{{{ PROMPT
# there's PROMPT stuff in preexec too
# http://www.nparikh.org/unix/prompt.php#zsh
NEWLINE=$'\n'
c="%b%F{%c2}%K{%c3}%B"
fgs=(
	"black"
	"255"
	""
	"255"
)
bgs=( # needs extra 0 at end for final carat bg
	"15"
	"32"
	"0"
	"32"
	"0"
)
# c1 is fg c2 is bg c3 is next bg for carats
sections=(
	" %n ${c}"
	" %~ ${c}"
	"${NEWLINE}"
	" %(!.#.$) ${c}"
)
PROMPT=""
for ((i = 1; i <= $#sections; i++)); do
	PROMPT+="%F{%c1}%K{%c2}$sections[i]"
	PROMPT="${PROMPT//\%c1/$fgs[i]}"
	PROMPT="${PROMPT//\%c2/$bgs[i]}"
	PROMPT="${PROMPT//\%c3/$bgs[$((i+1))]}"
done
PROMPT="%B${PROMPT}%f%k%b "
#}}}

#{{{ preexec
preexec() {
	#{{{ PROMPT
	printf "\033[2A\033[2K"
	# middle bit is last line of final prompt with %(!.#.$) swapped for %1~
	print -P "%B""%F{255}%K{32} %1~ %b%F{32}%K{0}%B%f%k%b"" $1"
	# print moved us down a line
	printf "\033[2K"
	#}}}

	#{{{ undistract-me
	start="${1%% *}"
	end="${1##*|}"
	end="${end#* }"
	case "${start#\\}" in
		"vim" | "fff" | "mocp") starttime=0 ;;
		*)
			case "${end%% *}" in
				"less") starttime=0 ;;
				*) starttime=$SECONDS ;;
			esac
		;;
	esac
	#}}}
}
#}}}

#{{{ precmd
precmd() {
#{{{ undistract-me
	((starttime > 0 && SECONDS-starttime >= 10)) &&
		(paplay /usr/share/sounds/freedesktop/stereo/message.oga &) &>/dev/null &&
		printf "$((SECONDS-starttime))s\n"
#}}}
}
#}}}

#{{{ keybinds
# showkey -a
	#{{{ broken keys/key combos
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
	#}}}

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
#}}}
