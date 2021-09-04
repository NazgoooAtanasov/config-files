#!/bin/sh

project_directory="PUT DIR HERE"

tmux start-server
tmux new-session -d -n "NAMEOFWINDOW" -c $project_directory
tmux neww -n "NAMEOFWINDOW" -c $project_directory
tmux neww -n "NAMEOFWINDOW" -c $project_directory
