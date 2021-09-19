#!/bin/sh

setxkbmap -model pc105 -option "grp:shifts_toggle,compose:sclk" "us,bg(phonetic)"
picom &
redshift-gtk -P -O 3000 &
flameshot &
copyq &
picom --experimental-backend --config ~/.config/picom/picom.conf &
nitrogen --restore &
/home/nazgo/tmux.start.sh &
