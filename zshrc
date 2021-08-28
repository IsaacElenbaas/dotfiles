source ~/.profile

#{{{ plugins
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
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
	#}}}

	#{{{ completion
zstyle ":completion:*" completer _files _complete _ignored _correct
# case-insensitive matching
zstyle ":completion:*" matcher-list 'm:{a-z}={A-Z}'
# /h/i/dot<Tab> -> /home/isaacelenbaas/dotfiles
zstyle ":completion:*" list-suffixes zstyle ':completion:*' expand prefix suffix
setopt correct
CORRECT_IGNORE='[_|.]*'

autoload -Uz compinit && compinit
	#}}}

setopt autocd
setopt cdsilent
CDPATH=".:$HOME"
WORDCHARS=
unsetopt beep
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
alias CAPSLOCK='xdotool key Caps_Lock'
alias c='clear'
alias cp='cp -ri'
alias ctl='systemctl'
alias detach='[ -n "$STY" ] && screen -X -S "${STY%%.*}" detach'
alias dirsize='du -sh -- .'
alias fff='f'
alias fpg='ffmpeg'
alias fpr='ffprobe'
alias keysounds='systemctl --user restart osu-keysounds'
alias less='less -x2'
alias ln='ln -s'
alias ls='ls -hl --color=auto'
alias m='neomutt'
alias mkdir='mkdir -p'
alias mocp='mocp -T ~/dotfiles/mocp-theme 2>/dev/null'
alias mutt='neomutt'
alias mv='mv -i'
alias nokeysounds='systemctl --user stop osu-keysounds'
alias pa='yay'
alias ping='ping -c 5'
alias pm='pacman'
alias q='exit'
alias qq='exit'
alias rm='rm -d'
alias sc='sc || exit'
alias v='vim'

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
PROMPT="%{"$'\033[?7l'"%}%K{$promptbgs[1]}%F{$promptfgs[1]}"
for (( i = 1; i <= $#promptsections; i++ )); do
	PROMPT+="$promptsections[i]"
	PROMPT="${PROMPT//\%cb/$promptbgs[i]}"
	PROMPT="${PROMPT//\%cnb/$promptbgs[$((i+1))]}"
	PROMPT="${PROMPT//\%cnf/$promptfgs[$((i+1))]}"
done
PROMPT="%B${PROMPT}%b%u%s%f%k %{"$'\033[?7h'"%}"
OLDPROMPT="%{"$'\033[?7l'"%}%K{$oldpromptbgs[1]}%F{$oldpromptfgs[1]}"
for (( i = 1; i <= $#oldpromptsections; i++ )); do
	OLDPROMPT+="$oldpromptsections[i]"
	OLDPROMPT="${OLDPROMPT//\%cb/$oldpromptbgs[i]}"
	OLDPROMPT="${OLDPROMPT//\%cnb/$oldpromptbgs[$((i+1))]}"
	OLDPROMPT="${OLDPROMPT//\%cnf/$oldpromptfgs[$((i+1))]}"
done
OLDPROMPT="%B${OLDPROMPT}%b%u%s%f%k %{"$'\033[?7h'"%}"
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

	start="${1#${1%%[![:space:]]*}}"
	start="${start%%[[:space:]]*}"
	end="${1##*|}"
	end="${end#${end%%[![:space:]]*}}"
	end="${end%%[[:space:]]*}"

		#{{{ undistract-me
	case "$start" in
		"" | "bash" | "bluetoothctl" | "colorpicker" | "f" | "fff" | "m" | "man" | "mocp" | "mpv" | "mutt" | "sc" | "ssh" | "termdown" | "v" | "vim") starttime=0 ;;
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
		(notify-send "Process Finished"; paplay /usr/share/sounds/freedesktop/stereo/message.oga --volume=65536 &) &>/dev/null &&
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
	[ -n "${1%%[![:space:]]*}" ] && return 1
	start="${1%$'\n'}"
	start="${start#${start%%[![:space:]]*}}"
	start="${start%%[[:space:]]*}"
	case "$start" in
		"git") fc -p "$HOME/.zsh_git_history"; fc -P; return 2 ;;
		"bluetoothctl" | "cat" | "cd" | "chmod" | "chown" | "colorpicker" | "cp" | "curl" | "diff" | "f" | "ffmpeg" | "ffprobe" | "grep" | "herbstclient" | "kill" | "killall" | "less" | "ln" | "ls" | "man" | "mkdir" | "mocp" | "mpv" | "mv" | "powertop" | "ping" | "rm" | "scp" | "ssh" | "systemctl" | "tar" | "termdown" | "top" | "touch" | "unzip" | "wget" | "zip") return 2 ;;
		"cleanpkg" | "cleanpkgclean" | "cleanup" | "dim" | "hue" | "keyrepeat" | "mocp-only" | "monitorsoff" | "monitorson" | "nokeyrepeat" | "own" | "pauseafter" | "renumber" | "rmonitoroff" | "runtime" | "sc" | "tabletsetup" | "theme" | "wn" | "ytdlmusic") return 2 ;;
	esac
	for alias in "${(@k)aliases}"; do
		[ "$start" = "$alias" ] && return 2
	done
	return 0;
}
	#}}}
