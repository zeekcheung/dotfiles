PLUGINS_DIR=$HOME/.local/share/zsh

plugins=(
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Bootstrap plugins
for plugin in $plugins; do
	# Install plugin if not already installed
	plugin_dir=$PLUGINS_DIR/$plugin
	if [ ! -d $plugin_dir ]; then
		echo "Installing $plugin..."
		git clone --depth=1 https://github.com/zsh-users/$plugin $plugin_dir
	fi

	# Load plugin
	plugin_file=$plugin_dir/$plugin.zsh
	if [ -f $plugin_file ]; then
		source $plugin_file
	fi
done

# Add zsh-completions to fpath
fpath=($PLUGINS_DIR/zsh-completions/src $fpath)

# Accept suggestion with <C-f>
bindkey '^F' autosuggest-accept
# Accpet partial suggestion with <A-f>
bindkey '^[f' vi-forward-word
