function command_exists
    set command_name $argv[1]
    command -v $command_name > /dev/null 2>&1
end

if command_exists bat
    alias cat bat
end

if command_exists exa
    alias la "eza -a --git --icons --group-directories-first"
    alias ls "eza --git --icons --group-directories-first"
    alias ll "eza -l --git --icons --group-directories-first"
else
    alias la "ls -a"
    alias ll "ls -l"
end

if command_exists git
    alias ga "git add"
    alias gb "git branch"
    alias gc "git commit"
    alias gd "git diff"
    alias gl "git log"
    alias gp "git pull && git push"
    alias gt "git status"
end

if command_exists lazygit
    alias gg lazygit
end

if command_exists nvim
    alias vi nvim
    # ~/.config/nvchad
    alias nvchad "env NVIM_APPNAME=nvchad nvim"
    # ~/.config/lazyvim
    alias lazyvim "env NVIM_APPNAME=lazyvim nvim"
end

if command_exists tmux
    alias t "tmux"
    alias ta "tmux attach -t"
    alias td "tmux detach"
    alias tl "tmux ls"
    alias tn "tmux new -s"
    alias tm "tmux new -A -s main"
end

