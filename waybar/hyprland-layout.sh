#!/bin/sh
hyprctl getoption general:layout | grep -q 'dwindle' && echo 'MA' || echo 'DW'
