#!/bin/bash

set -e

DIR=$(dirname $(readlink -f $0))
echo $DIR > $HOME/.bootstrap_path

echo perl -pi -e "s#$DIR/.bashrc#$DIR/dotfiles/.bashrc#" ~/.bashrc
perl -pi -e "s#$DIR/.bashrc#$DIR/dotfiles/.bashrc#" ~/.bashrc
if [[ `grep $DIR/dotfiles/.bashrc ~/.bashrc` == '' ]]; then
	echo "if [ -f $DIR/dotfiles/.bashrc ]; then" >> ~/.bashrc
	echo "	source '$DIR/dotfiles/.bashrc'"     >> ~/.bashrc
	echo fi                                     >> ~/.bashrc
fi

for f in $(ls -1a $DIR/dotfiles)
do
    if [[ $f == "." || $f == ".." || $f == ".bashrc" ]]; then
        continue
    fi
	rm -rf $HOME/$f
	ln -vs $DIR/dotfiles/$f $HOME/$f
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
