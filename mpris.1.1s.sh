#!/usr/bin/env bash

COMMAND_BASE='dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2'

PLAY_PAUSE="$COMMAND_BASE org.mpris.MediaPlayer2.Player.PlayPause"
NEXT="$COMMAND_BASE org.mpris.MediaPlayer2.Player.Next"
PREVIOUS="$COMMAND_BASE org.mpris.MediaPlayer2.Player.Previous"

MPRIS_META=$($COMMAND_BASE org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata)

ARTIST=$(echo "$MPRIS_META" | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2)
SONG_TITLE=$(echo "$MPRIS_META" | sed -n '/title/{n;p}' | cut -d '"' -f 2)

# get current hour (24 clock format i.e. 0-23)
hour=$(date +"%H")

# if it is midnight to midafternoon will say G'morning
if [ $hour -ge 0 -a $hour -lt 12 ]; then
  greet="Good Morning, $USER."
# if it is midafternoon to evening ( before 6 pm) will say G'noon
elif [ $hour -ge 12 -a $hour -lt 18 ]; then
  greet="Good Afternoon, $USER."
else # it is good evening till midnight
  greet="Good evening, $USER."
fi

if [[ -z "$SONG_TITLE" ]]; then
  TITLE="$greet"
else
  TITLE="$ARTIST - $SONG_TITLE"
fi

echo "$TITLE"
echo "---"
echo "Focus | bash='wmctrl -a $SONG_TITLE' terminal=false refresh=false"
echo "---"
echo "Play/Pause | bash='$PLAY_PAUSE' terminal=false refresh=false"
echo "---"
echo "Next | bash='$NEXT' terminal=false refresh=true"
echo "Previous | bash='$PREVIOUS' terminal=false refresh=true"
echo "---"
echo "Launch | bash='spotify & sleep 0.35 && xdotool getactivewindow windowminimize' terminal=false refresh=false"
