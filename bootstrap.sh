#!/bin/bash

set -e

DIR=`pwd`

if [[ `grep $DIR/.bashrc ~/.bashrc` == '' ]]; then
	echo "if [ -f $DIR/.bashrc ]; then" >> ~/.bashrc
	echo "	source '$DIR/.bashrc'"    >> ~/.bashrc
	echo fi                             >> ~/.bashrc
fi

for f in .gitconfig .bash_aliases .inputrc .profile .vimrc .vim .my.cnf .tmux.conf .fonts .arduino
do
	rm -rf ~/$f
	ln -vs $DIR/$f ~/$f
done

#mkdir -p ~/.ssh/
#ln -vfs $DIR/.ssh/config ~/.ssh/config

if [[ -z $UPDATE_FONTS ]]; then
    read -n 1 -p "Would you like to update fonts? (y/N) " UPDATE_FONTS
fi

if [[ -n $UPDATE_FONTS && $UPDATE_FONTS == 'y' ]]; then
	echo "updating fonts...";
	fc-cache -vf ~/.fonts/

	echo "enabling bitmapped fonts in console..."
	sudo rm -f /etc/fonts/conf.d/70-no-bitmaps.conf
	sudo cp $DIR/50-enable-fixed.conf /etc/fonts/conf.d/
    mkdir -p ~/.config/fontconfig/conf.d/
    cp $DIR/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	sudo dpkg-reconfigure fontconfig
fi

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
