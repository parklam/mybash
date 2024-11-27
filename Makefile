# --------------------------------------------------------
#  Core Makefile
#
#  Author: Park Lam <lqmonline@gmail.com>
# --------------------------------------------------------
SHELL=/bin/bash
export UNIPARK ?= 'unipark'
ifeq ($(.DEFAULT_GOAL),)
	.DEFAULT_GOAL := setup
endif

# ----------
#  Pre-defined
# ----------
# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))

__check_defined = \
    $(if $(value $1),, \
        $(error Undefined $1$(if $2, ($2))))
# ----------
# End of Pre-defined
# ----------

# ----------
# Init-env
# ----------
export PROJECT_ROOT ?= $(shell pwd)
export GIT_REPOS ?= $(shell git remote -v |grep orgin |head -n 1 \
	|awk -F: '{print $$2}' |awk -F. '{print $$1}')
# ----------
# End of Init-env
# ----------

$(call check_defined, UNIPARK, UNIPARK is undefined)

$(info -------------------- GNU Make ------------------)
$(info Project:     ${GIT_REPOS})
$(info Directory:   ${PROJECT_ROOT})
$(info Target:      $(if ${MAKECMDGOALS},${MAKECMDGOALS},${.DEFAULT_GOAL}))
$(info Datetime:    $(shell date))
$(info ------------------------------------------------)

.PHONY: help
help:
	@echo "Usage: `make setup`"

.PHONY: update
update:
	@git pull && git submodule update --init --recursive --remote

.PHONY: setup-bash
setup-bash:
	@sudo apt-get update \
		&& sudo apt -y upgrade \
		&& sudo apt install -y \
			dnsutils apt-transport-https ca-certificates curl \
			software-properties-common python3 python3-pip \
			python3-setuptools fail2ban
	@[ -z "$$(grep -i '_bashrc' ~/.bashrc)" ] \
		&& echo "[ -f ${PROJECT_ROOT}/_bashrc ] && . ${PROJECT_ROOT}/_bashrc" \
		| sed -e "s|$${HOME}|\$${HOME}|g" >> ~/.bashrc \
		|| echo "" > /dev/null
	@[ -z "$$(grep -i '_bash_alias' ~/.bashrc)" ] \
		&& echo "[ -f ${PROJECT_ROOT}/_bash_alias ] && . ${PROJECT_ROOT}/_bash_alias" \
		| sed -e "s|$${HOME}|\$${HOME}|g" >> ~/.bashrc \
		|| echo "" > /dev/null
	@echo "Bash has been setup."

.PHONY: setup-docker
setup-docker:
	@command -v docker >/dev/null 2>&1 \
		|| ( curl -sSL https://get.docker.io/ | sh )

.PHONY: setup-pyenv
setup-pyenv:
	@sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
		libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
		xz-utils tk-dev libffi-dev liblzma-dev
	@curl -sSL https://pyenv.run | bash
	@echo "Usage: pyenv install 3.8.3 && pyenv global 3.8.3"
	@echo "Pyenv has been installed."

.PHONY: setup-vim
setup-vim:
	@sudo apt-get install -y vim exuberant-ctags
	@rm ~/.vimrc > /dev/null 2>&1 ||true
	@ln -s "${PROJECT_ROOT}/_vimrc" ~/.vimrc
	@git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	@vim -c ':PluginInstall'
	@echo "Vim has been installed"

.PHONY: setup
setup: setup-bash setup-docker setup-pyenv setup-vim

.PHONY: purge
purge:
	@
