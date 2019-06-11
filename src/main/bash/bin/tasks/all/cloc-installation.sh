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
## cloc-installation - counts lines of code of an installation
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



## put bugs into errors, safer
set -o errexit -o pipefail -o noclobber -o nounset


##
## Test if we are run from parent with configuration
## - load configuration
##
if [[ -z ${FW_HOME:-} || -z ${FW_L1_CONFIG-} ]]; then
    printf " ==> please run from framework or application\n\n"
    exit 50
fi
source $FW_L1_CONFIG
CONFIG_MAP["RUNNING_IN"]="task"


##
## load main functions
##
source $FW_HOME/bin/api/_include


##
## set local variables
##



##
## set CLI options and parse CLI
##
CLI_OPTIONS=fhs
CLI_LONG_OPTIONS=force,help,simulate

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name cloc-installation -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "cloc-installation: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "cloc-installation")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpTag end options
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "cloc-installation: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go, do clean
##
############################################################################################
ConsolePrint info "cloci: starting task"

if [[ "${RTMAP_DEP_STATUS["cloc"]:-}" == "S" ]]; then
    cloc $(PathToSystemPath ${CONFIG_MAP["FW_HOME"]}) --force-lang="Bourne Again Shell",sh
else
    ConsolePrint error "cloci: dependency 'cloc' not loaded, cannot count"
fi

ConsolePrint info "cloci: done"
exit $TASK_ERRORS
