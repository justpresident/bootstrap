#!/bin/bash

set -e

DIR=`pwd`

if [[ `grep $DIR/.bashrc ~/.bashrc` == '' ]]; then
	echo "if [ -f $DIR/.bashrc ]; then" >> ~/.bashrc
	echo "	source '$DIR/.bashrc'"    >> ~/.bashrc
	echo fi                             >> ~/.bashrc
fi

for f in .gitconfig .inputrc .profile .vimrc .vim .my.cnf .tmux.conf .fonts
do
	rm -rf ~/$f
	ln -vs $DIR/$f ~/$f
done

read -n 1 -p "Would you like to update fonts? (y/N) " UPDATE_FONTS
if [[ -n $UPDATE_FONTS && $UPDATE_FONTS == 'y' ]]; then
	echo "updating fonts";
	sudo fc-cache -f -v
fi

mkdir -p ~/.ssh/
ln -vfs $DIR/.ssh/config ~/.ssh/config

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
