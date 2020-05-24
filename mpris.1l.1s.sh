#!/usr/bin/env bash

COMMAND_BASE='playerctl --player=spotify'

PLAY_PAUSE="$COMMAND_BASE play-pause"
NEXT="$COMMAND_BASE next"
PREVIOUS="$COMMAND_BASE previous"

STATE=$($COMMAND_BASE status)

ARTIST=$($COMMAND_BASE metadata xesam:artist)
SONG_TITLE=$($COMMAND_BASE metadata xesam:title)

ART_URL=$($COMMAND_BASE metadata mpris:artUrl)

# workaround spotify not caring to update their client on linux
ART_URL="${ART_URL/"open.spotify.com"/"i.scdn.co"}"

ART_IMG=$(curl -s "$ART_URL" | base64 -w 0)

# get current hour (24 clock format i.e. 0-23)
HOUR=$(date +"%H")

# PLAY/PAUSE FORMAT

if [ "$STATE" == "Playing" ]; then
    STATE="Pause"
else
    STATE="Play"
fi

# GREET FORMAT

# if it is midnight to midafternoon will say G'morning
if [ $HOUR -ge 0 -a $HOUR -lt 12 ]; then
  GREET="Good Morning, $USER."
# if it is midafternoon to evening ( before 6 pm) will say G'noon
elif [ $HOUR -ge 12 -a $HOUR -lt 18 ]; then
  GREET="Good Afternoon, $USER."
else # it is good evening till midnight
  GREET="Good evening, $USER."
fi

# TITLE FORMAT

if [[ -z "$SONG_TITLE" ]]; then
  TITLE="$GREET"
elif [[ -z "$ARTIST" ]]; then
  TITLE="$SONG_TITLE"
else
  TITLE="$ARTIST - $SONG_TITLE"
fi

# ARGOS OUTPUT

echo "$TITLE"
echo "---"

if [ "$TITLE" != "$GREET" ]; then
  echo "<b>$ARTIST</b>\n<b>$SONG_TITLE</b> | image='$ART_IMG' imageWidth=56 imageHeight=56"
  echo "---"
  echo "$STATE | bash='$PLAY_PAUSE' terminal=false refresh=true"
  echo "---"
  echo "Next | bash='$NEXT' terminal=false refresh=true"
  echo "Previous | bash='$PREVIOUS' terminal=false refresh=true"
else
  echo "Launch | bash='spotify' terminal=false refresh=false"
fi
