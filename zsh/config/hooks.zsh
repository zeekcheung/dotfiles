# Add a newline before each prompt except the first line
precmd() {
	precmd() {
		echo
	}
}

# Set terminal title
preexec() {
	if [[ -n "$TMUX" ]]; then
		return
	fi
	print -Pn "\e]0;$1\a"
}
