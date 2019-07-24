function bupdate {
    source ~/.bash_profile
}

function ff {
    find . -iname "*$@*"
}

function set_command_prompt {
    # Show git branch in the terminal status line
    PS1='\u:\w$ '

    # if not inside git repo - do nothing.
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      return
    fi
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$branch" = "HEAD" ]
    then
      branch="HEAD detached at $(git rev-parse --short HEAD)"
    fi
    PS1="\u:\w(\[$(tput setaf 2)\]$branch\[$(tput sgr0)\])$ "
}

PROMPT_COMMAND=set_command_prompt

function makenewmac {
    echo "Old Mac: $(ifconfig en0 |grep ether)"
    local newMac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "I generated new: $newMac"
    echo "Setting the new mac..."
    sudo ifconfig en0 ether $newMac
    echo "Please, verify the mac is updated: $(ifconfig en0 |grep ether)"
}

export EDITOR="vim"

alias grep="grep --color=auto"
alias tmux="TERM=screen-256color tmux"
alias gg="git grep"

if [ "$(uname)" == "Darwin" ]; then
    # Setup for Mac OS X platform
    # Add MacPorts bin paths
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:$MANPATH
    alias ls="exa"
    # Bash completions
    [ -f $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Setup for Linux platform
    alias xclip="xclip -selection c"
    alias ls="ls --color=auto"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Setup for WinNT platform
    :
fi

# Fuzzy search: https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Git comlpetions: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
