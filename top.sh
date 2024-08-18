#!/bin/bash
# This script gets called from a users bashrc
export TOP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${TOP_DIR}/misc.sh
source ${TOP_DIR}/docker/docker.sh
source ${TOP_DIR}/webtools.sh
source ${TOP_DIR}/git.sh
source ${TOP_DIR}/manpage_colors.sh
source ${TOP_DIR}/prompt.sh
source ${TOP_DIR}/submodules/submodules.sh
