#!/usr/bin/env bash

COMMAND_BASE='playerctl --player=spotify'

PLAY_PAUSE="$COMMAND_BASE play-pause"
NEXT="$COMMAND_BASE next"
PREVIOUS="$COMMAND_BASE previous"

ARTIST=$($COMMAND_BASE metadata xesam:artist)
SONG_TITLE=$($COMMAND_BASE metadata xesam:title)

ART_URL=$($COMMAND_BASE metadata mpris:artUrl)

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
elif [[ -z "$ARTIST" ]]; then
  TITLE="$SONG_TITLE"
else
  TITLE="$ARTIST - $SONG_TITLE"
fi

echo "$TITLE"
echo "---"
echo "Play - Pause | bash='$PLAY_PAUSE' terminal=false refresh=false"
echo "---"
echo "Next | bash='$NEXT' terminal=false refresh=true"
echo "Previous | bash='$PREVIOUS' terminal=false refresh=true"
echo "---"
echo "Launch | bash='spotify' terminal=false refresh=false"
