# Constants
DIR := $(abspath .)
DEPS := kshramt_py

export PYTHON ?= python3
export RUBY ?= ruby2
export MY_PYTHON := $(PYTHON)
export MY_RUBY := $(RUBY)

TEST_NAMES := \
   diff \
   each_cons \
   linspace \
   median_row \
   parse_stem \
   product \
   wrap \
   xys_cut \
   xys_rmean \
   xys_scale \
   xys_taper \
   ys_to_xys

# Configurations
.SUFFIXES:
.DELETE_ON_ERROR:
.ONESHELL:
.SECONDARY:
export SHELL := /bin/bash
export SHELLOPTS := pipefail:errexit:nounset:noclobber

# Tasks
.PHONY: all deps check
all: deps
deps: $(DEPS:%=dep/%.updated)

check: deps $(TEST_NAMES:%=test/%.sh.tested)

# Files

# Rules

test/%.sh.tested: test/%.sh %.sh test/util.sh
	$<
	touch $@

define DEPS_RULE_TEMPLATE =
dep/$(1)/%: | dep/$(1).updated ;
endef
$(foreach f,$(DEPS),$(eval $(call DEPS_RULE_TEMPLATE,$(f))))

dep/%.updated: config/dep/%.ref dep/%.synced
	cd $(@D)/$*
	git fetch origin
	git merge "$$(cat ../../$<)"
	cd -
	if [[ -r dep/$*/Makefile ]]; then
	   $(MAKE) -C dep/$*
	fi
	touch $@

dep/%.synced: config/dep/%.uri | dep/%
	cd $(@D)/$*
	git remote rm origin
	git remote add origin "$$(cat ../../$<)"
	cd -
	touch $@

$(DEPS:%=dep/%): dep/%:
	git init $@
	cd $@
	git remote add origin "$$(cat ../../config/dep/$*.uri)"
