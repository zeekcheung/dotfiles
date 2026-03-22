# vim: foldmethod=marker
# chezmoi:template: left-delimiter="# [[" right-delimiter=]]

# Environment {{{

# PowerShell
$env:LS_COLORS = "di=38;5;111:fi=0:ex=38;5;149"
$IsPowerShellCore = $PSVersionTable.PSEdition -eq "Core"
if ($IsPowerShellCore) {
    $PSStyle.FileInfo.Directory = "`e[94m"
}

# [[ if eq .chezmoi.os "windows" -]]
$env:SHELL = "powershell"
if ($IsPowerShellCore) {
    $env:SHELL = "pwsh"
}
# [[- end ]]

# Editor
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"

# Pager
$env:MANPAGER = "nvim +Man!"
$env:MANROFFOPT = "-c"

# fzf
$env:FZF_DEFAULT_COMMAND = "fd --type file --hidden"
$env:FZF_DEFAULT_OPTS = "--ansi --cycle --reverse --border=rounded --height=100% --preview='bat --color=always --theme=ansi --decorations=never {}' --preview-window='right,50%,border-left' --color=bg:-1 --color=gutter:-1"
$env:FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env:FZF_ALT_C_OPTS = "--preview 'eza --tree {}'"
$env:FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env:FZF_CTRL_T_OPTS = "--preview 'bat --color=always --theme=ansi --decorations=never {}'"

# ripgrep
$env:RIPGREP_CONFIG_PATH = "~/.ripgreprc"

# c/c++
$env:CC = "gcc"
$env:CXX = "g++"

# rust
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"
$env:CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse"
$env:CARGO_SOURCE_CRATES_IO_REPLACE_WITH = "rsproxy"
$env:CARGO_SOURCE_RSPROXY_REGISTRY = "sparse+https://rsproxy.cn/index/"

# go
$env:GOPROXY = "https://goproxy.cn,direct"
$env:GO111MODULE = "on"

# python
$env:UV_DEFAULT_INDEX = "https://pypi.tuna.tsinghua.edu.cn/simple"
$env:PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple"

# node
$env:NPM_CONFIG_REGISTRY = "https://registry.npmmirror.com"
$env:BUN_CONFIG_REGISTRY = $env:NPM_CONFIG_REGISTRY

# Wrangler
$env:WRANGLER_SEND_METRICS = "false"

# mise
$env:DOT_ROOT = "~/.local/share/chezmoi"
$env:NOTE_ROOT = "~/OneDrive/Notes"
$env:PROJECT_ROOT = "~/Projects"

# }}}

# PSReadLine {{{

# NOTE: PSReadLine should be updated in Windows PowerShell
# Install-Module -Name PSReadLine -AllowClobber -Force

# Improved command-line editing experience
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Vi # Windows
Set-PSReadLineOption -PredictionSource History

# }}}

# Keybindings {{{

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function AcceptSuggestion

# Helper to execute native fzf out-of-process (prevents pipeline crashes & respects nested quotes)
function Invoke-NativeFzf ($Command, $Opts) {
    $psi = [System.Diagnostics.ProcessStartInfo]::new("fzf.exe")
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.EnvironmentVariables["FZF_DEFAULT_COMMAND"] = $Command
    $psi.EnvironmentVariables["FZF_DEFAULT_OPTS"] = "$env:FZF_DEFAULT_OPTS $Opts"

    $proc = [System.Diagnostics.Process]::Start($psi)
    $output = $proc.StandardOutput.ReadToEnd()
    $proc.WaitForExit()

    return if ($output) { $output.Trim() } else { $null }
}

# Ctrl+R: History
Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock {
    $hist = (Get-PSReadLineOption).HistorySavePath

    if (Test-Path $hist) {
        $cmd = Get-Content $hist -Tail 2000 | Select-Object -Unique | fzf --tac
        if ($cmd) {
            [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($cmd.Trim())
        }
    }
}

# Ctrl+T: Files
Set-PSReadLineKeyHandler -Chord "Ctrl+t" -ScriptBlock {
    $path = Invoke-NativeFzf $env:FZF_CTRL_T_COMMAND $env:FZF_CTRL_T_OPTS

    if ($path) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert((If ($path -match " ") { '"' + $path + '"' } Else { $path }))
    }
}

