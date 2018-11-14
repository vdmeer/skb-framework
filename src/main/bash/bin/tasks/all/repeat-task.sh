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
## repeat-task - repeats a task
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.1
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
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
source $FW_HOME/bin/functions/_include
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
TIMES=1
TASK=
WAIT=1
ARGS=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=ht:w:
CLI_LONG_OPTIONS=help,times:,wait:

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name repeat-task -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "repeat-task: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=19
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "repeat-task")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help    "<none>"    "print help screen and exit"        $PRINT_PADDING
                BuildTaskHelpLine t times   "INT"       "repeat INT times"                  $PRINT_PADDING
                BuildTaskHelpLine w wait    "SEC"       "wait SEC seconds between repeats"  $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
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
            TASK=${1-}
            if [[ ! -n "$TASK" ]]; then
                ConsoleError "  ->" "repeat-task: a task identifier / name is required"
                exit 60
            fi
            shift
            ARGS=$(printf '%s' "$*")
            break
            ;;
        *)
            ConsoleFatal "  ->" "repeat-task: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
##
## ready to go
##
############################################################################################
ERRNO=0
ConsoleInfo "  -->" "rt: starting task"

__found=false
TASK=$(GetTaskID $TASK)
for ID in "${!RTMAP_TASK_LOADED[@]}"; do
    if [[ "$ID" == "$TASK" ]]; then
        __found=true
        break
    fi
done

if [[ $__found == false ]]; then
    ConsoleError "  ->" "rt: unknown or unloaded task '$TASK'"
    exit 61
fi

case $TIMES in
    '' | *[!0-9.]* | '.' | *.*.*)
        ConsoleError " ->" "rt: repeat times requires a number, got '$TIMES'"
        exit 62
        ;;
esac

case $WAIT in
    '' | *[!0-9.]* | '.' | *.*.*)
        ConsoleError " ->" "rt: wait requires a number, got '$WAIT'"
        exit 63
        ;;
esac

COLUMNS=$(tput cols)
COLUMNS=$((COLUMNS - 5))
for (( _repeat=1; _repeat<=$TIMES; _repeat++ )); do
    printf "\n\n    ["
    PrintColor light-blue "${EFFECTS["INT_BOLD"]}run $_repeat of $TIMES"
    printf ' %s %s %s' "--" $TASK $ARGS
    printf "]\n    "
    for ((x = 1; x < $COLUMNS; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"
    set +e
    ${DMAP_TASK_EXEC[$TASK]} $ARGS
    set -e
    sleep $WAIT
    printf "\n"
done

ConsoleInfo "  -->" "rt: done"
exit $ERRNO
