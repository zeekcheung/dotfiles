# Change execution policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Enhance command suggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Starship
Invoke-Expression (&starship init powershell)
# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Environment
$env:EDITOR = 'nvim'

# fzf
$env:FZF_DEFAULT_OPTS = "
--layout=reverse
--inline-info
--ansi
--bind=tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle
--preview='bat --color=always {}'
--preview-window=right,60%
"

# Remove default aliases
Remove-Alias -Name cat -Force
Remove-Alias -Name cd -Force
Remove-Alias -Name gc -Force
Remove-Alias -Name gp -Force
Remove-Alias -Name ls -Force

# Aliases
Set-Alias cat bat
Set-Alias cd z
Set-Alias grep rg
Set-Alias df Get-PSDrive
Set-Alias gg lazygit
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer
Set-Alias top btm
Set-Alias vi nvim

function ..
{ z .. 
}
function ls
{ eza --git --icons --group-directories-first 
}
function ll
{ eza -l --git --icons --group-directories-first 
}

function ga
{ git add $args 
}
function gb
{ git branch $args 
}
function gc
{ git commit -m $args 
}
function gd
{ git diff $args 
}
function gs
{ git stash $args 
}
function gp
{ git pull 
}
function gP
{ git push 
}
function gt
{ git status 
}

# Usage: config, config nvim, config wsl...
function config
{
  param (
    [String]$dirname
  )

  $dirname = '~\.config\' + $dirname
  Set-Location $dirname
  $command = $env:EDITOR + ' .'
  Invoke-Expression $command
}

# Usage: touch foo.txt, bar.txt || touch $HOME/foo.bar
function touch
{
  param(
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [String[]]$Paths
  )

  process
  {
    foreach ($Path in $Paths)
    {
      $expandedPath = $ExecutionContext.InvokeCommand.ExpandString($Path)
      $parentDirectory = Split-Path -Path $expandedPath -Parent

      if (-not [string]::IsNullOrWhiteSpace($parentDirectory) -and -not (Test-Path -Path $parentDirectory))
      {
        $null = New-Item -Path $parentDirectory -ItemType Directory
      }

      if (Test-Path -Path $expandedPath)
      {
        $currentDate = Get-Date
        $null = (Get-Item -Path $expandedPath).LastWriteTime = $currentDate
        $null = (Get-Item -Path $expandedPath).LastAccessTime = $currentDate
      } else
      {
        $null = New-Item -Path $expandedPath -ItemType File
      }
    }
  }
}

# Usage: which app
function which
{
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$CommandName
  )

  Get-Command $CommandName | Select-Object -ExpandProperty Definition
}

# Usage: ln $Env:APPDATA\bat ~\.config\bat
function ln
{
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$Source
  )

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Source) -Force | Out-Null
}

# Usage: env
function env
{ Get-ChildItem -Path 'Env:' 
}

# Usage: path
function path
{
  $paths = $env:Path -split ';'
  $index = 1

  foreach ($path in $paths)
  {
    Write-Host $path
    $index++
  }
}

