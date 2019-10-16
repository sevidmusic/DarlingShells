#!/bin/bash

printf "\n---------- ---------- ---------- ---------- ---------- \n"
while getopts "i:a:d:m:" opt; do
  case $opt in
  i) localAppsDirPath="$OPTARG" ;;
  a) appName="$OPTARG" ;;
  d) dcmsAppsDirPath="$OPTARG" ;;
  m) mode="flip" ;;
  *)
    printf "\nError: Invalid flag %s\n" "${opt}"
    exit 1
    ;;
  esac
done

# @todo" [-z $appName] && \ASK USER FOR APP NAME\ && appName=$appName

# determine mode | Note this may be removed if update app script is developed
if [ "$mode" == "flip" ]; then
  # defaults
  localAppsDirPath=${localAppsDirPath:-/home/sevi/PhpstormProjects/DarlingCms/apps}
  dcmsAppsDirPath=${dcmsAppsDirPath:-/home/sevi/PhpstormProjects/dcmsApps}
else
  # defaults
  localAppsDirPath=${localAppsDirPath:-/home/sevi/PhpstormProjects/dcmsApps}
  dcmsAppsDirPath=${dcmsAppsDirPath:-/home/sevi/PhpstormProjects/DarlingCms/apps}
fi

# Constructed vars | Note: Since rsync is used, repoPath must have trailing slash or else it will be copied as subdir of installPath i.e. /repo/appName would be insalled to /dest/appName/appName not /dest/appName
repoPath="${localAppsDirPath}/${appName}/"
installPath="${dcmsAppsDirPath}/${appName}"

printf "\nAre you really sure you want to install the %s app?:\n
Install Source        %s\n
Install Destination   %s\n
(Enter \"y\" to proceed, enter any other key to exit.)\n
\n" "${appName}" "${repoPath}" "${installPath}"

read -r confirm
if [ "$confirm" != "y" ]; then
  exit 0
fi

printf "\n----- Generating installation preview. -----\n"

sleep 4

rsync -aAXv --delete --dry-run "${repoPath}" "${installPath}"

printf "\nPlease review the installation preview above.\n
If everything looks ok, enter \"y\" to proceed with installation,\n
otherwise enter any other key to exit.\n"

read -r confirm

if [ "$confirm" != "y" ]; then
  exit 0
fi
# options -a (archive | sams as -rlptgoD) -A (preserve ACLs) -X (preserve extended attributes) -v (verbose)
rsync -aAXv --delete "${repoPath}" "${installPath}"

printf "\n----------- ---------- ---------- ---------- ---------- \n"
