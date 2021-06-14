source ~/.profile

#{{{ plugins
source ${ZDOTDIR:-$HOME/.zsh}/plugins/sudo.plugin.zsh
source ${ZDOTDIR:-$HOME/.zsh}/plugins/manydots.plugin.zsh

	#{{{ You Should Use
source ${ZDOTDIR:-$HOME/.zsh}/plugins/you-should-use.plugin.zsh
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
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
	#}}}

	#{{{ completion
zstyle ':completion:*' completer _files _complete _ignored _correct
# case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# /h/i/dot<Tab> -> /home/isaacelenbaas/dotfiles
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

autoload -Uz compinit && compinit
	#}}}

setopt autocd
setopt correct
CORRECT_IGNORE='[_|.]*'
unsetopt beep
bindkey -e
#}}}

#{{{ functions
	#{{{ f
f() {
	\fff "$@"
	cd "$(cat "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null)"
	rm "${XDG_CACHE_HOME:=$HOME/.cache}/fff/.fff_d" 2>/dev/null
}
	#}}}

	#{{{ Paste
Paste() { printf '\033]51;["call","Tapi_sc",[]]\007' }
Nopaste() { printf '\033]51;["call","Tapi_scEnd",[]]\007' }
	#}}}
#}}}

#{{{ aliases
alias sudo='sudo '
alias c='clear'
alias cp='cp -ri'
alias CAPSLOCK='xdotool key Caps_Lock'
alias detach='[ -n "$STY" ] && screen -X -S "${STY%%.*}" detach'
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
alias pm='pacman'
alias sc='sc || exit'
alias q='exit'
alias qq='exit'
alias rm='rm -d'
alias v='vim'

	#{{{ files
alias -s mkv='mpv'
alias -s mp3='mpv'
alias -s mp4='mpv'
alias -s mpeg='mpv'
alias -s ogg='mpv'
	#}}}
#}}}

#{{{ PROMPT
# allows functions in PROMPT
setopt prompt_subst
# OLDPROMPT stuff is in preexec
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
c="%F{%cb}%K{%cnb}%F{%cnf}"
nl=$'\n'"%K{%cnb}%F{%cnf}"
nlb="}%k%{%"

	#{{{ prompt functions
prompt-git() {
	git rev-parse --is-inside-work-tree &>/dev/null && {
		c2="${c//\%cb/$1}"
		c2="${c2//\%cnb/$2}"
		c2="${c2//\%cnf/$3}"
		printf "  %s %s" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" "$c2"
	}
}
	#}}}

	#{{{ PROMPT definition
promptfgs=(
	"black"
	"255"
	"255"
	""
	"255"
	""
)
promptbgs=(
	"15"
	"32"
	"\$(git rev-parse --is-inside-work-tree &>/dev/null && printf '34' || printf '%s' '$nlb')"
	"$nlb"
	"32"
	"$nlb"
)
promptsections=(
	" %n$([ "$USER" != "isaacelenbaas" ] && printf "%s" "@%M") $c"
	" %~ $c"
	"\$(prompt-git %cb %cnb %cnf)"
	"$nl"
	" %(!.#.$) $c"
)
	#}}}

nl=$'\n'"\033[K${nl:1}"

	#{{{ OLDPROMPT definition
oldpromptfgs=(
	"black"
	"255"
	""
)
oldpromptbgs=(
	"15"
	"32"
	"$nlb"
)
oldpromptsections=(
	" \$(date +'%I:%M') $c"
	" %~ $c"
)
	#}}}

	#{{{ PROMPT and OLDPROMPT generation
