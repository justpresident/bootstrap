
# SSH specific: key forwarding
alias ssh='ssh -A'

export MAIN_DISPLAY=eDP-1
export LEFT_DISPLAY=DVI-I-1-1
export RIGHT_DISPLAY=DVI-I-2-2

# command aliases
off() {
    xrandr | grep disconnected | FS=' ' awk '{print "--output " $1 " --off"}' | tr "\n" " " | xargs -t xrandr
}
function one_display {
    FILES_PATH=$HOME/Dropbox/bootstrap/bin/files/
    xrandr --output $MAIN_DISPLAY --mode 1920x1080 --rotate normal --pos 0x0 --primary
}

function two_displays {
    xrandr --output $MAIN_DISPLAY --mode 1920x1080 --rotate normal --pos 0x0 \
        --output $LEFT_DISPLAY --mode 1920x1080 --right-of $MAIN_DISPLAY --primary
}

function three_displays_work {
    xrandr --output $MAIN_DISPLAY --mode 1920x1080 --rotate normal --pos 0x0 \
        --output $LEFT_DISPLAY --mode 1920x1080 --left-of $MAIN_DISPLAY --primary\
        --output $RIGHT_DISPLAY --mode 1920x1080 --right-of $MAIN_DISPLAY
}

alias mplayer_speed_control='mplayer -af scaletempo=stride=30:overlap=.50:search=10'
alias mplayer_cam='mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:hue=0'
alias telegram='$HOME/apps/Telegram/Telegram'
alias workenv="source $HOME/bin/workenv"
alias homeenv="source $HOME/bin/homeenv"
alias lsfast="LS_COLORS='ex=00:su=00:sg=00:ca=00:' ls"
alias java8="export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/"
alias java11="export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/"

kssh () {
    kubectl exec -it $(kubectl get po | grep $1 | head -n 1 | cut -f 1 -d' ') bash
}

klogs () {
    kubectl logs $(kubectl get po | grep $1 | head -n 1 | cut -f 1 -d' ') ${@:2}
}
function d {
    CONTAINER=$1
    FORCE_BOOTSTRAP=$2

    bootstrapped=$(docker exec -it $CONTAINER bash -c "if [[ -f /bootstrap/bootstrap.sh ]]; then echo -n 1; fi")
    if [[ ! -z $FORCE_BOOTSTRAP || -z $bootstrapped ]]; then
        BOOTSTRAP_PATH=$(cat ~/.bootstrap_path)
        docker cp $BOOTSTRAP_PATH $CONTAINER:bootstrap
        docker exec -it -e UPDATE_FONTS=n $CONTAINER /bootstrap/bootstrap.sh > /dev/null
    fi
    docker exec -it -e DOCKER_HOSTNAME=$CONTAINER $CONTAINER bash

}

function save_nethack {
    SAVE_NAME=$1;
    if [[ -z $SAVE_NAME ]]; then
        SAVE_NAME="nethack";
    fi
    if [[ -d ~/Dropbox/nethack_saves/$SAVE_NAME ]]; then
        read -n 1 -p "Would you like to replace existing name '$SAVE_NAME'? (y/N) " REPLACE_GAME
        echo ;
        if [[ -n $REPLACE_GAME && $REPLACE_GAME == 'y' ]]; then
            sudo rm -rf ~/Dropbox/nethack_saves/$SAVE_NAME
        else
            return
        fi
    fi
    echo "Saving '$SAVE_NAME'"
    sudo cp -r /var/games/nethack Dropbox/nethack_saves/$SAVE_NAME
}

function load_nethack {
    SAVE_NAME=$1;
    if [[ -z $SAVE_NAME || ! -d ~/Dropbox/nethack_saves/$SAVE_NAME ]]; then
        echo Available save names:;
        ls -1 ~/Dropbox/nethack_saves/
        return
    fi

    sudo rm -rf /var/games/nethack;
    sudo cp -r ~/Dropbox/nethack_saves/$SAVE_NAME /var/games/nethack
    sudo chmod -R a+rw /var/games/nethack
    echo "Loaded"
}

## doc: list content differences between two directories
function dirdiff {
    local src="$1" dst
    dst="${2:-.}"

    if [ -z "$src" ]; then
        err "missing original directory"
        return 1
    fi

    if ! [ -d "$src" ]; then
        err "$src: not a directory"
        return 1
    fi
    if ! [ -d "$dst" ]; then
        err "$dst: not a directory"
        return 1
    fi

    diff -u <(cd "$src" && find . | LC_ALL=C sort | sed -e 's/^..//') \
        <(cd "$dst" && find . | LC_ALL=C sort | sed -e 's/^..//')
}

function rscreen {
    SNAME=$1
    if [[ -z $SNAME ]]; then
        echo "Open sessions:"
        screen -list
        return
    fi

    screen -D -R -S $SNAME
}


function rtmux {
    SNAME=$1
    if [[ -z $SNAME ]]; then
        echo "Open sessions:"
        tmux list-sessions
        return
    fi

    tmux -2 new-session -A -s $SNAME
}

function tagit {
    if [[ -z $1 || -z $2 ]]; then
        echo "Usage: $0 DIR_NAME LANGUAGE";
        echo "Available languages:";
        ctags --list-languages
        return;
    fi
    dir_path=$(readlink -f $1 2>/dev/null)

    if [[ ! -d $dir_path ]]; then
        echo "There is no such dir"
        return;
    fi

    LANG=$2
    if [[ ! $(ctags --list-languages | grep -E "^${LANG}\$") ]]; then
        echo "Language ${LANG} is not supported. Supported languages:";
        ctags --list-languages
        return
    fi

    ctags -f $dir_path/tags --recurse --totals \
        --exclude=blib --exclude=.svn \
        --exclude=.git --exclude='*~' \
        --extra=+fq \
        --fields=+K \
        --languages=${LANG} \
        --langmap=Perl:+.t
}

alias uri_decode=$'perl -MURI::Encode -ne \'print URI::Encode::uri_decode($_)\''
alias uri_encode=$'perl -MURI::Encode -ne \'print URI::Encode::uri_encode($_)\''

alias bootstrap_cmd='echo "git clone https://github.com/justpresident/bootstrap.git; cd bootstrap; ./bootstrap.sh; cd -; source .bashrc"'

function bootstrap_host {
	ssh -A $@ 'if [[ $(dpkg -l | cut -f1,3 -d" " | grep "ii git") == "" ]]; then sudo apt-get --yes --force-yes install git; fi; git clone https://github.com/justpresident/bootstrap.git; cd bootstrap; ./bootstrap.sh'
}
