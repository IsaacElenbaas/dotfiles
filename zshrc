#{{{ plugins
source ${ZDOTDIR:-${HOME}/.zsh}/plugins/sudo.plugin.zsh

	#{{{ You Should Use
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
export YSU_MESSAGE_POSITION="after"
# display all aliases
export YSU_MODE=ALL
# force use of aliases
export YSU_HARDCORE=1
	#}}}
#}}}

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
alias detach="[ -n "$STY" ] && screen -X -S "${STY%%.*}" detach"
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
alias pm='pacman'
alias q='exit'
alias rm='rm -d'
alias v='vim'

	#{{{ files
alias -s mkv="mpv"
alias -s mp3="mpv"
alias -s mp4="mpv"
alias -s mpeg="mpv"
alias -s ogg="mpv"
	#}}}
#}}}

#{{{ PROMPT
# allows functions in PROMPT
setopt prompt_subst
# there's PROMPT stuff in preexec too
# http://www.nparikh.org/unix/prompt.php#zsh
NEWLINE=$'\n'
readonly c="%b%F{%c2}%K{%c3}%B"
fgs=(
	"black"
	"255"
	"255"
	""
	"255"
)
bgs=( # needs extra 0 at end for final carat bg
	"15"
	"32"
	"\$([ -d .git ] && printf '34' || printf '0')"
	"0"
	"32"
	"0"
)
# c1 is fg c2 is bg c3 is next bg for carats
#{{{ functions
prompt-git() {
	if [ -d .git ]; then
		c2="${c//\%c2/$1}"
		c2="${c2//\%c3/$2}"
		printf "  $(git rev-parse --abbrev-ref HEAD) ${c2//\%/%%}"
	else
		printf ""
	fi
}
#}}}
sections=(
	" %n ${c}"
	" %~ ${c}"
	"\$(prompt-git %c2 %c3)"
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
	0="${1//\\/\\\\\\\\}"
	0="${0//\\n/\\\\n}"
	0="${0//\$/\\\\$}"
	0="${0//\`/\\\\\`}"
	0="${0//\%/%%}"
	# middle bit is last line of final prompt with %(!.#.$) swapped for %1~
	print -P -- "%B""%F{255}%K{32} %1~ %b%F{32}%K{0}%B%f%k%b"" $0"
	# print moved us down a line
	printf "\033[2K"
	#}}}

	start="$(printf -- "$0" | sed 's/^\s*//')"
	start="${start%% *}"
	end="${0##*|}"
	end="$(printf -- "$end" | sed 's/^\s*//')"
	end="${end%% *}"

	#{{{ undistract-me
	case "${start#\\}" in
		"bash" | "v" | "vim" | "f" | "fff" | "mocp" | "man" | "colorpicker" | "bluetoothctl") starttime=0 ;;
		*)
			case "${end%% *}" in
				"less") starttime=0 ;;
				*) starttime=$SECONDS ;;
			esac
		;;
	esac
	#}}}

	# screen automatic window title
	[ -n "$STY" ] && printf -- $'\ek%s\e\\' "$start"
}
#}}}

#{{{ precmd
precmd() {
	# undistract-me
	((starttime > 0 && SECONDS-starttime >= 10)) &&
		(paplay /usr/share/sounds/freedesktop/stereo/message.oga &) &>/dev/null &&
		printf "$((SECONDS-starttime))s\n"
}
#}}}

#{{{ chpwd
chpwd() {
	# open new screen windows in last dir
	if [ -n "$STY" ]; then
		[ -z "$cd" ] && cd=1 && screen -X -S "${STY%%.*}" chdir "$PWD" || unset cd
	fi
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
