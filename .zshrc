#! /bin/bash
stty start undef
stty stop undef
setopt noflowcontrol

export HISTORY_IGNORE="(jrnl *)"
export LS_COLORS=$LS_COLORS:'ow=34;40:'

# Add ssh keys
if which ssh-add > /dev/null; then
  ssh-add -L &> /dev/null
  if [ $? -eq 1 ]; then
    ssh-add
  fi 
fi

# enable 'complete' support for autocompletion
if which compdef > /dev/null; then
  autoload bashcompinit
  bashcompinit
fi

export ZSH=~/.oh-my-zsh

ZSH_THEME="gentoo"

export EDITOR='vim'
export LANG=en_US.UTF-8

DEFAULT_USER=$(whoami)

export DEFAULT_USER
export FZF_DEFAULT_COMMAND='rg --files'

if [[ $(uname) == 'Linux' ]]; then
    export TERM=xterm-256color
fi

# Completion plugins
plugins=(jump encode64 httpie urltools web-search asdf)
export plugins

source "$ZSH/oh-my-zsh.sh"

function git_reset() {
  git rev-parse --abbrev-ref --symbolic-full-name @\{u\} | xargs git reset --hard
}

function git_submodule_reset() {
  rm -rf submodules && git submodule init & git submodule update
}

function git_nuke() {
  branch=${1:-master}
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

function git_contributors() {
  git shortlog --summary --numbered --email --all
}

if which jump > /dev/null; then
  alias j='jump'
fi

if which kitty > /dev/null; then
  alias theme='kitty +kitten themes'
fi

if [[ -e $HOME/.asdf/bin ]]; then
  if ! which asdf > /dev/null; then
    export PATH=$PATH:$HOME/.asdf/bin
  fi
fi

if [[ -e $HOME/git-number ]]; then
  if ! which git-number > /dev/null; then
    export PATH=$PATH:$HOME/git-number
  fi
fi

if which git-number > /dev/null; then
	alias gn='git number --column'
	alias ga='git number add'
fi

# Set up fzf key bindings and fuzzy completion
if which fzf > /dev/null; then
  eval "$(fzf --zsh)"
fi


if which iex > /dev/null; then
  alias ism='iex -S mix'
  alias ismt='MIX_ENV=test iex -S mix'
  alias phx='iex -S mix phx.server'
fi

if which mix > /dev/null; then
  alias mt='mix test'
  alias mtw='mix test.watch'
fi

alias gco='git checkout'
alias gcv='git commit -v' # Commit with editor to see changes
alias gd='git diff'
alias gfp='git push -f origin $(git rev-parse --abbrev-ref HEAD)'
alias glp='git log -p'
alias gnb='git checkout -b' # Create new branch
alias gpo='git pull origin --ff-only'
alias gpu='git push -u'
alias grim='git rebase -i master'
alias gsb='git checkout -' # Switch to previous branch

alias rm='rm -iv'

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

function clean_yts() {
  if [ "$#" -eq 0 ]; then
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" *
  else
    rename -e "s/ \[(YTS\...|5\.1|UPSCALE|REPACK|BluRay|WEBrip|x265|10bit|RUSSIAN|BOOTLEG|DVDRip|REMASTERED|CRITERION|EXTENDED CUT)\]//gi" "$@"
  fi

  return 0;
}
