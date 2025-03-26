#!/usr/bin/env bash

SCRIPT_DIR=$(
    # shellcheck disable=2164
    cd "$(dirname "${BASH_SOURCE[0]}")"
    pwd -P
)
DOTFILES_DIR="$SCRIPT_DIR/.."
PACKAGES_DIR="$SCRIPT_DIR/packages"

# shellcheck disable=1091
source "$SCRIPT_DIR/common_functions"

OS=$(get_os_name)
SYSTEM_PACKAGES="${PACKAGES_DIR}/packages.arch"

if [[ "$OS" == "Arch" ]]; then
    info_msg "Arch Detected"
else
    error_msg "Running Arch install on non-Arch system."
    exit 1
fi

stow_everything() {
    info_msg "Symlinking configs via Stow"
    # TODO: Tear vim down to nothing
    stow_packages "eza" "fzf" "git-number" "hyprland" "kitty" "lazygit" "neovim" "tmux" "vim" "zsh"
}

install_pacman_packages() {
    # TODO: Separate packages into pacman/yay
    info_msg "Installing packages via Pacman"
    # shellcheck disable=2024
    sudo pacman -S - <"$SYSTEM_PACKAGES"
}

main() {
    pushd "$DOTFILES_DIR" >/dev/null 2>&1 || exit 127

    install_pacman_packages

    stow_everything

    initialize_submodules

    popd >/dev/null 2>&1 || exit 127
}

main
