#! /usr/bin/env bash
# shellcheck disable=1090 # paths of dynamic scripts are correct for this and 1091
# shellcheck disable=1091
# shellcheck disable=2086 # don't want double quotes on zstyle matcher-list
# shellcheck disable=2016 # don't want to expand expressions on zstyle matcher-list
# shellcheck disable=2034 # zsh's $path array is tied to $PATH, not unused
# shellcheck disable=2296 # syntax is correct for zstyle list-colors

# Uncomment this and last line if startup is slow to enable profiling
# zmodload zsh/zprof

# General
setopt noflowcontrol

DEFAULT_USER=$(whoami)

export DEFAULT_USER
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export LANG=en_US.UTF-8
export LS_COLORS=$LS_COLORS:"ow=34;40:"
export TERM=xterm-256color

# use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
# Tree for directories, syntax-highlighted contents for files
show_file_or_dir_preview='if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[5~" history-search-backward   # PgUp
bindkey "^[[6~" history-search-forward    # PgDn

if [[ $(uname) =~ "Darwin" ]]; then
  bindkey '\e[A' history-substring-search-up
  bindkey '\e[B' history-substring-search-down
elif [[ $(uname -a) =~ "WSL" ]]; then
  bindkey 'OA' history-substring-search-up
  bindkey 'OB' history-substring-search-down
else
  bindkey '\e[A' history-search-backward
  bindkey '\e[B' history-search-forward
fi

# History
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_space
# history will ignore anything starting with a space, but zsh doesn't respect
# $HISTORY_IGNORE, so alias commands I want to ignore to prepend a space.
alias jrnl=" jrnl"

LOCAL_BIN_PATH=~/.local/bin
export PATH="$LOCAL_BIN_PATH:$PATH"
# Drop duplicate PATH entries (nested shells, re-sourcing .zshrc, cargo env)
typeset -U path PATH

# Brew configuration. Must come before anything that checks for brew-installed
# commands (asdf, keychain, starship, ...) since it puts brew on PATH.
case "$(uname)" in
  Darwin) BREW_EXE=/opt/homebrew/bin/brew ;;
  *) BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew ;;
esac

if [[ -x "$BREW_EXE" ]]; then
  eval "$("$BREW_EXE" shellenv)"
  # Elixir/Erlang compilation flags
  # Compile Erlang Docs
  export KERL_BUILD_DOCS=yes
  # Use correct ssl installation dir for Erlang compiler
  OPENSSL_DIR=$("$BREW_EXE" --prefix openssl)
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=${OPENSSL_DIR}"
fi

# After brew so asdf's shims end up ahead of brew's bin on PATH
if command -v asdf >/dev/null; then
  export ASDF_FORCE_PREPEND=true
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

unalias open 2>/dev/null

