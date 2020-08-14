#!/usr/bin/env bash
# Author: Park Lam<lqmonline@gmail.com>

#BASEDIR=$(dirname $(readlink -f "$BASH_SOURCE"))
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$BASEDIR"

echo ". $BASEDIR/_bashrc" | sed -e "s#$HOME#\$HOME#g" - >> ~/.bashrc
echo ". $BASEDIR/_bash_alias" | sed -e "s#$HOME#\$HOME#g" - >> ~/.bashrc

rm ~/.vimrc 2> /dev/null && ln -v -s "${BASEDIR}/_vimrc" ~/.vimrc
