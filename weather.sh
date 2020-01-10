#!/bin/bash
WEATHER=$(curl -s wttr.in?format=4);
MSG=$(printf "${WEATHER}");
notify-send -t 3500 "${MSG}";
