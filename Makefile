
ifeq ($(OS),Windows_NT)
    SHELL='c:/Program Files/Git/usr/bin/sh.exe'
endif

SCRIPT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))


.DEFAULT_GOAL=help
.PHONY: help
help:  ## help for this Makefile
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		 }' $(MAKEFILE_LIST)

jupyter-lab:  ## start jupyter lab
	pipenv run bash $(SCRIPT_DIR)/scripts/jupyter-lab.sh

tmux:  ## start tmux
	tmuxp load tmux.yaml

flake8:
	pipenv run flake8 python/

.PHONY: clean
clean:  ## remove output files
	rm -rf output/*
