# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```
pacman -S git
```

### Stow

```
pacman -S stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
git clone git@github.com:Acrsahil/dotfiles.git
cd dotfiles
```

## Dependencies

Tpm (Tmux Plugins Manager)

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

then use GNU stow to create symlinks

```
stow .
```
