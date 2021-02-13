#!/bin/sh

redshift-gtk -P -O 3000 &
flameshot &
picom --experimental-backend --config ~/.config/picom/picom.conf &
nitrogen --restore &
