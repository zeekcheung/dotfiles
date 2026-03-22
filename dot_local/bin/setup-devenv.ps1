#Requires -RunAsAdministrator

# vim: foldmethod=marker
# chezmoi:template: left-delimiter="# [[" right-delimiter="]]"

# Prelude {{{

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# }}}

# Environment {{{

# PowerShell Environment Variables (Persisted to Machine scope)
[Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "1", "Machine")
[Environment]::SetEnvironmentVariable("POWERSHELL_UPDATECHECK", "Off", "Machine")

# Target the global shared path that BOTH powershell.exe and pwsh.exe look at natively
$LocalPSModulePath = Join-Path $env:LOCALAPPDATA "PowerShell" "Modules"
[Environment]::SetEnvironmentVariable("LOCAL_PSModulePath", $LocalPSModulePath, "User")

# Rust
$CargoHome = Join-Path $env:LOCALAPPDATA "cargo"
[Environment]::SetEnvironmentVariable("RUSTUP_HOME", (Join-Path $env:LOCALAPPDATA "rustup"), "User")
[Environment]::SetEnvironmentVariable("CARGO_HOME", $CargoHome, "User")

# Go
$GoPath = Join-Path $env:LOCALAPPDATA "go"
[Environment]::SetEnvironmentVariable("GOPATH", $GoPath, "User")
[Environment]::SetEnvironmentVariable("GOCACHE", (Join-Path $env:LOCALAPPDATA "go-build"), "User")
[Environment]::SetEnvironmentVariable("GOMODCACHE", (Join-Path $GoPath "pkg" "mod"), "User")

# Python
$UvToolDir = Join-Path $env:LOCALAPPDATA "uv"
[Environment]::SetEnvironmentVariable("UV_TOOL_DIR", $UvToolDir, "User")
[Environment]::SetEnvironmentVariable("UV_TOOL_BIN_DIR", (Join-Path $UvToolDir "bin"), "User")
[Environment]::SetEnvironmentVariable("PIP_CACHE_DIR", (Join-Path $env:LOCALAPPDATA "pip"), "User")

# Node
$NpmConfigDir = Join-Path $env:LOCALAPPDATA "npm"
$PnpmConfigDir = Join-Path $env:LOCALAPPDATA "pnpm"
[Environment]::SetEnvironmentVariable("NPM_CONFIG_PREFIX", $NpmConfigDir, "User")
[Environment]::SetEnvironmentVariable("NPM_CONFIG_CACHE", (Join-Path $NpmConfigDir "cache"), "User")
[Environment]::SetEnvironmentVariable("PNPM_HOME", $PnpmConfigDir, "User")

# Bun
$BunInstallDir = Join-Path $env:LOCALAPPDATA "bun"
[Environment]::SetEnvironmentVariable("BUN_INSTALL_BIN", (Join-Path $BunInstallDir "bin"), "User")
[Environment]::SetEnvironmentVariable("BUN_INSTALL_GLOBAL_DIR", (Join-Path $BunInstallDir "global"), "User")
[Environment]::SetEnvironmentVariable("BUN_INSTALL_CACHE_DIR", (Join-Path $BunInstallDir "install" "cache"), "User")

# }}}

# Winget Packages {{{

Write-Host "Installing winget packages..." -ForegroundColor Cyan

$Packages = @(
    @{ Id = "Microsoft.VCRedist.2015+.x64";     Scope = "machine" }
    @{ Id = "Microsoft.Coreutils";              Scope = "machine" }
    @{ Id = "Notepad++.Notepad++";              Scope = "machine" }
    @{ Id = "Nushell.Nushell";                  Scope = "machine" }
    @{ Id = "Starship.Starship";                Scope = "machine" }
    @{ Id = "rsteube.Carapace";                 Scope = "machine" }
    @{ Id = "eza-community.eza";                Scope = "machine" }
    @{ Id = "sharkdp.bat";                      Scope = "machine" }
    @{ Id = "sharkdp.fd";                       Scope = "machine" }
    @{ Id = "junegunn.fzf";                     Scope = "machine" }
    @{ Id = "BurntSushi.ripgrep.MSVC";          Scope = "machine" }
    @{ Id = "ajeetdsouza.zoxide";               Scope = "machine" }
    @{ Id = "JesseDuffield.lazygit";            Scope = "machine" }
    @{ Id = "Neovim.Neovim";                    Scope = "machine" }
    @{ Id = "tree-sitter.tree-sitter-cli";      Scope = "machine" }
    @{ Id = "BrechtSanders.WinLibs.POSIX.UCRT"; Scope = "machine" }
    @{ Id = "GoLang.Go";                        Scope = "machine" }
    @{ Id = "Oven-sh.Bun";                      Scope = "machine" }
    @{ Id = "Python.Python.3.14";               Scope = "machine" }
    @{ Id = "astral-sh.uv";                     Scope = "machine" }
    @{ Id = "DEVCOM.LuaJIT";                    Scope = "machine" }

    @{ Id = "LuaLS.lua-language-server";        Scope = "user" }
)

