SHELL=/bin/bash

# to see all colors, run
# bash -c 'for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done'
# the first 15 entries are the 8-bit colors

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET        := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.DEFAULT_GOAL := help
.PHONY: help init build tflint tofu terraform docs

help: ## This help
	@echo "Usage:"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf " $(GREEN)%-20s$(RESET) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""


init: ## Init project
	cd modules; \
	for f in * ; do \
		if [ -d "$$f" ] ; then \
			cd $$f ; \
			tofu init -upgrade ; \
			tflint --init; \
			cd .. ; \
		fi ; \
	done

clean: ## Clean workspace
	cd modules; \
	for f in * ; do \
		if [ -d "$$f" ] ; then \
			cd $$f ; \
			rm -rf .terraform ; \
			rm -rf .terraform.lock.hcl ; \
			cd .. ; \
		fi ; \
	done


build: tofu tflint docs ## Build module


tflint: ## Run TFLint check
	tflint --format compact --recursive


tofu: ## Run OpenTofu files
	tofu fmt -recursive -check


terraform: ## Run Terraform check
	terraform fmt -recursive -check


docs: ## Generate README.md
	terraform-docs markdown . \
		--recursive \
		--recursive-include-main=false \
		--recursive-path=modules \
		--sort-by=required \
		--output-file=README.md \
		--output-mode=insert \
		--lockfile=false
