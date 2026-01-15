# My Dotfiles

This directory contains the dotfiles for my system.

## Installation

First, check out the dotfiles repo in your $HOME directory using git:

```bash
git clone git@github.com:Acrsahil/dotfiles.git
cd dotfiles
```

Then run the installation script:

```bash
chmod +x install.sh
./install.sh
```

After installation, restart your terminal or run `exec zsh` to start using your new configuration.

## What Gets Installed

- Shell: zsh with starship prompt, autosuggestions, and syntax highlighting
- Terminal Tools: fzf, fd, bat, lsd
- Editor: neovim with tmux
- Development: nodejs, npm, python, pip, nvm, clang
- Utilities: unzip, zip, wget, curl
- Plugins: Tmux Plugin Manager, zsh-vi-mode
