# Setup script for Windows

$USERPROFILE = $env:USERPROFILE
$APPDATA = $env:APPDATA
$LOCALAPPDATA = $env:LOCALAPPDATA

$CONFIG = "$USERPROFILE\.config"
$DOCUMENTS = "$USERPROFILE\Documents"

# Symbolic link list: Destination => Source
$symbolicLinks = @{
  # Windows Terminal
  "$LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "$CONFIG\windows-terminal\settings.json"
  # Alacritty
  "$APPDATA\alacritty" = "$CONFIG\alacritty"
  # Powershell
  "$DOCUMENTS\PowerShell\Microsoft.PowerShell_profile.ps1" = "$CONFIG\powershell\profile.ps1"
  # Nushell
  "$APPDATA\nushell" = "$CONFIG\nushell"
  # Neovim
  "$LOCALAPPDATA\nvim" = "$CONFIG\nvim"
  # git
  "$USERPROFILE\.gitconfig" = "$CONFIG\.gitconfig"
  # lazygit
  "$APPDATA\lazygit" = "$CONFIG\lazygit"
  # bat
  "$APPDATA\bat" = "$CONFIG\bat"
  # clangd
  "$LOCALAPPDATA\clangd" = "$CONFIG\clangd"
  # wsl
  "$USERPROFILE\.wslconfig" = "$CONFIG\wsl\.wslconfig"
}

# $ScoopDir = 'D:\Apps\Scoop'
# $ScoopGlobalDir = 'D:\Apps\Scoop\apps'

# Scoop buckets
$scoopBuckets = @{
  "main" = "https://github.com/ScoopInstaller/Main"
  "extras" = "https://github.com/lukesampson/scoop-extras.git"
  "versions" = "https://github.com/ScoopInstaller/Versions"
  "nerd-fonts" = "https://github.com/matthewjberger/scoop-nerd-fonts"
}

# Scoop dependencies
$scoopDeps = @(
  "7zip"
  "bat"
  "bottom"
  "cacert"
  "curl"
  "dark"
  "deno"
  "eza"
  "fd"
  "fzf"
  # "git"
  "gzip"
  "go"
  "lazygit"
  "jq"
  "JetBrainsMono-NF"
  "lua"
  "mingw-winlibs"
  "neovim-nightly"
  "nodejs20"
  "nu"
  "python"
  "ripgrep"
  "rust"
  "sed"
  "starship"
  "sudo"
  "unzip"
  "xmake"
  "yarn"
  "zig"
  "zoxide"
)

# Install scoop
if (Get-Command -Name "scoop" -ErrorAction SilentlyContinue) {
  Write-Host "Scoop has been installed."
}
else {
  Write-Host "Installing scoop..."

  irm get.scoop.sh | iex
  # Invoke-RestMethod get.scoop.sh -outfile 'install.ps1'
  # .\install.ps1 -ScoopDir $ScoopDir -ScoopGlobalDir $ScoopGlobalDir
}

# Add missing buckets
Write-Host "Adding missing scoop buckets..."
$addedBuckets = scoop bucket list
foreach ($scoopBucket in $scoopBuckets.GetEnumerator()) {
  if ($addedBuckets -notcontains $scoopBucket.Key) {
    scoop bucket add $scoopBucket.Key $scoopBucket.Value
  }
}

# Install missing dependencies
Write-Host "Installing missing dependencies..."
$installedScoopDeps = scoop list
foreach ($scoopDep in $scoopDeps) {
  if ($installedScoopDeps -notcontains $scoopDep) {
    scoop install $scoopDep
  }
}

Install-Module -Name z –Force
Install-Module -Name PSFzf -Scope CurrentUser -Force

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symbolicLinks.GetEnumerator()) {
  Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}
