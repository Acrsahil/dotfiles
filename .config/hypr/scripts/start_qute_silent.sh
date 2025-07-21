#!/bin/bash
qutebrowser &
sleep 0.5 && hyprctl dispatch movetoworkspace 8,activewindow
