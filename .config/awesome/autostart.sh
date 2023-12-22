#!/bin/sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

run "picom"
run "feh" --bg-scale ~/Pictures/Wallpaper/wallhaven-28v3mm.jpg
