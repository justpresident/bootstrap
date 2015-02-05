#!/bin/bash

set -e

DIR=`pwd`

if [[ `grep $DIR/.bashrc ~/.bashrc` == '' ]]; then
	echo "if [ -f $DIR/.bashrc ]; then" >> ~/.bashrc
	echo "	source '$DIR/.bashrc'"    >> ~/.bashrc
	echo fi                             >> ~/.bashrc
fi

for f in .gitconfig .inputrc .profile .vimrc .vim .my.cnf
do
	rm -rf ~/$f
	ln -vs $DIR/$f ~/$f
done


mkdir -p ~/.ssh/
ln -vfs $DIR/.ssh/config ~/.ssh/config

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
