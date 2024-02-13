# Dotfiles

Uses GNU stow to manage symlinking configuration files.

## Installation

Ensure stow is installed.

### Linux
```
$ apt install stow
```

### Mac
```
$ brew install stow
```

Then, checkout the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/DoggettCK/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks.

```
$ stow .
```
