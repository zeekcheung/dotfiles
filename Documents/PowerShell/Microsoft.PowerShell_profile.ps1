# shell
$env:SHELL = "pwsh"

# editor
$env:EDITOR = @("nvim", "vim", "zed", "code", "notepad++", "notepad") |
  Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } |
  Select-Object -First 1

# mise
$env:DOT_ROOT = "~/.local/share/chezmoi"
$env:NOTE_ROOT = "~/OneDrive/Notes"
$env:PROJECT_ROOT = "~/Projects"

# fzf
$env:FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env:FZF_DEFAULT_OPTS = @"
--ansi
--cycle
--reverse
--border
--height=100%
--preview='bat --color=always --theme=ansi --decorations=never {}'
--preview-window='right,50%,border-left'
--color=bg:-1
--color=gutter:-1
"@
$env:FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env:FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env:FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env:FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# ripgrep
$env:RIPGREP_CONFIG_PATH = "~/.ripgreprc"

# gcc/g++
$env:CC = "gcc"
$env:CXX = "g++"

# rustup
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# Enhance command suggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function AcceptSuggestion

# Aliases
Set-Alias alias Set-Alias
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer

function ..
{
  Set-Location ..
}
function env
{
  Get-ChildItem -Path 'Env:'
}
function path
{
  $env:Path -split ';'
}
function cat
{
  bat -p $args
}
function f
{
  fzf $args
}

function which($name)
{
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function ln
{
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Target,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination
  )

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}

function Remove-DefaultAlias
{
  param ($name, $scope = 'Global')
  if (Get-Alias $name -ErrorAction SilentlyContinue)
  {
    Remove-Alias -Name $name -Scope $scope -Force
  }
}

Remove-DefaultAlias ls
function ls
{
  eza --color=always --sort=Name --group-directories-first $args
}
function la
{
  ls -a
}
function ll
{
  ls -l
}
function l
{
  ls -la
}
function tree
{
  eza --color=always --tree $args
}

Remove-DefaultAlias cat

Remove-DefaultAlias gc
Remove-DefaultAlias gp
Set-Alias gg lazygit
function ga
{
  git add $args
}
function gb
{
  git branch $args
}
function gc
{
  git commit $args
}
function gC
{
  git commit --amend $args
}
function gd
{
  git diff $args
}
function gf
{
  git fetch $args
}
function gl
{
  git log $args
}
function gp
{
  git push $args
}
function gP
{
  git push --force $args
}
function gr
{
  git rebase $args
}
function grc
{
  git rebase --continue $args
}
function gri
{
  git rebase --interactive $args
}
function gs
{
  git stash
}
function gt
{
  git status
}
function gu
{
  git pull $args
}

function cz
{
  chezmoi $args
}
function cza
{
  chezmoi apply $args
}
function czc
{
  chezmoi cd $args
}
function cze
{
  chezmoi edit $args
}
function czu
{
  chezmoi update $args
}

# carapace
$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

Invoke-Expression (&starship init powershell)
Invoke-Expression (&zoxide init powershell | Out-String)
Invoke-Expression (&mise activate pwsh | Out-String)
