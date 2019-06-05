#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# ============LICENSE_START=======================================================
#  Copyright (C) 2018 Sven van der Meer. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
#-------------------------------------------------------------------------------

##
## make script for the SKB-Framework
## - runs the SKB-Framework with task make-target-sets
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v1.0.0
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar


##
## Basic settings
##
SKB_FRAMEWORK=src/main/bash/bin/skb-framework



##
## SKB-Framework settings (SF)
##
export SF_MVN_SITES=$PWD
export SF_MAKE_TARGET_SETS=$PWD



##
## Check if we have some command line
## - if not, we need help, and then exit
## - if there's any indication for help, print help
##
if [[ -z "${1:-}" || "${1}" == "-h" || "${1}" == "--help" || "${1}" == "help" ]]; then
    if [[ -z "${1:-}" ]]; then
        printf "No target given\n"
    fi
    source skb-ts-scripts.skb
    TsRunTargets help
    printf "\n    Note: the skb-framework will be started with --snp --task-level debug\n"
    printf "          this means no shell prompt, tasks will print debug-level messages\n\n"
    exit 1
fi



##
## Everything looks ok, run SF and call 'make-target-sets' for our target set 'skb-fw'
##
mkdir -p src/main/bash/man/man1 2> /dev/null
mkdir -p src/main/bash/doc/manual 2> /dev/null

$SKB_FRAMEWORK --all-mode --install --execute-task make-target-sets --snp --task-level debug -- --id skb-fw --targets $1
