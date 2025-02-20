#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew"
    brew update
fi

osx_install() {
    # TODO: OSX Brewfile https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f
    brew install bat
    brew install eza
    brew install fd
    brew install font-jetbrains-mono-nerd-font
    brew install fzf
    brew install git-delta
    brew install ripgrep
    brew install stow
    brew install tlrc
    brew install zoxide
    brew install neovim
    brew install lazygit
    brew install glow
}

wsl_install() {
    brew bundle --file=./brewfiles/Brewfile.wsl

    echo "Download JetBrainsMono Nerd Font from https://www.nerdfonts.com and install via Windows"
}

# Do OS-specific software installs
case "$OSTYPE" in
darwin*)
    osx_install
    ;;
linux*)
    wsl_install
    ;;
*)
    echo "Unknown OS: ($OSTYPE)"
    ;;
esac

# Symlink everything
stow .

# Install programming languages via ASDF (versions in .tool-versions)
asdf install

# Git submodules include fzf-git.sh and git-number
git submodule update --recursive