PROMPT="%K{$promptbgs[1]}%F{$promptfgs[1]}"
for (( i = 1; i <= $#promptsections; i++ )); do
	PROMPT+="$promptsections[i]"
	PROMPT="${PROMPT//\%cb/$promptbgs[i]}"
	PROMPT="${PROMPT//\%cnb/$promptbgs[$((i+1))]}"
	PROMPT="${PROMPT//\%cnf/$promptfgs[$((i+1))]}"
done
PROMPT="%B${PROMPT}%b%u%s%f%k "
OLDPROMPT="%K{$oldpromptbgs[1]}%F{$oldpromptfgs[1]}"
for (( i = 1; i <= $#oldpromptsections; i++ )); do
	OLDPROMPT+="$oldpromptsections[i]"
	OLDPROMPT="${OLDPROMPT//\%cb/$oldpromptbgs[i]}"
	OLDPROMPT="${OLDPROMPT//\%cnb/$oldpromptbgs[$((i+1))]}"
	OLDPROMPT="${OLDPROMPT//\%cnf/$oldpromptfgs[$((i+1))]}"
done
OLDPROMPT="%B${OLDPROMPT}%b%u%s%f%k "
	#}}}
#}}}

#{{{ zsh hooks
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
	#{{{ preexec
preexec() {
		#{{{ OLDPROMPT
	plines=$(printf "%b" "$PROMPT\n" | wc -l)
	for (( i = 1; i <= $plines; i++ )); do
		printf "\033[A\033[K"
	done
	print -nP -- "$OLDPROMPT"
	printf "%s\n" "$1"
		#}}}

	start="$(printf "%s" "$1" | sed 's/^\s*//')"
	start="${start%% *}"
	end="${1##*|}"
	end="$(printf "%s" "$end" | sed 's/^\s*//')"
	end="${end%% *}"

		#{{{ undistract-me
	case "$start" in
		"bash" | "sc" | "v" | "vim" | "f" | "fff" | "mocp" | "m" | "mutt" | "man" | "colorpicker" | "bluetoothctl") starttime=0 ;;
		*)
			case "${end%% *}" in
				"less") starttime=0 ;;
				*) starttime=$SECONDS ;;
			esac
		;;
	esac
		#}}}

	# screen automatic window title
	if [ -n "$STY" ]; then
		[ "$VIM_TERMINAL" -eq -1 ] && printf '\033k%s\033\\' "$start" || ( start="${start//\%/%%}"; printf '\033]51;["call","Tapi_rename",["'"${start//\"/\\\"}"'"]]\007' )
	fi
}
	#}}}

	#{{{ precmd
precmd() {
	# undistract-me
	((starttime > 0 && SECONDS-starttime > 10)) &&
		(notify-send "Process Finished"; paplay /usr/share/sounds/freedesktop/stereo/message.oga &) &>/dev/null &&
		printf "$((SECONDS-starttime))s\n"
	tput cnorm # vim can't handle guis run in it run in a screen lol https://groups.google.com/forum/#!topic/vim_dev/HhczoxAdcWE
}
	#}}}

	#{{{ chpwd
chpwd() {
	# open new screen windows in last dir
	if [ -n "$STY" ]; then
		screen -X -S "${STY%%.*}" chdir "$PWD"
	fi
}
	#}}}

	#{{{ zshaddhistory
zshaddhistory() {
	case "$(printf "%s" "$1" | sed 's/^\s*//')" in
		"q" | "exit" | "detach") return 1 ;;
	esac
	return 0;
}
	#}}}
#}}}

#{{{ keybinds
# showkey -a
KEYTIMEOUT=99999

	#{{{ broken keys/key combos
