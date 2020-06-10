# "Just because it's automatic doesn't mean it works."
# — Daniel J. Bernstein

.PHONY: install
install: bin dotfiles brew python ruby node

.PHONY: bin
bin:
	# add aliases for things in bin
	[[ -d $HOME/bin ]] || mkdir ~/bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done

.PHONY: dotfiles
dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".config" -not -name ".github" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	gpg --list-keys || true;
	mkdir -p $(HOME)/.gnupg
	for file in $(shell find $(CURDIR)/.gnupg); do \
	f=$$(basename $$file); \
	ln -sfn $$file $(HOME)/.gnupg/$$f; \
	done; \
	ln -fn $(CURDIR)/.gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;

.PHONY: initial
initial: 
	# Install Xcode Command Line Tools.
	xcode-select --install;
	# install homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

.PHONY: brew
brew:
	brew cleanup;
	brew doctor;
	brew update;
	brew bundle;

.PHONY: python
python:
	asdf plugin-add python;
	asdf install python 3.7.7;
	asdf install python 3.8.3;
	
	pip install --upgrade pip;
	python -m pip install pipx;
	pipx install poetry;

.PHONY: golang
	asdf plugin-add golang;
	asdf install golang 1.14.4;

.PHONY: ruby
ruby:
	asdf plugin-add ruby;
	asdf install ruby 2.7.1;
	asdf install ruby 2.6.6;

.PHONY: node
node:
	asdf plugin-add nodejs;
	asdf install nodejs 12.18.0;
	asdf install nodejs 14.4.0;

default: install
