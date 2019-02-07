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
## list-exitstatus - list exitstatus
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
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
source $FW_HOME/bin/api/_include
source $FW_HOME/bin/api/describe/exitstatus.sh
ConsoleResetErrors
ConsoleResetWarnings


##
## set local variables
##
PRINT_MODE=
LS_FORMAT=list

APP=no
FW=no
LOADER=no
SHELL=no
TASK=no
ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AfhlP:sTt
CLI_LONG_OPTIONS=help,print-mode:,table,all,app,fw,loader,shell,task

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-exitstatus -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsoleError "  ->" "list-exitstatus: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -A | --all)
            ALL=yes
            CLI_SET=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "list-exitstatus")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                            $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                          $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "help screen format with additional information"        $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A         all         "<none>"    "all, disables all other filters, default"      $PRINT_PADDING
                BuildTaskHelpLine "<none>"  app         "<none>"    "only application status"                       $PRINT_PADDING
                BuildTaskHelpLine f         fw          "<none>"    "only framework status"                         $PRINT_PADDING
                BuildTaskHelpLine l         loader      "<none>"    "only loader status"                            $PRINT_PADDING
                BuildTaskHelpLine s         shell       "<none>"    "only shell status"                             $PRINT_PADDING
                BuildTaskHelpLine t         task        "<none>"    "only task status"                              $PRINT_PADDING
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

        --app)
            APP=yes
            CLI_SET=true
            shift
            ;;
        -f | --fw)
            FW=yes
            CLI_SET=true
            shift
            ;;
        -l | --loader)
            LOADER=yes
            CLI_SET=true
            shift
            ;;
        -s | --shell)
            SHELL=yes
            CLI_SET=true
            shift
            ;;
        -t | --task)
            TASK=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsoleFatal "  ->" "list-exitstatus: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## check CLI
############################################################################################
if [[ "$ALL" == "yes" || $CLI_SET == false ]]; then
    APP=yes
    FW=yes
    LOADER=yes
    SHELL=yes
    TASK=yes
fi
case $LS_FORMAT in
    list | table)
        ;;
    *)
        ConsoleFatal "  ->" "les: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A ES_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/es-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/es-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < $COLUMNS; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}#"
    printf "%*s" "$((ES_PADDING - 1))" ''
    printf "Description"
    printf '%*s' "$((DESCRIPTION_LENGTH - 11))" ''
    printf "Origin  Problem "
    printf "${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < $COLUMNS; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"

    printf " "
    for ((x = 1; x < $COLUMNS; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Exit Status (Error Codes)\n\n"
}

function ListBottom() {
    :
}



############################################################################################
## exitstatus print function
############################################################################################
PrintExitstatus() {
    local ID
    local i
    local keys

    for ID in ${!DMAP_ES[@]}; do
        if [[ "$APP" == "no" ]]; then
            if [[ "${DMAP_ES[$ID]}" == "app" ]]; then
                continue
            fi
        fi
        if [[ "$FW" == "no" ]]; then
            if [[ "${DMAP_ES[$ID]}" == "fw" ]]; then
                continue
            fi
        fi
        if [[ "$LOADER" == "no" ]]; then
            if [[ "${DMAP_ES[$ID]}" == "loader" ]]; then
                continue
            fi
        fi
        if [[ "$SHELL" == "no" ]]; then
            if [[ "${DMAP_ES[$ID]}" == "shell" ]]; then
                continue
            fi
        fi
        if [[ "$TASK" == "no" ]]; then
            if [[ "${DMAP_ES[$ID]}" == "task" ]]; then
                continue
            fi
        fi
        keys=(${keys[@]:-} $ID)
    done
    keys=($(printf '%s\n' "${keys[@]:-}"|sort))

    for i in ${!keys[@]}; do
        ID=${keys[$i]}
        case $LS_FORMAT in
            list)
                printf "   "
                if [[ -z "${ES_TABLE[$ID]:-}" ]]; then
                    ExitstatusInTable $ID $PRINT_MODE
                else
                    printf "${ES_TABLE[$ID]}"
                fi
                DescribeExitstatusDescription $ID 3 none
                ;;
            table)
                if [[ -z "${ES_TABLE[$ID]:-}" ]]; then
                    ExitstatusInTable $ID $PRINT_MODE
                else
                    printf "${ES_TABLE[$ID]}"
                fi
                DescribeExitstatusDescription $ID
                DescribeExitstatusStatus $ID
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
ConsoleInfo "  -->" "les: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintExitstatus
        ListBottom
        ;;
    table)
        TableTop
        PrintExitstatus
        TableBottom
        ;;
esac

ConsoleInfo "  -->" "les: done"
exit $TASK_ERRORS
