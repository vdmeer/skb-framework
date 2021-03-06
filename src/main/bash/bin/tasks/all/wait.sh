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
## wait - sleep for specified time
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
SECONDS=1



##
## set CLI options and parse CLI
##
CLI_OPTIONS=hs:
CLI_LONG_OPTIONS=help,seconds:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name wait -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "wait: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=21
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "wait")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start options
                printf "   options\n"
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"        $PRINT_PADDING
                BuildTaskHelpLine s seconds "SEC"       "wait SEC seconds, default is 1"    $PRINT_PADDING
                BuildTaskHelpTag end options
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -s | --seconds)
            SECONDS="$2"
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "wait: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsolePrint info "wait: starting task"

case $SECONDS in
    '' | *[!0-9.]* | '.' | *.*.*)
        ConsolePrint error "wait: requires a number, got '$SECONDS'"
        exit 60
        ;;
esac

ConsolePrint debug "waiting for $SECONDS seconds"
sleep $SECONDS
# $(echo "$SECONDS-.9" | bc -l)

ConsolePrint info "wait: done"
exit $ERRNO
