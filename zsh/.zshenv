# General
setopt noflowcontrol

DEFAULT_USER=$(whoami)

export BAT_THEME="base16-256"
export DEFAULT_USER
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export LANG=en_US.UTF-8
export LS_COLORS=$LS_COLORS:"ow=34;40:"
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
export HISTORY_IGNORE="jrnl*|lpass*"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


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

# Rename a given file (or all files) to remove common YTS tags
clean_yts() {
  if [ "$#" -eq 0 ]; then
      # TODO: Figure out how to clean this up
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" -- *
  else
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" "$@"
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

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

add_ssh_key ()
{
  key="${1:-$HOME/.ssh/id_rsa}"
  if [ -f "$key" ]; then
    echo "${GREEN}OK:${NC} Adding SSH key at $key"
    eval "$(keychain --quiet --eval --agents ssh "$key")"
  else
    echo "${RED}ERROR:${NC} No SSH key found at $key"
  fi
}

# SSH Key Caching
add_ssh_key ~/.ssh/id_rsa > /dev/null 2>&1;
add_ssh_key ~/.ssh/id_ed25519 > /dev/null 2>&1;


# Load override config that I don't want in source control
[[ ! -f ~/.zshenv.override ]] || source ~/.zshenv.override

