# Move into ~/Codes/DarlingCmsRedesign directory
cd ~/Code/DarlingCmsRedesign

# System Aliases
alias lsa="ls -al"
alias lsr="ls -AR --group-directories-first"
# Vagrant Aliases
alias vup="vagrant up"
alias vdn="vagrant halt"
alias vkill="vagrant destroy"
alias vsh="vagrant ssh"

# Git Aliases
alias gst="git status"
alias gpo="git push -u origin"
alias gpa="git push -u origin unitTests interfaces abstractions classes master"
alias gcm="git commit -am"
alias gbr="git branch"
alias gco="git checkout"
alias gmr="git merge"
alias gdf="git diff"

# Vi Mode (Allows vim commands to be used in bash)
set -o vi

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

# Rsync #

alias buI3="rsync -cvv /home/sevidmusic/.config/i3/config /home/sevidmusic/Code/DarlingShells/i3config"

# Backup .vimrc to DarlingShells on startup
echo "Backing up .vimrc file...";
echo "";
rsync -cvv /home/sevidmusic/.vimrc /home/sevidmusic/Code/DarlingShells/.vimrc;

# Backup .bash_aliases
echo "Backing up .bash_aliases file...";
echo "";
rsync -cvv /home/sevidmusic/.bash_aliases /home/sevidmusic/Code/DarlingShells/.bash_aliases;

# Backup i3 config
echo "Backing up i3 config file...";
echo "";
rsync -cvv /home/sevidmusic/.config/i3/config /home/sevidmusic/Code/DarlingShells/i3_config.txt;

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

# Use feh to assign desktop bg
feh --bg-fill ~/Pictures/matrixCodeBG.jpeg

# Find aliases
alias sRoot="find / \( -path /timeshift -o -path /tmp -o -path /proc \) -prune -o"

# Reload bash aliases
alias rbash="source ~/.bash_aliases"

