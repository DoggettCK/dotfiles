# Setup: Make sure fisher package manager is installed, then:
# fisher install catppuccin/fish
# fisher install patrickf1/fzf.fish
# fisher install gazorby/fifc

if status is-interactive
    # Commands to run in interactive sessions can go here
    set DEFAULT_USER $(whoami)
    set EDITOR nvim
    set GIT_EDITOR nvim
    set LANG en_US.UTF-8
    set LS_COLORS "$LS_COLORS:ow-34;40:"
    set TERM xterm-256color
    set XDG_CONFIG_HOME "$HOME/.config/"

    # Fish prepends to PATH by default
    fish_add_path "$HOME/.local/git-number"
    fish_add_path "$HOME/.local/bin"

    # ASDF setup
    set ASDF_FORCE_PREPEND true

    if set -q ASDF_DATA_DIR; and test -n ASDF_DATA_DIR
        fish_add_path "$ASDF_DATA_DIR/shims"
    else
        fish_add_path "$HOME/.asdf/shims"
    end

    # Homebrew setup
    if test -d /home/linuxbrew/.linuxbrew # Linux
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    else if test -d /opt/homebrew # MacOS
        eval (/opt/homebrew/bin/brew shellenv)
    end

    if type -q brew
        # Build options for Erlang
        set KERL_BUILD_DOCS yes
        set KERL_CONFIGURE_OPTIONS "--without-javac --with-ssl=$(brew --prefix openssl)"
        # Enable shell history for iex
        set ERL_AFLAGS "-kernel shell_history enabled"
    end

    # Git functions
    function git_reset
        # Reset current branch to latest on Github
        git rev-parse --abbrev-ref --symbolic-full-name @\{u\} | xargs git reset --hard
    end

    function git_submodule_reset
        # Reset and update all git submodules
        rm -rf submodules && git submodule init & git submodule update
    end

    function git_contributors
        # Get a list of all contributors to a repo
        git shortlog --summary --numbered --email --all
    end

    # Miscellaneous rename functions
    if type -q f2
        function clean_yts
            # Rename given (or all) dir(s) to remove anything between square
            # brackets that isn't [480p], [720p], [1080p], or [2160p].
            find . -maxdepth 1 -type d | f2 -id -f ' \[\D+\]' -r '' -f ' \[\d\.1\]' -r ''
        end

        function rename_md5
            # Rename all files not starting with an underscore to their md5.ext
            f2 -f '^[^_]+$' -r '{hash.md5}{ext}'
        end
    end

    # Load all SSH keys into ssh-agent, prompt for passphrase on first use.
    if type -q keychain
        keychain --eval --quiet | source
    end

    # Starship setup
    if type -q starship
        starship init fish | source
    end

    # FZF setup
    if type -q fzf
        fzf --fish | source
    end

    # Zoxide setup
    if type -q zoxide
        zoxide init --cmd cd fish | source
    end

    # Direnv setup
    if type -q direnv
        direnv hook fish | source
    end

    # Jump setup
    if type -q jump
        jump shell fish | source
    end

    # Yazi setup
    if type -q yazi
        function y
                set tmp (mktemp -t "yazi-cwd.XXXXXX")
                yazi $argv --cwd-file="$tmp"
                if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                    builtin cd -- "$cwd"
                end
                rm -f -- "$tmp"
            end
        end


    # Add Rust to path
    set -Ua fish_user_paths $HOME/.cargo/bin

    # gazorby/fifc setup
    set -Ux fifc_editor nvim
    set -U fifc_bat_opts --style=numbers
    set -U fifc_fd_opts --hidden
    set -U fifc_exa_opts --icons --tree

    # Aliases
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'
    alias ..... 'cd ../../../..'
    alias ga 'git number add'
    alias gcv 'git commit -v' # Commit with editor to see changes
    alias gd 'git number diff'
    alias gfp 'git push -f origin $(git rev-parse --abbrev-ref HEAD)'
    alias glp 'git log -p'
    alias gn 'git number --column'
    alias gnb 'git checkout -b' # Create new branch
    alias gpo 'git pull origin --ff-only'
    alias gpu 'git push -u'
    alias gsb 'git checkout -' # Switch to previous branch
    alias ism 'iex -S mix'
    alias ismt 'set MIX_ENV test ; iex -S mix'
    alias lg 'lazygit'
    alias ls 'ls --color=auto'
    alias mt 'mix test'
    alias mtw 'mix test.watch'
    alias phx 'iex --no-pry -S mix phx.server'
    alias tree 'exa -T --icons --color always'

    # Load override configs I don't want in source control
    if test -f "$HOME/.zshrc.override"
        source "$HOME/.zshrc.override"
    end
end
