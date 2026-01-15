# My dotfiles

This directory contains the dotfiles for my system

# Requirements

Ensure you have the following installed on your system

# Git and Stow

sudo pacman -S git stow --needed

# Installation

First, check out the dotfiles repo in your $HOME directory using git
git clone git@github.com:Acrsahil/dotfiles.git
cd dotfiles

# Dependencies

# Install core packages, AUR helper, and all AUR packages in one command

sudo pacman -S --needed zsh starship fzf fd bat tmux neovim base-devel nodejs npm python python-pip yarn unzip zip wget curl clang qt5-base google-chrome lsd eza git base-devel && \

# Install yay if not present

if ! command -v yay &>/dev/null; then git clone https://aur.archlinux.org/yay.git ~/yay && cd ~/yay && makepkg -si && cd ..; fi && \

# Install AUR packages

yay -S --needed zsh-vi-mode && \

# Clone Tmux Plugin Manager

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \

# Use GNU stow to create symlinks

stow . && \

# Install NVM, Node LTS and use it

export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
nvm install --lts && \
nvm use --lts && \

# Set zsh as default shell permanently

chsh -s $(which zsh) && \

# Ensure zsh launches even if bash is started

echo '# Launch zsh if not already running' >> ~/.bashrc && \
echo '[ -z "$ZSH_VERSION" ] && exec zsh' >> ~/.bashrc
