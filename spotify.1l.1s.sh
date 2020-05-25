#!/usr/bin/env bash

COMMAND_BASE='playerctl --player=spotify'

SONG_ARTIST=$($COMMAND_BASE metadata xesam:artist)
SONG_TITLE=$($COMMAND_BASE metadata xesam:title)

SONG_URL=$($COMMAND_BASE metadata xesam:url)

PLAY_PAUSE="$COMMAND_BASE play-pause"
NEXT="$COMMAND_BASE next"
PREVIOUS="$COMMAND_BASE previous"

COPY_URL="echo $SONG_URL | xclip -sel clip"
COPY_NOTIFY="notify-send \"Spotify\" \"Copied track url to clipboard.\""

# ART IMAGE

ART_ID=$($COMMAND_BASE metadata mpris:artUrl)
ART_ID="${ART_ID/'https://open.spotify.com/image/'/''}"

ART_URL="https://i.scdn.co/image/$ART_ID"

ART_PATH="$HOME/.cache/$ART_ID"

# cache art img to disk
wget -q -nc "$ART_URL" -O "$ART_PATH"

ART_IMG=$(base64 -w 0 $ART_PATH)

# GREET FORMAT

# get current hour (24 clock format i.e. 0-23)
HOUR=$(date +"%H")

# if it is midnight to midafternoon will say G'morning
if [ $HOUR -ge 0 -a $HOUR -lt 12 ]; then
  GREET="Good Morning, $USER."
# if it is midafternoon to evening ( before 6 pm) will say G'noon
elif [ $HOUR -ge 12 -a $HOUR -lt 18 ]; then
  GREET="Good Afternoon, $USER."
else # it is good evening till midnight
  GREET="Good evening, $USER."
fi

# PLAY/PAUSE FORMAT

STATE=$($COMMAND_BASE status)

if [ "$STATE" == "Playing" ]; then
    STATE="Pause"
else
    STATE="Play"
fi

# TITLE FORMAT

if [[ -z "$SONG_TITLE" ]]; then
  TITLE="$GREET"
elif [[ -z "$SONG_ARTIST" ]]; then
  TITLE="$SONG_TITLE"
else
  TITLE="$SONG_ARTIST - $SONG_TITLE"
fi

# ARGOS OUTPUT

echo "$TITLE"
echo "---"

# if spotify is running
if [ "$TITLE" != "$GREET" ]; then
  echo "<b>$SONG_ARTIST</b>\n<b>$SONG_TITLE</b> | bash='$COPY_URL && $COPY_NOTIFY' terminal=false image='$ART_IMG' imageWidth=56 imageHeight=56"
  echo "---"
  echo "$STATE | bash='$PLAY_PAUSE' terminal=false refresh=true"
  echo "---"
  echo "Next | bash='$NEXT' terminal=false refresh=true"
  echo "Previous | bash='$PREVIOUS' terminal=false refresh=true"
else
  echo "Launch | bash='spotify' terminal=false refresh=false"
fi
