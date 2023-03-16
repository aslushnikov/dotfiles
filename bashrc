function bupdate {
    source ~/.bash_profile
}

function set_command_prompt {
    # Show git branch in the terminal status line
    PS1='aslushnikov:\w$ '

    # if not inside git repo - do nothing.
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      return
    fi
    branch=""
    if ! git show-ref -q --verify HEAD; then
      branch="no HEAD";
    else
      branch=$(git rev-parse --abbrev-ref HEAD)
      if [ "$branch" = "HEAD" ]
      then
        branch="HEAD detached at $(git rev-parse --short HEAD)"
      fi
    fi
    PS1="aslushnikov:\w(\[$(tput setaf 2)\]$branch\[$(tput sgr0)\])$ "
}

PROMPT_COMMAND=set_command_prompt

export EDITOR="vim"

alias tmux="TERM=screen-256color tmux"
alias ls="exa"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Fuzzy search: https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Git Bash completions: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

if [[ "$(uname)" == "Darwin" ]]; then
    # silence bash deprecation warning on Big Sur (11.0+)
    export BASH_SILENCE_DEPRECATION_WARNING=1
    # HomeBrew setup
    eval "$(/opt/homebrew/bin/brew shellenv)"
    [ -f $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion

    export FF=/Volumes/Progged/firefox/obj-build-playwright/dist/Nightly.app/Contents/MacOS/firefox
    export WK=/Users/aslushnikov/prog/playwright/browser_patches/webkit/pw_run.sh
    export CR=/Volumes/Progged/chromium/output/chrome-mac/Chromium.app/Contents/MacOS/Chromium
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Setup for Linux platform
    alias xclip="xclip -selection c"
    alias ls="ls --color=auto"

    export FF=/home/aslushnikov/firefox/obj-build-playwright/dist/bin/firefox
    export WK=/home/aslushnikov/webkit/pw_run.sh
    export CR=/home/aslushnikov/chromium/output/chrome-linux/chrome
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Setup for WinNT platform
    :
fi

# Load cargo
source "$HOME/.cargo/env"
export PATH="$HOME/prog/bin:$PATH"

# Load NVM and NVM bash completions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
