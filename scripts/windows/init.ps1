# Directory symbolic link list: sourceDir => targetDir
$dirLinks = @{
  "$Env:APPDATA\alacritty" = "$Env:USERPROFILE\.config\alacritty"
  "$Env:LOCALAPPDATA\nvim" = "$Env:USERPROFILE\.config\nvim"
}

# File symbolic link list: sourceFile => targetFile
$fileLinks = @{
  "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" = "$Env:USERPROFILE\.config\powershell\profile.ps1"
}

# Create directory symbolic links
foreach ($dirLink in $dirLinks.GetEnumerator())
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
foreach ($fileLink in $fileLinks.GetEnumerator())
{
  $sourceFile = $fileLink.Key
  $targetFile = $fileLink.Value

  # Check if the symbolic link already exists. If it exists, delete it.
  if (Test-Path $sourceFile)
  {
    Remove-Item $sourceFile
  }

  # New-Item -ItemType SymbolicLink -Path $sourceFile -Target $targetFile
  New-Item -ItemType SymbolicLink -Path $sourceFile -Target $targetFile
}

