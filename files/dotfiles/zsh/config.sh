# enable control-s and control-q
stty start undef
stty stop undef
setopt noflowcontrol

# add ssh keys
ssh-add -L &> /dev/null
if [ $? -eq 1 ]; then
  ssh-add
fi 

# thefuck plugin
if which thefuck > /dev/null; then
  eval "$(thefuck --alias)"
fi

# enable 'complete' support for autocompletion
if which compdef > /dev/null; then
  autoload bashcompinit
  bashcompinit
fi

if which chruby > /dev/null; then
  # chruby requirement
  source /usr/local/share/chruby/chruby.sh
  # chruby auto-select for ruby version
  source /usr/local/share/chruby/auto.sh
fi

if [[ -d $HOME/.rbenv ]]; then
  eval "$(rbenv init -)"
fi

