if [ -e $HOME/prog/depot_tools ]; then
    PATH=$HOME/prog/depot_tools:$PATH
fi
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
#export PATH=$HOME/goma:$HOME/chromium/third_party/llvm-build/Release+Asserts/bin:$PATH
#export CC=clang
#export CXX=clang++

function wcanary {
    open  /Applications/Google\ Chrome\ Canary.app/ --args --user-data-dir="/tmp/canary" --remote-debugging-port=9223 --enable-devtools-experiments --custom-devtools-frontend=http://localhost:8090/front_end/ "http://localhost:9223#custom=true&experiments=true" aslushnikov.com "$@"
}

function wbeta {
    open  /Applications/Google\ Chrome\ Beta.app/ --args  --remote-debugging-port=9223 --enable-devtools-experiments --custom-devtools-frontend=http://localhost:8090/front_end/ "http://localhost:9223#custom=true&experiments=true" "$@"
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

function c() {
    rgomoninja chrome "$@"
}

function r() {
    cd $HOME/chromium
    if [ "$(uname)" == "Darwin" ]; then
        # Setup for Mac OS X platform
        # Add MacPorts bin paths
        open ./out/Release/Chromium.app --args "$@"
    else
        ./out/Release/chrome "$@"
    fi
    cd -
}

alias ccd="cd $HOME/chromium"
alias ccw="cd $HOME/blink"
alias cct="cd $HOME/layouttests/http/tests/devtools"
alias cci="cd $HOME/devtools"
alias landit="git cl dcommit"

# devTools IDE checkout management

function catt() {
    if (( $# == 0 )); then
        echo "catt <command> <test>
d - diff
a - actual
e - expected"
        return
    fi
    if (( $# == 1 )); then
        local command="d"
        local test=$1;
    elif (( $# == 2 )); then
        local command=$1
        local test=$2
    fi

    test=${test%.html}
    local suffix="";
    if [[ $command == "d" ]]; then
        suffix="-diff.txt";
    elif [[ $command == "a" ]]; then
        suffix="-actual.txt";
    elif [[ $command == "e" ]]; then
        suffix="-expected.txt";
    fi

    cat $HOME/chromium/out/Release/layout-test-results/${test}${suffix}
}

export LAYOUT_TEST="$HOME/chromium/blink/tools/run_layout_tests.sh --child-processes=7"
function wkt() {
    bash $LAYOUT_TEST "$@"
}

function twkt() {
    bash $LAYOUT_TEST --additional-drt-flag='--debug-devtools' --additional-drt-flag='--remote-debugging-port=9223' --time-out-ms=6000000 "$@"
}

function xwkt() {
   xvfb-run --server-args='-screen 0 1600x1200x24+32' $LAYOUT_TEST --no-show-results "$@"
}

function xtwkt() {
   xvfb-run --server-args='-screen 0 1600x1200x24+32' $LAYOUT_TEST --no-show-results --additional-drt-flag='--remote-debugging-port=9223' --time-out-ms=6000000 "$@"
}

function ewkt() {
    bash $LAYOUT_TEST --driver-logging "$@" 2>&1 | grep '^ERR:'
}

function exwkt() {
    bash $LAYOUT_TEST --driver-logging "$@" 2>&1 | grep '^ERR:'
}

function ggn {
    cd $HOME/chromium
    gn gen out/Release
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
    cd $HOME/chromium
    git pull --rebase
    gclient sync
    ggn
    c
    cd $olddir
}

function mystats() {
    local googleStartDate=`date -d "2012/10/22" +"%s"`
    local today=`date +"%s"`
    local gDays=$(echo "($today - $googleStartDate) / 86400" | bc)
    echo "gDays: $gDays"
    local patches=$(cd $HOME/chromium && git shortlog -s -n --author=lushnikov | cut -f1 | awk '{ sum += $1 } END { print sum }');
    echo "  CLs: $patches"
    echo "  lag: $(($patches - $gDays))"
}
