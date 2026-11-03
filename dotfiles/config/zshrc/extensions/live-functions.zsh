# Saved definitions, decoded from zsh Meta strings.

function '__beans_debug' {
local file="$BASH_COMP_DEBUG_FILE" 
if [[ -n ${file} ]]
then
	echo "$*" >> "${file}"
fi
}

function '__starship_get_time' {
(( STARSHIP_CAPTURED_TIME = int(rint(EPOCHREALTIME * 1000)) ))
}

function '__zoxide_cd' {
\builtin cd -- "$@"
}

function '__zoxide_doctor' {
[[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
[[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0
_ZO_DOCTOR=0 
\builtin printf '%s\n' 'zoxide: detected a possible configuration issue.' 'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' '' 'If the issue persists, consider filing an issue at:' 'https://github.com/ajeetdsouza/zoxide/issues' '' 'Disable this message by setting _ZO_DOCTOR=0.' '' >&2
}

function '__zoxide_hook' {
\command zoxide add -- "$(__zoxide_pwd)"
}

function '__zoxide_pwd' {
\builtin pwd -L
}

function '__zoxide_z' {
__zoxide_doctor
if [[ "$#" -eq 0 ]]
then
	__zoxide_cd ~
elif [[ "$#" -eq 1 ]] && {
		[[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]+$ ]]
	}
then
	__zoxide_cd "$1"
elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]
then
	__zoxide_cd "$2"
else
	\builtin local result
	result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")"  && __zoxide_cd "${result}"
fi
}

function '__zoxide_z_complete' {
[[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0
if [[ "${#words[@]}" -eq 2 ]]
then
	_cd -/
elif [[ "${words[-1]}" == '' ]]
then
	__zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})"  || __zoxide_result='' 
	compadd -Q ""
	\builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
	\builtin printf '\e[5n'
	return 0
fi
}

function '__zoxide_z_complete_helper' {
if [[ -n "${__zoxide_result}" ]]
then
	BUFFER="z ${(q-)__zoxide_result}" 
	__zoxide_result='' 
	\builtin zle reset-prompt
	\builtin zle accept-line
else
	\builtin zle reset-prompt
fi
}

function '__zoxide_zi' {
__zoxide_doctor
\builtin local result
result="$(\command zoxide query --interactive -- "$@")"  && __zoxide_cd "${result}"
}

function '_beans' {
local shellCompDirectiveError=1 
local shellCompDirectiveNoSpace=2 
local shellCompDirectiveNoFileComp=4 
local shellCompDirectiveFilterFileExt=8 
local shellCompDirectiveFilterDirs=16 
local shellCompDirectiveKeepOrder=32 
local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
local -a completions
__beans_debug "\n========= starting completion logic =========="
__beans_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"
words=("${=words[1,CURRENT]}") 
__beans_debug "Truncated words[*]: ${words[*]},"
lastParam=${words[-1]} 
lastChar=${lastParam[-1]} 
__beans_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"
setopt local_options BASH_REMATCH
if [[ "${lastParam}" =~ '-.*=' ]]
then
	flagPrefix="-P ${BASH_REMATCH}" 
fi
requestComp="${words[1]} __complete ${words[2,-1]}" 
if [ "${lastChar}" = "" ]
then
	__beans_debug "Adding extra empty parameter"
	requestComp="${requestComp} \"\"" 
fi
__beans_debug "About to call: eval ${requestComp}"
out=$(eval ${requestComp} 2>/dev/null) 
__beans_debug "completion output: ${out}"
local lastLine
while IFS='\n' read -r line
do
	lastLine=${line} 
done < <(printf "%s\n" "${out[@]}")
__beans_debug "last line: ${lastLine}"
if [ "${lastLine[1]}" = : ]
then
	directive=${lastLine[2,-1]} 
	local suffix
	(( suffix=${#lastLine}+2))
	out=${out[1,-$suffix]} 
else
	__beans_debug "No directive found.  Setting do default"
	directive=0 
fi
__beans_debug "directive: ${directive}"
__beans_debug "completions: ${out}"
__beans_debug "flagPrefix: ${flagPrefix}"
if [ $((directive & shellCompDirectiveError)) -ne 0 ]
then
	__beans_debug "Completion received error. Ignoring completions."
	return
fi
local activeHelpMarker="_activeHelp_ " 
local endIndex=${#activeHelpMarker} 
local startIndex=$((${#activeHelpMarker}+1)) 
local hasActiveHelp=0 
while IFS='\n' read -r comp
do
	if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ]
	then
		__beans_debug "ActiveHelp found: $comp"
		comp="${comp[$startIndex,-1]}" 
		if [ -n "$comp" ]
		then
			compadd -x "${comp}"
			__beans_debug "ActiveHelp will need delimiter"
			hasActiveHelp=1 
		fi
		continue
	fi
	if [ -n "$comp" ]
	then
		comp=${comp//:/\\:} 
		local tab="$(printf '\t')" 
		comp=${comp//$tab/:} 
		__beans_debug "Adding completion: ${comp}"
		completions+=${comp} 
		lastComp=$comp 
	fi
done < <(printf "%s\n" "${out[@]}")
if [ $hasActiveHelp -eq 1 ]
then
	if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]
	then
		__beans_debug "Adding activeHelp delimiter"
		compadd -x "--"
		hasActiveHelp=0 
	fi
fi
if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]
then
	__beans_debug "Activating nospace."
	noSpace="-S ''" 
fi
if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]
then
	__beans_debug "Activating keep order."
	keepOrder="-V" 
fi
if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]
then
	local filteringCmd
	filteringCmd='_files' 
	for filter in ${completions[@]}
	do
		if [ ${filter[1]} != '*' ]
		then
			filter="\*.$filter" 
		fi
		filteringCmd+=" -g $filter" 
	done
	filteringCmd+=" ${flagPrefix}" 
	__beans_debug "File filtering command: $filteringCmd"
	_arguments '*:filename:'"$filteringCmd"
elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]
then
	local subdir
	subdir="${completions[1]}" 
	if [ -n "$subdir" ]
	then
		__beans_debug "Listing directories in $subdir"
		pushd "${subdir}" > /dev/null 2>&1
	else
		__beans_debug "Listing directories in ."
	fi
	local result
	_arguments '*:dirname:_files -/'" ${flagPrefix}"
	result=$? 
	if [ -n "$subdir" ]
	then
		popd > /dev/null 2>&1
	fi
	return $result
else
	__beans_debug "Calling _describe"
	if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace
	then
		__beans_debug "_describe found some completions"
		return 0
	else
		__beans_debug "_describe did not find completions."
		__beans_debug "Checking if we should do file completion."
		if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]
		then
			__beans_debug "deactivating file completion"
			return 1
		else
			__beans_debug "Activating file completion"
			_arguments '*:filename:_files'" ${flagPrefix}"
		fi
	fi
fi
}

function 'f' {
local tmp dir
tmp="$(mktemp)" 
yazi --cwd-file "$tmp" "$@"
if [ -s "$tmp" ]
then
	dir="$(<"$tmp")" 
	trash-put -f "$tmp"
	if [ "$dir" != "$PWD" ]
	then
		cd -- "$dir" || return
	fi
else
	trash-put -f "$tmp"
fi
}

function 'files' {
nautilus --browser "$@" > /dev/null 2>&1 &
disown
}

function 'instant_prompt_example' {
prompt_example
}

function 'mdcd' {
mkdir -p -- "$1" && cd -- "$1" || return
}

function 'my_git_formatter' {
emulate -L zsh
if [[ -n $P9K_CONTENT ]]
then
	typeset -g my_git_format=$P9K_CONTENT 
	return
fi
if (( $1 ))
then
	local meta='%244F' 
	local clean='%76F' 
	local modified='%178F' 
	local untracked='%39F' 
	local conflicted='%196F' 
else
	local meta='%244F' 
	local clean='%244F' 
	local modified='%244F' 
	local untracked='%244F' 
	local conflicted='%244F' 
fi
local res
if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]
then
	local branch=${(V)VCS_STATUS_LOCAL_BRANCH} 
	(( $#branch > 32 )) && branch[13,-13]="…" 
	res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}" 
fi
if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]
then
	local tag=${(V)VCS_STATUS_TAG} 
	(( $#tag > 32 )) && tag[13,-13]="…" 
	res+="${meta}#${clean}${tag//\%/%%}" 
fi
[[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}" 
if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]
then
	res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}" 
fi
if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]
then
	res+=" ${modified}wip" 
fi
if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND ))
then
	(( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}" 
	(( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" " 
	(( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}" 
elif [[ -n $VCS_STATUS_REMOTE_BRANCH ]]
then
	
fi
(( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}" 
(( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" " 
(( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}" 
(( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}" 
[[ -n $VCS_STATUS_ACTION ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}" 
(( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}" 
(( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}" 
(( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}" 
(( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}" 
(( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─" 
typeset -g my_git_format=$res 
}

function 'prompt_example' {
p10k segment -f 208 -i '⭐' -t 'hello, %n'
}

function 'prompt_starship_precmd' {
STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=(${pipestatus[@]}) 
if (( ${+STARSHIP_START_TIME} ))
then
	__starship_get_time && STARSHIP_DURATION=$(( STARSHIP_CAPTURED_TIME - STARSHIP_START_TIME )) 
	unset STARSHIP_START_TIME
else
	unset STARSHIP_DURATION STARSHIP_CMD_STATUS STARSHIP_PIPE_STATUS
fi
STARSHIP_JOBS_COUNT="${#jobstates[*]}" 
}

function 'prompt_starship_preexec' {
__starship_get_time && STARSHIP_START_TIME=$STARSHIP_CAPTURED_TIME 
}

function 'pyenv' {
local command=${1:-} 
[ "$#" -gt 0 ] && shift
case "$command" in
	(activate | deactivate | rehash | shell) eval "$(pyenv "sh-$command" "$@")" ;;
	(*) command pyenv "$command" "$@" ;;
esac
}

function 'starship_zle-keymap-select' {
zle reset-prompt
}

function 'z' {
__zoxide_z "$@"
}

function 'zi' {
__zoxide_zi "$@"
}
