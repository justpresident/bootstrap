# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# The beginning of everything
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# set Language and messages
export LC_ALL=ru_RU.UTF8
export LANG=ru_RU.UTF8
export LC_MESSAGES=en_US.UTF8
export LC_NUMERIC=en_US.UTF8


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
PS1="${TITLEBAR}$CYAN[\t] $BLUE\u$NO_COLOR@$DARK_ORANGE\h $DARK_ORANGE:\w$NO_COLOR\\$ "
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
export PATH=$PATH:/home/italiano/apps/sbt/bin

source "$CUR_DIR/.bash_aliases"
