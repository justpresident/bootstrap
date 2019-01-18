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

HN=$(if [[ -z $DOCKER_HOSTNAME ]]; then echo "${DARK_ORANGE}\\h"; else echo "${RED}docker:$DARK_ORANGE$DOCKER_HOSTNAME"; fi)
PS1="$NO_COLOR[\t] $CYAN\u$NO_COLOR@$HN $NO_COLOR:\w\\$ "
PS2='continue-> '
PS4='$0.$LINENO+ '
unset HN

# Bash cpecific
HISTSIZE=1000000
HISTFILESIZE=20000000


# includes
CUR_FILE_PATH=${BASH_ARGV[0]}

CUR_DIR=`dirname ${BASH_ARGV[0]}`
CUR_DIR=`readlink -f $CUR_DIR`

export PATH=$CUR_DIR/bin:$PATH

source "$CUR_DIR/.bash_aliases"
