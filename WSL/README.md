# Dotfiles for [WSL](https://learn.microsoft.com/en-us/windows/wsl/wsl-config)

## .wslconfig

Configure global settings with [.wslconfig](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig) across all installed distributions running on WSL.

- Can be used only for distributions run by WSL 2. Distributions running as WSL 1 will not be affected by this configuration as they are not running as a virtual machine.
- The .wslconfig file does not exist by default. It must be created and stored in your `%UserProfile%` directory to apply these configuration settings.
- To get to your `%UserProfile%` directory, in PowerShell, use `cd ~` to access your home directory (which is typically your user profile,
  `C:\Users\<UserName>`) or you can open Windows File Explorer and enter `%UserProfile%` in the address bar. The directory path should look something like: `C:\Users\<UserName>\.wslconfig`.

## wsl.conf

Configure local settings with wsl.conf per-distribution for each Linux distribution running on WSL 1 or WSL 2.

- Can be used for distributions run by either version, WSL 1 or WSL 2.
- Stored in the `/etc` directory of the distribution as a unix file.
- To get to the /etc directory for an installed distribution, use the distribution's command line with `cd /` to access the root directory,
  then ls to list files or `explorer.exe .` to view in Windows File Explorer. The directory path should look something like: `/etc/wsl.conf`.
