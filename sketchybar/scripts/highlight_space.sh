#!/usr/bin/env bash

ICON_WIDTH=30
HIGHLIGHT_WIDTH=22
NEW_SPACE_WIDTH=27
PULL_LEFT=-999999

SPACES=$(yabai -m query --spaces)

read -r DID COUNT POS < <(echo "$SPACES" | jq -r '
  (map(select(.["has-focus"])) | .[0]) as $focused
  | (map(select(.display == $focused.display)) | map(.index)) as $siblings
  | "\($focused.display) \($siblings | length) \(($siblings | index($focused.index)) + 1)"
')

[[ -z $POS ]] && exit 0

OFFSET=$((NEW_SPACE_WIDTH + ICON_WIDTH - (ICON_WIDTH - HIGHLIGHT_WIDTH) / 2))
PADDING=$((-ICON_WIDTH * (COUNT - POS) - OFFSET))

FIRSTS=" $(echo "$SPACES" | jq -r 'group_by(.display) | map(min_by(.index).index) | join(" ")') "

ARGS=()
for sid in $(echo "$SPACES" | jq -r '.[].index'); do
  if [[ $FIRSTS == *" $sid "* ]]; then
    ARGS+=(--set "space_ex.$sid" padding_left=$PULL_LEFT)
  else
    ARGS+=(--set "space_ex.$sid" padding_left=0)
  fi
done

sketchybar "${ARGS[@]}" \
           --animate circ 10 \
           --set highlight_space display="$DID" background.padding_left=$PADDING
