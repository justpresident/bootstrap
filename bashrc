
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias rasp='ssh 192.168.1.43'
alias virtbox='ssh 192.168.1.38'

BLUE="\[\033[0;34m\]"
DARK_BLUE="\[\033[1;34m\]"
RED="\[\033[0;31m\]"
DARK_RED="\[\033[1;31m\]"
NO_COLOR="\[\033[0m\]"
GREEN="\[\033[01;32m\]"
CYAN="\[\033[01;36m\]"

case $TERM in
	xterm*|rxvt*)
		TITLEBAR='\[\033]0;\u@\h:\w\007\]'
		;;
	*)
		TITLEBAR=""
		;;
esac

PS1="\u@\h [\t]> "
PS1="${TITLEBAR}$BLUE\u@$GREEN\h $CYAN[\t]$DARK_RED:\w$NO_COLOR\$ "
PS2='continue-> '
PS4='$0.$LINENO+ '

#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\][\t]\$ '

HISTSIZE=1000000
HISTFILESIZE=20000000

export CLASSPATH=$CLASSPATH:~/algs4/stdlib.jar:~/algs4/algs4.jar

export PATH=/usr/local/sbin:/usr/local/bin:$PATH
