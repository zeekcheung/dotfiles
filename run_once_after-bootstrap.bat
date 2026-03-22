@echo off
SETLOCAL EnableDelayedExpansion

echo Installing packages...

:: List of required packages
set PACKAGES=^
 jdx.mise

:: List of optional/commented packages
:: Tencent.WeChat.Universal
:: Tencent.QQ.NT
:: Tencent.QQMusic
:: Daum.PotPlayer
:: ClashVergeRev.ClashVergeRev
:: voidtools.Everything
:: Microsoft.PowerToys
:: 9NBLGGH5R558
:: Microsoft.WindowsTerminal
:: Microsoft.PowerShell
:: Nushell.Nushell
:: Neovim.Neovim.Nightly
:: tree-sitter.tree-sitter-cli ^
:: BrechtSanders.WinLibs.POSIX.UCRT ^
:: 7zip.7zip
:: GnuWin32.Gzip
:: Rime.Weasel
:: ZedIndustries.Zed

for %%p in (%PACKAGES%) do (
    echo Installing: %%p
    winget install --id "%%p" --silent --accept-source-agreements --accept-package-agreements
)

echo Installation done!

echo Installing dev tools...

"%USERPROFILE%\AppData\Local\Microsoft\Winget\Links\mise.exe" install

set "MISE_SHIMS=%USERPROFILE%\AppData\Local\mise\shims"

echo %PATH% | findstr /C:"%MISE_SHIMS%" >nul
if %errorlevel% neq 0 (
    echo Adding %MISE_SHIMS% to User PATH...
    setx PATH "%PATH%;%MISE_SHIMS%"
) else (
    echo mise shims are already in the PATH.
)

echo Installation done!

:: echo Installing rime-ice...

:: set "RIME_DIR=%APPDATA%\Rime"

:: NOTE: SWITCH TO A DIFFERENT INPUT METHOD (e.g., US English), if Rime is active.
:: Otherwise windows will lock the database files (.log/.LOCK) and this script WILL fail.
:: taskkill /f /im "WeaselServer.exe" /t >nul 2>&1
:: taskkill /f /im "WeaselDeployer.exe" /t >nul 2>&1

:: rd /s /q "%APPDATA%\Rime"

:: git clone https://v6.gh-proxy.org/https://github.com/iDvel/rime-ice.git "%RIME_DIR%" --depth 1

:: NOTE: Apply custom config MANUALLY
:: chezmoi apply ~/AppData/Roaming/Rime
