#!/bin/bash

if pgrep "waybar" >/dev/null; then
  killall waybar
else
  waybar &
fi
