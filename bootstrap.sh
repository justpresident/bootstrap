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

mkdir -p ~/.ssh/
ln -vfs $DIR/.ssh/config ~/.ssh/config

read -n 1 -p "Would you like to update fonts? (y/N) " UPDATE_FONTS
if [[ -n $UPDATE_FONTS && $UPDATE_FONTS == 'y' ]]; then
	echo "updating fonts...";
	sudo fc-cache -f -v

	echo "enabling bitmapped fonts in console..."
	sudo rm -f /etc/fonts/conf.d/70-no-bitmaps.conf
	sudo cp $DIR/50-enable-fixed.conf /etc/fonts/conf.d/
	sudo dpkg-reconfigure fontconfig
fi

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
