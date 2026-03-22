# Environment variables
$env:EDITOR = @("nvim", "vim", "code", "notepad++", "notepad") |
  Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } |
  Select-Object -First 1

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

$env:CC = "gcc"
$env:CXX = "g++"

fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

$env:FNM_MULTISHELL_PATH = "$env:LOCALAPPDATA\fnm_multishells\17184_1745943454228"
$env:FNM_VERSION_FILE_STRATEGY = "local"
$env:FNM_DIR = "$env:APPDATA\fnm"
$env:FNM_LOGLEVEL = "info"
$env:FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$env:FNM_COREPACK_ENABLED = "true"
$env:FNM_RESOLVE_ENGINES = "true"
$env:FNM_ARCH = "x64"

# Note: VSCode cannot resolve below settings
if (-not $env:VSCODE_PID)
{
  $Host.UI.RawUI.WindowTitle = "pwsh.exe"
  Import-Module -Name Microsoft.WinGet.CommandNotFound
}

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
Set-Alias vi nvim

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
function gcm
{
  git commit -m $args
}
function gca
{
  git commit --amend --no-edit $args
}
function gco
{
  git checkout $args
}
function gd
{
  git diff $args
}
function gl
{
  git log $args
}
function gf
{
  git fetch $args
}
function gpl
{
  git pull $args
}
function gps
{
  git push $args
}
function gpsf
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
function gst
{
  git status
}

# carapace
$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
