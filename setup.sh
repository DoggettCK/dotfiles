#!/usr/bin/env bash

install_or_update_brew() {
    if [[ $(command -v brew) == "" ]]; then
        echo "Installing Homebrew"
        $(command -v bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Updating Homebrew"
        brew update
    fi
}

# Do OS-specific software installs
shopt -s nocasematch
case $(uname -a) in
*"NixOS"*) OS="NixOS" ;;
*"Darwin"*) OS="Darwin" ;;
*"WSL"*) OS="WSL" ;;
*) OS="Linux" ;;
esac

case "$OS" in
NixOS)
    echo "NixOS-specific installation"
    echo "Brew currently unsupported on NixOS, install via /etc/nixos/configuration.nix"
    # TODO: add instructions to output NixOS packages list
    echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via system"
    ;;
Darwin)
    echo "OSX-specific installation"
    install_or_update_brew
    echo "Installing packages via Brew"
    brew bundle
    ;;
WSL)
    echo "WSL-specific installation"
    install_or_update_brew
    echo "Installing packages via Brew"
    brew bundle
    ;;
esac

# Symlink everything
echo "Symlinking Alacritty config with stow"
stow -R -v -t ~ alacritty
echo "Symlinking ASDF config with stow"
stow -R -v -t ~ asdf
echo "Symlinking FZF config with stow"
stow -R -v -t ~ fzf
echo "Symlinking Git config with stow"
stow -R -v -t ~ git
echo "Symlinking Kitty config with stow"
stow -R -v -t ~ kitty
echo "Symlinking Neovim config with stow"
stow -R -v -t ~ neovim
echo "Symlinking Tmux config with stow"
stow -R -v -t ~ tmux
echo "Symlinking Vim config with stow"
stow -R -v -t ~ vim
echo "Symlinking ZSH config with stow"
stow -R -v -t ~ zsh

# Install programming languages via ASDF (versions in .tool-versions)
echo "Installing plugins and languages via ASDF specified in ~/.tool-versions"
cat asdf/.tool-versions | \
	cut -d ' ' -f 1 | \
	tr '\n' '\0' | \
	xargs -0 -n1 asdf plugin add
asdf install

# Git submodules include fzf-git.sh and git-number
echo "Updating git submodules"
git submodule update --recursive
