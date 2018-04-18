# "Just because it's automatic doesn't mean it works."
# — Daniel J. Bernstein

IMAGE_PREFIX = michaelbiven
IMAGE_REPO = dotfiles
IMAGE_VERSION ?= latest
IMAGE_NAME = $(IMAGE_PREFIX)/$(IMAGE_REPO):$(IMAGE_VERSION)


.PHONY: install bin dotfiles initial brew python ruby mac build run kube-run test shellcheck

install: bin dotfiles initial brew python ruby

bin:
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sf $$file ~/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	mkdir -p $(HOME)/.gnupg;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	sudo chmod 600 $(HOME)/.gnupg/gpg.conf;
	sudo chmod 755 $(HOME)/.gnupg;
	ln -fn $(CURDIR)/.gitignore $(HOME)/.gitignore;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;

initial: 
	# Install Xcode Command Line Tools.
	xcode-select --install;
	# install homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";


brew:
	brew prune;
	brew update;
	brew bundle;

python:
	brew install pyenv;
	pyenv install 3.6.5;
	pyenv global 3.6.5;
	eval "$(pyenv init -)";
	curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python;
	pipsi install pipenv;
	pipsi install legit;
	pipsi install em-keyboard;

ruby:
	rbenv install 2.4.3;
	rbenv install 2.5.0;
	rbenv global 2.5.0;

mac:
	# apply settings from macos.sh
	~/bin/macos.sh

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -ti --rm $(IMAGE_NAME)

kube-run:
	kubectl run -i -t --image=$(IMAGE_NAME) shell --restart=Never --rm

default: install

test: shellcheck

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

shellcheck:
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh