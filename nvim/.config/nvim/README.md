# Nvim

My personal configurations for [Neovim](https://neovim.io/).

## Installation

### Linux/MacOS

```bash
# Make a backup of current Neovim files:

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Clone the repository:
git clone git@github.com:zeekcheung/nvim.git ~/.config/nvim
```

### Windows

```bash
# Make a backup of current Neovim files:

# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak

# Clone the repository:
git clone git@github.com:zeekcheung/nvim.git $env:LOCALAPPDATA\nvim
```
