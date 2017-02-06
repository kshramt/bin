# Constants
DIR := $(abspath .)

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
.PHONY: all check

check: $(TEST_NAMES:%=test/%.sh.tested)

# Files

# Rules

test/%.sh.tested: test/%.sh %.sh test/util.sh
	$<
	touch $@
