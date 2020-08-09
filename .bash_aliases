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
rsync -c ~/.bash_profile ~/Code/DarlingShells/.bash_profile
rsync -c ~/.bashrc ~/Code/DarlingShells/.bashrc
rsync -c ~/gitDiff.sh ~/Code/DarlingShells/gitDiff.sh
rsync -c ~/gitStatus.sh ~/Code/DarlingShells/gitStatus.sh
rsync -c ~/reloadApps.sh ~/Code/DarlingShells/reloadApps.sh
rsync -c ~/runPhpUnitContestTests.sh ~/Code/DarlingShells/runPhpUnitContestTests.sh
rsync -c ~/runPhpUnit.sh ~/Code/DarlingShells/runPhpUnit.sh
rsync -c ~/runFactoryTests.sh ~/Code/DarlingShells/runFactoryTests.sh


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
alias gitCommitAndUpdateFromUnitTests="showLoadingBar 'Running tests' && phpunit && reloadApps.sh && showLoadingBar 'Preparinig to commit changes from unitTests and update other repos' && gbr && sleep 1 && showLoadingBar 'Loading diff for review' && git diff unitTests --color && showLoadingBar 'Committing changes' && git add . && git commit -a && showLoadingBar 'Pushing changes to origin/unitTests' && gpo && showLoadingBar 'Running tests before updating other repos' && phpunit && reloadApps.sh && showLoadingBar 'Updating other repos' && showLoadingBar 'Checking out master' && git checkout master && showLoadingBar 'Pulling from origin/unitTests' && git pull origin unitTests && showLoadingBar 'Pushing changes to master' && gpo && showLoadingBar 'Checking out Apps' && git checkout Apps && showLoadingBar 'Pulling from origin/master' && git pull origin master && showLoadingBar 'Pushing to origin/Apps' && gpo && showLoadingBar 'Checking out bbp' && git checkout blackballotpowercontest && showLoadingBar 'Pulling from origin/master' && git pull origin master && showLoadingBar 'Pushing to origin/blackballotpowercontest' && gpo && showLoadingBar 'All repos are up to date, switching back to unitTests' && git checkout unitTests && showLoadingBar 'Checking diff' && git diff origin/unitTests && git diff origin/master && git diff origin/Apps && git diff origin/blackballotpowercontest && gst && git log -1"
alias gitUpdateFromUnitTests="showLoadingBar 'Running tests' && phpunit && reloadApps.sh && showLoadingBar 'Running tests before updating other repos' && phpunit && reloadApps.sh && showLoadingBar 'Updating other repos' && showLoadingBar 'Checking out master' && git checkout master && showLoadingBar 'Pulling from origin/unitTests' && git pull origin unitTests && showLoadingBar 'Pushing changes to master' && gpo && showLoadingBar 'Checking out Apps' && git checkout Apps && showLoadingBar 'Pulling from origin/master' && git pull origin master && showLoadingBar 'Pushing to origin/Apps' && gpo && showLoadingBar 'Checking out bbp' && git checkout blackballotpowercontest && showLoadingBar 'Pulling from origin/master' && git pull origin master && showLoadingBar 'Pushing to origin/blackballotpowercontest' && gpo && showLoadingBar 'All repos are up to date, switching back to unitTests' && git checkout unitTests && showLoadingBar 'Checking diff' && git diff origin/unitTests && git diff origin/master && git diff origin/Apps && git diff origin/blackballotpowercontest && gst && git log -1"


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
alias devAppStart="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.php' | entr -s '/home/vagrant/reloadApps.sh'";
alias devStartCore="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.php' | entr -s '/home/vagrant/runPhpUnit.sh \"Core\"'";
alias devStartExt="find /var/www/html/core /var/www/html/Extensions /var/www/html/Apps /var/www/html/Tests /var/www/html/index.php /var/www/html/php.xml -name '*.php' | entr -s '/home/vagrant/runPhpUnit.sh \"Extensions\"'";

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

alias tnsCode="tmux new -s Code"
alias nprHeadlines="w3m -dump https://text.npr.org | grep -m 5 '•'"
alias cnnHeadlines="w3m -dump https://lite.cnn.com/en | grep -m 5 '•'"
alias hackerNews="w3m -dump https://news.ycombinator.com | grep -m 10 -E '[0-9]'"
