source $HOME/.bashrc

if [ -e $HOME/.chromium.bash ]; then
    source $HOME/.chromium.bash
fi

if [ -e $HOME/.hostspecific.bash ]; then
    source $HOME/.hostspecific.bash
fi

export N_PREFIX=$HOME
export PATH=$N_PREFIX/bin:$HOME/bin:$PATH

