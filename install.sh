#!/bin/bash

# Dotfiles Installation Script
# This script installs all required packages and sets up the dotfiles

set -e # Exit on error

echo "Starting dotfiles installation..."

# Install core packages
echo "Installing core packages..."
sudo pacman -S --needed git stow zsh starship zsh-autosuggestions zsh-syntax-highlighting fzf fd bat tmux neovim base-devel nodejs npm python python-pip unzip zip wget curl clang qt5-base lsd

# Install yay if not present
echo "Checking for yay AUR helper..."
if ! command -v yay &>/dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si
    cd ..
else
    echo "yay is already installed"
fi

# Install AUR packages
echo "Installing AUR packages..."
yay -S --needed zsh-vi-mode

# Clone Tmux Plugin Manager
echo "Installing Tmux Plugin Manager..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM is already installed"
fi

# Use GNU stow to create symlinks
echo "Creating symlinks with stow..."
stow .

# Install NVM
echo "Setting up NVM and Node.js..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# Set zsh as default shell permanently
echo "Setting zsh as default shell..."
chsh -s $(which zsh)

# Ensure zsh launches even if bash is started
echo "Configuring bashrc to launch zsh..."
if ! grep -q "exec zsh" ~/.bashrc 2>/dev/null; then
    echo '# Launch zsh if not already running' >>~/.bashrc
    echo '[ -z "$ZSH_VERSION" ] && exec zsh' >>~/.bashrc
fi

echo ""
echo "Installation complete!"
echo "Please restart your terminal or run 'exec zsh' to start using your new configuration."
