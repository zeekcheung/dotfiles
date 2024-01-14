$APPDATA = $Env:APPDATA
$LOCALAPPDATA = $ENV:LOCALAPPDATA
$CONFIG = "$Env:USERPROFILE\.config"
$DOCUMENTS = "$Env:USERPROFILE\Documents"

# Directory symbolic link list: sourceDir => targetDir
$dirLinks = @{
  # Alacrity
  "$APPDATA\alacritty" = "$CONFIG\alacritty"
  # Neovim
  "$LOCALAPPDATA\nvim" = "$CONFIG\nvim"
}

# File symbolic link list: sourceFile => targetFile
$fileLinks = @{
  # Powershell
  "$DOCUMENTS\PowerShell\Microsoft.PowerShell_profile.ps1" = "$CONFIG\powershell\profile.ps1"
  # Windows Terminal
  "$LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "$CONFIG\windows-terminal\settings.json"
}

function New-SymbolicLinks
{
  param (
    [Parameter(Mandatory=$true)]
    [Hashtable]$DirectoryLinks,

    [Parameter(Mandatory=$true)]
    [Hashtable]$FileLinks
  )

  # Create directory symbolic links
  foreach ($dirLink in $DirectoryLinks.GetEnumerator())
  {
    $sourceDir = $dirLink.Key
    $targetDir = $dirLink.Value

    # Check if the symbolic link already exists. If it exists, delete it.
    if (Test-Path $sourceDir)
    {
      Remove-Item $sourceDir
    }

    # Create the symbolic link
    New-Item -ItemType SymbolicLink -Path $sourceDir -Target $targetDir
  }

  # Create file symbolic links
  foreach ($fileLink in $FileLinks.GetEnumerator())
  {
    $sourceFile = $fileLink.Key
    $targetFile = $fileLink.Value

    # Check if the symbolic link already exists. If it exists, delete it.
    if (Test-Path $sourceFile)
    {
      Remove-Item $sourceFile
    }

    # Create the symbolic link
    New-Item -ItemType SymbolicLink -Path $sourceFile -Target $targetFile
  }
}

# Call the function with the specified symbolic link lists
New-SymbolicLinks -DirectoryLinks $dirLinks -FileLinks $fileLinks

