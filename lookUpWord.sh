#!/bin/bash

set -o posix

curl -s "dict://dict.org/d:${1}" | less

