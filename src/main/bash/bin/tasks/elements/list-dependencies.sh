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
## list-dependencies - list dependencies
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

TESTED=
ORIGIN=
REQUESTED=
STATUS=
INSTALL=

CLI_SET=false
ALL=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AhIo:P:rs:Tt
CLI_LONG_OPTIONS=all,help,install,origin:,print-mode:,requested,status:,tested,table

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-dependencies -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-dependencies: unknown CLI options"
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
            CACHED_HELP=$(TaskGetCachedHelp "list-dependencies")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                      $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "help screen format with additional information"    $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A all         "<none>"    "all dependencies, disables all other filters"                                      $PRINT_PADDING
                BuildTaskHelpLine I install     "<none>"    "only dependencies required only by install tasks"                                  $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "only dependencies from origin: f(w), a(pp)"                                        $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "only requested dependencies"                                                       $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "only dependencies with status: (s)uccess, (w)arning, (e)rror, (n)ot attempted"     $PRINT_PADDING
                BuildTaskHelpLine t tested      "<none>"    "only tested dependencies"                                                          $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;
        -I | --install)
            INSTALL=yes
            CLI_SET=true
            shift
            ;;
        -o | --origin)
            ORIGIN="$2"
            CLI_SET=true
            shift 2
            ;;
        -r | --requested)
            REQUESTED=yes
            CLI_SET=true
            shift
            ;;
        -s | --status)
            STATUS="$2"
            CLI_SET=true
            shift 2
            ;;
        -t | --tested)
            TESTED=yes
            CLI_SET=true
            shift
            ;;

        -P | --print-mode)
            PRINT_MODE="$2"
            CLI_SET=true
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
            ConsolePrint fatal "list-dependencies: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI, init CACHE, test columns
############################################################################################
if [[ "$ALL" == "yes" ]]; then
    TESTED=
    ORIGIN=
    STATUS=
    REQUESTED=
    INSTALL=
elif [[ $CLI_SET == false ]]; then
    TESTED=
else
    if [[ -n "$ORIGIN" ]]; then
        case $ORIGIN in
            F| f | fw | framework)
                ORIGIN=FW_HOME
                ;;
            A | a | app | application)
                ORIGIN=APP_HOME
                ;;
            *)
                ConsolePrint error "ld: unknown origin: $ORIGIN"
                exit 61
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            S | s | success)
                STATUS=S
                ;;
            E | e | errors | error)
                STATUS=E
                ;;
            W | w | warnings | warning)
                STATUS=W
                ;;
            N | n | not-attempted)
                STATUS=N
                ;;
            *)
                ConsolePrint error "ld: unknown status: $STATUS"
                exit 62
        esac
    fi
fi
case $LS_FORMAT in
    list | table)
        ;;
    *)
        ConsolePrint fatal "ld: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A DEP_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/dep-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/dep-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


if (( ${CONSOLE_MAP["DEP_LINE_MIN_LENGTH"]} > ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]} )); then
    ConsolePrint error "ld: not enough columns for table, need ${CONSOLE_MAP["DEP_LINE_MIN_LENGTH"]} found ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]}"
    exit 60
fi



############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Dependency"
    printf "%*s" "$((${CONSOLE_MAP["DEP_PADDING"]} - 10))" ''
    printf "Description"
    printf '%*s' "$((${CONSOLE_MAP["DEP_DESCRIPTION_LENGTH"]} - 11))" ''
    printf "O S${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"

    printf " flags: (O) origin, (S) status\n"

    printf " colors: "
    PrintColor light-green ${CHAR_MAP["LEGEND"]}
    printf " success, "
    PrintColor light-blue ${CHAR_MAP["LEGEND"]}
    printf " not attempted, "
    PrintColor light-red ${CHAR_MAP["LEGEND"]}
    printf " errors"

    printf "\n\n "
    for ((x = 1; x < ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Dependencies\n"
}

function ListBottom() {
    printf "\n"
}



############################################################################################
## dependency print function
############################################################################################
PrintDependencies() {
    local ID
    local i
    local keys

    for ID in ${!DMAP_DEP_ORIGIN[@]}; do
        if [[ -n "$REQUESTED" ]]; then
            if [[ -z "${RTMAP_REQUESTED_DEP[$ID]:-}" ]]; then
                continue
            fi
        fi
        if [[ -n "$TESTED" ]]; then
            if [[ "${RTMAP_DEP_STATUS[$ID]:-}" != "S" ]]; then
                continue
            fi
        fi
        if [[ -n "$STATUS" ]]; then
            case ${RTMAP_DEP_STATUS[$ID]} in
                $STATUS)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$ORIGIN" ]]; then
            if [[ ! "$ORIGIN" == "${DMAP_DEP_ORIGIN[$ID]}" ]]; then
                continue
            fi
        fi
        if [[ "$INSTALL" == "yes" ]]; then
            found=false
            ## install set, so show all dependencies _only_ in 'install' tasks
            ## so go through DMAP_TASK_REQ_DEP_MAN and DMAP_TASK_REQ_DEP_OPT until we find an 'install' task
            for TASK_ID in ${!DMAP_TASK_REQ_DEP_MAN[@]}; do
                for TDEP in ${DMAP_TASK_REQ_DEP_MAN[$TASK_ID]}; do
                    if [[ "$TDEP" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                        found=true
                        break
                    fi
                done
                if [[ $found == true ]]; then
                    break
                fi
            done
            if [[ $found == false ]]; then
                for TASK_ID in ${!DMAP_TASK_REQ_DEP_OPT[@]}; do
                    for TDEP in ${DMAP_TASK_REQ_DEP_OPT[$TASK_ID]}; do
                        if [[ "$TDEP" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                            found=true
                            break
                        fi
                    done
                    if [[ $found == true ]]; then
                        break
                    fi
                done
            fi
            if [[ $found == false ]]; then
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
                if [[ -z "${DEP_TABLE[$ID]:-}" ]]; then
                    DependencyInTable $ID $PRINT_MODE
                else
                    printf "${DEP_TABLE[$ID]}"
                fi
                DependencyDescription $ID 3 none
                ;;
            table)
                if [[ -z "${DEP_TABLE[$ID]:-}" ]]; then
                    DependencyInTable $ID $PRINT_MODE
                else
                    printf "${DEP_TABLE[$ID]}"
                fi
                DependencyDescription $ID
                DependencyStatus $ID $PRINT_MODE
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
ConsolePrint info "ld: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintDependencies
        ListBottom
        ;;
    table)
        TableTop
        PrintDependencies
        TableBottom
        ;;
esac

ConsolePrint info "ld: done"
exit $TASK_ERRORS