# Alt+C: Directories
Set-PSReadLineKeyHandler -Chord "Alt+c" -ScriptBlock {
    $dir = Invoke-NativeFzf $env:FZF_ALT_C_COMMAND $env:FZF_ALT_C_OPTS

    if ($dir) {
        Set-Location $dir
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}

# }}}

# Aliases {{{

Set-Alias alias Set-Alias
Set-Alias ipconfig Get-NetIPAddress
Set-Alias reboot Restart-Computer
Set-Alias shutdown top-Computer
Set-Alias v nvim
Set-Alias vi nvim
Set-Alias f fzf
Set-Alias py python
Set-Alias pn pnpm

function .. {
    Set-Location ..
}
function path {
    $env:Path -split ';'
}
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function Remove-DefaultAlias {
    param ($name, $scope = 'Global')

    if (Get-Alias $name -ErrorAction SilentlyContinue) {
        Remove-Item -Path "Alias:\$name" -Force -ErrorAction SilentlyContinue
    }
}

# Git
Remove-DefaultAlias gc
Remove-DefaultAlias gp
function ga {
    git add $args
}
function gb {
    git branch $args
}
function gc {
    git commit $args
}
function gC {
    git commit --amend $args
}
function gd {
    git diff $args
}
function gf {
    git fetch $args
}
function gl {
    git log $args
}
function gp {
    git push $args
}
function gP {
    git push --force $args
}
function gr {
    git rebase $args
}
function grc {
    git rebase --continue $args
}
function gri {
    git rebase --interactive $args
}
function gs {
    git stash
}
function gt {
    git status
}
function gu {
    git pull --rebase $args
}
Set-Alias gg lazygit

# Chezmoi
function cz {
    chezmoi $args
}
function cza {
    chezmoi apply $args
}
function czc {
    chezmoi cd $args
}
function czd {
    chezmoi destroy $args
}
function cze {
    chezmoi edit $args
}
function czu {
    chezmoi update $args
}

function vf {
    param([Parameter(ValueFromRemainingArguments)]$Target)

    $Path = if ($Target) {
        Get-Item $Target -ErrorAction SilentlyContinue
    } else {
        Get-Item .
    }

    if (-not $Path) {
        return Write-Warning "Path '$Target' not found."
    }

    if ($Path.PSIsContainer) {
        $Selected = fzf

        if ($Selected) {
            # Use .FullName to avoid the "Path is null" error
            $FullPath = Join-Path $Path.FullName $Selected
            & $env:EDITOR "$FullPath"
        }
    } else {
        # If it's already a file, open it directly
        & $env:EDITOR "$($Path.FullName)"
    }
}

function dot($Target) {
    Push-Location $env:DOT_ROOT
    vf $Target
    Pop-Location
}

function note([string]$NoteName) {
    Push-Location $env:NOTE_ROOT

    if (-not [string]::IsNullOrEmpty($NoteName)) {
        if (-not (Test-Path $NoteName)) {
            New-Item -ItemType File -Path $NoteName -Force | Out-Null
            Write-Host "Created new note: $NoteName" -ForegroundColor Cyan
        }
        & $env:EDITOR "$NoteName"
    } else {
        vf .
    }

    Pop-Location
}

Register-ArgumentCompleter -CommandName vf -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    Get-ChildItem -Name "$wordToComplete*"
}

Register-ArgumentCompleter -CommandName dot -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    Get-ChildItem -Path $env:DOT_ROOT -Name | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName note -ParameterName NoteName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    Get-ChildItem -Path $env:NOTE_ROOT -Name | Where-Object { $_ -like "$wordToComplete*" }
}

# }}}

# Tools {{{

# Cache the init scripts in cache dir
$CacheDir = Join-Path $env:TEMP "\powershell"
if (-not (Test-Path $CacheDir)) {
    New-Item -ItemType Directory -Path $CacheDir | Out-Null
}

# Init tool with cache: cache_init <command> [args...]
function Import-CachedInit {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Tool,
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )

    $InitPath = Join-Path $CacheDir "$Tool.ps1"

    if (-not (Test-Path $InitPath)) {
        & $Tool $Args | Out-String | Set-Content -Path $InitPath
    }

    . $InitPath
}

# Mise
# Import-CachedInit mise activate pwsh

# Starship
Import-CachedInit starship init powershell --print-full-init
Set-PSReadLineOption -ViModeIndicator None

# Zoxide
Import-CachedInit zoxide init powershell

if ($IsPowerShellCore) {
    # Carapace
    $env:CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"
    $env:CARAPACE_MATCH = "CASE_INSENSITIVE"
    Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
    Import-CachedInit carapace _carapace powershell

}

# Bun {{{

# Registery completions for `bun run`
Register-ArgumentCompleter -CommandName bun -Native -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $tokens = $commandAst.ToString() -split '\s+'

    if ($tokens.Count -ge 2 -and $tokens[1] -eq 'run' -and $tokens.Count -le 3) {
        $packageJsonPath = Join-Path (Get-Location) 'package.json'
        if (Test-Path $packageJsonPath) {
            try {
                $packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
                $scriptNames = $packageJson.scripts.PSObject.Properties.Name
                $scriptNames | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
            } catch {
            }
        }
    }
}

# }}}

# }}}