#}}}

#{{{ keybinds
# showkey -a
bindkey -e
# hundreths of a second
KEYTIMEOUT=1

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

#{{{ enter
_enter() {
	BUFFER="${BUFFER%${BUFFER##*[![:space:]]}}"

		#{{{ navi
	start="${BUFFER%%[![:space:]]*}"
	BUFFER="${BUFFER#${BUFFER%%[![:space:]]*}} "
	if [ "${BUFFER%%[[:space:]]*}" = "n" ] || [ "${BUFFER%%[[:space:]]*}" = "navi" ]; then
		navi="$(navi --print)"
		if [ -z "${navi%$'\n'}" ]; then
			[ -z "${BUFFER#*[[:space:]]}" ] && BUFFER="" || BUFFER="$start${BUFFER:0:-1}"
			return
		fi
		[ -z "${BUFFER#*[[:space:]]}" ] && start=" "
		BUFFER="$start${navi%$'\n'} ${BUFFER#*[[:space:]]}"
		BUFFER="${BUFFER%[[:space:]]}"
		starttime=$SECONDS
		zle accept-line
		return
	fi
	BUFFER="$start${BUFFER:0:-1}"
		#}}}

		#{{{ prompt to expand currently typing path on enter
	checkpath=$LBUFFER
	[[ "$RBUFFER" =~ ^([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])* ]] && checkpath="$checkpath$MATCH"
	if [[ "$checkpath" =~ ([^[:space:]\/\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*\/([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]]; then
		[[ -a $(eval printf $(printf '%q' "$MATCH" | sed -E 's/((^|[^\\])(\\\\)*)\\{3} /\1\\ /g' | sed -E 's/((^|[^\\])(\\\\)*)\\~/\1~/' | sed -E 's/((^|[^\\])(\\\\)*)\\{3}\(/\1\\(/g' | sed -E 's/((^|[^\\])(\\\\)*)\\{3}\)/\1\\)/g')) ]] && { zle accept-line; return; }
		OLDBUF=$BUFFER
		zle complete-word _files
		# select first if multiple matches
		while [[ "${LBUFFER%${LBUFFER##*[![:space:]]}}" =~ ([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]] && [[ ! -a $(eval printf $(printf '%q' "$MATCH" | sed -E 's/((^|[^\\])(\\\\)*)\\{3} /\1\\ /g' | sed -E 's/^\\~/~/')) ]]; do
			zle complete-word _files
			[ "$BUFFER" = "$LASTBUF" ] && break || LASTBUF=$BUFFER
		done
		if [ "$BUFFER" != "$OLDBUF" ]; then
			# save expansion
			[[ "${LBUFFER%${LBUFFER##*[![:space:]]}}" =~ ([^[:space:]\\\;\$\`\&\|\<\>\!\'\"]|\\\\[^\\])*$ ]]
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
		#}}}

	zle accept-line
}
zle -N _enter
bindkey "^M" _enter
#}}}

	#{{{ autocommands
		#{{{ f
_autocommand-f() {
	if [ "$LBUFFER" = "f" ] && [ -z "$RBUFFER" ]; then
		BUFFER=" fff"
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N _autocommand-f
bindkey "f" _autocommand-f
bindkey -sM isearch "f" "\026f"
		#}}}

		#{{{ l
_autocommand-l() {
	if [ "$LBUFFER" = "l" ] && [ -z "$RBUFFER" ]; then
		BUFFER=" ls"
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N _autocommand-l
bindkey "l" _autocommand-l
bindkey -sM isearch "l" "\026l"
		#}}}

		#{{{ n
_autocommand-n() {
	if [ "$LBUFFER" = "n" ] && [ -z "$RBUFFER" ]; then
		navi="$(navi --print)"
		[ -z "${navi%$'\n'}" ] && { BUFFER=""; return; }
		BUFFER=" $navi"
		zle accept-line
	else
		zle self-insert
	fi
}
zle -N _autocommand-n
bindkey "n" _autocommand-n
bindkey -sM isearch "n" "\026n"
		#}}}
	#}}}

bindkey -s "^[" ""
bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search
#}}}

# auto save screen layouts
# doesn't trigger in vim terminal, equivalent function in vimrc
[ -z "$VIM_TERMINAL" ] && [ -n "$STY" ] && [ "$(ps -o etimes= -p "$PPID")" -le 1 ] && screen -X -S "${STY%%.*}" eval "layout new \"s${STY%%.*}\"" "next" && VIM_TERMINAL=-1
export SHELL="/usr/bin/zsh"
