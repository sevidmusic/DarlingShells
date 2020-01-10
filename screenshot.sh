#!/bin/bash

DATE=$(date +"/home/sevidmusic/Screenshots/%Y%m%d_%I%M%S%P.png");
MSG=$(printf "Created new screenshot:\n\n${DATE}");
import -window root "${DATE}";
notify-send -t 2500 "${MSG}";

