# vim: foldmethod=marker
# chezmoi:template: left-delimiter="# [[" right-delimiter="]]"

# Environment {{{

# [[ if eq .chezmoi.os "linux" -]]
$env.XDG_CONFIG_HOME = ("~/.config" | path expand)
$env.XDG_CACHE_HOME = ("~/.cache" | path expand)
$env.XDG_DATA_HOME = ("~/.local/share" | path expand)
$env.XDG_STATE_HOME = ("~/.local/state" | path expand)

$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.MANPAGER = "nvim +Man!"
$env.MANROFFOPT = "-c"

# [[- end -]]

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

# Rigrep
$env.RIPGREP_CONFIG_PATH = ("~/.ripgreprc" | path expand)

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

# Path
# use std/util "path add" # prepend

# }}}

# Nushell {{{

# Find a detailed list of available settings using:
# config nu --doc | nu-highlight | less -R

# General {{{
$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = $env.EDITOR
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = false
$env.config.use_kitty_protocol = true
$env.config.shell_integration.osc2 = true
$env.config.shell_integration.osc7 = true
$env.config.shell_integration.osc8 = true
$env.config.shell_integration.osc133 = true
$env.config.shell_integration.osc633 = true
$env.config.bracketed_paste = true
$env.config.error_style = "fancy"
$env.config.table.mode = "default"
$env.config.filesize.unit = "metric"
$env.config.cursor_shape.vi_normal = "block"
# $env.config.cursor_shape.vi_insert = "block"
$env.config.color_config.shape_garbage = {fg: "red", bg: "default", attr: b}

# }}}

# Keybindings {{{
$env.config.edit_mode = "vi"
$env.config.keybindings ++= [
  {
    name: accept_suggestion
    modifier: control
    keycode: char_f
    mode: [emacs vi_insert vi_normal]
    event: {send: HistoryHintComplete}
  }
  {
    name: fzf_history
    modifier: control
    keycode: char_r
    mode: [emacs vi_insert vi_normal]
    event: [
      {send: ExecuteHostCommand, cmd: "commandline edit --insert (
          history | get command | reverse | uniq | str join (char -i 0)
            | fzf --preview 'echo {}' --preview-window wrap --read0
            | decode utf-8 | str trim
        )"}
    ]
  }
  {
    name: fzf_files
    modifier: control
    keycode: char_t
    mode: [emacs vi_insert vi_normal]
    event: [
      {send: ExecuteHostCommand, cmd: "commandline edit --insert (nu -l -i -c $'($env.FZF_CTRL_T_COMMAND) | fzf ($env.FZF_CTRL_T_OPTS)')"}
    ]
  }
  {
    name: fzf_dirs
    modifier: alt
    keycode: char_c
    mode: [emacs vi_insert vi_normal]
    event: [
      {send: ExecuteHostCommand, cmd: "cd (nu -c $'($env.FZF_ALT_C_COMMAND) | fzf ($env.FZF_ALT_C_OPTS)')"}
    ]
  }
]

# }}}

# }}}

# Prompt {{{
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
  starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""

# }}}

# Aliases {{{

# General
alias l = ls -a -l
alias la = ls -a
alias ll = ls -l
alias f = fzf
alias cat = bat -p
alias tree = eza --tree
alias vi = nvim
alias diff = nvim -d
alias py = python

# [[- if eq .chezmoi.os "linux" -]]
alias se = sudoedit
alias grep = grep --color=always

# [[- end ]]

# Git
alias ga = git add
alias gb = git branch
alias gc = git commit
alias gC = git commit --amend
alias gd = git diff
alias gf = git fetch
alias gl = git log
alias gp = git push
alias gP = git push --force
alias gr = git rebase
alias grc = git rebase --continue
alias gri = git rebase --interactive
alias gs = git stash
alias gt = git status
alias gu = git pull --rebase
alias gg = lazygit

# Chezmoi
alias cz = chezmoi
alias cza = chezmoi apply
alias czc = chezmoi cd
alias czd = chezmoi destroy
alias cze = chezmoi edit
alias czu = chezmoi update

# }}}

# Commands {{{

# List files in the directory
def files_in_dir [dir?: string] {
  ls -as (
        if ($dir | is-empty) { $env.PWD } else {
            $dir | path expand
        }
    ) | get name
}

# Fuzzy find a file and open it with the editor
def vf [target?: string@files_in_dir] {
  let full_path = if ($target | is-empty) { $env.PWD } else {
    $env.PWD | path join $target
  }

  if ($full_path | path exists) {
    let editor = $env.EDITOR
    match ($full_path | path type) {
      "file" => { ^$editor $full_path }
      "dir" => {
        cd $full_path
        let selected = (try { fzf } catch { null })
        if ($selected | is-not-empty) {
          vf $selected
        }
        cd -
      }
      _ => { print $"Path ($full_path) is not a file or directory" }
    }
  } else {
    print $"Path ($full_path) does not exist."
  }
}

# List all dot files
def dot_files [] { files_in_dir $env.DOT_ROOT }

# Fuzzy find a dotfile and open it with the editor
def dot [target?: string@dot_files] {
  let current_dir = $env.PWD
  cd $env.DOT_ROOT
  vf $target
  cd $current_dir
}

# List all note files
def note_files [] { files_in_dir $env.NOTE_ROOT }

# Fuzzy find a note file and open it with the editor
def note [note_name?: string@note_files] {
  let current_dir = $env.PWD
  cd $env.NOTE_ROOT

  if ($note_name | is-empty) {
    vf
  } else {
    let note_path = $note_name
    if not ($note_path | path exists) {
      touch $note_path
      print $"Created new note: ($note_path)"
    }
    vf $note_path
  }

  cd $current_dir
}

# }}}

# Tools {{{

# Cache the init scripts in autoload dir
let cache_dir = $nu.user-autoload-dirs.0
mkdir $cache_dir

# Init tool with cache: cache_init <command> [args...]
def cache-init [tool: string, ...args: string] {
  let init_path = $cache_dir | path join $"($tool).nu"

  if not ($init_path | path exists) {
    run-external $tool ...$args | save -f $init_path
  }
}

# Mise
# cache-init mise activate nu

# Zoxide
cache-init zoxide init nushell

# Carapace
$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
cache-init carapace _carapace nushell
# }}}
