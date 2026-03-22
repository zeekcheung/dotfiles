# Shell
$env.SHELL = "nu"

# Editor
$env.EDITOR = "nvim"

# Fzf
$env.FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env.FZF_DEFAULT_OPTS = r#'--ansi --cycle --reverse --border=rounded --height 100% --preview='bat --color=always --theme=ansi --decorations=never {}' --preview-window='right,50%,border-left' --color=bg:-1 --color=gutter:-1'#
$env.FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env.FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env.FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env.FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# Ripgrep
$env.RIPGREP_CONFIG_PATH = "~/.ripgreprc" | path expand

# C/C++
$env.CC = "gcc"
$env.CXX = "g++"

# Rust
$env.RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env.RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"
$env.CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse"
$env.CARGO_SOURCE_CRATES_IO_REPLACE_WITH = "rsproxy"
$env.CARGO_SOURCE_RSPROXY_REGISTRY = "sparse+https://rsproxy.cn/index/"

# Go
$env.GOPROXY = "https://goproxy.cn,direct"

# Python
$env.UV_DEFAULT_INDEX = "https://pypi.tuna.tsinghua.edu.cn/simple"
$env.PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple"

# Node
$env.NPM_CONFIG_REGISTRY = "https://registry.npmmirror.com"

# Misc
$env.DOT_ROOT = ("~/.local/share/chezmoi" | path expand)
$env.NOTE_ROOT = ("~/OneDrive/Notes" | path expand)
$env.PROJECT_ROOT = ("~/Projects" | path expand)

mkdir $nu.cache-dir

# Mise
# mise activate nu | save -f $"($nu.cache-dir)/mise.nu"

# Zoxide
zoxide init nushell | save -f $"($nu.cache-dir)/zoxide.nu"

# Carapace
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
carapace _carapace nushell | save -f $"($nu.cache-dir)/carapace.nu"
