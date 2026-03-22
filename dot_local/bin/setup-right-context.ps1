#Requires -RunAsAdministrator

# Registers a file type with New menu and default open command on Windows

param (
    [string]$Extension  = ".txt",
    [string]$Command    = "notepad++.exe",
    [string]$DisplayName = "文本文档"
)

# Resolve executable from PATH
$exe = Get-Command $Command -ErrorAction SilentlyContinue
if (-not $exe) {
    Write-Host "Command not found: $Command" -ForegroundColor Red
    Exit
}

$classes = "HKCU:\Software\Classes"

# Create a ProgID name
$progId = "My" + $Extension.Substring(1) + "File"

# Register file extension -> ProgID
$extPath = Join-Path $classes $Extension
New-Item -Path $extPath -Force | Out-Null
Set-ItemProperty -Path $extPath -Name "(Default)" -Value $progId

# Register ProgID
$progPath = Join-Path $classes $progId
New-Item -Path $progPath -Force | Out-Null

# Set display name
Set-ItemProperty -Path $progPath -Name "(Default)" -Value $DisplayName

# Enable "New" menu
$shellNew = Join-Path $progPath "ShellNew"
New-Item -Path $shellNew -Force | Out-Null
Set-ItemProperty -Path $shellNew -Name "NullFile" -Value ""

# Set default open command
$openCmd = Join-Path $progPath "shell\open\command"
New-Item -Path $openCmd -Force | Out-Null
Set-ItemProperty -Path $openCmd -Name "(Default)" -Value "`"$($exe.Source)`" `"%1`""

Write-Host "✅ Registered '$Extension' as '$DisplayName'" -ForegroundColor Green

