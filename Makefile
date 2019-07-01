# "Just because it's automatic doesn't mean it works."
# — Daniel J. Bernstein

.PHONY: install bin dotfiles initial brew python ruby node mac

install: bin dotfiles initial brew python ruby node mac

bin:
	# add aliases for things in bin
	[ -d ~/T ] || mkdir ~/bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sf $$file ~/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name "*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name "Brewfile" -not -name "LICENSE" -not -name "Makefile" -not -name "macos" -not -name "*.md"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.$$f; \
	done; \
	ln -fn $(CURDIR)/.gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;

initial: 
	# Install Xcode Command Line Tools.
	xcode-select --install;
	# install homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

brew:
	brew cleanup;
	brew doctor;
	brew update;
	brew bundle;

python:
	pyenv install 3.5.7;
	pyenv install 3.6.8;
	pyenv install 3.7.3
	pyenv global 3.7.3;
	eval "$(pyenv init -)";
	curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python;
	pipsi install pipenv;
	pipsi install legit;
	pipsi install em-keyboard;

ruby:
	rbenv install 2.4.6;
	rbenv install 2.5.5;
	rbenv global 2.5.5;

node:
	if [ ! -d "$HOME/.nvm/" ]; then \
  		mkdir "$HOME/.nvm" \
	fi;
	nvm install --lts;
	nvm install 12.5.0;

mac:
	# apply settings from macos.sh
	$(CURDIR)/macos.sh

default: install
