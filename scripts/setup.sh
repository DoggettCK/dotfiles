#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info_msg() {
    echo -e "${GREEN}${1}${NC}"
}

warning_msg() {
    echo -e "${YELLOW}${1}${NC}"
}

error_msg() {
    echo -e "${RED}${1}${NC}"
}

# Detect OS
shopt -s nocasematch
case $(uname -a) in
*"Arch"*) OS="Arch" ;;
*"Darwin"*) OS="Darwin" ;;
*)
    if command -v pacman >/dev/null 2>&1; then
        OS="Arch"
    else
        OS="Linux"
    fi
    ;;
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
    BREWFILE="${BUNDLE_DIR}../packages/Brewfile"
    ;;
Arch)
    SYSTEM_PACKAGES="${BUNDLE_DIR}../packages/packages.arch"
    ;;
*)
    BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew
    BREWFILE="${BUNDLE_DIR}../packages/Brewfile.linux"
    SYSTEM_PACKAGES="${BUNDLE_DIR}../packages/packages.linux"
    ;;
esac

brew_update() {
    eval "$($BREW_EXE update)"
}

brew_bundle() {
    eval "$($BREW_EXE shellenv)"
    brew bundle -v --file "$@"
}

install_or_update_brew() {
    if [[ ! -x "$BREW_EXE" ]]; then
        info_msg "Installing Homebrew"
        $(command -v bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        info_msg "Updating Homebrew"
        brew_update
    fi
}

stow_package() {
    info_msg "Symlinking ${1} config with stow"
    stow -R -v -t ~ "$1"
}

stow_everything() {
    stow_package "fzf"
    stow_package "git-number"
    stow_package "neovim"
    stow_package "tmux"
    # TODO: Tear vim down to nothing
    # TODO: Move packages under scripts
    stow_package "vim"
    stow_package "zsh"
}

initialize_submodules() {
    # Git submodules include fzf-git.sh and git-number
    info_msg "Updating git submodules"
    git submodule update --init --recursive --remote
}

install_arch_packages() {
    sudo pacman -S - <"$SYSTEM_PACKAGES"
}

install_ubuntu_packages() {
    sudo apt install $(
        grep -vE "^\s*#" packages/packages.linux |
            tr "\n" " "
    )
}

main() {
    case "$OS" in
    Arch)
        info_msg "Arch-specific installation"
        info_msg "Installing packages via Pacman"
        install_arch_packages
        info_msg "Symlinking configs via Stow"
        stow_everything
        ;;
    Darwin)
        info_msg "OSX-specific installation"
        info_msg "Installing or updating Brew"
        install_or_update_brew
        info_msg "Installing packages via Brew"
        brew_bundle "$BREWFILE"
        info_msg "Symlinking configs via Stow"
        stow_everything
        ;;
    *)
        info_msg "Generic system installation"
        info_msg "Installing packages via Apt"
        install_ubuntu_packages
        info_msg "Installing or updating Brew"
        install_or_update_brew
        info_msg "Installing packages via Brew"
        brew_bundle "$BREWFILE"
        info_msg "Symlinking configs via Stow"
        stow_everything
        error_msg "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via system"
        ;;
    esac

    initialize_submodules
}

main