foreach ($pkg in $Packages) {
    Write-Host "Installing $($pkg.Id)..." -ForegroundColor Cyan
    winget install --id $pkg.Id --scope $pkg.Scope --source winget --accept-source-agreements --accept-package-agreements
}

Write-Host "Installation done!" -ForegroundColor Green

# }}}

# Dev Tools {{{

$GhProxy = "https://v6.gh-proxy.org/"

sh (Join-Path $env:USERPROFILE ".local" "bin" "setup-devtools.sh")

# PowerShell {{{

# PowerShell Editor Services {{{

$TargetPsesFolder = Join-Path $LocalPSModulePath "PowerShellEditorServices"

if (-not (Test-Path $TargetPsesFolder)) {
    Write-Host "Installing PowerShell Editor Services globally..." -ForegroundColor Cyan

    $TempZip = Join-Path $env:TEMP "pses.zip"
    $Url = "${GhProxy}https://github.com/PowerShell/PowerShellEditorServices/releases/latest/download/PowerShellEditorServices.zip"

    Invoke-RestMethod -Uri $Url -OutFile $TempZip
    Expand-Archive -Path $TempZip -DestinationPath $LocalPSModulePath -Force
    Remove-Item -Path $TempZip -Force

    Write-Host "PowerShell Editor Services installed globally to $LocalPSModulePath" -ForegroundColor Green
} else {
    Write-Host "PowerShell Editor Services is already installed at $TargetPsesFolder. Skipping." -ForegroundColor Green
}

# }}}

# }}}

# Rime {{{

$RimeTempDir = Join-Path $env:TEMP "rime-ice"
$RimeUserDir = Join-Path $env:APPDATA "Rime"
$RimeDotDir = Join-Path $env:USERPROFILE ".local" "share" "chezmoi" ".chezmoitemplates" "rime"

Write-Host "Updating rime-ice..." -ForegroundColor Cyan

$exclude = Get-ChildItem -Path $RimeDotDir -File -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Name

if (Test-Path $RimeTempDir) {
    Remove-Item $RimeTempDir -Recurse -Force
}

git clone --depth=1 "${GhProxy}https://github.com/iDvel/rime-ice.git" $RimeTempDir

Get-ChildItem -Path $RimeTempDir -File | ForEach-Object {
    if ($exclude -notcontains $_.Name) {
        Copy-Item $_.FullName $RimeUserDir -Force
    }
}

Remove-Item $RimeTempDir -Recurse -Force

Write-Host "Rime-ice updated." -ForegroundColor Green

# }}}

# }}}

# PATH {{{

Write-Host "Normalizing PATH..." -ForegroundColor Cyan

$UserPriority = @(
    (Join-Path $env:USERPROFILE ".local" "bin")
    (Join-Path $BunInstallDir "bin")
    (Join-Path $NpmConfigDir "bin")
    (Join-Path $UvToolDir "bin")
    (Join-Path $GoPath "bin")
    (Join-Path $CargoHome "bin")
)

$MachinePriority = @(
    "C:\Program Files\nu\bin"
    "C:\Program Files\PowerShell\7"
    "C:\Program Files\WinGet\Links"
    "C:\Program Files\coreutils\bin"
    "C:\Program Files\Neovim\bin"
    "C:\Program Files\Git\cmd"
    "C:\Program Files\Git\bin"
    # "C:\Program Files\Python314\Scripts"
    # "C:\Program Files\Python314"
    "C:\Program Files\Go\bin"
    "C:\Program Files\dotnet"
)

function Set-NormalizedPath {
    param(
        [ValidateSet("User", "Machine")]
        [string]$Scope,

        [string[]]$Priority
    )

    $Path = [Environment]::GetEnvironmentVariable("Path", $Scope) -split ';' | Where-Object { $_ }

    $NewPath = @()

    foreach ($Preferred in $Priority) {
        $Match = $Path | Where-Object { $_.TrimEnd('\') -ieq $Preferred.TrimEnd('\') }

        if ($Match) {
            $NewPath += $Match
            $Path = $Path | Where-Object { $_.TrimEnd('\') -ine $Preferred.TrimEnd('\') }
        }
    }

    $NewPath += $Path

    [Environment]::SetEnvironmentVariable("Path", ($NewPath -join ';'), $Scope)
}

Set-NormalizedPath -Scope User -Priority $UserPriority
Set-NormalizedPath -Scope Machine -Priority $MachinePriority

# }}}

Write-Host "All setups completed successfully!" -ForegroundColor Green
