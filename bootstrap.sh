#!/bin/bash

set -e
set +x

trap "cd $(pwd -P);" INT TERM EXIT
cd "$(dirname "$0")"

# Link all files to $HOME
echo "-- Linking dotfiles to home directory"
rm -rf "$HOME/.bashrc"
rm -rf "$HOME/.bash_profile"
rm -rf "$HOME/.tmux.conf"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.vimrc"
ln -s "$PWD/gitconfig" "$HOME/.gitconfig"
ln -s "$PWD/tmux.conf" "$HOME/.tmux.conf"
ln -s "$PWD/bashrc" "$HOME/.bashrc"
ln -s "$PWD/bash_profile" "$HOME/.bash_profile"
ln -s "$PWD/vimrc" "$HOME/.vimrc"

# install vim colorscheme
mkdir -p "$HOME/.vim/colors"
if ! [[ -f "$HOME/.vim/colors/distinguished.vim" ]]; then
  echo "-- Installing vim colorscheme: https://github.com/Lokaltog/vim-distinguished"
  wget --directory-prefix="$HOME/.vim/colors" https://raw.githubusercontent.com/Lokaltog/vim-distinguished/develop/colors/distinguished.vim
fi

# install typescript vim highlight
# https://github.com/leafgarland/typescript-vim
if ! [[ -d "$HOME/.vim/pack/typescript/start/typescript-vim" ]]; then
  echo "-- Installing vim typescript highlighter: https://github.com/leafgarland/typescript-vim"
  git clone https://github.com/leafgarland/typescript-vim.git ~/.vim/pack/typescript/start/typescript-vim
fi

# install rust vim highlight
if ! [[ -f "$HOME/.vim/pack/plugins/start/rust.vim" ]]; then
  echo "-- Installing rust vim support"
  git clone https://github.com/rust-lang/rust.vim ~/.vim/pack/plugins/start/rust.vim
fi

# install FZF
if ! [[ -d "$HOME/.fzf" ]]; then
  echo "-- Installing FZF: https://github.com/junegunn/fzf"
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install"
fi

# install bash completions
if ! [[ -f "${HOME}/.git-completion.bash" ]]; then
  echo "-- Installing git completions"
  wget --directory-prefix="$HOME" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash && mv "${HOME}/git-completion.bash" "${HOME}/.git-completion.bash"
fi

if ! [[ -f "${HOME}/.ssh/id_ed25519.pub" ]]; then
  echo "-- Generating SSH key (\$HOME/.ssh/id_ed25519.pub)"
  ssh-keygen -t ed25519 -C "aslushnikov@gmail.com"
fi

if ! command -v rustup >/dev/null; then
  echo "-- installing rust: https://www.rust-lang.org/tools/install"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  # get new PATH variable after rust installation
  source "$HOME/.bashrc"
fi

if ! command -v exa >/dev/null; then
  echo "-- installing exa: https://github.com/ogham/exa"
  cargo install exa
fi

if ! command -v bat >/dev/null; then
  echo "-- installing bat: https://github.com/sharkdp/bat"
  cargo install bat
fi

if ! command -v delta >/dev/null; then
  echo "-- installing git-delta: https://github.com/dandavison/delta"
  cargo install git-delta
fi

if ! command -v rg >/dev/null; then
  echo "-- installing ripgrep: https://github.com/BurntSushi/ripgrep"
  cargo install ripgrep
fi

echo 'Done.'
