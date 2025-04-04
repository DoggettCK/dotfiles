#! /bin/bash
# General
setopt noflowcontrol

DEFAULT_USER=$(whoami)

export BAT_THEME="base16-256"
export DEFAULT_USER
export EDITOR="nvim"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export GIT_EDITOR="nvim"
export LANG=en_US.UTF-8
export LS_COLORS=$LS_COLORS:"ow=34;40:"
export TERM=xterm-256color
export XDG_CONFIG_HOME="$HOME/.config/"

## Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_space
# history will ignore anything starting with a space, but zsh doesn't respect
# $HISTORY_IGNORE, so alias commands I want to ignore to prepend a space.
alias jrnl=" jrnl"
alias lpass=" lpass"


LOCAL_BIN_PATH=~/.local/bin
GIT_NUMBER_PATH=~/.local/git-number
export PATH="$LOCAL_BIN_PATH:$GIT_NUMBER_PATH:$PATH"

if command -v asdf > /dev/null 2>&1; then
  export ASDF_FORCE_PREPEND=true
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

#
# Default postgres connection info
DB_USER=$( whoami )
export DB_USER
export DB_PASS=

case "$(uname)" in
  Darwin) BREW_EXE=/opt/homebrew/bin/brew ;;
  *) BREW_EXE=/home/linuxbrew/.linuxbrew/bin/brew ;;
esac

if [[ -x "$BREW_EXE" ]]; then
  eval "$($BREW_EXE shellenv)"
  # Elixir/Erlang compilation flags
  # Compile Erlang Docs
  export KERL_BUILD_DOCS=yes
  # Use correct ssl installation dir for Erlang compiler
  OPENSSL_DIR=$(eval "$BREW_EXE --prefix openssl")
  export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=${OPENSSL_DIR}"
fi

# Functions
# Reset current branch to latest on Github
git_reset() {
  git rev-parse --abbrev-ref --symbolic-full-name @\{u\} | xargs git reset --hard
}

# Reset and update all git submodules
git_submodule_reset() {
  rm -rf submodules && git submodule init & git submodule update
}

# Delete all local git branches except the one passed in (defaults to main)
git_nuke() {
  branch=${1:-main}
  echo -n "Are you sure you want to delete all git branches except \"$branch\"? " 
  read -r -k1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "git checkout $branch"
    git checkout "$branch"
    printf "git branch --no-color | awk '{gsub(/^[ \t*]+| [ \t]+$/,\"\"); print \$0}' | grep -v \"%s\" | xargs git branch -D\n" "$branch"
    git branch --no-color | awk '{gsub(/^[ \t*]+| [ \t]+$/,""); print $0}' | grep -v "$branch" | xargs git branch -D
  fi
}

# Get a list of all contributors to a repo
git_contributors() {
  git shortlog --summary --numbered --email --all
}

# Rename the given file to its md5 sum and lowercase extension
mv_md5() {
  local filename;
  local md5_sum;
  local ext;
  filename="$1";
  md5_sum=$(md5sum "$filename" | cut -d " " -f 1);
  ext=$(echo "$filename" | rev | cut -d "." -f 1 | rev | tr '[:upper:]' '[:lower:]');
  mv "$1" "${md5_sum}.${ext}.tmp";
  mv "${md5_sum}.${ext}.tmp" "${md5_sum}.${ext}";
}

clean_yts() {
  # Rename given (or all) dir(s) to remove anything between square brackets
  # that isn't [480p], [720p], [1080p], or [2160p].
  CLEAN_REGEX="s/ \[((?!(2160p|1080p|720p|480p)).)*\]//gi"

  if hash -v prename 2>/dev/null; then
    RENAME_EXE=prename
  elif [[ -x /usr/bin/vendor_perl/rename ]]; then
    RENAME_EXE=/usr/bin/vendor_perl/rename
  else
    RENAME_EXE=rename
  fi

  if [ "$#" -eq 0 ]; then
    "$RENAME_EXE" "$CLEAN_REGEX" -- *
  else
    "$RENAME_EXE" "$CLEAN_REGEX" "$@"
  fi

  return 0;
}

if command -v yazi > /dev/null 2>&1; then
  y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

# Load all SSH keys into a singleton ssh-agent
eval "$(keychain --eval --quiet)"

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
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

# Add in snippets
zinit snippet OMZP::asdf
zinit snippet OMZP::encode64
zinit snippet OMZP::git
zinit snippet OMZP::jump
zinit snippet OMZP::urltools
zinit snippet OMZP::web-search

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

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

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}' {}" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
  esac
}

# Aliases
command -v batcat > /dev/null 2>&1 && alias bat="batcat"
command -v hyprctl > /dev/null 2>&1 && alias hc="hyprctl"

alias ga='git number add'
alias gcv='git commit -v' # Commit with editor to see changes
alias gfp='git push -f origin $(git rev-parse --abbrev-ref HEAD)'
alias glp='git log -p'
alias gn='git number --column'
alias gnb='git checkout -b' # Create new branch
alias gpo='git pull origin --ff-only'
alias gpu='git push -u'
alias gsb='git checkout -' # Switch to previous branch
alias ism='iex -S mix'
alias ismt='MIX_ENV=test iex -S mix'
alias j='jump'
alias lg="lazygit"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias mt='mix test'
alias mtw='mix test.watch'
alias phx='iex -S mix phx.server'
alias rm='rm -iv'

# Load override config that I don't want in source control
[[ ! -f ~/.zshrc.override ]] || source ~/.zshrc.override
