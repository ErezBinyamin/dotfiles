#!/bin/bash

# CONTROLS
# Ignore all prompt customizations and use ubuntu default
export PROMPT_DEFAULT=0

# If you have a slow network, set to a '1' to stop all slow network items
export PROMPT_SLOW_NETWORK=1

# Use IP octets to color command line
export PROMPT_IP_COLORING=1

# Randomize prompt colors (override IP coloring)
export PROMPT_RANDOM_COLORING=0

# ---------------- Toggle pressence of CL PROMPT elements ----------------
# Battery life status
export PROMPT_BATTERY=1		

# date/time
export PROMPT_DATE_TIME=1	

# Local IP address
export PROMPT_IP_ADDR=1		

# Current working dir
export PROMPT_WRK_DIR=1		

# Git Repo name
export PROMPT_GIT_REPO=1	

# Git Push/Pull status
export PROMPT_GIT_REMOTE=1	

# Git branch name / commit status
export PROMPT_GIT_BRANCH=1	

# Git branch status symbols
export PROMPT_GIT_SYMBOLS=1	

# Caps lock awareness symbol
export PROMPT_CAPS_LOCK=1	

# SSH awareness symbol
export PROMPT_SSH_ENDING=1	
