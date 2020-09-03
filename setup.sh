#!/bin/bash

set -o posix

error_dshells_repo_missing() {
    printf "\n\nPlease clone Darling Shells repo to ~/DarlingShells to use this script"
    exit 1
}

[[ -f ~/DarlingShells/darlingarch.sh ]] || error_dshells_repo_missing

pacman -Syy tmux vim htop --noconfirm

git config --global user.name "sevidmusic"
git config --global user.email "sdmwebsdm&gmail.com"

rsync -c ~/DarlingShells/.autorsync ~/.autorsync
rsync -c ~/DarlingShells/.bashrc ~/.bashrc
rsync -c ~/DarlingShells/.bash_aliases ~/.bash_aliases
rsync -c ~/DarlingShells/.bash_profile ~/.bash_profile
rsync -c ~/DarlingShells/.tmux.conf ~/.tmux.conf
rsync -c ~/DarlingShells/.vimrc ~/.vimrc
rsync -c ~/DarlingShells/darlingarch.sh ~/darlingarch.sh
rsync -c ~/DarlingShells/htoprc /root/.config/htop/htoprc

mkdir ~/Code

mv ~/DarlingShells ~/Code/DarlingShells

source ~/.bash_profile

