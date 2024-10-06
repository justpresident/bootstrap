h()  { history 30; }                           # last few history commands
ht() { HISTTIMEFORMAT='%F_%T  ' history 30; }  # history with time stamps
hc() { source $BOOTSTRAP_DIR/bin/history_merge.bash; }      # merge & clean history

# SSH specific: key forwarding
alias ssh='ssh -A'
if [[ $OSTYPE =~ darwin* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

function discover_displays {
    xrandr --auto
    export MAIN_DISPLAY=$(xrandr --listactivemonitors | grep '0:' 2>&1 | awk '{ print $4; }')
    export MAIN_DISPLAY_RES=${MAIN_DISPLAY_RES:-1920x1080}
    export EXT_LEFT_DISPLAY=$(xrandr --listactivemonitors | grep '1:' 2>&1 | awk '{ print $4; }')
    export EXT_LEFT_DISPLAY_RES=${EXT_LEFT_DISPLAY_RES:-2560x1440}
}

# command aliases
function one_display {
    discover_displays
    xrandr --output $MAIN_DISPLAY --mode $MAIN_DISPLAY_RES --rotate normal --pos 0x0 --primary
}
function ext_display {
    discover_displays
    xrandr --output $EXT_LEFT_DISPLAY --mode $EXT_LEFT_DISPLAY_RES --rotate normal --pos 0x0 --primary --output $MAIN_DISPLAY --off
}

function displays1600x1200 {
    discover_displays
    xrandr \
        --output $EXT_LEFT_DISPLAY --mode 1600x1200 --rotate normal --pos 0x0 --primary \
        --output $MAIN_DISPLAY --mode 1600x1200 --right-of $EXT_LEFT_DISPLAY
}
function displays1920x1080 {
    discover_displays
    xrandr \
        --output $EXT_LEFT_DISPLAY --mode 1920x1080 --rotate normal --pos 0x0 --primary \
        --output $MAIN_DISPLAY --mode 1920x1080 --right-of $EXT_LEFT_DISPLAY
}

function two_displays {
    discover_displays
    RES=$(xrandr \
        --output $EXT_LEFT_DISPLAY --mode $EXT_LEFT_DISPLAY_RES --rotate normal --pos 0x0 --primary \
        --output $MAIN_DISPLAY --mode $MAIN_DISPLAY_RES --right-of $EXT_LEFT_DISPLAY 2>&1)
    if [[ $RES ]]; then
        xrandr \
            --output $MAIN_DISPLAY --mode $EXT_LEFT_DISPLAY_RES --rotate normal --pos 0x0 --primary \
            --output $EXT_LEFT_DISPLAY --mode $MAIN_DISPLAY_RES --right-of $MAIN_DISPLAY
    fi
}

# function three_displays_work {
#     xrandr --output $LEFT_DISPLAY --mode 1920x1080 --rotate normal --pos 0x0 --primary \
#         --output $MAIN_DISPLAY --mode 1920x1080 --left-of $LEFT_DISPLAY \
#         --output $RIGHT_DISPLAY --mode 1920x1080 --right-of $LEFT_DISPLAY
# }

alias player='mplayer'
alias mplayer_speed_control='mplayer -af scaletempo=stride=30:overlap=.50:search=10'
alias mplayer_cam='mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:hue=0'
alias telegram='$HOME/apps/Telegram/Telegram'
alias ue='$HOME/apps/UnrealEngine-release/Engine/Binaries/Linux/UE4Editor'
alias workenv="source $HOME/bin/workenv"
alias homeenv="source $HOME/bin/homeenv"
alias lsfast="LS_COLORS='ex=00:su=00:sg=00:ca=00:' ls"
alias java8="export JAVA_HOME=/usr/lib/jvm/java-1.8.0/"
alias java11="export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
alias pron="$HOME/Dropbox/cypher.pl $HOME/Dropbox/pron"
alias hpet_disable='grubby --args "hpet=disable" --update-kernel=ALL'

alias vcamera_load="sudo modprobe v4l2loopback exclusive_caps=1 card_label=External"
alias vcamera_feed="gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 8 -f v4l2 /dev/video2"
alias weather="curl -s http://wttr.in/london | grep -v Follow"
alias vim="select_vim $@"

function select_vim() {
choose_from_menu 'Select' selected_choice vim nvim
echo $selected_choice;
$selected_choice "$@";
}

kssh () {
    kubectl exec -it $(kubectl get po | grep $1 | head -n 1 | cut -f 1 -d' ') bash
}

klogs () {
    kubectl logs $(kubectl get po | grep $1 | head -n 1 | cut -f 1 -d' ') ${@:2}
}

klogs_all() {
    pods=$(kubectl get pods | grep $1 | cut -f1 -d' ')
    for pod in $pods; do
        kubectl logs $pod ${@:2} | awk "{print \"$pod:\" \$0}"
    done
}

function graphite_produce_increasing_metric {
    SERVER=$1
    PORT=$2
    METRIC=$3

    VAL=$((RANDOM % 100))
    while [[ true ]]; do
        date
        GRAPHITE_DATAPOINT="$METRIC $VAL `date +%s`"
        echo $GRAPHITE_DATAPOINT
        echo $GRAPHITE_DATAPOINT | nc -N ${SERVER} ${PORT}
        ((VAL += RANDOM % 100))
        sleep $((RANDOM % 10))
    done
}

function throttle_cpu {
    pid=$1
    limit=$2

    if [[ -z $pid ]]; then
        ps -e o pid,user,pcpu,pmem,comm,nwchan,wchan --sort %cpu | head -n1
        ps -e o pid,user,pcpu,pmem,comm,nwchan,wchan --sort %cpu | tail -n1
        pid=$(ps -e o pid --sort %cpu | tail -n1)
    else
        ps --pid $pid o pid,user,pcpu,pmem,comm,nwchan,wchan
    fi
    if [[ -z $limit ]]; then limit=1;fi

    read -p "Throttle process $pid with ${limit}% cpu? (y/n) > " answer
    if [[ $answer != "y" ]]; then
        echo "aborted"
        return
    fi

    set -x
    group=/sys/fs/cgroup/cpu/throttled$limit
    #if [[ ! -d $group ]]; then
        sudo mkdir $group
        echo $(($limit*1000)) | sudo tee $group/cpu.cfs_quota_us
        echo 100000 | sudo tee $group/cpu.cfs_period_us
    #fi
    set +x
    echo $pid | sudo tee $group/cgroup.procs
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

    if [ -z "$TMUX" ]; then
        if [ ! -z "$SSH_TTY" ]; then
            if [ ! -z "$SSH_AUTH_SOCK" ]; then
                ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/auth-sock"
            fi
            export SSH_AUTH_SOCK="$HOME/.ssh/auth-sock"
        fi
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

function static_img_video {
    if [[ -z $1 || -z $2 || -z $3 ]]; then
        echo "converts mp3 to video with a static image"
        echo "Usage: static_img_video image.jpg audio.mp3 out.mp4";
        return;
    fi
    ffmpeg -loop 1 -i $1 -i $2 -c:a copy -c:v libx264 -shortest $3
}

function video_duration {
    if [[ -z $1 ]]; then
        echo "Get video duration in seconds";
        echo "Usage: video_duration video.mp4"
        return;
    fi
    ffprobe -i $1 -v quiet -show_entries format=duration -hide_banner
}

function video_reencode {
    if [[ -z $1 || -z $2 ]]; then
        echo "Encodes video using VP9 and audio using libvorbis"
        echo "Usage: video_reencode video.in video.out";
        echo "More info at https://opensource.com/article/17/6/ffmpeg-convert-media-file-formats";
        return;
    fi
    ffmpeg -i $1 -c:v vp9 -c:a libvorbis $2
}

function split_flac {
    if [[ -z $1 || -z $2 ]]; then
        echo "Splits one flac file with a .cue into multiple"
        echo "Usage: split_flac file.flac file.cue";
        echo "You need to install followin dependencies in Ubuntu:\nsudo apt-get install cuetools shntool flac"
        return;
    fi
    cuebreakpoints $2 | shnsplit -o flac $1
}

function to_mp3 {
    if [[ -z $1 || -z $2 ]]; then
        echo "Converts an audio file to mp3 with VBR"
        echo "Usage: split_flac file.flac file.mp3";
        return;
    fi
    ffmpeg -i $1 -c:v copy -q:a 0 $2
}

function encode_dvd_rip {
    if [[ -z $1 || -z $2 ]]; then
        echo "Converts dvd rip into avi. Consider checking and updating bitrate before converting(mplayer -dvd-device /path_to_rip -identify dvd://2)"
        echo "Usage: encode_dvd_rip /path/to/rip TRACK_NUMBER";
        return;
    fi
    RIPDIR=$1
    TITLE=$2
    LAVCOPTS="vcodec=mpeg4:vbitrate=7500000:vhq:vqmin=2:autoaspect:v4mv:mbd=2:trell"
    mencoder -dvd-device $RIPDIR dvd://$TITLE -ni -ovc lavc -lavcopts $LAVCOPTS:vpass=1 -oac copy -o /dev/null
    mencoder -dvd-device $RIPDIR dvd://$TITLE -ni -ovc lavc -lavcopts $LAVCOPTS:vpass=2 -oac mp3lame -o video.avi
    rm divx2pass.log
}


# Example use:
# selections=(
#     "Selection A"
#     "Selection B"
#     "Selection C"
# )
#choose_from_menu "Please make a choice:" selected_choice "${selections[@]}"
#echo "Selected choice: $selected_choice"
function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            (( index++ ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then (( cur-- )); (( cur < 0 )) && (( cur = 0 ))
        elif [[ $key == $esc[B ]] # down arrow
        then (( cur++ )); (( cur >= count )) && (( cur = count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

