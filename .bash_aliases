#!/bin/bash

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/Code/DarlingShells"

### Functions ###
# @todo May be error, though this is working, currently referenceing $2, thinking it should be $1...test later
setTextColor() {
  printf "\e[%sm" "${2}"
}

writeWordSleep() {
  printf "%s" "${1}"
  sleep "${2}"
}

sleepWriteWord() {
  sleep "${2}"
  printf "%s" "${1}"
}

sleepWriteWordSleep() {
  sleep "${2}"
  printf "%s" "${1}"
  sleep "${2}"
}


initColors() {
  WARNINGCOLOR=$(setTextColor 35)
  CLEARCOLOR=$(setTextColor 0)
  NOTIFYCOLOR=$(setTextColor 33)
  DSHCOLOR=$(setTextColor 41)
  USRPRMPTCOLOR=$(setTextColor 41)
  HIGHLIGHTCOLOR=$(setTextColor 41)
  HIGHLIGHTCOLOR2=$(setTextColor 45)
  ATTENTIONEFFECT=$(setTextColor 5)
  ATTENTIONEFFECTCOLOR=$(setTextColor 36)
  DARKTEXTCOLOR=$(setTextColor 30)
}


showLoadingBar() {
  local _slb_inc
  printf "\n"
  sleepWriteWordSleep "${CLEARCOLOR}${ATTENTIONEFFECT}${ATTENTIONEFFECTCOLOR}${1}${CLEARCOLOR}" .3
  setTextColor 43
  _slb_inc=0
  while [[ ${_slb_inc} -le 27 ]]; do
    sleepWriteWordSleep ":" .009
    _slb_inc=$((_slb_inc + 1))
  done
  echo "${ATTENTIONEFFECTCOLOR}[100%]${CLEARCOLOR}"
  setTextColor 0
  sleep 1
  if [[ "${2}" != "dontClear" ]]; then
    clear
  fi
}

### Do on login ###

# If not in a tmux session, use pywal to set color scheme to random wallpaper in ~/Wallpapers
# (if were in tmux weve already loggend in so there is no need to run this)
[[ -z "${TMUX}" ]] && wal -q -i /home/sevidmusic/Wallpapers

# Initialize colors for use with printf and echo
initColors

# Move into /var/www/html directory
cd /var/www/html

# Vi Mode (Allows vim commands to be used in bash)
set -o vi

# Force programs to use vim when a terminal based text editor is needed
export VISUAL=vim
export EDITOR="$VISUAL"

# Rsync #

# Backup color scheme created by pywal for phpstorm, this color scheme is generated whenever wal is run.
#rsync -c ~/.PhpStorm2019.3/config/colors/material-pywal.icls /home/sevidmusic/Code/DarlingShells/material-pywal.icls

# Backup .vimrc to DarlingShells on startup
#rsync -c /home/sevidmusic/.vimrc /home/sevidmusic/Code/DarlingShells/.vimrc

# Backup .bash_aliases
#rsync -c /home/sevidmusic/.bash_aliases /home/sevidmusic/Code/DarlingShells/.bash_aliases

# Backup i3 config
#rsync -c /home/sevidmusic/.config/i3/config /home/sevidmusic/Code/DarlingShells/i3_config.txt

# Backup i3status config
#rsync -c /etc/i3status.conf /home/sevidmusic/Code/DarlingShells/i3status_config.txt

# Backup i3status config
#rsync -c /home/sevidmusic/.config/compton.conf /home/sevidmusic/Code/DarlingShells/compton.conf

# Copy current newComponent.sh from DarlingShells to DarlingCmsRedesign to keep DarliingCms's version up to date.
#rsync -c /home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh /home/sevidmusic/Code/DarlingCmsRedesign/newComponent.sh

# Copy current newPrimary.sh from DarlingShells to DarlingCmsRedesign to keep DarliingCms's version up to date.
#rsync -c /home/sevidmusic/Code/DarlingShells/DCMS/newPrimary.sh /home/sevidmusic/Code/DarlingCmsRedesign/newPrimary.sh

# Copy current component code templates from DarlingShells to DarlingCmsRedesign to keep DarlingCms's versions up to date.
#rsync -cdr /home/sevidmusic/Code/DarlingShells/DCMS/templates/ /home/sevidmusic/Code/DarlingCmsRedesign/templates

# Play fun animation
sl -al
clear

# Show wheather
curl wttr.in?format=2;

# Run neofetch on login (fun)
#neofetch
showLoadingBar "Loading"
sleep 1
clear

# Always start with fresh history
history -c

### aliases ###

# System aliases
alias lsa="ls -al"
alias lsr="ls -AR --group-directories-first"
alias c="clear"
alias d="diff -y --suppress-common-lines"
alias q="exit"

# System info aliases
## Show all attached drives
alias showDrives="lsblk"

# System update aliases
alias sysUpdate="sudo timeshift --create --comments 'Pre sysUpdate' && sudo apt update && sudo apt upgrade && sudo snap refresh"
alias sysUpdateNoBu="sudo apt update && sudo apt upgrade && sudo snap refresh"

# pywal aliases
## Regenerate pywal color scheme for PhpStorm and place it in PhpStorm config dir, then call rbash whih will backup new scheme
alias pwj="~/gitClones/intellijPywal/intellijPywalGen.sh ~/.PhpStorm2019.3/config && rbash"

# Darling dev aliases
alias ddms="w3m 192.168.33.10/index.php"
alias lsAllExtCompPHPFiles='lsr Extensions/ | grep "[/]*[php]" | sed -E "s,component,,g; s,abstractions,abstractions/component,g; s,classes,classes/component,g; s,interfaces,interfaces/component,g; s,Extensions/Foo/Tests/Unit/interfaces/component/:,,g; s,//,/,g;" && printf "\n\n"'
alias dnc=~/Code/DarlingShells/DCMS/demoNewComponent.sh

