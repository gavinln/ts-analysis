
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

nvim:  ## run nvim editor
	poetry run nvim

black:  ## run black formatted for Python
	poetry run black -l 79 ts_analysis/

.PHONY: clean
clean:  ## remove output files
	rm -rf output/*

.PHONY: prophet-tutorial
prophet-tutorial:  ## tutorial for prophet from Facebook
	poetry run python -c "from ts_analysis import prophet_tutorial; prophet_tutorial()"
