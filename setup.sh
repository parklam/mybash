#!/usr/bin/env bash
# Author: Park Lam<lqmonline@gmail.com>

if ! type "git" > /dev/null; then
    echo "Command 'git' is not found. Please install 'git' first!"
    exit 1
fi

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sed "s#$HOME#\$HOME#g" - <<EOF >> ~/.bashrc
# Link to MyBash: https://github.com/parklam/mybash.git"
if [ -x $BASEDIR ]; then
    eval "\$( cd $BASEDIR/ && git pull >/dev/null 2>&1 )"
    . $BASEDIR/_bashrc
    . $BASEDIR/_bash_alias
fi
EOF

rm ~/.vimrc > /dev/null 2>&1
ln -s "${BASEDIR}/_vimrc" ~/.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c ':PluginInstall'
