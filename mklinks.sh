#!/bin/bash

DIR=`pwd`

for f in vim vimrc profile bashrc gitconfig inputrc
do
	ln -s $DIR/$f ~/.$f
done

if [ `uname` == "Darwin" ]
then
	for f in Preferences.sublime-settings CPP.sublime-build
	do
		ln -s $DIR/$f ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/$f
	done
fi


mkdir -p ~/.ssh/
ln -s $DIR/ssh/config ~/.ssh/config
