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

alias grep="grep --color=auto"
alias ls="ls --color"
alias homeshick="$HOME/.homesick/repos/homeshick/home/.homeshick"

