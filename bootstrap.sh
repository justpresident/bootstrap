#!/bin/bash

set -e

if [[ $OSTYPE =~ darwin* ]]; then
    READLINK=$(which greadlink)
else
    READLINK=$(which readlink)
fi
if [[ -z $READLINK ]]; then
    echo "Failed to find readlink tool"
fi

export DIR=$(dirname $($READLINK -f $0))
echo -n $DIR > $HOME/.bootstrap_path

# bashrc
perl -pi -e "s#$DIR/.bashrc#$DIR/dotfiles/.bashrc#" ~/.bashrc
if [[ `grep $DIR/dotfiles/.bashrc ~/.bashrc` == '' ]]; then
    echo "if [ -f $DIR/dotfiles/.bashrc ]; then" >> ~/.bashrc
    echo "  source '$DIR/dotfiles/.bashrc'"     >> ~/.bashrc
    echo fi                                     >> ~/.bashrc
fi
touch ~/.bash_logout
if [[ `grep $DIR/dotfiles/.bash_logout ~/.bash_logout` == '' ]]; then
    echo "if [ -f $DIR/dotfiles/.bash_logout ]; then" >> ~/.bash_logout
    echo "  source '$DIR/dotfiles/.bash_logout'"      >> ~/.bash_logout
    echo fi                                           >> ~/.bash_logout
fi

# link all dotfiles in $HOME
for f in $(ls -1a $DIR/dotfiles)
do
    if [[ $f == "." || $f == ".." || $f == ".bashrc" || $f == ".bash_logout" || $f == ".config" || $f == ".local" ]]; then
        continue
    fi
    rm -rf $HOME/$f
    ln -vs $DIR/dotfiles/$f $HOME/$f
done

# link all subfolders in $HOME/.config/*
if [[ ! -d $HOME/.config ]]; then
    mkdir $HOME/.config
fi
for f in $(ls -1a $DIR/dotfiles/.config)
do
    if [[ $f == "." || $f == ".." ]]; then
        continue
    fi
    rm -rf $HOME/.config/$f
    ln -vs $DIR/dotfiles/.config/$f $HOME/.config/$f
done

# link all subfolders in $HOME/.local/share/*
if [[ ! -d $HOME/.local/share ]]; then
    mkdir -p $HOME/.local/share
fi
for f in $(ls -1a $DIR/dotfiles/.local/share)
do
    if [[ $f == "." || $f == ".." ]]; then
        continue
    fi
    rm -rf $HOME/.local/share/$f
    ln -vs $DIR/dotfiles/.local/share/$f $HOME/.local/share/$f
done

# bootstrap.d
pushd $DIR
for script in $(ls -1 $DIR/bootstrap.d/); do
    . $DIR/bootstrap.d/$script
done
popd

# fonts
if [[ -z $UPDATE_FONTS ]]; then
    read -n 1 -p "Would you like to update fonts? (y/N) " UPDATE_FONTS
fi

if [[ -n $UPDATE_FONTS && $UPDATE_FONTS == 'y' ]]; then
    echo "updating fonts...";
    fc-cache -vf ~/.fonts/

    echo "enabling bitmapped fonts in console..."
    sudo rm -f /etc/fonts/conf.d/70-no-bitmaps.conf
    sudo cp $DIR/files/fontconfig/50-enable-fixed.conf /etc/fonts/conf.d/
    mkdir -p ~/.config/fontconfig/conf.d/
    cp $DIR/files/fontconfig/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
    sudo dpkg-reconfigure fontconfig
fi

echo
echo "Bootstrap is successfull!"
echo "Don't forget to launch source ~/.bashrc"
