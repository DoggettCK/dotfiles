#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]; then
  brew install fd eza zoxide zsh-autosuggestions zsh-syntax-highlighting
else
  sudo apt-get install fdfind eza zoxide zsh-autosuggestions zsh-syntax-highlighting
  ln -s $(which fdfind) ~/.local/bin/fd
fi


git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
