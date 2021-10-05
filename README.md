# My Dotfiles

An easy way to store my configuration files in git and auto-install them via
symlinks on a new system.

Run `script/setup` to make the magic happen.

## The Magic aka Auto-Symlinking

For me, in `zsh`, this is what running `script/setup` looks like:

```sh
$ script/setup
Installing Git shell configuration
Linking /Users/cdoggett/.gitshrc to /Users/cdoggett/dotfiles/files/gitshrc.txt
----------
Installing Global .gitignore configuration
Linking /Users/cdoggett/.gitignore_global to /Users/cdoggett/dotfiles/files/gitignore.txt
Running post-link command: git config --global core.excludesfile /Users/cdoggett/.gitignore_global
----------
Installing Input configuration
Linking /Users/cdoggett/.inputrc to /Users/cdoggett/dotfiles/files/inputrc.txt
----------
Installing Vim configuration
Unlinking existing .vimrc
Linking /Users/cdoggett/.vimrc to /Users/cdoggett/dotfiles/files/vimrc.txt
----------
Installing ZSH configuration
Unlinking existing .zshrc
Linking /Users/cdoggett/.zshrc to /Users/cdoggett/dotfiles/files/zshrc.txt
```

## Adding New Dotfiles

Simply add a file or directory to the `files/` path, and then add it to the
`config.txt`, with the values separated by the pipe ('|') character.

The first field should be a simple text description of what is being installed,
followed by the file name under the `/files` directory, then the name of the
file as it should be under your `~` directory.

Examples:

```sh
Vim configuration|vimrc.txt|.vimrc
```

### Optional Post-link Commands

A fourth field is supported, and if present in the config file, will be run via
`eval` after substituting any instance of `LINK_PATH` with the final link path.

Example:

```sh
git config --global core.excludesfile LINK_PATH
```

becomes

```sh
git config --global core.excludesfile /Users/cdoggett/.gitignore_global
```
