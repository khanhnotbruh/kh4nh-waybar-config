#!/bin/bash

time=$(date +"%H:%M")
datef=$(date +"%d %b %Y")

# output JSON with both pieces (Waybar will read this every second)
cat <<EOF
{
  "text": "<span class='time'>$time</span><span class='date'>$datef</span>",
  "class": "clock"
}
EOF
