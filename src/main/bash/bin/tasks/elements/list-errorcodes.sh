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
## list-errorcodes - list error codes
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

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-errorcodes -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-errorcodes: unknown CLI options"
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
            CACHED_HELP=$(TaskGetCachedHelp "list-errorcodes")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start standard-options
                printf "   standard list options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                  $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "table format with additional information"      $PRINT_PADDING
                BuildTaskHelpTag end standard-options

                printf "\n"
                BuildTaskHelpTag start standard-filters
                printf "   standard list filters\n"
                BuildTaskHelpLine A         all         "<none>"    "all entries, disables all other filters"   $PRINT_PADDING
                BuildTaskHelpTag end standard-filters

                printf "\n"
                BuildTaskHelpTag start task-filters
                printf "   task filters\n"
                BuildTaskHelpLine "<none>"  app         "<none>"    "application status"    $PRINT_PADDING
                BuildTaskHelpLine f         fw          "<none>"    "framework status"      $PRINT_PADDING
                BuildTaskHelpLine l         loader      "<none>"    "loader status"         $PRINT_PADDING
                BuildTaskHelpLine s         shell       "<none>"    "shell status"          $PRINT_PADDING
                BuildTaskHelpLine t         task        "<none>"    "task status"           $PRINT_PADDING
                BuildTaskHelpTag end task-filters
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
            ConsolePrint fatal "list-errorcodes: internal error (task): CLI parsing bug"
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
        ConsolePrint fatal "lec: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A EC_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/ec-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/ec-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["EC_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}#"
    printf "%*s" "$((${CONSOLE_MAP["EC_PADDING"]} - 1))" ''
    printf "Description"
    printf '%*s' "$((${CONSOLE_MAP["EC_DESCRIPTION_LENGTH"]} - 11))" ''
    printf "Origin  Problem "
    printf "${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["EC_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"

    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["EC_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Error Codes\n\n"
}

function ListBottom() {
    :
}



############################################################################################
## error code print function
############################################################################################
PrintErrorcode() {
    local ID
    local i
    local keys

    for ID in ${!DMAP_EC[@]}; do
        if [[ "$APP" == "no" ]]; then
            if [[ "${DMAP_EC[$ID]}" == "app" ]]; then
                continue
            fi
        fi
        if [[ "$FW" == "no" ]]; then
            if [[ "${DMAP_EC[$ID]}" == "fw" ]]; then
                continue
            fi
        fi
        if [[ "$LOADER" == "no" ]]; then
            if [[ "${DMAP_EC[$ID]}" == "loader" ]]; then
                continue
            fi
        fi
        if [[ "$SHELL" == "no" ]]; then
            if [[ "${DMAP_EC[$ID]}" == "shell" ]]; then
                continue
            fi
        fi
        if [[ "$TASK" == "no" ]]; then
            if [[ "${DMAP_EC[$ID]}" == "task" ]]; then
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
                if [[ -z "${EC_TABLE[$ID]:-}" ]]; then
                    ErrorcodeInTable $ID $PRINT_MODE
                else
                    printf "${EC_TABLE[$ID]}"
                fi
                ErrorcodeTagline $ID 3 none
                ;;
            table)
                if [[ -z "${EC_TABLE[$ID]:-}" ]]; then
                    ErrorcodeInTable $ID $PRINT_MODE
                else
                    printf "${EC_TABLE[$ID]}"
                fi
                ErrorcodeTagline $ID
                ErrorcodeStatus $ID
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
ConsolePrint info "lec: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintErrorcode
        ListBottom
        ;;
    table)
        TableTop
        PrintErrorcode
        TableBottom
        ;;
esac

ConsolePrint info "lec: done"
exit $TASK_ERRORS
