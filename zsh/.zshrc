# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

proxy() {
  export https_proxy=http://127.0.0.1:20171 http_proxy=http://127.0.0.1:20171 all_proxy=socks5://127.0.0.1:20170
  echo "proxy on"
}

unproxy() {
  unset https_proxy http_proxy all_proxy
  echo "proxy off"
}

# zsh-completions
source ~/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
# zsh-autosuggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-syntax-highlighting
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# starship
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh)"

# Aliases
alias zshconfig="nvim ~/.config/zsh"

alias ~="cd ~"
alias ..="cd .."
alias cat="bat"
alias cd="z"
alias grep="rg"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gg="lazygit"
alias gl="git log"
alias gp="git pull && git git push"
alias gt="git status"
alias ipconfig="ifconfig"
alias la="eza -a --git --icons --group-directories-first"
alias ls="eza --git --icons --group-directories-first"
alias ll="eza -l --git --icons --group-directories-first"
alias vi="nvim"
