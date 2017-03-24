#!/bin/bash -ex

apt-get install \
    git vim yakuake \
    fluxbox i3lock gnome-screenshot acpi notify-osd

user=$(whoami)
echo -e "\n\nPlease execute visudo and add following row at the very bottom:\n $user ALL=(ALL) NOPASSWD: /usr/sbin/pm-suspend, /sbin/reboot, /sbin/halt\n"
