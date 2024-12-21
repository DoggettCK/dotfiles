#! /bin/bash
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
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

ZSH_THEME="powerlevel10k/powerlevel10k"

export EDITOR='vim'
export LANG=en_US.UTF-8

DEFAULT_USER=$(whoami)

export DEFAULT_USER
export FZF_DEFAULT_COMMAND='rg --files'

if [[ $(uname) == 'Linux' ]]; then
    export TERM=xterm-256color
fi

# Completion plugins
plugins=(jump encode64 httpie urltools web-search asdf zsh-autosuggestions)
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

if which fzf > /dev/null; then
  # Set up fzf key bindings and fuzzy completion
  eval "$(fzf --zsh)"

  export PATH=~/.local/bin/:$PATH
  # be sure to install fd-find (TODO: Figure out cross-system dependency install)
  # apt install fd-find
  # brew install fd
  # ln -s $(which fdfind) ~/.local/bin/fd
  # TODO: Make sure ~/.local/bin is in $PATH
  # Use fd instead of fzf
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type = d --hidden --strip-cwd-prefix --exclude .git"

  # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
