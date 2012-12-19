#!/bin/sh -u
main=${0%.*}.rb
${MY_RUBY} ${main} "$@"
