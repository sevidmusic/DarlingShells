export PATH="${PATH}:${HOME}/.local/bin"

# Always start with fresh history
history -c

#### FUNCTIONS ####

setTextColor() {
  printf "\e[%sm" "${1}"
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

initColors

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
###################

# Move into ~/Codes/DarlingCmsRedesign directory
cd ~/Code/DarlingCmsRedesign;

# System Aliases
alias lsa="ls -al"
alias lsr="ls -AR --group-directories-first"
alias c="clear"
alias d="diff -y --suppress-common-lines"

# IntellijPyWalGen Aliases
alias pwj="~/gitClones/intellijPywal/intellijPywalGen.sh ~/.PhpStorm2019.3/config && rbash"
rsync -c ~/.PhpStorm2019.3/config/colors/material-pywal.icls /home/sevidmusic/Code/DarlingShells/material-pywal.icls

# w3m aliases
alias dcms="w3m 192.168.33.10"

# Vagrant Aliases
alias vup="vagrant up"
alias vdn="vagrant halt"
alias vkill="vagrant destroy"
alias vsh="vagrant ssh"

# Git Aliases
alias gst="git status"
alias gpo="git push -u origin"
alias gpa="git push -u origin Extensions WorkingDemo abstractions classes dsh interfaces master unitTests"
alias gcm="git commit -am"
alias gbr="git branch"
alias gco="git checkout"
alias gmr="git merge"
alias gdf="git diff"

# Vi Mode (Allows vim commands to be used in bash)
set -o vi;

# Ctags (needed for vim autocompletion, though not necessarily related to vim)
# Note: Both ctags and exuberant ctags are accomodated, the ectagsUpdate will
# update the tag file named "php.tags". The ctagsUpdate will update the tag file
# named "ctags.tags". (Exuberant is an improvment of ctagsh, so i prefer it.)
alias ectagsUpdate="ctags-exuberant -R -V --languages=PHP -f php.tags ./"
alias ctagsUpdate="ctags -R -V --languages=PHP -f ctags.tags ./"

# Edit .bash_aliases via vim
alias editAliases="vim ~/.bash_aliases"

# edit .vimrc via vim
alias editVimrc="vim ~/.vimrc"

# Show all attached drives
alias showDrives="lsblk"


alias editI3Config="vim /home/sevidmusic/.config/i3/config"
alias editI3Status="sudo vim /etc/i3status.conf"

alias editComptonConfig="vim /home/sevidmusic/.config/compton.conf"

# Rsync #

# Backup .vimrc to DarlingShells on startup
#echo "Backing up .vimrc file...";
#echo "";
rsync -c /home/sevidmusic/.vimrc /home/sevidmusic/Code/DarlingShells/.vimrc;

# Backup .bash_aliases
#echo "Backing up .bash_aliases file...";
#echo "";
rsync -c /home/sevidmusic/.bash_aliases /home/sevidmusic/Code/DarlingShells/.bash_aliases;

# Backup i3 config
#echo "Backing up i3 config file...";
#echo "";
rsync -c /home/sevidmusic/.config/i3/config /home/sevidmusic/Code/DarlingShells/i3_config.txt;

# Backup i3status config
#echo "Backing up i3status config file...";
#echo "";
rsync -c /etc/i3status.conf /home/sevidmusic/Code/DarlingShells/i3status_config.txt;

# Backup i3status config
#echo "Backing up compton config file...";
#echo "";
rsync -c /home/sevidmusic/.config/compton.conf /home/sevidmusic/Code/DarlingShells/compton.conf;

# Copy current newComponent.sh from DarlingShells to DarlingCmsRedesign to keep DarliingCms's version up to date.
rsync -c /home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh /home/sevidmusic/Code/DarlingCmsRedesign/newComponent.sh;

# Copy current newPrimary.sh from DarlingShells to DarlingCmsRedesign to keep DarliingCms's version up to date.
rsync -c /home/sevidmusic/Code/DarlingShells/DCMS/newPrimary.sh /home/sevidmusic/Code/DarlingCmsRedesign/newPrimary.sh;


# Copy current component code templates from DarlingShells to DarlingCmsRedesign to keep DarlingCms's versions up to date.
rsync -cdr /home/sevidmusic/Code/DarlingShells/DCMS/templates/ /home/sevidmusic/Code/DarlingCmsRedesign/templates;

# Force programs to use vim when a terminal based text editor is needed
export VISUAL=vim
export EDITOR="$VISUAL"

# Useful shortcuts specifically intended for use while developing the DarlingCmsRedesign
alias dcmsListIdentifiable="find ./core -name 'Identifiable*.php' | grep 'Identifiable'"
alias dcmsListClassifiable="find ./core -name 'Classifiable*.php' | grep 'Classifiable'"
alias dcmsListExportable="find ./core -name 'Exportable*.php' | grep 'Exportable'"
alias dcmsListStorable="find ./core -name 'Storable*.php' | grep 'Storable'"
alias dcmsListSwitchable="find ./core -name 'Switchable*.php' | grep 'Switchable'"

alias dcmsListIdentifiableTests="find ./Tests -name 'Identifiable*.php' | grep 'Identifiable'"
alias dcmsListClassifiableTests="find ./Tests -name 'Classifiable*.php' | grep 'Classifiable'"
alias dcmsListExportableTests="find ./Tests -name 'Exportable*.php' | grep 'Exportable'"
alias dcmsListStorableTests="find ./Tests -name 'Storable*.php' | grep 'Storable'"
alias dcmsListSwitchableTests="find ./Tests -name 'Switchable*.php' | grep 'Switchable'"

# Find aliases
alias sRoot="find / \( -path /timeshift -o -path /tmp -o -path /proc \) -prune -o"

# Reload bash aliases
alias rbash="source ~/.bash_aliases"

alias compton="killall compton; compton -b;"

alias sysUpdate="sudo timeshift --create --comments 'Pre sysUpdate' && sudo apt update && sudo apt upgrade && sudo snap refresh"

alias phpStorm="/snap/phpstorm/136/bin/phpstorm.sh"

alias ct="wal -i ~/Wallpapers"

alias wthr="curl wttr.in?format=3"

# Take a screenshot, date it, and save to ~/Screenshots
alias scs="/home/sevidmusic/Code/DarlingShells/manualScreenshot.sh"

# Play fun animation
sl -al;

clear;

# Show wheather
curl wttr.in?format=2;

# Run neofetch on login (fun)
#neofetch;
#Use following while corona virus is fucking up the world
printf "\n%s\n--------------------\n" "Corona Virus Update"
### MISC ####
alias dshells="cd ~/Code/DarlingShells && pwd"
alias dcmsDev="cd ~/Code/DarlingCmsRedesign && pwd"
alias locate="locate -e"
alias locateCount="locate -c"
alias locateBlob="locate -0"
alias locateExactMatch="locate -r"
alias locateExactMatchCount="locate -cr"
alias museScore="/home/sevidmusic/AppImages/MuseScore-3.4.2-x86_64.AppImage"
alias q="exit"
alias cvWorld="curl -s https://corona-stats.online/"
alias cvUS="curl -s https://corona-stats.online/US"
alias cvUpdates="curl -s https://corona-stats.online/updates"
alias cvUSStatus="cvUS | grep 'US' | head -2 | column"
alias cvWorldStatus="cvWorld | grep 'World' | head -2 | column"
alias cvNYStatus="cvUS | grep 'York' | head -2 | column"
showLoadingBar "Loading" "dontClear"
printf "\n%s\n" "$(cvUSStatus)" &&
printf "\n%s\n" "$(cvUpdates | head -7)"
printf "\nCurrent Directory: %s%s%s\n" "$(setTextColor 42)"  "$(pwd)" "$(setTextColor 0)"

alias sdm="cd /home/sevidmusic/Music && pwd"
alias tns='/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Bazzer" -c "Foo"'
alias dnc=~/Code/DarlingShells/DCMS/demoNewComponent.sh
alias lsNewComponents='lsr Extensions/ | grep "[/]*[php]" | sed -E "s,component,,g; s,abstractions,abstractions/component,g; s,classes,classes/component,g; s,interfaces,interfaces/component,g; s,Extensions/Foo/Tests/Unit/interfaces/component/:,,g; s,//,/,g;" && printf "\n\n"'
