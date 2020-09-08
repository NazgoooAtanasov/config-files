#!/bin/sh

pcmanfm -d &
redshift-gtk -P -O 3500 &
flameshot &
picom --config ~/.config/picom/picom.conf &
nitrogen --restore &