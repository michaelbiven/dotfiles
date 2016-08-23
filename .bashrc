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

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# DNS
alias masqdns='sudo networksetup -setdnsservers "Wi-Fi" 127.0.0.1 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 127.0.0.1'
alias opendns='sudo networksetup -setdnsservers "Wi-Fi" 208.67.222.222 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 208.67.222.222'
alias googledns='sudo networksetup -setdnsservers "Wi-Fi" 8.8.8.8 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 8.8.8.8'
alias flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ips="sudo ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Get week number
alias week='date +%V'

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_ed25519.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Pipe my private key to my clipboard.
alias prikey="more ~/.ssh/id_ed25519 | pbcopy | echo '=> Private key copied to pasteboard.'"


# functions
# drain gearman queue
# drain_gearman HOSTNAME FUNCTION NAME
  function drain_gearman() {
    gearman -t 1000 -n -w -h $1-f $2 > /dev/null
  }
  
# Create a new directory and enter it
mkd() {
	mkdir -p "$@" && cd "$@"
}

wh() {
  history | awk '{print $2};' | sort | uniq -c | sort -rn | head -20
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# View TLS
function ciphers() {
  nmap --script ssl-cert,ssl-enum-ciphers -p 443,993 "$@"
}


#
# Get the common name and all he SANS for a https
#
function getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified."
    return 1
  fi

  local domain="${1}"
  echo "Testing ${domain}…"
  echo ""; # newline

  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" 2>&1)

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_header, no_serial, no_version, \
      no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
    echo "Common Name:"
    echo ""; # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
    echo ""; # newline
    echo "Subject Alternative Name(s):"
    echo ""; # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
    return 0
  else
    echo "ERROR: Certificate not found."
    return 1
  fi
}

# Credit: https://gist.github.com/dansimau/f5d8b0b2aefb9c9c46621f4869ccc151
#
# Change to the directory of the specified Go package name.
#
gg() {
	paths=($(g "$@"))
	path_index=0

	if [ ${#paths[@]} -gt 1 ]; then
		c=1
		for path in "${paths[@]}"; do
			echo [$c]: cd ${GOPATH}/${path}
			c=$((c+1))
		done
		echo -n "Go to which path: "
		read path_index

		path_index=$(($path_index-1))
	fi

	path=${paths[$path_index]}
	cd $GOPATH/src/$path
}

#
# Print the directories of the specified Go package name.
#
g() {
	local pkg_candidates="$((cd $GOPATH/src && find . -mindepth 1 -maxdepth 5 -type d \( -path "*/$1" -or -path "*/$1.git" \) -print) | sed 's/^\.\///g')"
	echo "$pkg_candidates"
}

#
# Bash autocomplete for g and gg functions.
#
_g_complete()
{
    COMPREPLY=()

    local cur
    local prev

    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=( $(compgen -W "$(for f in $(find "$GOPATH/src" -mindepth 1 -maxdepth 5 -type d -name "${cur}*" ! -name '.*' ! -path '*/.git/*' ! -path '*/test/*' ! -path '*/Godeps/*' ! -path '*/examples/*'); do echo "${f##*/}"; done)" --  "$cur") )
    return 0
}

complete -F _g_complete g
complete -F _g_complete gg

export PATH

