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
## start-browser - starts a browser with an optional URL
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
URL=


##
## set CLI options and parse CLI
##
CLI_OPTIONS=hu:
CLI_LONG_OPTIONS=help,url:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name start-browser -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "start-browser: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "start-browser")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"            $PRINT_PADDING
                BuildTaskHelpLine u url    "URL"        "optional URL to load in browser"       $PRINT_PADDING
                BuildTaskHelpTag end options
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -u | --url)
            URL="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "start-browser: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsolePrint info "sb: starting task"

if [[ -z "${CONFIG_MAP["BROWSER"]:-}" ]]; then
    ConsolePrint error "sb: no setting for BROWSER, cannot start any"
    ConsolePrint info "sb: done"
    exit 60
fi

SCRIPT=${CONFIG_MAP["BROWSER"]}
SCRIPT=${SCRIPT//%URL%/$URL}

ConsolePrint debug "sb: running - $SCRIPT"
$SCRIPT &
ERRNO=$?

ConsolePrint info "sb: done"
exit $ERRNO
