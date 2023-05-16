#!/bin/sh

project_directory="/home/ng/_Forkpoint/acne"

tmux start-server
tmux new-session -d -n "vim" -c $project_directory
tmux neww -n "dev" -c $project_directory
tmux neww -n "etc" -c $project_directory
