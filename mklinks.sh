#!/bin/bash

DIR=`pwd`

ln -s $DIR/vim ~/.vim
ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/profile ~/.profile
ln -s $DIR/bashrc ~/.bashrc
ln -s $DIR/gitconfig ~/.gitconfig
ln -s $DIR/inputrc ~/.inputrc
mkdir -p ~/.ssh/
ln -s $DIR/ssh/config ~/.ssh/config
