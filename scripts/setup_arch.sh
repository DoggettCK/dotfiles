#!/usr/bin/env bash

# shellcheck disable=1091
source common_functions

OS=get_os_name
BUNDLE_DIR=get_script_directory
SYSTEM_PACKAGES="${BUNDLE_DIR}/packages/packages.arch"

if [[ "$OS" == "Arch" ]]; then
    info_msg "Arch Detected"
else
    error_msg "Running Arch install on non-Arch system."
    exit 1
fi

stow_everything() {
    stow_package "eza"
    stow_package "fzf"
    stow_package "git-number"
    stow_package "hyprland"
    stow_package "kitty"
    stow_package "lazygit"
    stow_package "neovim"
    stow_package "tmux"
    # TODO: Tear vim down to nothing
    stow_package "vim"
    stow_package "zsh"
}

install_arch_packages() {
    # shellcheck disable=2024
    sudo pacman -S - <"$SYSTEM_PACKAGES"
}

main() {
    info_msg "Arch-specific installation"
    info_msg "Installing packages via Pacman"
    install_pacman_packages
    info_msg "Symlinking configs via Stow"
    stow_everything

    initialize_submodules
}

main
