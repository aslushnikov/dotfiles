export GYP_GENERATORS="ninja"
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
alias aloha="cd /var/www"
#export PATH=$HOME/goma:$HOME/chromium/third_party/llvm-build/Release+Asserts/bin:$PATH
#export CC=clang
#export CXX=clang++

# Main checkout management
function closure {
    cd $HOME/blink
    python ./Source/devtools/scripts/compile_frontend.py "$@"
    cd -
}

function rclean {
    cd $HOME/chromium
    rm -rf out/Release/*
    cd -
}

function dtclean {
    cd $HOME/chromium
    rm -rf out/Release/resources/inspector
    rm -rf out/Release/gen/devtools
    cd -
}

function dclean {
    cd $HOME/chromium
    rm -rf out/Debug/*
    cd -
}

function rgomoninja() {
    cd $HOME/chromium
    PATH=/usr/local/google/home/lushnikov/goma:$PATH ninja -j 200 -C out/Release "$@"
    cd -
}

function dgomoninja() {
    cd $HOME/chromium
    PATH=/usr/local/google/home/lushnikov/goma:$PATH ninja -j 200 -C out/Debug "$@"
    cd -
}

function not() {
    if (( $# == 0 )); then
        notify-send -u critical "Terminal" "Done."
    else
        notify-send -u critical "Terminal" "$@"
    fi
}

function c() {
    rgomoninja chrome "$@"
}

function r() {
    cd $HOME/chromium
    if [ "$(uname)" == "Darwin" ]; then
        # Setup for Mac OS X platform
        # Add MacPorts bin paths
        open ./out/Release/Chromium.app
    else
        ./out/Release/chrome "$@"
    fi
    cd -
}

alias ccd="cd $HOME/chromium"
alias ccw="cd $HOME/blink"
alias cci="cd $HOME/devtools"
alias landit="git cl dcommit"
alias tte="tt editor/"
alias cpcm="cp $HOME/prog/CodeMirror/lib/codemirror.* $HOME/devtools/front_end/cm/"

# devTools IDE checkout management

function wflow() {
    if (( $# == 0 )); then
        cd $HOME/IDE
        return
    fi
    local command=$1
    shift;

    if [[ $command == "up" ]]; then
        cd $HOME/IDE
        git pull origin master
        gclient sync
        return
    fi

    if [[ $command == "c" ]]; then
        cd $HOME/IDE
        PATH=/usr/local/google/home/lushnikov/goma:$PATH ninja -j 200 -C out/Release chrome
        return
    fi

    if [[ $command == "r" ]]; then
        cd $HOME/IDE
        # create data directory if it does not exist
        mkdir -p $HOME/ide-data/profile
        ./out/Release/chrome --remote-debugging-port=9222 --user-data-dir="$HOME/ide-data" "$@"
        return;
    fi

    if [[ $command == "serve" ]]; then
        cd $HOME/devtools
        static . -p 8090
        return;
    fi

    if [[ $command == "all" ]]; then
        wflow up
        wflow c
        wflow r "$@"
        return
    fi

    echo "wflow <command>
up - update sorces
c - compile
r - run
serve - serve front end
all - up + c + r"
}

function tt() {
    cd $HOME/chromium
    local path="inspector/"
    if (( $# == 1 )); then
        path="$path""$1"
    fi
    ./webkit/tools/layout_tests/run_webkit_tests.sh $path
    cd -
}

function wkt() {
    bash $HOME/chromium/webkit/tools/layout_tests/run_webkit_tests.sh "$@"
}

function xwkt() {
   xvfb-run --server-args='-screen 0 1600x1200x24+32' $HOME/chromium/webkit/tools/layout_tests/run_webkit_tests.sh --no-show-results "$@"
}

function ewkt() {
    bash $HOME/chromium/webkit/tools/layout_tests/run_webkit_tests.sh --driver-logging "$@" 2>&1 | grep '^ERR:'
}

function exwkt() {
    bash $HOME/chromium/webkit/tools/layout_tests/run_webkit_tests.sh --driver-logging "$@" 2>&1 | grep '^ERR:'
}

function gypi() {
    cd $HOME/chromium
    ./build/gyp_chromium
    cd -
}

function testGitRepositoryClear() {
    echo "Verifying clean state of $1"
    cd $1
    local branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ $branch != "master" ]]; then
        echo "chromium checkout is not on MASTER branch"
        return 1
    fi
    git diff --exit-code
    if (( $? != 0 )); then
        echo "chromium checkout is DIRTY"
        return 1
    fi
    cd -
    return 0;
}

function upd() {
    local olddir=$(pwd -L)
    echo "Updating chromium checkout"
    testGitRepositoryClear $HOME/chromium
    if (( $? != 0 )); then
        return 1;
    fi
    testGitRepositoryClear $HOME/blink
    if (( $? != 0 )); then
        return 1;
    fi
    cd $HOME/chromium
    git pull origin master
    gclient sync
    c
    cd $olddir
}
