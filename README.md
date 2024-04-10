# Dotfiles

My personal dotfiles for Linux (Arch && Ubuntu) and Windows.

## 🎉 Tools

- Terminal Emulators

  - [Alacritty](https://github.com/alacritty/alacritty)
  - [Kitty](https://github.com/kovidgoyal/kitty)
  - [Wezterm](https://github.com/wez/wezterm/)
  - [Windows Terminal](https://github.com/microsoft/terminal)

- Editors

  - [Neovim](https://github.com/neovim/neovim)
  - [VScode](https://github.com/microsoft/vscode)

- Shell

  - [zsh](https://www.zsh.org)
  - [fish](https://github.com/fish-shell/fish-shell)
  - [Nushell](https://github.com/nushell/nushell)
  - [PowerShell](https://github.com/PowerShell/PowerShell)
  - [starship](https://github.com/starship/starship)

- Command Line Tools
  - [bat](https://github.com/sharkdp/bat)
  - [bottom](https://github.com/ClementTsang/bottom?tab=readme-ov-file#scoop)
  - [eza](https://github.com/eza-community/eza)
  - [fzf](https://github.com/junegunn/fzf)
  - [lazygit](https://github.com/jesseduffield/lazygit)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [tmux](https://github.com/tmux/tmux)
  - [yazi](https://github.com/sxyazi/yazi)
  - [zoxide](https://github.com/ajeetdsouza/zoxide)

## ✅ Pre-requisites

- Windows
  - [Windows Terminal](https://apps.microsoft.com/detail/9N0DX20HK701?hl=zh-cn&gl=US)
  - [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#install-powershell-using-winget-recommended)

## 🚀 Installation

1. Clone the repository.

   ```bash
   # use https
   git clone https://github.com/zeekcheung/.dotfiles $HOME/.dotfiles

   # or ssh
   git clone git@github.com:zeekcheung/.dotfiles.git $HOME/.dotfiles
   ```

2. Run the setup scripts.

   ```bash
   cd $HOME/.dotfiles

   # Windows
   pwsh setup_windows.ps1

   # Ubuntu
   bash setup_ubuntu.sh
   ```
