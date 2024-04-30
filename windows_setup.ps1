# Setup script for Windows

$AppData = $Env:APPDATA
$LocalAppData = $Env:LOCALAPPDATA
$USERPROFILE = $Env:USERPROFILE

$Dotfiles = "$HOME\.dotfiles"
$Documents = [Environment]::GetFolderPath('MyDocuments')

# Symbolic link list: Target => Destination
$SymLinks = @{
  # alacritty
  "$Dotfiles\alacritty\.config\alacritty" = "$AppData\alacritty"
  # bat
  "$Dotfiles\bat\.config\bat" = "$AppData\bat"
  # clangd
  "$Dotfiles\clangd\.config\clangd\windows-config.yaml" = "$LocalAppData\clangd\config.yaml"
  # git
  "$Dotfiles\git\.gitconfig" = "$USERPROFILE\.gitconfig"
  # lazygit
  "$Dotfiles\lazygit\.config\lazygit" = "$AppData\lazygit"
  # nushell
  "$Dotfiles\nushell\.config\nushell" = "$AppData\nushell"
  # nvim
  "$Dotfiles\nvim\.config\nvim" = "$LocalAppData\nvim"
  # powershell
  "$Dotfiles\powershell\.config\powershell\profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # vim
  "$Dotfiles\vim\.vimrc" = "$USERPROFILE\_vimrc"
  # windows terminal
  "$Dotfiles\windows-terminal\.config\windows-terminal\settings.json" = "$LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # wsl
  "$Dotfiles\wsl\.config\wsl\.wslconfig" = "$USERPROFILE\.wslconfig"
}

# Scoop buckets
$ScoopBuckets = @(
  'main'
  'extras'
  'versions'
)

# Scoop packages
$ScoopPackages = @(
  '7zip'
  'bat'
  # 'bottom'
  'cacert'
  'curl'
  'dark'
  # 'deno'
  'eza'
  'fd'
  'fzf'
  'gzip'
  # 'go'
  'lazygit'
  # 'jq'
  # 'JetBrainsMono-NF'
  # 'lua'
  # 'mingw-winlibs'
  'neovim'
  # 'nodejs'
  # 'nu'
  # 'python'
  # 'ripgrep'
  # 'rust'
  'sed'
  # 'starship'
  # 'sudo'
  'unzip'
  # 'vim-nightly'
  # 'xmake'
  # 'yarn'
  # 'zig'
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
foreach ($Bucket in $ScoopBuckets) {
  if ($AddedBuckets -notcontains $Bucket) {
    scoop bucket add $Bucket
  }
}

# Install missing packages
Write-Host 'Installing missing packages...'
$InstalledScoopPackages = scoop list
foreach ($Package in $ScoopPackages) {
  if ($InstalledScoopPackages -notcontains $Package) {
    scoop install $Package
  }
}

# Install-Module -Name z –Force
# Install-Module -Name PSFzf -Scope CurrentUser -Force

# Refresh Path
$Env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Create Symbolic Links
Write-Host 'Creating Symbolic Links...'
foreach ($Symlink in $SymLinks.GetEnumerator()) {
  $Target = $Symlink.Key
  $Destination = $Symlink.Value

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}
