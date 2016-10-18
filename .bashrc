# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# The beginning of everything
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# set Language and messages
export LC_ALL=en_US.UTF8


# Terminal colors and greeting message
NO_COLOR="\[\033[0m\]"
RED="\[\033[0;31m\]"
BRIGHT_RED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
BRIGHT_GREEN="\[\033[1;32m\]"
DARK_ORANGE="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
BOLDBLUE="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
LPURPLE="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
LBLUE="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"
BOLDWHITE="\[\033[0;37m\]"

case $TERM in
	xterm*|rxvt*)
		TITLEBAR='\[\033]0;\u@\h:\w\007\]'
		;;
	*)
		TITLEBAR=""
		;;
esac

PS1="\u@\h [\t]> "
PS1="$NO_COLOR[\t] ${TITLEBAR}$CYAN\u$NO_COLOR@$DARK_ORANGE\h $NO_COLOR:\w\\$ "
PS2='continue-> '
PS4='$0.$LINENO+ '

# Bash cpecific
HISTSIZE=1000000
HISTFILESIZE=20000000


# includes
CUR_FILE_PATH=${BASH_ARGV[0]}

CUR_DIR=`dirname ${BASH_ARGV[0]}`
CUR_DIR=`readlink -f $CUR_DIR`


export PATH=$PATH:$CUR_DIR/bin
if [[ -d $HOME/apps/sbt/bin ]]; then
	export PATH=$PATH:$HOME/apps/sbt/bin
fi

# Android dev
if [[ -d $HOME/apps/android-sdk-linux/tools/ ]]; then
	export PATH=$PATH:$HOME/apps/android-sdk-linux/tools/
fi

if [[ -d $HOME/apps/android-ndk-r10e/ ]]; then
	export PATH=$PATH:$HOME/apps/android-ndk-r10e/
fi

if [[ -d $HOME/apps/qt/Tools/QtCreator/bin ]]; then
	export PATH=$PATH:$HOME/apps/qt/Tools/QtCreator/bin/
fi

source "$CUR_DIR/.bash_aliases"
