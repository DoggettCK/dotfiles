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
stow alacritty
stow asdf
stow fzf
stow git
stow kitty
stow neovim
stow tmux
stow vim
stow zsh

# Install programming languages via ASDF (versions in .tool-versions)
asdf install

# Git submodules include fzf-git.sh and git-number
git submodule update --recursive
