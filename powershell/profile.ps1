# Starship prompt
Invoke-Expression (&starship init powershell)

# Change execution policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Enhance command suggestions
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Remove default aliases
Remove-Alias -Name cd -Force
Remove-Alias -Name gc -Force
Remove-Alias -Name gp -Force

# Functions
function cd
{
  param (
    [string]$Path
  )

  $item = Get-Item -LiteralPath $Path -Force

  $targetPath = ""

  # Goto the target directory if it's a symbolic link
  if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
  {
    $targetPath = $item.Target
  } else
  {
    $targetPath = $Path
  }

  Set-Location -LiteralPath $targetPath
}

# Usage: ls
function list
{
  $items = Get-ChildItem -Hidden:$false
  $items | ForEach-Object {
    Write-Host $_.Name -ForegroundColor Cyan
  }
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

# Usage: ln -Target "C:\path\to\file.txt" -Link "C:\path\to\symlink.txt"
function ln
{
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Target,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]$Link
  )

  if (!(Test-Path $Target))
  {
    Write-Host "Target file does not exist: $Target"
    return
  }

  if (Test-Path $Link)
  {
    Write-Host "Link file already exists: $Link"
    return
  }

  New-Item -ItemType SymbolicLink -Path $Link -Value $Target | Out-Null
}

# Usage: env
function env
{
  Get-ChildItem -Path 'Env:'
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
  & "git" "commit" "-m" $args
}

function gd
{
  git diff $args 
}

function gs
{
  git stash $args 
}

function gp
{
  & "git" "pull" 
}

function gP
{
  & "git" "push"
}

function gt
{
  git status 
}

