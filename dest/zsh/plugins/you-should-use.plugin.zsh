#!/bin/zsh

NONE="\033[0m"
BOLD="\033[1m"
RED="\033[0;31m"
LIGHT_RED="\033[1;31m"
YELLOW="\033[0;33m"

# Writing to a buffer rather than directly to stdout/stderr allows us to decide if we want to write before or after a command has been executed
function _write_ysu_buffer() {
	_YSU_BUFFER+="$@"
}

function _flush_ysu_buffer() {
	# Passing as first argument to interpret escape sequences
	printf "$_YSU_BUFFER" >&2
	_YSU_BUFFER=""
	if [ "$YSU_MESSAGE_POSITION" != "before" ] && [ "$YSU_MESSAGE_POSITION" != "after" ]; then
		YSU_MESSAGE_POSITION="after"
		printf "$RED${BOLD}Unknown value for YSU_MESSAGE_POSITION '$position.' Expected value 'before' or 'after'$NONE\n" >&2
	fi
}

function ysu_message() {
	local DEFAULT_MESSAGE_FORMAT="${BOLD}${YELLOW}Found existing %alias_type for ${LIGHT_RED}\"%command\"${YELLOW} - you should use ${LIGHT_RED}\"%alias\"${NONE}"
	local alias_type_arg="${1}"
	local command_arg="${2}"
	local alias_arg="${3}"
	command_arg="${command_arg//\%/%%}"
	command_arg="${command_arg//\\/\\\\}"
	local MESSAGE="${YSU_MESSAGE_FORMAT:-"$DEFAULT_MESSAGE_FORMAT"}"
	MESSAGE="${MESSAGE//\%alias_type/$alias_type_arg}"
	MESSAGE="${MESSAGE//\%command/$command_arg}"
	MESSAGE="${MESSAGE//\%alias/$alias_arg}"
	_write_ysu_buffer "$MESSAGE\n"
}


function _check_ysu_hardcore() {
	[ "$YSU_HARDCORE" = 1 ] && kill -s INT $$
}


function _check_git_aliases() {
	local typed="$1"
	typed="${typed#${typed%%[![:space:]]*}}"
	local expanded="$2"
	local found=false

	# sudo will use another user's profile and so aliases would not apply
	if [[ "$typed" == "sudo "* ]]; then
		return
	fi

	if [[ "$typed" == "git "* ]]; then
		git config --get-regexp "^alias\..+$" | sort | while read key value; do
			key="${key#alias.}"
			if [[ "$expanded" == "git $value" || "$expanded" == "git $value "* ]]; then
				ysu_message "git alias" "$value" "git $key"
				found=true
			fi
		done
		$found && _check_ysu_hardcore
		[ "$YSU_MESSAGE_POSITION" = "before" ] && _flush_ysu_buffer
	fi
}

function _check_aliases() {
	local typed="$1"
	typed="${typed#${typed%%[![:space:]]*}}"
	local expanded="$2"
	local found=false
	local key
	local value
	local entry

	# sudo will use another user's profile and so aliases would not apply
	if [[ "$typed" = "sudo "* ]]; then
		return
	fi

	{ alias -g; alias -r; } | sort | while read entry; do
		key="${entry%%=*}"
		value="${entry#*=}"
		# Remove leading and trailing ' if they exist
		value="${(Q)value}"
		# Skip ignored aliases
		[ "${YSU_IGNORED_ALIASES[(r)$key]}" = "$key" ] && continue
		if [[ "$typed" == "$value" || "$typed" == "$value "* ]]; then
			# An alias was used
			[[ "$typed" == "$key" || "$typed" == "$key "* ]] && { _YSU_BUFFER=""; return; }
			# Aliases longer than or equal in length to the original command are likely for typos
			[ ${#key} -ge ${#value} ] && continue
			ysu_message "alias" "$value" "$key"
			found=true
		fi
	done
	$found && _check_ysu_hardcore
	[ "$YSU_MESSAGE_POSITION" = "before" ] && _flush_ysu_buffer
}

function disable_you_should_use() {
	add-zsh-hook -D preexec _check_aliases
	add-zsh-hook -D preexec _check_git_aliases
	add-zsh-hook -D precmd _flush_ysu_buffer
}

function enable_you_should_use() {
	disable_you_should_use
	add-zsh-hook preexec _check_aliases
	add-zsh-hook preexec _check_git_aliases
	add-zsh-hook precmd _flush_ysu_buffer
}

autoload -Uz add-zsh-hook
enable_you_should_use
