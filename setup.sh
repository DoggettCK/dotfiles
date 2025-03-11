#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    $(command -v bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

# Do OS-specific software installs
case "$OSTYPE" in
darwin*)
    brew bundle
    ;;
linux*)
    echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via Windows"
    if (( $(uname -s) =~ "NixOS" )); then
        echo "Brew currently unsupported on NixOS"
        # TODO: add instructions to output NixOS packages list
    else
        echo "Installing packages via Brew"
        brew bundle
    fi
    ;;
*)
    echo "Unknown OS: ($OSTYPE)"
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
