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
if ! [[ -f "$HOME/.vim/color/distinguished.vim" ]]; then
  wget --directory-prefix="$HOME/.vim/colors" https://raw.githubusercontent.com/Lokaltog/vim-distinguished/develop/colors/distinguished.vim
fi

# install diff-so-fancy
mkdir -p "$HOME/prog"
if ! [[ -d "$HOME/prog/diff-so-fancy" ]]; then
  git clone https://github.com/so-fancy/diff-so-fancy "$HOME/prog/diff-so-fancy"
fi
if ! [[ -f "$HOME/bin/diff-so-fancy" ]]; then
  sudo ln -s "$HOME/prog/diff-so-fancy/diff-so-fancy" "$HOME/bin/diff-so-fancy"
fi

# install FZF
if ! [[ -d "$HOME/.fzf" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install"
fi

# install bash completions
wget --directory-prefix="$HOME" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && mv "${HOME}/git-completion.bash" "${HOME}/.git-completion.bash"
