# shell
$env.SHELL = "nu"

# editor
$env.EDITOR = (
    ["nvim", "vim", "vi", "zed", "notepad++", "notepad"]
    | where { |it| (which $it | is-not-empty) }
    | first
)

# misc
$env.DOT_ROOT = "~/.local/share/chezmoi"
$env.NOTE_ROOT = "~/OneDrive/Notes"
$env.PROJECT_ROOT = "~/Projects"

# fzf
$env.FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env.FZF_DEFAULT_OPTS = r#'--ansi --cycle --reverse --border --height 100% --preview='bat --color=always --theme=ansi --decorations=never {}' --preview-window='right,50%,border-left' --color=bg:-1 --color=gutter:-1'#
$env.FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env.FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env.FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# ripgrep
$env.RIPGREP_CONFIG_PATH = "~/.ripgreprc" | path expand

# gcc/g++
$env.CC = "gcc"
$env.CXX = "g++"

# rustup
$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# mise
mise activate nu | save -f ~/.mise.nu
