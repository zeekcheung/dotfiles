# Setup script for Windows

$AppData = $env:APPDATA
$LocalAppData = $env:LOCALAPPDATA

$Config = "$HOME\.config"
$Documents = [Environment]::GetFolderPath('MyDocuments')

# Symbolic link list: Target => Destination
$SymLinks = @{
  # alacritty
  "$Config\alacritty" = "$AppData\alacritty"
  # bat
  "$Config\bat" = "$AppData\bat"
  # clangd
  "$Config\clangd\windows-config.yaml" = "$LocalAppData\clangd\config.yaml"
  # git
  "$Config\.gitconfig" = "$USERPROFILE\.gitconfig"
  # lazygit
  "$Config\lazygit" = "$AppData\lazygit"
  # neovim
  "$Config\nvim" = "$LocalAppData\nvim"
  # nushell
  "$Config\nushell" = "$AppData\nushell"
  # powershell
  "$Config\powershell\profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # vim
  "$Config\vim\.vimrc" = "$USERPROFILE\_vimrc"
  # windows terminal
  "$Config\windows-terminal\settings.json" = "$LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # wsl
  "$Config\wsl\.wslconfig" = "$USERPROFILE\.wslconfig"
}

# Scoop buckets
$ScoopBuckets = @{
  'main' = 'https://github.com/ScoopInstaller/Main'
  'extras' = 'https://github.com/ScoopInstaller/Extras'
  'versions' = 'https://github.com/ScoopInstaller/Versions'
  'nerd-fonts' = 'https://github.com/matthewjberger/scoop-nerd-fonts'
}

# Scoop dependencies
$ScoopDeps = @(
  '7zip'
  'bat'
  'bottom'
  'cacert'
  'curl'
  'dark'
  'deno'
  'eza'
  'fd'
  'fzf'
  # "git"
  'gzip'
  'go'
  'lazygit'
  'jq'
  'JetBrainsMono-NF'
  'lua'
  'mingw-winlibs'
  'neovim'
  'nodejs'
  'nu'
  'python'
  'ripgrep'
  'rust'
  'sed'
  'starship'
  'sudo'
  'unzip'
  'vim-nightly'
  'xmake'
  'yarn'
  'zig'
  'zoxide'
)

$ChangeScoopDir = $false
$ScoopDir = 'D:\Apps\Scoop'
$ScoopGlobalDir = 'D:\Apps\Scoop\apps'

# Install scoop
if (Get-Command -Name 'scoop' -ErrorAction SilentlyContinue) {
  Write-Host 'Scoop has been installed.'
}
else {
  Write-Host 'Installing scoop...'

  if ($ChangeScoopDir) {
    Invoke-RestMethod get.scoop.sh -OutFile 'install.ps1'
    .\install.ps1 -ScoopDir $ScoopDir -ScoopGlobalDir $ScoopGlobalDir
    Remove-Item install.ps1
  }
  else {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  }
}

# Add missing buckets
Write-Host 'Adding missing scoop buckets...'
$AddedBuckets = scoop bucket list
foreach ($ScoopBucket in $ScoopBuckets.GetEnumerator()) {
  if ($AddedBuckets -notcontains $ScoopBucket.Key) {
    scoop bucket add $ScoopBucket.Key $ScoopBucket.Value
  }
}

# Install missing dependencies
Write-Host 'Installing missing dependencies...'
$InstalledScoopDeps = scoop list
foreach ($ScoopDep in $ScoopDeps) {
  if ($InstalledScoopDeps -notcontains $ScoopDep) {
    scoop install $ScoopDep
  }
}

# Install-Module -Name z –Force
# Install-Module -Name PSFzf -Scope CurrentUser -Force

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Create Symbolic Links
Write-Host 'Creating Symbolic Links...'
foreach ($Symlink in $SymLinks.GetEnumerator()) {
  $Target = $Symlink.Key
  $Destination = $Symlink.Value

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}