# Linux only: macOS ships a real `open` binary, so skip this there
if (( ! $+commands[open] )); then
  open() {
    if (( $# == 0 )); then
      xdg-open . >/dev/null 2>&1 &!
      return
    fi

    local f
    for f in "$@"; do
      xdg-open "$f" >/dev/null 2>&1 &!
      (( $# > 1 )) && sleep 0.2
    done
  }
fi

# Functions
# Reset current branch to latest on Github
git_reset() {
  git rev-parse --abbrev-ref --symbolic-full-name @\{u\} | xargs git reset --hard
}

# Reset and update all git submodules
git_submodule_reset() {
  rm -rf submodules && git submodule init && git submodule update
}

# Delete all local git branches except the one passed in (defaults to main)
git_nuke() {
  local branch=${1:-main}
  echo -n "Are you sure you want to delete all git branches except \"$branch\"? " 
  read -r -k1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "git checkout $branch"
    git checkout "$branch"
    printf "git branch --no-color | awk '{gsub(/^[ \t*]+| [ \t]+$/,\"\"); print \$0}' | grep -vxF \"%s\" | xargs git branch -D\n" "$branch"
    git branch --no-color | awk '{gsub(/^[ \t*]+| [ \t]+$/,""); print $0}' | grep -vxF "$branch" | xargs git branch -D
  fi
}

# Get a list of all contributors to a repo
git_contributors() {
  git shortlog --summary --numbered --email --all
}

# Rename given (or all) dir(s) to remove anything between square brackets
# that isn't [480p], [720p], [1080p], or [2160p].
alias clean_yts="find . -maxdepth 1 -type d | f2 -id -f ' \[\D+\]' -r '' -f ' \[\d\.1\]' -r '' -f ' \[10bit\]' -r '' -f ' \[x265\]' -r ''"

# Rename all files not starting with an underscore to their md5.ext
alias rename_md5="f2 -f '^[^_]+$' -r '{hash.md5}{ext}'"

# Load all SSH keys into a singleton ssh-agent
if command -v keychain >/dev/null; then
  eval "$(keychain --eval --quiet)"
fi

# Enable shell history for iex
export ERL_AFLAGS="-kernel shell_history enabled"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

if [[ -r "$HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
fi

# Add in zsh plugins
zinit light zsh-users/zsh-completions
# Must load before plugins that wrap widgets (autosuggestions, syntax-highlighting)
# and before `fzf --zsh`, which then falls back to fzf-tab for non-** completion
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting

# # Add in snippets
zinit snippet OMZP::jump

# Load completions
autoload -Uz compinit
# Full compinit (with security audit) at most once a day; otherwise trust the
# cached dump. The (N.mh+24) glob qualifier matches the dump only if it's older
# than 24 hours, and works on both macOS and Linux unlike stat's flags.
_stale_zcompdump=(~/.zcompdump(N.mh+24))
if (( $#_stale_zcompdump )); then
  compinit
  # compinit only rewrites the dump when completions change, so bump its mtime
  touch ~/.zcompdump
else
  compinit -C
fi
unset _stale_zcompdump

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no                         # let fzf-tab replace the menu
zstyle ':completion:*:descriptions' format '[%d]'      # enables group headers
zstyle ':completion:*:git-checkout:*' sort false       # keep git's own ordering
zstyle ':fzf-tab:*' switch-group '<' '>'               # cycle completion groups
# __zoxide_z because `zoxide init --cmd cd` replaces cd
zstyle ':fzf-tab:complete:(cd|__zoxide_z):*' fzf-preview 'eza -1 --color=always $realpath'

# Shell integrations
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v fzf >/dev/null; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

if command -v yazi >/dev/null; then
  function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      IFS= read -r -d '' cwd < "$tmp"
      [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
      rm -f -- "$tmp"
  }
fi

# Add Rust tools to path if installed
[[ -f ~/.cargo/env ]] && source ~/.cargo/env

[[ ! -f ~/.config/fzf/fzf-git.sh/fzf-git.sh ]] || source ~/.config/fzf/fzf-git.sh/fzf-git.sh

# FZF completion functions

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --exclude .git . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  # Tab completion for things like `ssh **<Tab>` to get a list of
  # hosts.
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Aliases
alias gcv='git commit -v' # Commit with editor to see changes
alias gd_format='{ git diff --diff-filter=d --name-only HEAD -- "*.gd"; git ls-files --others --exclude-standard -- "*.gd"; } | sort -u | xargs -r gdscript-formatter'
alias gd_lint_all="find . -path ./addons -prune -o -type f -name '*.gd' -print | xargs -r gdscript-formatter lint --max-line-length 100 --pretty"
alias gd_lint='{ git diff --diff-filter=d --name-only HEAD -- "*.gd"; git ls-files --others --exclude-standard -- "*.gd"; } | sort -u | xargs -r gdscript-formatter lint --max-line-length 100 --pretty'
alias gd_reorder='{ git diff --diff-filter=d --name-only HEAD -- "*.gd"; git ls-files --others --exclude-standard -- "*.gd"; } | sort -u | xargs -r gdscript-formatter --reorder-code'
alias gfp='git push -f origin $(git rev-parse --abbrev-ref HEAD)'
alias glp='git log -p'
alias gnb='git checkout -b' # Create new branch
alias gpo='git pull origin --ff-only'
alias gpu='git push -u'
alias gsb='git checkout -' # Switch to previous branch
alias ism='iex -S mix'
alias ismt='MIX_ENV=test iex -S mix'
alias j='jump'
alias lg="lazygit"
alias mt='mix test'
alias mtw='mix test.watch'
alias phx='iex --no-pry -S mix phx.server'
alias quit='exit'
# Only prompt-on-delete in interactive shells; keep scripts/tools non-interactive
[[ -o interactive ]] && alias rm='rm -iv'
alias whatis='yay -Qi'
alias ls='ls --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Load override config that I don't want in source control
[[ ! -f ~/.zshrc.override ]] || source ~/.zshrc.override

# Uncomment for profiling data
# zprof
