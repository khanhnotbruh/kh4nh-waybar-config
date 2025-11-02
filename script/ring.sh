#!/usr/bin/env bash
usage=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 50)

cat <<EOF
<svg width="26" height="26" viewBox="0 0 36 36">
  <circle cx="18" cy="18" r="15" stroke="#444" stroke-width="3" fill="none"/>
  <circle cx="18" cy="18" r="15"
          stroke="#89b4fa" stroke-width="3"
          stroke-dasharray="$((usage * 94 / 100)),94"
          stroke-linecap="round"
          transform="rotate(-90 18 18)" fill="none"/>
</svg>
EOF
