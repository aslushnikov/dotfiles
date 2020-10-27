#!/bin/bash

set -e
set +x

trap "cd $(pwd -P);" INT TERM EXIT
cd "$(dirname "$0")"

# Link all files to $HOME
rm -rf "$HOME/.bashrc"
rm -rf "$HOME/.tmux.conf"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.vimrc"
ln -s "$PWD/gitconfig" "$HOME/.gitconfig"
ln -s "$PWD/tmux.conf" "$HOME/.tmux.conf"
ln -s "$PWD/bashrc" "$HOME/.bashrc"
ln -s "$PWD/vimrc" "$HOME/.vimrc"

# install vim colorscheme
mkdir -p "$HOME/.vim/colors"
wget --directory-prefix="$HOME/.vim/colors" https://raw.githubusercontent.com/Lokaltog/vim-distinguished/develop/colors/distinguished.vim

# install diff-so-fancy
mkdir -p "$HOME/prog"
git clone https://github.com/so-fancy/diff-so-fancy "$HOME/prog/diff-so-fancy"
sudo ln -s "$HOME/prog/diff-so-fancy/diff-so-fancy" /usr/local/bin/diff-so-fancy

# install FZF
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
"$HOME/.fzf/install"

# install bash completions
wget --directory-prefix="$HOME" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && mv "${HOME}/git-completion.bash" "${HOME}/.git-completion.bash"
