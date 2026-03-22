:: vim: foldmethod=marker
:: chezmoi.template.delimiter: left-delimiter=":: [[" right-delimiter="]]"

@echo off
chcp 65001 >nul
SETLOCAL EnableDelayedExpansion

:: Environment {{{

:: PowerShell
setx POWERSHELL_TELEMETRY_OPTOUT 1
setx POWERSHELL_UPDATECHECK Off

:: }}}

:: Packages {{{

echo Installing packages...

set PACKAGES=^
  jdx.mise
  :: Tencent.WeChat.Universal
  :: Tencent.QQ.NT
  :: Tencent.QQMusic
  :: Daum.PotPlayer
  :: voidtools.Everything
  :: Microsoft.PowerToys
  :: Microsoft.WindowsTerminal
  :: Microsoft.PowerShell
  :: Nushell.Nushell
  :: Neovim.Neovim
  :: ZedIndustries.Zed
  :: Rime.Weasel
  :: 7zip.7zip
  :: GnuWin32.Gzip
  :: Bitwarden.Bitwarden
  :: BrechtSanders.WinLibs.POSIX.UCRT
  :: FelixZeller.markdown-oxide

for %%p in (%PACKAGES%) do (
  echo Installing: %%p
  winget install --id "%%p" --source winget --silent --accept-source-agreements --accept-package-agreements
)

echo Installation done!

:: }}}

:: Dev Tools {{{

echo Installing dev tools...

"%LOCALAPPDATA%\Microsoft\Winget\Links\mise.exe" install

:: PATH {{{

set MISE_SHIMS_PATH="%LOCALAPPDATA%\mise\shims"

:: Backup PATH
reg export "HKCU\Environment" "%TEMP%\PATH_Backup.reg" /y >nul 2>&1

:: Check if mise shims are in the PATH
echo %PATH% | findstr %MISE_SHIMS_PATH% >nul

:: Add mise shims to the PATH
if %errorlevel% neq 0 (
	echo Adding %MISE_SHIMS_PATH% to User PATH...

	powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('Path','User'); if($p -notmatch [regex]::Escape('%MISE_SHIMS_PATH:\=\\%')){[Environment]::SetEnvironmentVariable('Path',\"$p;%MISE_SHIMS_PATH%\",'User')}"
) else (
	echo mise shims are already in the PATH.
)

:: }}}

:: }}}

echo Installation done!

