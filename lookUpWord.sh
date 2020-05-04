#!/bin/bash

set -o posix

curl "dict://dict.org/d:${1}" | grep -E "[0-9][.][ ]"

