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
BREW_EXE=/opt/homebrew/bin/brew
BREWFILE="${PACKAGES_DIR}/Brewfile"

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
    info_msg "Installing packages via Brew"
    eval "$($BREW_EXE shellenv)"
    brew bundle -v --file "$BREWFILE"
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
    info_msg "Symlinking configs via Stow"
    stow_packages "eza" "fzf" "git-number" "kitty" "lazygit" "neovim" "tmux" "vim" "zsh"
}

main() {
    pushd "$DOTFILES_DIR" >/dev/null 2>&1 || exit 127

    install_or_update_brew

    brew_bundle

    stow_everything

    initialize_submodules

    popd >/dev/null 2>&1 || exit 127
}

main
