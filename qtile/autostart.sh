#!/bin/sh

redshift-gtk -P -O 4500 &
flameshot &
picom --config ~/.config/picom/picom.conf &
nitrogen --restore &
