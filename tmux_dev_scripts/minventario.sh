#!/bin/bash

SESH="MINVENTARIO_SESSION"

tmux has-session -t $SESH 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESH -n "editor"

    tmux send-keys -t $SESH:editor "cd /media/dark/Work System/Proyectos de Programacion/En proceso \(importantes\)/Python/FAVDashboard" C-m
    tmux send-keys -t $SESH:editor "vim ." C-m

    # tmux new-window -t $SESH -n "server" 
    # tmux send-keys -t $SESH:server "cd /media/dark/Work System/Proyectos de Programacion/En proceso \(importantes\)/Laravel/NEWGES" C-m
    # tmux send-keys -t $SESH:server "php artisan serve" C-m

    # tmux select-window -t $SESH:editor

fi

tmux attach-session -t $SESH

