# Prerequisites
- [Vim distinguished color theme](https://github.com/Lokaltog/vim-distinguished)
- [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) to fix pbcopy/pbpaste on OS X in tmux. NB: under iTerm2, a checkbox "Allow clipboard access to terminal apps" should be checked.
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) to see nice git diffs in terminal
- [fzf](https://github.com/junegunn/fzf) for fuzzy-search files in terminal
- [git bash completions](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash) so that bash would complete branchnames etc on Tab.

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
- Install [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy): `brew install diff-so-fancy`
- Install [fzf](https://github.com/junegunn/fzf): `brew install fzf`
  - Install shell extensions: `/usr/local/opt/fzf/install`
- Install [bash-completion](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash): `brew install bash-completion`
- Generate SSH key and add it to github
```sh
# Generate key
ssh-keygen -t rsa -b 4096 -C "the-github-email-address"
# Copy key to paste later into the github
pbcopy < ~/.ssh/id_rsa.pub
```
