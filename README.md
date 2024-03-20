# Nvim

A starter template for [Neovim](https://neovim.io/).

## Installation

### Windows

```bash
# Make a backup of your current Neovim files:

# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak

# Clone the starter:
git clone git@github.com:zeekcheung/nvim.git $env:LOCALAPPDATA\nvim
```

### Linux/MacOS

```bash
# Make a backup of your current Neovim files:

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Clone the starter:
git clone git@github.com:zeekcheung/nvim.git ~/.config/nvim
```
