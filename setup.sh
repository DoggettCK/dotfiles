#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]; then
  brew install bat
  brew install eza
  brew install fd
  brew install font-meslo-lg-nerd-font
  brew install fzf
  brew install git-delta
  brew install ripgrep
  brew install stow
  brew install tlrc
  brew install zoxide
  brew install neovim
  brew install lazygit
  brew install glow
else
  sudo apt-get install bat
  sudo apt-get install eza
  sudo apt-get install fd-find
  sudo apt-get install fzf
  sudo apt-get install git-delta
  sudo apt-get install ripgrep
  sudo apt-get install stow
  sudo apt-get install tldr
  sudo apt-get install zoxide
  brew install neovim
  brew install lazygit
  brew install glow

  echo "Download MesloLG Nerd Font from https://www.nerdfonts.com and install via Windows"

  if [[ -L ~/.local/bin/fd ]]; then
    echo "Found symlink to fdfind at ~/.local/bin/fd"
  else
    echo "Linking $(which fdfind) to ~/.local/bin/fd"
    ln -s "$(which fdfind)" ~/.local/bin/fd
  fi
fi

# Git submodules include fzf-git.sh and git-number
git submodule update --init --recursive
