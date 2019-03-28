#!/bin/bash

export DISPLAY=:1

tigervncserver $DISPLAY -geometry 1920x1080 -localhost no -noxstartup -SecurityTypes None --I-KNOW-THIS-IS-INSECURE > /dev/null 2>&1

if [ ! "$?" -eq "0" ]; then
  echo "VNC server was not started, quitting"
  exit 1
fi

/usr/bin/firefox > /dev/null 2>&1 &
FIREFOX_PID=$!

if [ ! "$?" -eq "0" ]; then
  echo "Firefox was not started, quitting"
  exit 1
fi

/usr/bin/dwm > /dev/null 2>&1 &
DWM_PID=$1

if [ ! "$?" -eq "0" ]; then
  echo "DWM was not started, quitting"
fi

# Block until firefox process is running
while true; do
  kill -0 "$FIREFOX_PID" > /dev/null 2>&1

  if [ "$?" -eq "0" ]; then
    break
  fi
done

echo "Waiting for VNC connections"

# Watch firefox process, kill vnc if it dies
while true; do
  kill -0 "$FIREFOX_PID" > /dev/null 2>&1

  if [ ! "$?" -eq "0" ]; then
    echo "Firefox has stopped, killing VNC server"
    tigervncserver -kill $DISPLAY
    break
  fi

  sleep 1
done

echo "Finished, thanks for playing"
