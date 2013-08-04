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

function close_bracket {
    branch=$(parse_git_branch)
    if [ -z "$branch" ]
    then
        printf ""
    else
        printf ")"
    fi
}
# Show git branch in the terminal status line
export PS1='\u:\w$(open_bracket)\[$(tput setaf 2)\]$(pretty_branch)\[$(tput sgr0)\]$(close_bracket)\$ '

export PATH=$PATH:$HOME/bin
export EDITOR="vim"

# Adding z.sh if any
if [ -e $HOME/prog/z ]; then
    . $HOME/prog/z/z.sh
fi

alias grep="grep --color=auto"
alias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"
alias ls="ls --color"
alias tmux="TERM=screen-256color tmux"

if [ "$(uname)" == "Darwin" ]; then
    # Setup for Mac OS X platform
    # Add MacPorts bin paths
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    export MANPATH=/opt/local/share/man:$MANPATH
    alias ls="gls --color"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Setup for Linux platform
    :
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Setup for WinNT platform
    :
fi
