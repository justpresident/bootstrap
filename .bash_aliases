
# SSH specific: key forwarding
ssh-add >/dev/null 2>&1
alias ssh='ssh -A'

# command aliases
alias one_display='xrandr --output eDP1 --mode 1920x1080 --rotate normal --pos 0x0 --output DP1 --off'
alias two_displays='xrandr --output eDP1 --mode 1920x1080 --rotate normal --pos 0x0 --output DP1 --mode 1600x1200 --left-of eDP1'
alias mplayer_speed_control='mplayer -af scaletempo=stride=30:overlap=.50:search=10'
alias mplayer_cam='mplayer tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:hue=100'


alias bootstrap_cmd='echo "git clone https://github.com/justpresident/bootstrap.git; cd bootstrap; ./bootstrap.sh; cd -; source .bashrc"'

function bootstrap_host {
	ssh -A $@ 'if [[ $(dpkg -l | cut -f1,3 -d" " | grep "ii git") == "" ]]; then sudo apt-get --yes --force-yes install git; fi; git clone https://github.com/justpresident/bootstrap.git; cd bootstrap; ./bootstrap.sh'
}
