#!/bin/sh
printf '\033c\033]0;%s\a' Lidar 3rd
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Lidar 3rd.x86_64" "$@"
