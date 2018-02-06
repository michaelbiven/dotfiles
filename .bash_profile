# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

eval "$(rbenv init -)"