# Quick cd aliases
alias dshells="cd ~/Code/DarlingShells && pwd"
alias dcmsDev="cd ~/Code/DarlingCmsRedesign && pwd"
alias sdm="cd /home/sevidmusic/Music && pwd"

# Vagrant aliases
alias vup="vagrant up"
alias vdn="vagrant halt"
alias vsh="vagrant ssh"

# Git aliases
alias gst="git status"
alias gpo="git push -u origin"
alias gpa="git push -u origin Extensions WorkingDemo abstractions classes dsh interfaces master unitTests"
alias gcm="git commit -am"
alias gbr="git branch"
alias gco="git checkout"
alias gmr="git merge"
alias gdf="git diff"

# ctags aliases
# (ctags is needed for vim autocompletion, though not necessarily related to vim)
# Note: Both ctags and exuberant ctags are accomodated, the ectagsUpdate will
# update the tag file named "php.tags". The ctagsUpdate will update the tag file
# named "ctags.tags". (Exuberant is an improvment of ctagsh, so i prefer it.)
alias ectagsUpdate="ctags-exuberant -R -V --languages=PHP -f php.tags ./"
alias ctagsUpdate="ctags -R -V --languages=PHP -f ctags.tags ./"

# Edit config aliases
alias editAliases="vim ~/.bash_aliases"
alias editVimrc="vim ~/.vimrc"
alias editI3Config="vim /home/sevidmusic/.config/i3/config"
alias editI3Status="sudo vim /etc/i3status.conf"
alias editComptonConfig="vim /home/sevidmusic/.config/compton.conf"

# Find aliases
alias sRoot="find / \( -path /timeshift -o -path /tmp -o -path /proc \) -prune -o"

# Restart/reload aliases
alias rbash="source ~/.bash_aliases"
alias compton="killall compton; compton -b;"

# Launch app aliases
alias phpStorm="/snap/phpstorm/136/bin/phpstorm.sh"
alias museScore="/home/sevidmusic/AppImages/MuseScore-3.4.2-x86_64.AppImage"

# Fun aliases
alias wthr="curl wttr.in?format=3"

# Note: This expects you to pipe to it, i.e., echo "Text to say" | say
alias say="spd-say -e -t 'female3' -m 'none' -i '-42' -p '17' -r '-27' -w && sleep 2"

# Take a screenshot, date it, and save to ~/Screenshots
alias scs="/home/sevidmusic/Code/DarlingShells/manualScreenshot.sh"

# locate aliases
alias locate="locate -e"
alias locateCount="locate -c"
alias locateBlob="locate -0"
alias locateExactMatch="locate -r"
alias locateExactMatchCount="locate -cr"


# VAGRANT SPECIFIC

# Run entr to trigger phpunit whenever one of the core/*.php
# or Tests/*.php files are modified
#alias devStart="find /var/www/html/core /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml'"
alias devStart="find /var/www/html/core /var/www/html/Tests /var/www/html/Extensions /var/www/html/Apps /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml'"

# Run entr to trigger git diff  whenever one of the core/*.php
# or Tests/*.php files are modified
#alias gitDiffStart="find /var/www/html/core /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/home/vagrant/gitDiff.sh'";
alias gitDiffStart="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/home/vagrant/gitDiff.sh'";

# Rund entr to trigger git status whenever one of the core/*.php
# or Tests/*.php file are modified.
alias gitStatStart="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/home/vagrant/gitStatus.sh'";

# Always run fix apache script
sudo ~/Code/DarlingShells/fixApachePermissonIssue.sh

# Php Unit Stuff

alias phpunit="/var/www/html/vendor/phpunit/phpunit/phpunit -c php.xml"
alias phpunitV="/var/www/html/vendor/phpunit/phpunit/phpunit --verbose -c php.xml"
alias phpunitD="/var/www/html/vendor/phpunit/phpunit/phpunit --verbose --debug -c php.xml"
alias lotsOTests="for i in {0..100} ; do phpunit; done"



# Unsorted aliases
alias ddmsDemo="w3m 192.168.33.10/WorkingDemo.php"
alias loopSl="while [[ true ]]; do showLoadingBar 'Starting up' && sl -al && clear && showLoadingBar 'The train has left the station. It shall return soon.' && sleep 5 && showLoadingBar 'Loading current DDMS dev stats' && sleep 5 && gst && sleep 5 && showLoadingBar 'Loading DDMS diff' && sleep 5 && git diff && sleep 5 && showLoadingBar 'Loading DDMS diff --stat' && git diff --stat && sleep 5 && showLoadingBar 'One moment please' && sleep 5 && showLoadingBar 'Loading date' && sleep 5&& date && sleep 5 && showLoadingBar 'Loading calander' && sleep 5 && cal && sleep 5 && showLoadingBar 'Loading current directory info' && sleep 5 && pwd && sleep 5 && ls && sleep 5 && showLoadingBar && sleep 5 && showLoadingBar 'The train should be arriving soon' && sleep 5 && showLoadingBar 'Preparing for reload' && sleep 5 && showLoadingBar 'The train is arriving. Restarting' && clear; done"
alias loopPwj="while [[ true ]]; do clear && sleep 3 && showLoadingBar 'The train should be arriving soon' && sleep 5 && sl -al && clear && showLoadingBar 'Preparing for reload' && sleep 5 && pwj && sleep 5 && showLoadingBar 'The train is arriving. Restarting' && clear && sleep 180; done"
rsync -c ~/.bash_aliases ~/Code/DarlingShells/.bash_aliases
