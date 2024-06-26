# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# The beginning of everything
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

export LESS="-IR --follow-name"

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

# this is how it should look like on servers:
#   [23:06:12] srv@srv-fedora-PF22711J :/$
#   {WHITE} {CYAN}@{DARK_ORANGE} :WHITE$
# this is how it should look like in containers:
#   [00:28:12] root@docker:7aa246ac9744 :/#
#   {WHITE} {CYAN}@{RED}:{DARK_ORANGE} :WHITE#
prompt_cmd () {
    if [[ $? == 0 ]]; then
        CMD_PROMPT="${GREEN}\\$ ${NO_COLOR}";
    else
        CMD_PROMPT="${BRIGHT_RED}\\$ ${NO_COLOR}";
    fi
    if [[ -z $DOCKER_HOSTNAME ]]; then
        HN="${DARK_ORANGE}\\h";
    else
        HN="${RED}docker:$DARK_ORANGE$DOCKER_HOSTNAME";
    fi
    PS1="$NO_COLOR[\t] $CYAN\u$NO_COLOR@$HN $NO_COLOR:\w";
    if [[ -n $VIRTUAL_ENV ]]; then
        PS1+="$GREEN($VIRTUAL_ENV)";
    fi
    PS1+=$CMD_PROMPT
    unset HN
    unset CMD_PROMPT
}
PROMPT_COMMAND='prompt_cmd'
PS2='continue-> '
PS4='$0.$LINENO+ '

# Bash cpecific
HISTSIZE=1000000
HISTFILESIZE=20000000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend # append the history at exit, not replace it
# HISTTIMEFORMAT=''       # Save the timestamp, but don't output it
HISTTIMEFORMAT='%F_%T '
PROMPT_COMMAND="$PROMPT_COMMAND;history -a"


# includes
CUR_FILE_PATH=${BASH_ARGV[0]}

if [[ $OSTYPE =~ darwin* ]]; then
    READLINK=$(which greadlink)
else
    READLINK=$(which readlink)
fi
if [[ -z $READLINK ]]; then
    echo "Failed to find readlink tool"
fi

export DOTFILES_DIR=$(dirname ${BASH_ARGV[0]})
export DOTFILES_DIR=$($READLINK -f $DOTFILES_DIR)

# This variable can be used in bash scripts. Useful for tools in bin folder
export BOOTSTRAP_DIR=$(dirname $DOTFILES_DIR)
export PATH=$BOOTSTRAP_DIR/bin:$PATH

source "$DOTFILES_DIR/.bash_aliases"
