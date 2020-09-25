# ------------------------------------------------------------------------------
# Description
# -----------
#
# sudo or sudoedit will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
#
# ------------------------------------------------------------------------------

sudo-command-line() {
	# BUFFER is whole buffer, LBUFFER is left of cursor, RBUFFER right of it

	# current buffer is empty
	[[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

	# Save beginning space
	local WHITESPACE=""
	if [[ ${LBUFFER:0:1} == " " ]] ; then
		# not safe to send through printf->sed
		WHITESPACE=" "
		LBUFFER="${LBUFFER:1}"
	fi

	if [[ $BUFFER == sudo\ * ]]; then
		if [[ ${#LBUFFER} -le 4 ]]; then
			RBUFFER="${BUFFER#sudo }"
			LBUFFER=""
		else
			LBUFFER="${LBUFFER#sudo }"
		fi
	else
		LBUFFER="sudo $LBUFFER"
	fi

	# preserve at least one beginning space to hide from history if tried to before
	LBUFFER="${WHITESPACE}${LBUFFER}"
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
