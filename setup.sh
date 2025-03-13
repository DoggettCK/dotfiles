#!/usr/bin/env bash

case "$(uname)" in
  Darwin) BREW_EXE=/opt/homebrew/bin/brew ;;
  *) BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew ;;
esac

brew_update() {
  eval "$($BREW_EXE update)"
}

brew_bundle() {
  eval "$($BREW_EXE shellenv)"
  brew bundle -v
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
    stow_package "asdf"
    stow_package "fzf"
    stow_package "git"
    stow_package "kitty"
    stow_package "neovim"
    stow_package "tmux"
    stow_package "vim"
    stow_package "zsh"
}

install_languages_with_asdf() {
    # Install programming languages via ASDF (versions in .tool-versions)
    echo "Installing plugins and languages via ASDF specified in ~/.tool-versions"
    cut -d ' ' -f 1 <asdf/.tool-versions |
        tr '\n' '\0' |
        xargs -0 -n1 asdf plugin add
    asdf install
}

initialize_submodules() {
    # Git submodules include fzf-git.sh and git-number
    echo "Updating git submodules"
    git submodule update --init --recursive --remote
}

main() {
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
        echo "Symlinking configs via Stow"
        stow_everything
        echo "Brew currently unsupported on NixOS, install via /etc/nixos/configuration.nix"
        # TODO: add instructions to output NixOS packages list
        # TODO: Make font warning
        echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via system"
        ;;
    Darwin)
        echo "OSX-specific installation"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle
        echo "Symlinking configs via Stow"
        stow_everything
        echo "Installing languages via ASDF"
        install_languages_with_asdf
        ;;
    WSL)
        echo "WSL-specific installation"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle
        echo "Symlinking configs via Stow"
        stow_everything
        echo "Installing languages via ASDF"
        install_languages_with_asdf
        echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via system"
        ;;
    *)
        echo "Generic system installation"
        echo "Installing or updating Brew"
        install_or_update_brew
        echo "Installing packages via Brew"
        brew_bundle
        echo "Symlinking configs via Stow"
        stow_everything
        echo "Installing languages via ASDF"
        install_languages_with_asdf
        ;;
    esac

    initialize_submodules
}

main
