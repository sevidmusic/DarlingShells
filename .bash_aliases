#!/bin/bash

# Path
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/Code/DarlingShells"

# Load custom bash functions from DarlingShells repo
source ~/Code/DarlingShells/.bash_functions

# Vi Mode (Allows vim commands to be used in bash)
set -o vi

# Force programs to use vim when a terminal based text editor is needed
export VISUAL=vim
export EDITOR="$VISUAL"

# Initialize colors for use with printf and echo
initColors

# Move into /var/www/html directory
cd /var/www/html

# Rsync #
rsync -c /home/vagrant/.vimrc /home/vagrant/Code/DarlingShells/.vimrc
rsync -c ~/.bash_aliases ~/Code/DarlingShells/.bash_aliases
rsync -c ~/reloadApps.sh ~/Code/DarlingShells/reloadApps.sh

# Play fun animation
sl -al
clear

showLoadingBar "Loading development environment"
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

# Darling dev aliases
alias ddms="w3m 192.168.33.10/index.php"
alias lsAllExtCompPHPFiles='lsr Extensions/ | grep "[/]*[php]" | sed -E "s,component,,g; s,abstractions,abstractions/component,g; s,classes,classes/component,g; s,interfaces,interfaces/component,g; s,Extensions/Foo/Tests/Unit/interfaces/component/:,,g; s,//,/,g;" && printf "\n\n"'

# Quick cd aliases
alias dshells="cd ~/Code/DarlingShells && pwd"
alias dcmsDev="cd ~/Code/DarlingCmsRedesign && pwd"

# Git aliases
alias gst="git status"
alias gpo="git push -u origin"
alias gcm="git commit -am"
alias gbr="git branch"
alias gco="git checkout"
alias gdf="git diff --color"

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

# Restart/reload aliases
alias rbash="source ~/.bash_aliases"

# Use entr to trigger scripts in various contexts
alias dshRunAllTests="showLoadingBar 'Tests will start in a moment' && sleep 1 && find /var/www/html/core /var/www/html/Tests /var/www/html/Extensions /var/www/html/Apps /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/usr/bin/sleep 3 && /usr/bin/sl && clear && /var/www/html/vendor/phpunit/phpunit/phpunit -c /var/www/html/php.xml'"
alias devAppStart="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.*' | entr -s '/home/vagrant/reloadApps.sh'";

# Always run fix apache script
sudo ~/Code/DarlingShells/fixApachePermissonIssue.sh

# Php Unit Stuff
alias phpunit="/var/www/html/vendor/phpunit/phpunit/phpunit -c php.xml"
alias phpunitD="/var/www/html/vendor/phpunit/phpunit/phpunit --verbose --debug -c php.xml"
alias phpunitV="phpunitD | grep -En '^[A-Z]|::|^Test|started|interfaces|classes|abstractions'"
alias lotsOTests="for i in {0..100} ; do phpunit; done"

# Re-install App aliases
alias dcmsInstallDevApps="rbash && cd ./Apps/WorkingDemo && php ./Components.php && sleep 2 && cd ../dcmsDev && php ./Components.php && sleep 2 && rbash"
alias dcmsReInstallBBPC="cd /var/www/html && rm -r ./.dcmsJsonData && cd /var/www/html/Apps/blackballotpowercontest/ && php ./Components.php && cd /var/www/html"
alias dcmsReinstalDcmsDevApp="sudo rm -r /var/www/html/.dcmsJsonData/ && cd /var/www/html/Apps/dcmsDev/ && php ./Components.php && cd /var/www/html && sleep 1 && clear && w3m -dump dcms.dev"

# Unsorted aliases

