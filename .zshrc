#! /bin/bash
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path manipulation
if [[ $(uname) =~ "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ $(uname) =~ "Linux" ]]; then
  if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  
  fi
fi

LOCAL_BIN_PATH=~/.local/bin
GIT_NUMBER_PATH=~/.local/git-number

export PATH=$LOCAL_BIN_PATH:$GIT_NUMBER_PATH:$PATH
export GIT_EDITOR=nvim
export EDITOR=nvim

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# General
setopt noflowcontrol

DEFAULT_USER=$(whoami)

export BAT_THEME="base16-256"
export DEFAULT_USER
export EDITOR='vim'
export LANG=en_US.UTF-8
export LS_COLORS=$LS_COLORS:'ow=34;40:'
export TERM=xterm-256color

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
export HISTORY_IGNORE="(jrnl *)"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases

if [[ $(uname) =~ "WSL" ]]; then
  alias bat="batcat"
fi
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
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias mt='mix test'
alias mtw='mix test.watch'
alias phx='iex -S mix phx.server'
alias rm='rm -iv'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

[[ ! -f ~/.config/fzf/fzf-git.sh/fzf-git.sh ]] || source ~/.config/fzf/fzf-git.sh/fzf-git.sh

# SSH Agent
if command -v ssh-add > /dev/null 2>&1; then
  ssh-add -L &> /dev/null
  if [ $? -eq 1 ]; then
    ssh-add
  fi 
fi

# Functions
# Reset current branch to latest on Github
function git_reset() {
  git rev-parse --abbrev-ref --symbolic-full-name @\{u\} | xargs git reset --hard
}

# Reset and update all git submodules
function git_submodule_reset() {
  rm -rf submodules && git submodule init & git submodule update
}

# Delete all local git branches except the one passed in (defaults to main)
function git_nuke() {
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
function git_contributors() {
  git shortlog --summary --numbered --email --all
}

# Rename the given file to its md5 sum and lowercase extension
function mv_md5() {
  local filename;
  local md5_sum;
  local ext;
  filename="$1";
  md5_sum=$(md5sum "$filename" | cut -d " " -f 1);
  ext=$(echo "$filename" | rev | cut -d "." -f 1 | rev | tr '[:upper:]' '[:lower:]');
  mv "$1" "${md5_sum}.${ext}.tmp";
  mv "${md5_sum}.${ext}.tmp" "${md5_sum}.${ext}";
}

# Rename a given file (or all files) to remove common YTS tags
function clean_yts() {
  if [ "$#" -eq 0 ]; then
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" -- *
  else
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" "$@"
  fi

  return 0;
}

if command -v yazi > /dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

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
