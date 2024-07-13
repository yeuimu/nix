#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini

case $1 in
  "monitor")
    polybar monitor 2>&1 | tee -a /tmp/polybar.log & disown
    ;;
  "note")
    polybar note 2>&1 | tee -a /tmp/polybar.log & disown
    ;;
esac

echo "Polybar launched..."
