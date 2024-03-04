alias ez="vim ~/.bashrc"
alias sz=". ~/.bashrc"

fzf_dir() {
	local dirs=()
	local command_to_run="$1"
	shift

	while [[ "$#" -gt 0 ]]; do
		case "$1" in
			-p|--parent)
				shift
				if [ -d "$1" ]; then
					while IFS= read -r -d '' dir; do
						dirs+=("$dir")
					done < <(find "$1" -maxdepth 1 -type d -not -name "$(basename "$1")" -print0)

				fi
				;;
			-d|--directory)
				shift
				if [ -d "$1" ]; then
					dirs+=( "$1" )
				fi
				;;
			*)
				echo "Unknown option: $1"
				return 1
				;;
		esac
		shift
	done

	if [ "${#dirs[@]}" -eq 0 ]; then
		echo "No valid directories found."
		return 1
	fi

	local selected_dir
	selected_dir=$(printf "%s\n" "${dirs[@]}" | fzf --prompt="Select a directory: " --preview='ls {}' --ansi)

	if [ -n "$selected_dir" ]; then
		$command_to_run "$selected_dir"
	else
		echo "No directory selected."
		return 1
	fi
}

alias vs22="start /c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/Common7/IDE/devenv.exe"

FZF_RUN_ARGS=(
	"-p" "D:\Documents\Projects"
	"-p" "D:\Documents\work"
	#"-d" "$HOME/dotfiles/gypsum"
)

jc() { 
	fzf_dir code "${FZF_RUN_ARGS[@]}" 
}

js() { 
	projects=()
	for ((i=1; i < ${#FZF_RUN_ARGS[@]}; i+=2)); do
		mapfile -t files < <(rg "${FZF_RUN_ARGS[i]}" --files --max-depth=5 --glob "*.sln") #windows path seps
		#mapfile -t files < <(rg "${FZF_RUN_ARGS[i]}" --files --max-depth=5 --glob "*.sln" | sed 's/\\/\//g' | sed -E 's/([A-Z]):\//\/\L\1\//g') # unix path seps
		projects+=("${files[@]}")
	done

	local selected_project
	selected_project=$(printf "%s\n" "${projects[@]}" | fzf --prompt="Select a project: " --preview='grep -Eo "^Project.*" {} | sed '"'"'s/.* = "\([^"]\+\)".*/\1/g'"'" --ansi)
	if [ -n "$selected_project" ]; then
		start /c/Program\ Files/Microsoft\ Visual\ Studio/2022/Community/Common7/IDE/devenv.exe "$selected_project" &
	else
		echo "No directory selected."
	fi
}

jd() {
	fzf_dir cd "${FZF_RUN_ARGS[@]}" 
}
