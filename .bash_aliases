
# SSH specific: key forwarding
alias ssh='ssh -A'

# command aliases
alias one_display='xrandr --output eDP1 --mode 1920x1080 --rotate normal --pos 0x0 --output DP1 --off'
alias two_displays='xrandr --output eDP1 --mode 1920x1080 --rotate normal --pos 0x0 --output DP1 --mode 1600x1200 --left-of eDP1'
alias one_display_work='xrandr --output eDP1 --mode 1366x768 --rotate normal --pos 0x0 --output DP1-2 --off'
alias two_displays_work='xrandr --output eDP1 --mode 1366x768 --rotate normal --pos 0x0 --output DP1-2 --mode 1920x1080 --right-of eDP1 --primary'
alias mplayer_speed_control='mplayer -af scaletempo=stride=30:overlap=.50:search=10'
alias mplayer_cam='mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:hue=100'

## doc: list content differences between two directories
dirdiff()
{
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
