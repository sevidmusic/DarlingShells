#!/bin/bash

set -o posix

error_dshells_repo_missing() {
    printf "\n\nPlease clone Darling Shells repo to ~/DarlingShells to use this script"
    exit 1
}

[[ -f ~/DarlingShells/darlingarch.sh ]] || error_dshells_repo_missing

printf "\n\nInstalling vim, tmux, and htop\n\n" && sleep 2
pacman -Syy tmux vim htop --noconfirm

printf "\n\nConfiguring git\n\n" && sleep 2
git config --global user.name "sevidmusic"
git config --global user.email "sdmwebsdm&gmail.com"

mkdir -p /root/.config/htop

printf "\n\nsyncing user configuration files\n\n" && sleep 2
rsync -c ~/DarlingShells/.autorsync ~/.autorsync
rsync -c ~/DarlingShells/.bashrc ~/.bashrc
rsync -c ~/DarlingShells/.bash_aliases ~/.bash_aliases
rsync -c ~/DarlingShells/.bash_profile ~/.bash_profile
rsync -c ~/DarlingShells/.tmux.conf ~/.tmux.conf
rsync -c ~/DarlingShells/.vimrc ~/.vimrc
rsync -c ~/DarlingShells/darlingarch.sh ~/darlingarch.sh
rsync -c ~/DarlingShells/htoprc /root/.config/htop/htoprc


printf "\n\nMaking ~/Code direcotry\n\n" && sleep 2
[[ -d ~/Code ]] || mkdir ~/Code

printf "\n\nMoving ~/DarlingShells to ~/Code/DarlingShells\n\n" && sleep 2
mv ~/DarlingShells ~/Code/DarlingShells

[[ -f ~/.bash_profile ]] && .~/.bash_profile

printf "\n\nDone\n\n"

pwd

ls -a
