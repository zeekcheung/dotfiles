if status is-interactive
    # Commands to run in interactive sessions can go here

    # Fish style
    set -g fish_greeting ""

    function fish_postcmd --on-event fish_postexec
        echo
    end
    # Fish style end

    # Starship
    set -gx STARSHIP_CONFIG ~/.config/starship/config.toml
    starship init fish | source
    # Starship end

    # Wsl Proxy
    function proxy
        set -l host_ip (cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
        set -gx http_proxy $host_ip:10809
        set -gx https_proxy $host_ip:10809

        git config --global http.proxy $host_ip:10809
        git config --global https.proxy $host_ip:10809

        echo "Proxy enabled"
    end

    function unproxy
        set -e http_proxy
        set -e https_proxy

        git config --global --unset http.proxy
        git config --global --unset https.proxy

        echo "Proxy disabled"
    end
    # Wsl Proxy end
end

# Github hosts
sudo sh -c 'sed -i "/# GitHub520 Host Start/Q" /etc/hosts && curl https://raw.hellogithub.com/hosts >> /etc/hosts' >/dev/null 2>&1
# Github hosts end

# Tmux
set -gx TMUX_PLUGIN_MANAGER_PATH $HOME/.tmux/plugins/tpm
# Tmux end

# Nvim
fish_add_path $HOME/.local/share/nvim/mason/bin

function nvchad
    env NVIM_APPNAME=nvchad nvim
end
# Nvim end

# Rust
fish_add_path $HOME/.cargo/bin
# Rust end

# Go
set -gx GOPATH $HOME/code/go
set -gx GOBIN $GOPATH/bin
fish_add_path /usr/local/go/bin
fish_add_path $GOBIN
# Go end

# NodeJS
set -U nvm_default_version v18.17.1
fish_add_path $HOME/.local/share/nvm/v18.17.1/bin
# NodeJS end

# Deno
set -gx DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin
# Deno end

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not string match -q -- $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end
alias pn=pnpm
# pnpm end

# Alias
alias cl clear
alias h history

alias ll "ls -l"
alias la "ls -all"
alias mkdir "mkdir -p"

alias ps "ps aux"
alias psg "ps aux | grep"
alias top htop
alias kill "kill -9"

alias vi nvim
alias cat batcat
alias grep "grep --color=auto"
alias lua luajit
alias python python3

alias bashls bash-language-server
alias dockerls docker-langserver
alias html vscode-html-language-server
alias cssls vscode-css-language-server
alias emmet_ls emmet-ls
alias jsonls vscode-json-languge-server
alias lua_ls lua-language-server
alias prismals prisma-language-server
alias ruff_lsp ruff-lsp
alias tailwindcss tailwindcss-language-server
alias tsserver typescript-language-server
alias volar vue-language-server
alias yamlls yaml-language-server

alias gg lazygit
alias gt "git status"
alias ga "git add"
alias gb "git branch"
alias gc "git commit"
alias gd "git diff"
alias gp "git pull"
alias gP "git push"
alias gl "git log"
alias gs "git stash"

alias apt "sudo apt"
alias update "sudo apt update && sudo apt upgrade"

alias ipconfig ifconfig
# Alias end
