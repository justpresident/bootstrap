#!/bin/bash

DIR=`pwd`

for f in vim vimrc profile bashrc gitconfig inputrc
do
	ln -s $DIR/$f ~/.$f
done

mkdir -p ~/.ssh/
ln -s $DIR/ssh/config ~/.ssh/config
