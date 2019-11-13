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
alias gcm="git commit -am"
alias gbr="git branch"
alias gco="git checkout"
alias gmr="git merge"
alias gdf="git diff"

# Vi Mode (Allows vim commands to be used in bash)
set -o vi

# Ctags (needed for vim autocompletion, though not necessarily related to vim)
alias updateCtags="ctags-exuberant -f php.tags --languages=PHP -R"
