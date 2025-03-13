#!/usr/bin/env bash

# Detect OS
shopt -s nocasematch
case $(uname -a) in
*"Arch"*) OS="Arch" ;;
*"Darwin"*) OS="Darwin" ;;
*) OS="Linux" ;;
esac

# Detect script directory
if [[ $BASH_SOURCE = */* ]]; then
    BUNDLE_DIR=${BASH_SOURCE%/*}/
else
    BUNDLE_DIR=./
fi

case "$OS" in
Darwin)
    BREW_EXE=/opt/homebrew/bin/brew
    BREWFILE="${BUNDLE_DIR}/../packages/Brewfile"
    ;;
Arch)
    BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew
    BREWFILE="${BUNDLE_DIR}/../packages/Brewfile.arch"
    SYSTEM_PACKAGES="${BUNDLE_DIR}/../packages/packages.arch"
    ;;
*)
    BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew
    BREWFILE="${BUNDLE_DIR}/../packages/Brewfile.linux"
    ;;
esac

brew_update() {
    eval "$($BREW_EXE update)"
}

brew_bundle() {
    eval "$($BREW_EXE shellenv)"
    brew bundle -v "$@"
}

install_or_update_brew() {
    if [[ ! -x "$BREW_EXE" ]]; then
        echo "Installing Homebrew"
        $(command -v bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Updating Homebrew"
        brew_update
    fi
}

stow_package() {
    echo "Symlinking ${1} config with stow"
    stow -R -v -t ~ "$1"
}

stow_everything() {
    stow_package "alacritty"
    stow_package "fzf"
    stow_package "git"
    stow_package "kitty"
    stow_package "neovim"
    stow_package "tmux"
    stow_package "vim"
    stow_package "zsh"
}

initialize_submodules() {
    # Git submodules include fzf-git.sh and git-number
    echo "Updating git submodules"
    git submodule update --init --recursive --remote
}

main() {
    case "$OS" in
    Arch)
        echo "Arch-specific installation"
        echo "Installing packages via Pacman"
        sudo pacman -S - <"$SYSTEM_PACKAGES"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle "$BREWFILE"
        echo "Symlinking configs via Stow"
        stow_everything
        ;;
    Darwin)
        echo "OSX-specific installation"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle "$BREWFILE"
        echo "Symlinking configs via Stow"
        stow_everything
        ;;
    *)
        echo "Generic system installation"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle "$BREWFILE"
        echo "Symlinking configs via Stow"
        stow_everything
        echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via system"
        ;;
    esac

    initialize_submodules
}

main
