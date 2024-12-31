# Dotfiles

Uses GNU stow to manage symlinking configuration files.

## Installation

Checkout the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/DoggettCK/dotfiles.git
$ cd dotfiles
```

Run `./setup.sh` to install all the software expected by `.zshrc`. If you're
using NeoVim, install it via [Homebrew](https://brew.sh/), which should
automatically be sourced by `.zshrc` if it exists, as that will have a much
newer version of NeoVim than `apt install neovim` currently provides.

Then, just use GNU stow to create symlinks for all of the config files.

```
$ stow .
```
