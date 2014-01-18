source $HOME/.bashrc

if [ -e $HOME/.chromium.bash ]; then
    source $HOME/.chromium.bash
fi

if [ -e $HOME/.hostspecific.bash ]; then
    source $HOME/.hostspecific.bash
fi

# adding Z if any
if [ -e $HOME/prog/z/z.sh ]; then
    export _Z_NO_RESOLVE_SYMLINKS=1
    source $HOME/prog/z/z.sh
fi

export N_PREFIX=$HOME
if [ -e $HOME/depot_tools ]; then
    PATH=$HOME/depot_tools:$PATH
fi
export PATH=$N_PREFIX/bin:$HOME/bin:$PATH
