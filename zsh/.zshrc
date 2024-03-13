# shellcheck disable=SC1090,SC1091,SC2034,SC2086,SC2128,SC2155,SC2206

# Add custom executable scripts to PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# plugin list
plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Bootstrap plugins
for plugin in $plugins; do
	plugin_dir=$HOME/.config/zsh/plugins/$plugin
	if [ ! -d $plugin_dir ]; then
		echo "Installing $plugin..."
		git clone --depth=1 https://github.com/zsh-users/$plugin $plugin_dir
	fi

	plugin_file=$plugin_dir/$plugin.zsh
	source $plugin_file
done

package_exist() {
	command -v "$1" >/dev/null 2>&1
}

if package_exist bat; then
	alias cat="bat"
fi

if package_exist eza; then
	alias la="eza -a --git --icons --group-directories-first"
	alias ls="eza --git --icons --group-directories-first"
	alias ll="eza -l --git --icons --group-directories-first"
else
	alias la="ls -a"
	alias ll="ls -l"
fi

if package_exist git; then
	alias ga="git add"
	alias gb="git branch"
	alias gc="git commit"
	alias gd="git diff"
	alias gl="git log"
	alias gp="git pull && git push"
	alias gt="git status"
fi

if package_exist lazygit; then
	alias gg="lazygit"
fi

if package_exist nvim; then
	alias vi="nvim"
	# ~/.config/nvchad
	alias nvchad="env NVIM_APPNAME=nvchad nvim"
	# ~/.config/lazyvim
	alias lazyvim="env NVIM_APPNAME=lazyvim nvim"

	# Preferred editor for local and remote sessions
	if [[ -n $SSH_CONNECTION ]]; then
		export EDITOR='nvim'
	else
		export EDITOR='vim'
	fi

	# Language servers installed via mason
	export PATH=$HOME/.local/share/nvim/mason/bin:$PATH
fi

# tmux
if package_exist tmux; then
	export TMUX_PLUGIN_MANAGER_PATH=$HOME/.tmux/plugins/tpm

	alias t="tmux"
	alias ta="tmux attach -t"
	alias td="tmux detach"
	alias tk="tmux kill-session -t"
	alias tl="tmux ls"
	alias tn="tmux new -s"
	alias tm="tmux new -A -s main"
fi

# starship
if package_exist "starship"; then
	eval "$(starship init zsh)"
fi

# zoxide
if package_exist "zoxide"; then
	eval "$(zoxide init zsh)"
	alias cd="z"
fi
