#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source $(dirname ${BASH_SOURCE[0]})/prompt/prompt.sh

