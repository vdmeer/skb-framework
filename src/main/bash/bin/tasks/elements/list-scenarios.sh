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
## list-scenarios - list scenarios
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

LOADED=
UNLOADED=
APP_MODE=
ORIGIN=
STATUS=

NO_ALL=
NO_BUILD=
NO_DESCR=
INSTALL=
NO_LIST=
NO_START=

ODL=

ALL=
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AhIlm:o:P:s:Tu
CLI_LONG_OPTIONS=all,mode:,help,install,loaded,origin:,print-mode:,status:,unloaded,no-a,no-b,no-d,no-dl,no-l,no-s,odl,table

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-scenarios -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-scenarios: unknown CLI options"
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
            CACHED_HELP=$(TaskGetCachedHelp "list-scenarios")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                        $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                      $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "help screen format with additional information"    $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A         all         "<none>"    "all scenarios, disables all other filters"                                     $PRINT_PADDING
                BuildTaskHelpLine I         install     "<none>"    "only scenarios for application mode flavor 'install'"                          $PRINT_PADDING
                BuildTaskHelpLine l         loaded      "<none>"    "only loaded scenarios"                                                         $PRINT_PADDING
                BuildTaskHelpLine m         mode        "MODE"      "only scenarios for application mode: all, dev, build, use"                     $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-a        "<none>"    "activate all '--no-' filters"                                                  $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-b        "<none>"    "exclude scenarios starting with 'build-'"                                      $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-d        "<none>"    "exclude scenarios starting with 'describe-'"                                   $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-dl       "<none>"    "exclude scenarios starting with 'describe-' or 'list-'"                        $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-l        "<none>"    "exclude scenarios starting with 'list-'"                                       $PRINT_PADDING
                BuildTaskHelpLine "<none>"  no-s        "<none>"    "exclude scenarios starting with 'start-'"                                      $PRINT_PADDING
                BuildTaskHelpLine o         origin      "ORIGIN"    "only scenarios from origin: f(w), a(pp)"                                       $PRINT_PADDING
                BuildTaskHelpLine "<none>"  odl         "<none>"    "show only scenarios starting with 'describe-' or 'list-'"                      $PRINT_PADDING
                BuildTaskHelpLine s         status      "STATUS"    "only scenarios with status: (s)uccess, (w)arning, (e)rror, (n)ot attempted"    $PRINT_PADDING
                BuildTaskHelpLine u         unloaded    "<none>"    "only unloaded scenarios"                                                       $PRINT_PADDING
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
        -l | --loaded)
            LOADED=yes
            CLI_SET=true
            shift
            ;;
        -m | --mode)
            APP_MODE="$2"
            CLI_SET=true
            shift 2
            ;;
        --no-a)
            NO_ALL=yes
            CLI_SET=true
            shift
            ;;
        --no-b)
            NO_BUILD=yes
            CLI_SET=true
            shift
            ;;
        --no-d)
            NO_DESCR=yes
            CLI_SET=true
            shift
            ;;
        --no-dl)
            NO_DESCR=yes
            NO_LIST=yes
            CLI_SET=true
            shift
            ;;
        --no-l)
            NO_LIST=yes
            CLI_SET=true
            shift
            ;;
        --no-s)
            NO_START=yes
            CLI_SET=true
            shift
            ;;
        -o | --origin)
            ORIGIN="$2"
            CLI_SET=true
            shift 2
            ;;
        --odl)
            ODL=yes
            CLI_SET=true
            shift
            ;;

        -T | --table)
            shift
            LS_FORMAT=table
            ;;
        -P | --print-mode)
            PRINT_MODE="$2"
            CLI_SET=true
            shift 2
            ;;
        -s | --status)
            STATUS="$2"
            CLI_SET=true
            shift 2
            ;;
        -u | --unloaded)
            UNLOADED=yes
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "list-scenarios: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI, init CACHE, check columns
############################################################################################
if [[ "$ALL" == "yes" ]]; then
    LOADED=
    UNLOADED=
    APP_MODE=all
    ORIGIN=
    STATUS=
    NO_ALL=
    NO_BUILD=
    NO_DESCR=
    INSTALL=all
    NO_LIST=
    NO_START=
elif [[ $CLI_SET == false ]]; then
    APP_MODE=${CONFIG_MAP["APP_MODE"]}
    LOADED=yes
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
                case $ORIGIN in
                    *[!0-9]*)
                        ConsolePrint error "ls: unknown origin: $ORIGIN"
                        exit 61
                    ;;
                esac
        esac
    fi
    if [[ -n "$APP_MODE" ]]; then
        case $APP_MODE in
            A | a | All | all)
                APP_MODE=all
                ;; 
            D | d | Dev | dev)
                APP_MODE=dev
                ;;
            B | b| Build | build)
                APP_MODE=build
                ;;
            U | u | Use | use)
                APP_MODE=use
                ;;
            *)
                ConsolePrint error "ls: unknown application mode: $APP_MODE"
                exit 62
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
                ConsolePrint error "ls: unknown status: $STATUS"
                exit 63
        esac
    fi
    if [[ -n "$NO_ALL" ]]; then
        NO_BUILD=yes
        NO_DESCR=yes
        INSTALL=yes
        NO_LIST=yes
        NO_START=yes
    fi
