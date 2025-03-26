#!/usr/bin/env bash

# shellcheck disable=1091
source common/functions

OS=get_os_name
BUNDLE_DIR=get_script_directory
BREW_EXE=/opt/homebrew/bin/brew
BREWFILE="${BUNDLE_DIR}/packages/Brewfile"

if [[ "$OS" == "OSX" ]]; then
    info_msg "OSX Detected"
else
    error_msg "Running OSX install on non-OSX system."
    exit 1
fi

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

stow_everything() {
    stow_package "eza"
    stow_package "fzf"
    stow_package "git-number"
    stow_package "kitty"
    stow_package "lazygit"
    stow_package "neovim"
    stow_package "tmux"
    # TODO: Tear vim down to nothing
    stow_package "vim"
    stow_package "zsh"
}

main() {
    info_msg "OSX-specific installation"
    info_msg "Installing or updating Brew"
    install_or_update_brew
    info_msg "Installing packages via Brew"
    brew_bundle "$BREWFILE"
    info_msg "Symlinking configs via Stow"
    stow_everything
    initialize_submodules
}

main
