#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
PROMPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${PROMPT_DIR}/prompt/prompt.sh