fi
case $LS_FORMAT in
    list | table)
        ;;
    *)
        ConsolePrint fatal "ls: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A SCN_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/scn-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/scn-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


if (( ${CONSOLE_MAP["SCN_LINE_MIN_LENGTH"]} > ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]} )); then
    ConsolePrint error "ls: not enough columns for table, need ${CONSOLE_MAP["SCN_LINE_MIN_LENGTH"]} found ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]}"
    exit 60
fi



############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Scenario"
    printf "%*s" "$((${CONSOLE_MAP["SCN_PADDING"]} - 8))" ''
    printf "Description"
    printf '%*s' "$((${CONSOLE_MAP["SCN_DESCRIPTION_LENGTH"]} - 11))" ''
    printf "O F D B U S${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"

    printf " flags: (O) Origin, (D) development, (B) build, (U) use, (S) status\n"
    printf " - icons: "
    PrintColor light-green ${CHAR_MAP["AVAILABLE"]}
    printf " defined, "
    PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
    printf " not defined"

    printf "\n"
    printf " - colors: "
    PrintColor light-green ${CHAR_MAP["LEGEND"]}
    printf " success, "
    PrintColor light-blue ${CHAR_MAP["LEGEND"]}
    printf " not attempted, "
    PrintColor yellow ${CHAR_MAP["LEGEND"]}
    printf " warnings, "
    PrintColor light-red ${CHAR_MAP["LEGEND"]}
    printf " errors, "
    PrintColor light-cyan ${CHAR_MAP["LEGEND"]}
    printf " reverted"

    printf "\n\n "
    for ((x = 1; x < ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Scenarios\n"
}

function ListBottom() {
    printf "\n"
}



############################################################################################
## scenario print function
############################################################################################
PrintScenarios() {
    local ID
    local i
    local keys

    for ID in ${!DMAP_SCN_ORIGIN[@]}; do
        if [[ -n "$ODL" ]]; then
            case "$ID" in
                "describe-"* | "list-"*)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$NO_BUILD" ]]; then
            case "$ID" in
                "build-"*)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$NO_DESCR" ]]; then
            case "$ID" in
                "describe-"*)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$INSTALL" && "$INSTALL" == "yes" ]]; then
            if [[ "${DMAP_SCN_MODE_FLAVOR[$ID]}" != "install" ]]; then
                continue
            fi
        fi
        if [[ -n "$NO_LIST" ]]; then
            case "$ID" in
                "list-"*)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$NO_START" ]]; then
            case "$ID" in
                "start-"*)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$LOADED" ]]; then
            if [[ -z "${RTMAP_SCN_LOADED[$ID]:-}" ]]; then
                continue
            fi
        fi
        if [[ -n "$UNLOADED" ]]; then
            if [[ -z "${RTMAP_SCN_UNLOADED[$ID]:-}" ]]; then
                continue
            fi

        fi
        if [[ -n "$STATUS" ]]; then
            case ${RTMAP_SCN_STATUS[$ID]} in
                $STATUS)
                    ;;
                *)
                    continue
                    ;;
            esac
        fi
        if [[ -n "$APP_MODE" ]]; then
            if [[ "$APP_MODE" != "all" ]]; then
                case ${DMAP_SCN_MODES[$ID]} in
                    *$APP_MODE*)
                        ;;
                    *)
                        continue
                        ;;
                esac
            fi
        fi
        if [[ -n "$ORIGIN" ]]; then
            if [[ ! "$ORIGIN" == "${DMAP_SCN_ORIGIN[$ID]}" ]]; then
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
                if [[ -z "${SCN_TABLE[$ID]:-}" ]]; then
                    ScenarioInTable $ID $PRINT_MODE
                else
                    printf "${SCN_TABLE[$ID]}"
                fi
                ScenarioDescription $ID 3 none
                ;;
            table)
                if [[ -z "${SCN_TABLE[$ID]:-}" ]]; then
                    ScenarioInTable $ID $PRINT_MODE
                else
                    printf "${SCN_TABLE[$ID]}"
                fi
                ScenarioDescription $ID
                ScenarioStatus $ID $PRINT_MODE
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
ConsolePrint info "ls: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintScenarios
        ListBottom
        ;;
    table)
        TableTop
        PrintScenarios
        TableBottom
        ;;
esac

ConsolePrint info "ls: done"
exit $TASK_ERRORS
