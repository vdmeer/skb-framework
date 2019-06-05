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
## repeat-scenario - repeats a scenario
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
## - reset errors and warnings
##
source $FW_HOME/bin/api/_include
ResetCounter errors
ResetCounter warnings


##
## set local variables
##
TIMES=1
SCENARIO=
WAIT=1



##
## set CLI options and parse CLI
##
CLI_OPTIONS=hs:t:
CLI_LONG_OPTIONS=help,scenario:,times:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name repeat-scenario -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "repeat-scenario: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=27
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "repeat-scenario")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"        $PRINT_PADDING
                BuildTaskHelpLine s scenario    SCENARIO    "the scenario to repeat"            $PRINT_PADDING
                BuildTaskHelpLine t times       INT         "repeat INT times"                  $PRINT_PADDING
                BuildTaskHelpLine w wait        SEC         "wait SEC seconds between repeats"  $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -s | --scenario)
            SCENARIO="$2"
            shift 2
            ;;
        -t | --times)
            TIMES="$2"
            shift 2
            ;;
        -w | --wait)
            WAIT="$2"
            shift 2
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "repeat-scenario: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsolePrint info "rs: starting task"

if [[ -z $SCENARIO ]]; then
    ConsolePrint error "rs: a scenario is required"
    exit 60
fi

SCN_ID=$(GetScenarioID $SCENARIO)
if [[ -z ${SCN_ID:-} ]]; then
    ConsolePrint error "rs: unknown scenario: $SCENARIO"
    exit 60
else
    if [[ -z ${DMAP_SCN_ORIGIN[$SCN_ID]:-} ]]; then
        ConsolePrint error "rs: unknown scenario: $SCENARIO"
        exit 61
    fi
fi


FILE=${DMAP_SCN_EXEC[$SCN_ID]}
if [[ ! -f $FILE ]]; then
    ConsolePrint error "rs: did not find scenario file for scenario $SCN_ID: $FILE"
    exit 62
fi

case $TIMES in
    '' | *[!0-9.]* | '.' | *.*.*)
        ConsolePrint error "rs: repeat times requires a number, got '$TIMES'"
        exit 63
        ;;
esac

case $WAIT in
    '' | *[!0-9.]* | '.' | *.*.*)
        ConsolePrint error "rs: wait requires a number, got '$WAIT'"
        exit 64
        ;;
esac

for (( _repeat=1; _repeat<=$TIMES; _repeat++ )); do
    printf "\n\n    ["
    PrintColor light-blue "run $_repeat of $TIMES"
    printf ' %s %s' "--" $SCN_ID
    printf "]\n    "
    for ((x = 1; x < ${CONSOLE_MAP["SCN_COLUMNS_PADDED5"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"
    ExecuteScenario $SCN_ID
    sleep $WAIT
    printf "\n"
done

ConsolePrint info "rs: done"
exit $ERRNO
