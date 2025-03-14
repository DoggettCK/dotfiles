# Dotfiles

Uses GNU stow to manage symlinking configuration files.

## Installation

Checkout the dotfiles repo in your $HOME directory using git

```bash
$ git clone git@github.com/DoggettCK/dotfiles.git
$ cd dotfiles
```

Run `./setup.sh` to install all the software expected by `.zshrc`. If you're
using NeoVim, install it via [Homebrew](https://brew.sh/), which should
automatically be sourced by `.zshrc` if it exists, as that will have a much
newer version of NeoVim than `apt install neovim` currently provides.

If you want to just install the config for a particular piece of software, for
example NeoVim, you can just run:

```bash
$ stow neovim
```

If you've cloned the repo somewhere other than your home directory, `stow`
defaults to putting the symlinks in the parent directory from where you run it,
so you need to target the `$HOME` directory, like:

```bash
$ stow -t ~ neovim
```

## Key remapping

My laptop has an extra backslash key next to a half-sized left Shift key, and I
also wanted to remap Caps Lock to Ctrl. [keyd](https://github.com/rvaiya/keyd/)
turned out to be the solution. Install it as a service and add the following to
`/etc/keyd/default.conf`, then run `sudo keyd reload`.

```
[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
capslock = overload(control, esc)

# Treat extra left backslash key as left shift
102nd = leftshift

# Remaps the escape key to capslock
# esc = capslock
```
