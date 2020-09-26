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
alias sc='sc || exit'
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

#{{{ zsh hooks
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
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

	# 0 is safe for printf by now
	start="$(printf -- "$0" | sed 's/^\s*//')"
	start="${start%% *}"
	start="${start#\\}"
	end="${0##*|}"
	end="$(printf -- "$end" | sed 's/^\s*//')"
	end="${end%% *}"

		#{{{ undistract-me
	case "$start" in
		"bash" | "sc" | "v" | "vim" | "f" | "fff" | "mocp" | "man" | "colorpicker" | "bluetoothctl") starttime=0 ;;
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

	#{{{ zshaddhistory
zshaddhistory() {
	0="${1//\\/\\\\\\\\}"
	0="${0//\\n/\\\\n}"
	0="${0//\$/\\\\$}"
	0="${0//\`/\\\\\`}"
	0="${0//\%/%%}"
	start="$(printf -- "$0" | sed 's/^\s*//')"
	start="${start%% *}"
	start="${start#\\}"
	case "$start" in
		"q" | "exit" | "detach") return 1 ;;
	esac
	return 0;
}
	#}}}
#}}}

#{{{ keybinds
# showkey -a
	#{{{ broken keys/key combos
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
	#}}}

	#{{{ enclosing characters
		#{{{ parentheses
			#{{{ ()
snip_parens() {
	LBUFFER="${LBUFFER}("
	RBUFFER=")${RBUFFER}"
}
zle -N snip_parens
bindkey '()' snip_parens
			#}}}
			#{{{ ();
snip_parens-semi() {
	LBUFFER="${LBUFFER}();"
}
zle -N snip_parens-semi
bindkey '();' snip_parens-semi
			#}}}
			#{{{ ().
snip_parens-dot() {
	LBUFFER="${LBUFFER}()."
}
zle -N snip_parens-dot
bindkey '().' snip_parens-dot
			#}}}
			#{{{ (),
snip_parens-comma() {
	LBUFFER="${LBUFFER}(),"
}
zle -N snip_parens-comma
bindkey '(),' snip_parens-comma
			#}}}
			#{{{ ():
snip_parens-colon() {
	LBUFFER="${LBUFFER}():"
}
zle -N snip_parens-colon
bindkey '():' snip_parens-colon
			#}}}
			#{{{ ()<Space>
snip_parens-space() {
	LBUFFER="${LBUFFER}() "
}
zle -N snip_parens-space
bindkey '() ' snip_parens-space
			#}}}
			#{{{ ()<CR>
snip_parens-cr() {
	LBUFFER="${LBUFFER}()"
	zle accept-line
}
zle -N snip_parens-cr
bindkey '()^M' snip_parens-cr
			#}}}
		#}}}
		#{{{ brackets
			#{{{ []
snip_brackets() {
	LBUFFER="${LBUFFER}["
	RBUFFER="]${RBUFFER}"
}
zle -N snip_brackets
bindkey '[]' snip_brackets
			#}}}
			#{{{ [],
snip_brackets-comma() {
	LBUFFER="${LBUFFER}[],"
}
zle -N snip_brackets-comma
bindkey '[],' snip_brackets-comma
			#}}}
			#{{{ []<Space>
snip_brackets-space() {
	LBUFFER="${LBUFFER}[] "
}
zle -N snip_brackets-space
bindkey '[] ' snip_brackets-space
			#}}}
			#{{{ []<CR>
snip_brackets-cr() {
	LBUFFER="${LBUFFER}[]"
	zle accept-line
}
zle -N snip_brackets-cr
bindkey '[]^M' snip_brackets-cr
			#}}}
		#}}}
		#{{{ carats
			#{{{ <>
snip_carats() {
	LBUFFER="${LBUFFER}<"
	RBUFFER=">${RBUFFER}"
}
zle -N snip_carats
bindkey '<>' snip_carats
			#}}}
			#{{{ <><Space>
snip_carats-space() {
	LBUFFER="${LBUFFER}< "
	RBUFFER=" >${RBUFFER}"
}
zle -N snip_carats-space
bindkey '<> ' snip_carats-space
			#}}}
			#{{{ <><CR>
snip_carats-cr() {
	LBUFFER="${LBUFFER}<>"
	zle accept-line
}
zle -N snip_carats-cr
bindkey '<>^M' snip_carats-cr
			#}}}
		#}}}
		#{{{ double quotes
			#{{{ ""
snip_double-quotes() {
	LBUFFER="${LBUFFER}"'"'
	RBUFFER='"'"${RBUFFER}"
}
zle -N snip_double-quotes
bindkey '""' snip_double-quotes
			#}}}
			#{{{ "".
