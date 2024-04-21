# Enhance command suggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+f" -Function AcceptSuggestion

# Global variables: $Config, $Documents, etc
$Global:Config = $HOME + '\.config'
$Global:Documents = [Environment]::GetFolderPath('MyDocuments')
$Global:Downloads = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
$Global:Music = [Environment]::GetFolderPath('MyMusic')
$Global:Pictures = [Environment]::GetFolderPath('MyPictures')
$Global:Videos = [Environment]::GetFolderPath('MyVideos')

# Environment variables
$env:EDITOR = 'nvim'
$env:FZF_DEFAULT_OPTS = "
  --layout=reverse
  --inline-info
  --ansi
  --bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
  --preview='bat --color=always {}'
  --preview-window=right,60%
"

# Aliases
Set-Alias alias Set-Alias
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer
Set-Alias vi nvim

function .. { Set-Location .. }
function env { Get-ChildItem -Path 'Env:' }
function path { $env:Path -split ';' }
function reload { & $PROFILE }

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

function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function Remove-DefaultAlias {
  param ($name, $scope = 'Global')
  if (Get-Alias $name -ErrorAction SilentlyContinue) {
    Remove-Alias -Name $name -Scope $scope -Force
  }
}

Remove-DefaultAlias ls
function ls { eza --git --group-directories-first }
function la { eza -a --git --group-directories-first }
function ll { eza -l --git --group-directories-first }
function l { eza -al --git --group-directories-first }

Remove-DefaultAlias gc
Remove-DefaultAlias gp
function ga { git add $args }
function gb { git branch $args }
function gc { git commit -m $args }
function gd { git diff $args }
function gs { git stash $args }
function gp { git pull && git push }
function gt { git status }
Set-Alias gg lazygit

# Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Alias -Name cd -Scope Global -Force
Set-Alias cd z -Scope Global -Force

function Get-GitBranch {
  # Check if the current directory is a Git repository
  if (Test-Path -Path ".git" -PathType Container) {
    try {
      # Retrieve the name of the current branch
      $branchName = git symbolic-ref --short HEAD
      if ($branchName) {
        return " on  $branchName"
      }
    } catch {
      # Handle any errors silently
    }
  }
  return ''
}

# custom prompt
$firstPrompt = $true
function prompt {
  $user = $Env:USERNAME
  $dir = Get-Location
  $gitBranch = Get-GitBranch
  
  # Define colors
  $userColor = "Yellow"
  $dirColor = "Cyan"
  $branchColor = "Magenta"
  $promptSymbolColor = "Green"

  # Add a newline before the prompt for subsequent prompts
  if ($firstPrompt) {
    $global:firstPrompt = $false
  } else {
    Write-Host ""
  }
  
  # Format prompt components with colors
  Write-Host "$user " -NoNewLine  -ForegroundColor $userColor
  if ($gitBranch -ne '') {
    Write-Host "$dir" -NoNewLine -ForegroundColor $dirColor
    Write-Host "$gitBranch" -ForegroundColor $branchColor
  } else {
    Write-Host "$dir" -ForegroundColor $dirColor
  }
  Write-Host '❯' -NoNewLine -ForegroundColor $promptSymbolColor
  
  return " "
}
