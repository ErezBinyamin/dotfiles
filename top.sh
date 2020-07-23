#!/bin/bash
# This script gets called from a users bashrc
cd ${INIT_DIR}
source chubin.sh
source git.sh
source manpage_colors.sh
source misc.sh
source prompt.sh
cd - > /dev/null
