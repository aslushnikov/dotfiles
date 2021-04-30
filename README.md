
# Prerequisites
- [Vim distinguished color theme](https://github.com/Lokaltog/vim-distinguished)
- [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) to fix pbcopy/pbpaste on OS X in tmux. NB: under iTerm2, a checkbox "Allow clipboard access to terminal apps" should be checked.
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) to see nice git diffs in terminal
- [fzf](https://github.com/junegunn/fzf) for fuzzy-search files in terminal
- [git bash completions](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash) so that bash would complete branchnames etc on Tab.

> **NOTE**: run `./bootstrap.sh` to link dotfiles, install fzf, diff-so-fancy and vim colorscheme.

# Fresh MacOS Setup

- Add Russian input source, set `Cmd-Space` to switch input and `Alt-Space` to trigger Spotlight
- Install [iTerm2](https://www.iterm2.com/)
- Install [rustup](https://www.rust-lang.org/tools/install)
- Install [rust](https://www.rust-lang.org/tools/install): `rustup toolchain install stable`
- Install [ripgrep](https://github.com/BurntSushi/ripgrep): `cargo install ripgrep`
- Install [brew](https://brew.sh/)
- Install [nvm](https://github.com/nvm-sh/nvm)
- Install [node](https://nodejs.org/en/): `nvm install stable`
- Install command-line tools: `xcode-select --install`
- Install [exa](https://the.exa.website/): `brew install exa`
- Install [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard): `brew install reattach-to-user-namespace`
- Install [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): (put diff-so-fancy script in the PATH and make it executable)
- Install [fzf](https://github.com/junegunn/fzf): (install with .git so that it works with vim and bash)
- Install [bash-completion](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash): `brew install bash-completion`
- Install [vim javascript syntax](https://github.com/pangloss/vim-javascript/blob/master/syntax/javascript.vim): `mkdir -p $HOME/.vim/syntax && curl https://raw.githubusercontent.com/pangloss/vim-javascript/master/syntax/javascript.vim -o $HOME/.vim/syntax/javascript.vim`
- Install [vim typescript syntax](https://github.com/leafgarland/typescript-vim): `git clone https://github.com/leafgarland/typescript-vim.git ~/.vim/pack/typescript/start/typescript-vim`
- Install [vim distinguished theme](https://github.com/Lokaltog/vim-distinguished): `mkdir -p $HOME/.vim/colors && curl https://raw.githubusercontent.com/Lokaltog/vim-distinguished/develop/colors/distinguished.vim -o $HOME/.vim/colors/distinguished.vim`
- Generate SSH key and add it to github
    ```sh
    # Generate key
    ssh-keygen -t rsa -b 4096 -C "the-github-email-address"
    # Copy key to paste later into the github
    pbcopy < ~/.ssh/id_rsa.pub
    ```
