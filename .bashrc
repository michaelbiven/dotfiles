# My God, it's full of stars
. ~/bin/bash_colors.sh

# notify of bg job completion immediately
set -o notify

# vi mode
set -o vi

# do not check for new mail
unset MAILCHECK

# default umask
umask 0022

# Paths
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"


# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
export NODE_PATH="$NODE_PATH:$NVM_DIR/$VERSION/lib/node_modules"

# rvm
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/Dropbox/go
PATH="$GOROOT/bin:$GOPATH/bin:$PATH"


if [ -f ~/bin/git-completion.bash ]; then
  . ~/bin/git-completion.bash
fi


if [[ -n "$(which brew)" ]]; then
	export BREW_CELLAR=$(brew --cellar)
	export BREW_PREFIX=$(brew --prefix)
fi

if [[ -f $BREW_PREFIX/etc/bash_completion ]]; then
  source $BREW_PREFIX/etc/bash_completion
fi

# history 101
export HISTSIZE=1000000
export HISTFILESIZE=1000000000
shopt -s histappend


export TERM='xterm-color'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Load in the git branch prompt script.
source ~/bin/git-prompt.sh

# PS1 prompt
PS1="\[$BRIGHT_BLUE\]╭\[$BRIGHT_YELLOW\] \t \[$BRIGHT_GREEN\]\u@\h \W\[$BRIGHT_BLUE\]\$(__git_ps1)\n\[$BRIGHT_BLUE\]╰ \$ \[$RESET\]"

# Load any local settings
if [[ -r "$HOME/.bash.local" ]]; then
  source "$HOME/.bash.local"
fi

# aliases
alias ls='ls -G'
alias ll='ls -lG'
alias rs="rsync -zavrR --delete --links"
alias be='bundle exec'
alias beep='tput bel'
alias myip="ifconfig | grep inet | grep -v 127.0.0.1 | awk '{print \$2}' | cut -d: -f2"
alias masqdns='sudo networksetup -setdnsservers "Wi-Fi" 127.0.0.1 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 127.0.0.1'
alias opendns='sudo networksetup -setdnsservers "Wi-Fi" 208.67.222.222 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 208.67.222.222'
alias googledns='sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 8.8.8.8'


# functions
# drain gearman queue
# drain_gearman HOSTNAME FUNCTION NAME
  function drain_gearman() {
    gearman -t 1000 -n -w -h $1-f $2 > /dev/null
  }

export PATH
