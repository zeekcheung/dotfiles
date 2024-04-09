# Add a newline before each prompt except the first line
precmd() {
	precmd() {
		echo
	}
}

# Set terminal title
preexec() {
	print -Pn "\e]0;$1\a"
}
