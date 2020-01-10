#!/bin/sh

free -h | awk '/^Mem:/ {print $3 "/" $2}'

sensors -f | awk '/^temp1/ {print $2}'

sensors -f | awk '/^temp1/ {print $2}'

ps -axch -o cmd:15,%mem --sort=%mem | head

ps -axch -o cmd:15,%cpu --sort=%cpu | head