snip_double-quotes-dot() {
	LBUFFER="${LBUFFER}"'"".'
}
zle -N snip_double-quotes-dot
bindkey '"".' snip_double-quotes-dot
			#}}}
			#{{{ "",
snip_double-quotes-comma() {
	LBUFFER="${LBUFFER}"'"",'
}
zle -N snip_double-quotes-comma
bindkey '"",' snip_double-quotes-comma
			#}}}
			#{{{ ""<Space>
snip_double-quotes-space() {
	LBUFFER="${LBUFFER}"'"" '
}
zle -N snip_double-quotes-space
bindkey '"" ' snip_double-quotes-space
			#}}}
			#{{{ ""<CR>
snip_double-quotes-cr() {
	LBUFFER="${LBUFFER}"'""'
	zle accept-line
}
zle -N snip_double-quotes-cr
bindkey '""^M' snip_double-quotes-cr
			#}}}
		#}}}
		#{{{ single quotes
			#{{{ ''
snip_single-quotes() {
	LBUFFER="${LBUFFER}'"
	RBUFFER="'${RBUFFER}"
}
zle -N snip_single-quotes
bindkey "''" snip_single-quotes
			#}}}
			#{{{ ''.
snip_single-quotes-dot() {
	LBUFFER="${LBUFFER}''."
}
zle -N snip_single-quotes-dot
bindkey "''." snip_single-quotes-dot
			#}}}
			#{{{ '',
snip_single-quotes-comma() {
	LBUFFER="${LBUFFER}'',"
}
zle -N snip_single-quotes-comma
bindkey "''," snip_single-quotes-comma
			#}}}
			#{{{ ''<Space>
snip_single-quotes-space() {
	LBUFFER="${LBUFFER}' "
	RBUFFER=" '${RBUFFER}"
}
zle -N snip_single-quotes-space
bindkey "'' " snip_single-quotes-space
			#}}}
			#{{{ ''<CR>
snip_single-quotes-cr() {
	LBUFFER="${LBUFFER}''"
	zle accept-line
}
zle -N snip_single-quotes-cr
bindkey "''^M" snip_single-quotes-cr
			#}}}
		#}}}
		#{{{ backticks
			#{{{ ``
snip_paren() {
	LBUFFER="${LBUFFER}`"
	RBUFFER="`${RBUFFER}"
}
zle -N snip_paren
bindkey '``' snip_paren
			#}}}
			#{{{ ``<Space>
snip_paren-space() {
	LBUFFER="${LBUFFER}` "
	RBUFFER=" `${RBUFFER}"
}
zle -N snip_paren-space
bindkey '`` ' snip_paren-space
			#}}}
			#{{{ ``<CR>
snip_paren-cr() {
	LBUFFER="${LBUFFER}``"
	zle accept-line
}
zle -N snip_paren-cr
bindkey '``^M' snip_paren-cr
			#}}}
		#}}}
		#{{{ curly brackets
			#{{{ {)
snip_braces() {
	LBUFFER="${LBUFFER}{}"
}
zle -N snip_braces
bindkey '{)' snip_braces
			#}}}
			#{{{ {}<Space>
snip_braces-space() {
	LBUFFER="${LBUFFER}{} "
}
zle -N snip_braces-space
bindkey '{} ' snip_braces-space
			#}}}
		#}}}
	#}}}

	#{{{ spaces in enclosing characters
snip_space() {
	if ([ "${LBUFFER: -1}" = "(" ] && [ "${RBUFFER:0:1}" = ")" ]) ||
	   ([ "${LBUFFER: -1}" = "[" ] && [ "${RBUFFER:0:1}" = "]" ]) ||
	   ([ "${LBUFFER: -1}" = "{" ] && [ "${RBUFFER:0:1}" = "}" ]) ||
	then
		LBUFFER="${LBUFFER} " && RBUFFER=" ${RBUFFER}"
	elif [ "${LBUFFER: -2}" = " +" ] && ([ "${RBUFFER:0:1}" = '"' ] || [ "${RBUFFER:0:1}" = "'" ]); then
		LBUFFER="${LBUFFER:0:-2}${RBUFFER:0:1} + " && RBUFFER="${RBUFFER:1}"
	else
		LBUFFER="${LBUFFER} "
	fi
}
zle -N snip_space
bindkey ' ' snip_space
	#}}}

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
#}}}

# auto save screen layouts
[ -n "$STY" ] && [ "$(ps -o etimes= -p "$PPID")" -le 1 ] && screen -X -S "${STY%%.*}" eval "layout new \"s${STY%%.*}\"" "next"
