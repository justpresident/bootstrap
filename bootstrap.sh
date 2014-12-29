#!/bin/bash

set -e

DIR=`pwd`

if [[ `grep /home/italiano/bootstrap/.bashrc ~/.bashrc` == '' ]]; then
	echo source \'$DIR/.bashrc\' >> ~/.bashrc
fi

for f in .gitconfig .inputrc .profile .vimrc .vim
do
	rm -rf ~/$f
	ln -vs $DIR/$f ~/$f
done


mkdir -p ~/.ssh/
ln -vfs $DIR/.ssh/config ~/.ssh/config

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
