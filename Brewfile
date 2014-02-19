# Install command-line tools using Homebrew
# Usage: `brew bundle Brewfile`
#
# http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
# https://github.com/mathiasbynens/dotfiles

# Make sure we’re using the latest Homebrew
update

# Upgrade any already-installed formulae
upgrade

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
install coreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`
install findutils --default-names
# Install GNU `sed`, overwrite built-in `sed`
install gnu-sed --default-names
# Install Bash 4
install bash
install bash-completion

# Install wget with IRI support
install wget --enable-iri


# Install more recent versions of some OS X tools
install vim --override-system-vi
tap homebrew/dupes
install homebrew/dupes/grep


# Install other useful binaries
install ack
install git
install nmap
install pv
install tree
install webkit2png


# Remove outdated versions from the cellar
cleanup
