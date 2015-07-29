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
        gclient sync --nohooks
        cd $HOME/IDE/third_party/WebKit
        git pull --rebase
        $HOME/IDE/build/gyp_chromium
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
        static . -p 8090 -H '{"Access-Control-Allow-Origin": "*","Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept"}'
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

export LAYOUT_TEST=$HOME/chromium/blink/tools/run_layout_tests.sh
function wkt() {
    bash $LAYOUT_TEST "$@"
}

function xwkt() {
   xvfb-run --server-args='-screen 0 1600x1200x24+32' $LAYOUT_TEST --no-show-results "$@"
}

function ewkt() {
    bash $LAYOUT_TEST --driver-logging "$@" 2>&1 | grep '^ERR:'
}

function exwkt() {
    bash $LAYOUT_TEST --driver-logging "$@" 2>&1 | grep '^ERR:'
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
    git pull --rebase
    gclient sync --nohooks
    cd $HOME/blink
    git pull --rebase
    $HOME/chromium/build/gyp_chromium
    c
    cd $olddir
}

function roll() {
    if (( $# == 0 )); then
        echo "usage: $0 <file_name>

This utility should be run from downstream CodeMirror version.
Symlink $HOME/CodeMirror should point to upstream version.
The method will search for <file_name> in CodeMirror upstream
folder and, if a single instance was found, will copy it to local
dir."
        return 1;
    fi
    local fileName=$1
    if ! [[ -e $fileName ]]; then
        echo "File $fileName is not found in the current directory."
        return 2;
    fi

    # goto upstream CodeMirror folder
    cd $HOME/CodeMirror
    local files=$(find . -name $fileName)
    cd - &>/dev/null

    local fileNumber=$(echo $files | wc -l)
    if (( $fileNumber > 1 )); then
        echo "Ambiguity for rolling instances
$files"
        return 3;
    fi
    if [[ -z $files ]]; then
        echo "Could not find $fileName in upstream"
        return 4;
    fi
    cp -v $HOME/CodeMirror/$files $fileName
}
