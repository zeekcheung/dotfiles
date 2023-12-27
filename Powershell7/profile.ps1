# Starship prompt
Invoke-Expression (&starship init powershell)

# Enhance command suggestions
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Functions
# Usage: ls
function list {
  $items = Get-ChildItem -Hidden:$false
  $items | ForEach-Object {
    Write-Host $_.Name -ForegroundColor Cyan
  }
}

# Usage: which app
function which {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$CommandName
  )

  Get-Command $CommandName | Select-Object -ExpandProperty Definition
}

# Usage: ln -Target "C:\path\to\file.txt" -Link "C:\path\to\symlink.txt"
function ln {
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Target,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$Link
  )

  if (!(Test-Path $Target)) {
    Write-Host "Target file does not exist: $Target"
    return
  }

  if (Test-Path $Link) {
    Write-Host "Link file already exists: $Link"
    return
  }

  New-Item -ItemType SymbolicLink -Path $Link -Value $Target | Out-Null
}

# Usage: env
function env {
  Get-ChildItem -Path 'Env:'
}

# Usage: path
function path {
  $paths = $env:Path -split ';'
  $index = 1

  foreach ($path in $paths) {
    Write-Host $path
    $index++
  }
}

# Aliases
Set-Alias ls list
Set-Alias ll 'Get-ChildItem'
Set-Alias grep 'Select-String'
Set-Alias df 'Get-PSDrive'
Set-Alias ipconfig 'Get-NetIPAddress'
Set-Alias reboot 'Restart-Computer'
Set-Alias shutdown 'Stop-Computer'

Set-Alias vi nvim

Set-Alias gg 'lazygit'
Set-Alias gt 'git status'
Set-Alias ga 'git add'
Set-Alias gb 'git branch'
Set-Alias gcm 'git commit'
Set-Alias gd 'git diff'
Set-Alias gpull 'git pull'
Set-Alias gpush 'git push'
Set-Alias gl 'git log'
Set-Alias gs 'git stash'
