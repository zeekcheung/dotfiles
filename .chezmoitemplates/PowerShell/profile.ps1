# vim: foldmethod=marker
# chezmoi:template: left-delimiter="# [[" right-delimiter=]]

# Environment {{{

# shell
$env:SHELL = "pwsh"

# editor
$env:EDITOR = "nvim"

# fzf
$env:FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env:FZF_DEFAULT_OPTS = "--ansi --cycle --reverse --border=rounded --height=100% --preview='bat --color=always --theme=ansi --decorations=never {}' --preview-window='right,50%,border-left' --color=bg:-1 --color=gutter:-1"
$env:FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env:FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env:FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env:FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# ripgrep
$env:RIPGREP_CONFIG_PATH = "~/.ripgreprc"

# c/c++
$env:CC = "gcc"
$env:CXX = "g++"

# rust
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"
$env:CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse"
$env:CARGO_SOURCE_CRATES_IO_REPLACE_WITH = "rsproxy"
$env:CARGO_SOURCE_RSPROXY_REGISTRY = "sparse+https://rsproxy.cn/index/"

# go
$env:GOPROXY = "https://goproxy.cn,direct"

# python
$env:UV_DEFAULT_INDEX = "https://pypi.tuna.tsinghua.edu.cn/simple"
$env:PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple"

# node
$env:NPM_CONFIG_REGISTRY = "https://registry.npmmirror.com"

# mise
$env:DOT_ROOT = "~/.local/share/chezmoi"
$env:NOTE_ROOT = "~/OneDrive/Notes"
$env:PROJECT_ROOT = "~/Projects"

# }}}

# PSReadLine {{{

# NOTE: PSReadLine should be updated in Windows PowerShell
# Install-Module -Name PSReadLine -AllowClobber -Force

# Improved command-line editing experience
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function AcceptSuggestion

# }}}

# Aliases {{{

Set-Alias alias Set-Alias
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer
Set-Alias py python
Set-Alias vi nvim
Set-Alias f fzf

function .. { Set-Location .. }
function env { Get-ChildItem -Path 'Env:' }
function path { $env:Path -split ';' }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }

function ln {
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

function Remove-DefaultAlias {
  param ($name, $scope = 'Global')
  if (Get-Alias $name -ErrorAction SilentlyContinue) {
    Remove-Alias -Name $name -Scope $scope -Force
  }
}

# Remove-DefaultAlias ls
# function ls { eza --color=always --sort=Name --group-directories-first $args }
function l { ls -la }
function la { ls -a }
function ll { ls -l }
function tree { eza --color=always --tree $args }

Remove-DefaultAlias cat
Set-Alias cat bat

Remove-DefaultAlias gc
Remove-DefaultAlias gp
function ga { git add $args }
function gb { git branch $args }
function gc { git commit $args }
function gC { git commit --amend $args }
function gd { git diff $args }
function gf { git fetch $args }
function gl { git log $args }
function gp { git push $args }
function gP { git push --force $args }
function gr { git rebase $args }
function grc { git rebase --continue $args }
function gri { git rebase --interactive $args }
function gs { git stash }
function gt { git status }
function gu { git pull --rebase $args }
Set-Alias gg lazygit

function cz { chezmoi $args }
function cza { chezmoi apply $args }
function czc { chezmoi cd $args }
function czd { chezmoi destroy $args }
function cze { chezmoi edit $args }
function czu { chezmoi update $args }

function vf {
  param([Parameter(ValueFromRemainingArguments)]$Target)

  $Path = if ($Target) { Get-Item $Target -ErrorAction SilentlyContinue } else { Get-Item . }

  if (-not $Path) { return Write-Warning "Path '$Target' not found." }

  if ($Path.PSIsContainer) {
    $Selected = fzf

    if ($Selected) {
      # Use .FullName to avoid the "Path is null" error
      $FullPath = Join-Path $Path.FullName $Selected
      & $env:EDITOR "$FullPath"
    }
  } else {
    # If it's already a file, open it directly
    & $env:EDITOR "$($Path.FullName)"
  }
}

function dot {
  param($Target)
  Push-Location $env:DOT_ROOT
  vf $Target
  Pop-Location
}

function note {
  param([string]$NoteName)
  Push-Location $env:NOTE_ROOT

  if (-not [string]::IsNullOrEmpty($NoteName)) {
    if (-not (Test-Path $NoteName)) {
      New-Item -ItemType File -Path $NoteName -Force | Out-Null
      Write-Host "Created new note: $NoteName" -ForegroundColor Cyan
    }
    & $env:EDITOR "$NoteName"
  } else {
    vf .
  }
  Pop-Location
}

Register-ArgumentCompleter -CommandName vf -ParameterName Target -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete)
  Get-ChildItem -Name "$wordToComplete*"
}

Register-ArgumentCompleter -CommandName dot -ParameterName Target -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete)
  Get-ChildItem -Path $env:DOT_ROOT -Name | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName note -ParameterName NoteName -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete)
  Get-ChildItem -Path $env:NOTE_ROOT -Name | Where-Object { $_ -like "$wordToComplete*" }
}

# }}}

# Tools {{{

# Cache the init scripts in cache dir
$CacheDir = Join-Path $env:TEMP "\powershell"
if (-not (Test-Path $CacheDir)) { New-Item -ItemType Directory -Path $CacheDir | Out-Null }

# Init tool with cache: cache_init <command> [args...]
function Import-CachedInit {
  param (
    [Parameter(Mandatory=$true)]
    [string]$Tool,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
  )

  $InitPath = Join-Path $CacheDir "$Tool.ps1"

  if (-not (Test-Path $InitPath)) {
    & $Tool $Args | Out-String | Set-Content -Path $InitPath
  }

  . $InitPath
}

# Mise
# Import-CachedInit mise activate pwsh

# Starship
Import-CachedInit starship init powershell --print-full-init

# Zoxide
Import-CachedInit zoxide init powershell

# }}}

