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
export PATH=$N_PREFIX/bin:$HOME/bin:$PATH

# MacPorts Installer addition on 2016-01-01_at_23:07:25: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.