bindkey "^[OH"    beginning-of-line
bindkey "^[[1~"   beginning-of-line
bindkey "^[[7~"   beginning-of-line
bindkey "^[OF"    end-of-line
bindkey "^[[4~"   end-of-line
bindkey "^[[8~"   end-of-line
bindkey "^[[1;5C" forward-word
bindkey "^[OC"    forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[OD"    forward-word
	#}}}

	#{{{ spaces in enclosing characters
snip_space() {
	if ([ "${LBUFFER: -1}" = "(" ] && [ "${RBUFFER:0:1}" = ")" ]) ||
	   ([ "${LBUFFER: -1}" = "[" ] && [ "${RBUFFER:0:1}" = "]" ]) ||
	   ([ "${LBUFFER: -1}" = "{" ] && [ "${RBUFFER:0:1}" = "}" ]) ||
	then
		LBUFFER="$LBUFFER " && RBUFFER=" $RBUFFER"
	elif [ "${LBUFFER: -2}" = " +" ] && ([ "${RBUFFER:0:1}" = '"' ] || [ "${RBUFFER:0:1}" = "'" ]); then
		LBUFFER="${LBUFFER:0:-2}${RBUFFER:0:1} + " && RBUFFER="${RBUFFER:1}"
	else
		LBUFFER="$LBUFFER "
	fi
}
zle -N snip_space
bindkey " " snip_space
	#}}}

	#{{{ vim terminal
		#{{{ cutting/deleting
_trash() {
	BUFFER=
}
_delete() {
	BUFFER="${BUFFER//\\/\\\\\\\\}"
	BUFFER="${BUFFER//\%/%%}"
	BUFFER="${BUFFER//\"/\\\\\"}"
	printf '\033]51;["call","Tapi_yank",["'"$BUFFER"'"]]\007'
	_trash
}
zle -N _trash
bindkey "^Ux" _trash
zle -N _delete
bindkey "^Ud" _delete
bindkey "^Ut" push-line
		#}}}
	#}}}

	#{{{ prompt to expand currently typing path on enter
_enter() {
	checkpath=$LBUFFER
	[[ "$RBUFFER" =~ ^([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])* ]] && checkpath="$checkpath$MATCH"
	if [[ "$checkpath" =~ ([^[:space:]\/\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*\/([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]]; then
		[[ -a $(eval printf $(printf '%q' "$MATCH" | sed -E 's/((^|[^\\])(\\\\)*)\\{3} /\1\\ /g' | sed -E 's/((^|[^\\])(\\\\)*)\\~/\1~/' | sed -E 's/((^|[^\\])(\\\\)*)\\{3}\(/\1\\(/g' | sed -E 's/((^|[^\\])(\\\\)*)\\{3}\)/\1\\)/g')) ]] && { zle accept-line; return; }
		OLDBUF=$BUFFER
		zle complete-word _files
		# select first if multiple matches
		while [[ "${LBUFFER%% }" =~ ([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]] && [[ ! -a $(eval printf $(printf '%q' "$MATCH" | sed -E 's/((^|[^\\])(\\\\)*)\\{3} /\1\\ /g' | sed -E 's/^\\~/~/')) ]]; do
			zle complete-word _files
			[ "$BUFFER" = "$LASTBUF" ] && break || LASTBUF=$BUFFER
		done
		if [ "$BUFFER" != "$OLDBUF" ]; then
			# save expansion
			[[ "${LBUFFER%% }" =~ ([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]]
			printf "\nzsh: expand to '$MATCH' [nye]? "
			while true; do
				read -rs -k 1 key || { BUFFER=$OLDBUF; break; }
				# remove garbage from arrows and such
				read -rs -k 99 -t 0.05 key2
				[[ "$key" == "y" || "$key" == $'\n' || "$key" == "" ]] && break
				[ "$key" = "n" ] && { BUFFER=$OLDBUF; break; }
				[ "$key" = "e" ] && { BUFFER=$OLDBUF; printf "\033[$(wc -l <<< \"$PROMPT\")A"; zle reset-prompt; return; }
				printf "\r\033[Kzsh: expand to '$MATCH' [nye]? "
			done
		fi
	fi
	zle accept-line
}
zle -N _enter
bindkey "^M" _enter
	#}}}

bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search
#}}}

# auto save screen layouts
# doesn't trigger in vim terminal, equivalent method in vimrc
[ -z "$VIM_TERMINAL" ] && [ -n "$STY" ] && [ "$(ps -o etimes= -p "$PPID")" -le 1 ] && screen -X -S "${STY%%.*}" eval "layout new \"s${STY%%.*}\"" "next" && VIM_TERMINAL=-1
export SHELL="/usr/bin/zsh"
