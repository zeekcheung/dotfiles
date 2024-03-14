PLUGINS_DIR=$HOME/.local/share/zsh

plugins=(
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Bootstrap plugins
for plugin in $plugins; do
	plugin_dir=$PLUGINS_DIR/$plugin
	if [ ! -d $plugin_dir ]; then
		echo "Installing $plugin..."
		git clone --depth=1 https://github.com/zsh-users/$plugin $plugin_dir
	fi

	plugin_file=$plugin_dir/$plugin.zsh
	if [ -f $plugin_file ]; then
		source $plugin_file
	fi
done

fpath=($PLUGINS_DIR/zsh-completions/src $fpath)
