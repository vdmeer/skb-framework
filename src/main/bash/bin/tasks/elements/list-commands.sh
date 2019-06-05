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
## list-commands - list commands
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
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
PRINT_MODE=
LS_FORMAT=list



##
## set CLI options and parse CLI
##
CLI_OPTIONS=hP:T
CLI_LONG_OPTIONS=help,print-mode:,table

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-commands -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-commands: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "list-commands")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                      $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "help screen format with additional information"    $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -P | --print-mode)
            PRINT_MODE="$2"
            shift 2
            ;;
        -T | --table)
            shift
            LS_FORMAT=table
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "list-commands: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## check CLI
############################################################################################
case $LS_FORMAT in
    list | table)
        ;;
    *)
        ConsolePrint fatal "lc: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A COMMAND_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/cmd-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/cmd-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["CMD_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Command"
    printf "%*s" "$((${CONSOLE_MAP["CMD_PADDING"]} - 7))" ''
    printf "Description"
    printf '%*s' "$((${CONSOLE_MAP["CMD_DESCRIPTION_LENGTH"]} - 11))" ''
    printf "${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["CMD_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done

    printf "\n\n All other input will be treated as an attempt to run a task with arguments.\n"
    printf " Use 'list-tasks' (or 'lt') for a list of tasks, 'list-tasks --help' for more help.\n\n"

    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["CMD_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Shell Commands\n\n"
}

function ListBottom() {
    printf "\n\n All other input will be treated as an attempt to run a task with arguments.\n"
    printf " Use 'list-tasks' (or 'lt') for a list of tasks, 'list-tasks --help' for more help.\n\n"
}



############################################################################################
## command print function
############################################################################################
PrintCommands() {
    local i
    local keys

    for i in ${!DMAP_CMD[@]}; do
        keys=(${keys[@]:-} $i)
    done
    keys=($(printf '%s\n' "${keys[@]:-}"|sort))

    for i in ${!keys[@]}; do
        ID=${keys[$i]}
        case $LS_FORMAT in
            list)
                printf "   "
                if [[ -z "${COMMAND_TABLE[$ID]:-}" ]]; then
                    CommandInTable $ID $PRINT_MODE
                else
                    printf "${COMMAND_TABLE[$ID]}"
                fi
                CommandDescription $ID 3 none
                ;;
            table)
                if [[ -z "${COMMAND_TABLE[$ID]:-}" ]]; then
                    CommandInTable $ID $PRINT_MODE
                else
                    printf "${COMMAND_TABLE[$ID]}"
                fi
                CommandDescription $ID
                ;;
        esac
        printf "\n"
    done
}



############################################################################################
##
## ready to go
##
############################################################################################
ConsolePrint info "lc: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintCommands
        ListBottom
        ;;
    table)
        TableTop
        PrintCommands
        TableBottom
        ;;
esac

ConsolePrint info "lc: done"
exit $TASK_ERRORS
