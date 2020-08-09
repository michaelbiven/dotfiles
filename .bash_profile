######### Set PATH #########
# Note that asdf needs to sourced last at the bottom 
# of this file via `. $(brew --prefix asdf)/asdf.sh`.

# Explicity set PATH and ignore /private/etc/paths
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin

# Poetry
PATH="$HOME/.poetry/bin:$PATH"

# Add ~/.local to the PATH
if [[ -d $HOME/.local/bin ]]; then
        PATH=$HOME/.local/bin:$PATH
fi

# Add ~/bin to the $PATH
[[ :$PATH: == *:$HOME/bin:* ]] || PATH=$HOME/bin:$PATH

######### Prompt #########
# starship
eval "$(starship init bash)"

######### Options #########
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# notify of bg job completion immediately
set -o notify

# do not check for new mail
unset MAILCHECK

# default umask
umask 0022

######### Exports #########

# Make vim the default editor.
export EDITOR='vim';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Don't log these to the history
export HISTIGNORE=" *:ls:cd:cd -:df:pwd:exit:date:* --help:* -h:bg:fg:history:clear;"

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# B before Z
export BASH_SILENCE_DEPRECATION_WARNING=1

# ls colors
export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'

######### Tab Completion #########
# Add tab completion for many Bash commands
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# asdf
. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

#export PATH="$HOME/.asdf/installs/poetry/1.0.10/bin:$PATH"

######### Aliases #########

# Create a Zettle ID
alias zettel='date +"%Y%m%d%H%M%S"'

# List all files colorized in long format, including dot files
alias la="ls -laFG"

# List only directories
alias lsd="ls -lFG | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls -G"

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup'

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# IP addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="sudo ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# test DNS server receive buffer size
# https://www.dns-oarc.net/oarc/services/replysizetest
alias bdns="dig +short rs.dns-oarc.net TXT"

# Get week number
alias week='date +%V'

# youtube-dl
alias yt='youtube-dl --extract-audio --audio-format mp3'

# brew dependencies
alias brewlist="brew leaves | xargs brew deps --include-build --tree"

# open with browser
alias safari="open -a safari"
alias firefox="open -a firefox"
alias chrome="open -a google\ chrome"
alias edge="open -a microsoft\ edge"

######### Functions #########

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}

# Print top commands
function wh() {
  history | awk '{print $2};' | sort | uniq -c | sort -rn | head -20
}

# Tired of expanding ls to find out I need to switch to less
function l () {
    if [[ -z $1 ]]; then
        ls
    elif [[ -d $1 ]]; then
        # echo "$1 is a directory"
        ls $1
    elif [[ "$(file -bL --mime $1)" == *"charset=binary"* ]]; then
        # echo "$1 is a binary"
        file $1
    elif [[ -f $1 ]]; then
        # echo "$1 is a file"
        less $1
        file $1
    else
        #echo "$1 is not valid#"
        file $1
    fi
}

# Determine size of a file or total size of a directory
function fs() {
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

# print active network services
function nets() {
  networksetup -listallnetworkservices | grep -v "*" | xargs 
}

alias cloudflaredns='sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 && sudo networksetup -setdnsservers "Thunderbolt Ethernet" 1.1.1.1'

# Convert to lowercase.
function lc() {
  tr '[:upper:]' '[:lower:]'
}

# Convert to uppercase.
function uc() {
  tr '[:lower:]' '[:upper:]'
}

# Print PATHs one line each
function path(){
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

#########  Export PATH #########
export PATH=$PATH

export PATH="$HOME/.asdf/installs/poetry/1.0.10/bin:$PATH"
