# Enhance command suggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

# Global variables: $Config, $Documents, etc
$Global:Config = $HOME + '\.config'
$Global:Documents = [Environment]::GetFolderPath('MyDocuments')
$Global:Downloads = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
$Global:Music = [Environment]::GetFolderPath('MyMusic')
$Global:Pictures = [Environment]::GetFolderPath('MyPictures')
$Global:Videos = [Environment]::GetFolderPath('MyVideos')

<#
.SYNOPSIS
cd to parent folder

.EXAMPLE
..
#>
function .. {
  Set-Location ..
}

<#
.SYNOPSIS
Open config folder with $env:EDITOR

.EXAMPLE
config, config nvim, config wsl, etc
#>
function config {
  param (
    [String]$dirname
  )

  $current_location = Get-Location
  $target_location = $Global:Config + $dirname

  Set-Location $target_location
  $command = $env:EDITOR + ' .'
  Invoke-Expression $command

  Set-Location $current_location
}

<#
.SYNOPSIS
List environment variables

.EXAMPLE
env
#>
function env {
  Get-ChildItem -Path 'Env:'
}

<#
.SYNOPSIS
Create symbolic link

.EXAMPLE
ln ~\.config\bat $Env:APPDATA\bat
#>
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

<#
.SYNOPSIS
List paths

.EXAMPLE
path
#>
function path {
  $env:Path -split ';'
}

<#
.SYNOPSIS
Create files

.EXAMPLE
touch foo.txt, bar.txt || touch $HOME/foo.bar
#>
function touch {
  param(
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [String[]]$Paths
  )

  process {
    foreach ($Path in $Paths) {
      $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($Path)
      $parentDirectory = Split-Path -Path $expandedPath -Parent

      if (-not [string]::IsNullOrWhiteSpace($parentDirectory) -and -not (Test-Path -Path $parentDirectory)) {
        $null = New-Item -Path $parentDirectory -ItemType Directory
      }

      if (Test-Path -Path $expandedPath) {
        $currentDate = Get-Date
        $null = (Get-Item -Path $expandedPath).LastWriteTime = $currentDate
        $null = (Get-Item -Path $expandedPath).LastAccessTime = $currentDate
      }
      else {
        $null = New-Item -Path $expandedPath -ItemType File
      }
    }
  }
}

<#
.SYNOPSIS
Get the path of a command

.EXAMPLE
which pwsh
#>
function which {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$CommandName
  )

  Get-Command $CommandName | Select-Object -ExpandProperty Definition
}

<#
.SYNOPSIS
Check if command exists

.EXAMPLE
Test-CommandExists pwsh
#>
function Test-CommandExists {
  Param ($command)
  $oldPreference = $ErrorActionPreference
  $ErrorActionPreference = 'stop'
  try { if (Get-Command $command) { RETURN $true } }
  Catch { Write-Host "$command does not exist"; RETURN $false }
  Finally { $ErrorActionPreference = $oldPreference }
}

if (Test-CommandExists bat) {
  Set-Alias cat bat -Force
}

if (Test-CommandExists eza) {
  Remove-Alias -Name ls -Force

  function ls {
    eza --git --icons --group-directories-first
  }
  function la {
    eza -a --git --icons --group-directories-first
  }
  function ll {
    eza -l --git --icons --group-directories-first
  }
}
else {
  Set-Alias la 'ls -a'
  Set-Alias ll 'ls -l'
}

if (Test-CommandExists fzf) {
  $env:FZF_DEFAULT_OPTS = "
    --layout=reverse
    --inline-info
    --ansi
    --bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
    --preview='bat --color=always {}'
    --preview-window=right,60%
  "
}

if (Test-CommandExists git) {
  Remove-Alias -Name gc -Force
  Remove-Alias -Name gp -Force

  function ga {
    git add $args
  }
  function gb {
    git branch $args
  }
  function gc {
    git commit -m $args
  }
  function gd {
    git diff $args
  }
  function gs {
    git stash $args
  }
  function gp {
    git pull
  }
  function gP {
    git push
  }
  function gt {
    git status
  }
}

if (Test-CommandExists lazygit) {
  Set-Alias gg lazygit
}

if (Test-CommandExists nvim) {
  $env:EDITOR = 'nvim'
  Set-Alias vi nvim
}

if (Test-CommandExists zoxide) {
  Remove-Alias -Name cd -Force
  Set-Alias cd z

  # zoxide
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Aliases
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer

# Starship
Invoke-Expression (&starship init powershell)