function bupdate {
    source ~/.bash_profile
}

function ff {
    find . -iname "*$@*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function open_bracket {
    branch=$(parse_git_branch)
    if [ -z "$branch" ]
    then
        printf ""
    else
        printf "("
    fi
}

function pretty_branch {
    branch=$(parse_git_branch)
    if [ -z "$branch" ]
    then
        printf ""
    else
        printf "$branch"
    fi
}

function makenewmac {
    echo "Old Mac: $(ifconfig en0 |grep ether)"
    local newMac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "I generated new: $newMac"
    echo "Setting the new mac..."
    sudo ifconfig en0 ether $newMac
    echo "Please, verify the mac is updated: $(ifconfig en0 |grep ether)"
}

function close_bracket {
    branch=$(parse_git_branch)
    if [ -z "$branch" ]
    then
        printf ""
    else
        printf ")"
    fi
}
if [ -e ~/.git-completion ]; then
    source ~/.git-completion
fi

# Show git branch in the terminal status line
export PS1='\u:\w$(open_bracket)\[$(tput setaf 2)\]$(pretty_branch)\[$(tput sgr0)\]$(close_bracket)\$ '

export EDITOR="vim"

alias grep="grep --color=auto"
alias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"
alias ls="ls --color=auto"
alias tmux="TERM=screen-256color tmux"
alias gg="git grep"
alias tass="tmux attach-session -t"

if [ "$(uname)" == "Darwin" ]; then
    # Setup for Mac OS X platform
    # Add MacPorts bin paths
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:$MANPATH
    alias ls="gls --color"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Setup for Linux platform
    alias xclip="xclip -selection c"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Setup for WinNT platform
    :
fi
