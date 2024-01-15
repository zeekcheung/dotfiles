# Dotfiles

My personal dotfiles.

## 🎉 Tools
- Terminal Emulators
  - [Alacritty](https://github.com/alacritty/alacritty)
  - [Wezterm](https://github.com/wez/wezterm/)
  - [Windows Terminal](https://github.com/microsoft/terminal)

- Editors
  - [Neovim](https://github.com/neovim/neovim)
  - [VScode](https://github.com/microsoft/vscode)

- Shell
  - [fish-shell](https://github.com/fish-shell/fish-shell)
  - [Nushell](https://github.com/nushell/nushell)
  - [PowerShell](https://github.com/PowerShell/PowerShell)
  - [starship](https://github.com/starship/starship)

- Command Line Tools
  - [bat](https://github.com/sharkdp/bat)
  - [bottom](https://github.com/ClementTsang/bottom?tab=readme-ov-file#scoop)
  - [eza](https://github.com/eza-community/eza)
  - [fd](https://github.com/sharkdp/fd)
  - [fzf](https://github.com/junegunn/fzf)
  - [lazygit](https://github.com/jesseduffield/lazygit)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [tmux](https://github.com/tmux/tmux)
  - [zoxide](https://github.com/ajeetdsouza/zoxide)

## ✅ Pre-requisites
- [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#install-powershell-using-winget-recommended)

## 🚀 Installation

1. Clone the repository.
```bash
# use https
git clone https://github.com/zeekcheung/dotfiles ~/.config

# or ssh
git clone git@github.com:zeekcheung/dotfiles.git ~/.config
```

2. Run the scripts.
```bash
# Windows
pwsh ~/.config/scripts/windows/Setup.ps1

# Ubuntu
bash ~/.config/scripts/ubuntu/Setup.sh
```