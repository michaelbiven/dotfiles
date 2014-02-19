# Load the default .profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile"

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
