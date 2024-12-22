#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]; then
  brew install stow
  brew install fd
  brew install git-delta
  brew install eza
  brew install bat
  brew install ripgrep
  brew install zoxide
  brew install zsh-autosuggestions
  brew install zsh-syntax-highlighting
  brew install font-meslo-lg-nerd-font
else
  sudo apt-get install stow
  sudo apt-get install fd-find
  sudo apt-get install eza
  sudo apt-get install git-delta
  sudo apt-get install bat
  sudo apt-get install ripgrep
  sudo apt-get install zoxide
  sudo apt-get install zsh-autosuggestions
  sudo apt-get install zsh-syntax-highlighting

  echo "Download MesloLG Nerd Font from https://www.nerdfonts.com and install via Windows"

  if [[ -L ~/.local/bin/fd ]]; then
    echo "Found symlink to fdfind at ~/.local/bin/fd"
  else
    echo "Linking $(which fdfind) to ~/.local/bin/fd"
    ln -s "$(which fdfind)" ~/.local/bin/fd
  fi
fi

git submodule update --init --recursive
# TODO: Don't clone if existing
echo "Cloning romkatv/powerlevel10k.git"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" > /dev/null 2>&1
echo "Cloning zsh-users/zsh-autosuggestions.git"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions > /dev/null 2>&1
echo "Cloning zsh-users/zsh-syntax-highlighting.git"
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting > /dev/null 2>&1
