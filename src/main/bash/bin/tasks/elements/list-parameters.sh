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
## list-parameters - list parameters
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

DEFAULT=
ORIGIN=
REQUESTED=
STATUS=
INSTALL=

CLI_SET=false
ALL=



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AdDhIo:P:rs:T
CLI_LONG_OPTIONS=all,default,def-table,help,install,origin:,print-mode:,requested,status:,table

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-parameters -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-parameters: unknown CLI options"
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
        -D | --def-table)
            shift
            LS_FORMAT=default-table
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "list-parameters")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n"
                BuildTaskHelpTag start standard-options
                printf "   standard list options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                    $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"                  $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "table format with additional information"      $PRINT_PADDING
                BuildTaskHelpTag end standard-options

                printf "\n"
                BuildTaskHelpTag start task-options
                printf "   task options\n"
                BuildTaskHelpLine D def-table   "<none>"    "print default value table"                     $PRINT_PADDING
                BuildTaskHelpTag end task-options

                printf "\n"
                BuildTaskHelpTag start standard-filters
                printf "   standard list filters\n"
                BuildTaskHelpLine A all         "<none>"    "all entries, disables all other filters"       $PRINT_PADDING
                BuildTaskHelpTag end standard-filters

                printf "\n"
                BuildTaskHelpTag start task-filters
                printf "   task filters\n"
                BuildTaskHelpLine d default     "<none>"    "with a declared default value"                     $PRINT_PADDING
                BuildTaskHelpLine I install     "<none>"    "required only by install tasks"                    $PRINT_PADDING
                BuildTaskHelpLine o origin      "ORIGIN"    "from origin: f(w), a(pp)"                          $PRINT_PADDING
                BuildTaskHelpLine r requested   "<none>"    "requested"                                         $PRINT_PADDING
                BuildTaskHelpLine s status      "STATUS"    "for status: (o)ption, (f)ile, (e)nv, (d)efault"    $PRINT_PADDING
                BuildTaskHelpTag end task-filters
            else
                cat $CACHED_HELP
            fi
            exit 0
            ;;

        -d | --default)
            DEFAULT=yes
            CLI_SET=true
            shift
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
            ConsolePrint fatal "list-parameters: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI, init CACHE, test columns
############################################################################################
if [[ "$ALL" == "yes" ]]; then
    DEFAULT=
    ORIGIN=
    REQUESTED=
    STATUS=
    INSTALL=
elif [[ $CLI_SET == false ]]; then
    ALL=
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
                ConsolePrint error "dp: unknown origin: $ORIGIN"
                exit 61
        esac
    fi
    if [[ -n "$STATUS" ]]; then
        case $STATUS in
            N | n | notset)
                STATUS=N
                ;;
            O | o | option)
                STATUS=O
                ;;
            E | e | env | environment)
                STATUS=E
                ;;
            F | f | file)
                STATUS=F
                ;;
            D | d | default)
                STATUS=D
                ;;
            *)
                ConsolePrint error "dp: unknown status: $STATUS"
                exit 62
        esac
    fi
fi
case $LS_FORMAT in
    list | table | default-table)
        ;;
    *)
        ConsolePrint fatal "lp: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac


declare -A PARAM_TABLE
FILE=${CONFIG_MAP["CACHE_DIR"]}/param-tab.${CONFIG_MAP["PRINT_MODE"]}
if [[ -n "$PRINT_MODE" ]]; then
    FILE=${CONFIG_MAP["CACHE_DIR"]}/param-tab.$PRINT_MODE
fi
if [[ -f $FILE ]]; then
    source $FILE
fi


if (( ${CONSOLE_MAP["PARAM_LINE_MIN_LENGTH"]} > ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]} )); then
    ConsolePrint error "lp: not enough columns for table, need ${CONSOLE_MAP["PARAM_LINE_MIN_LENGTH"]} found ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}"
    exit 60
fi



############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Parameter"
    printf "%*s" "$((${CONSOLE_MAP["PARAM_PADDING"]} - 9))" ''
    printf "Description"
    printf '%*s' "$((${CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]} - 11))" ''
    printf "O D S${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done

    printf "\n\n"
    printf " define parameters in environemnt or '.skb' with prefix: '${CONFIG_MAP["FLAVOR"]}_'"

    printf "\n\n"
    printf " flags: (O) Origin, (D) default value, (S) status\n"
    printf " - icons: "
    PrintColor light-green ${CHAR_MAP["AVAILABLE"]}
    printf " defined, "
    PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
    printf " not defined"

    printf "\n"
    printf " - colors:"
    printf " CLI ";             PrintColor light-blue   ${CHAR_MAP["LEGEND"]}
    printf " , environment ";   PrintColor green        ${CHAR_MAP["LEGEND"]}
    printf " , file ";          PrintColor brown        ${CHAR_MAP["LEGEND"]}
    printf " , default ";       PrintColor yellow       ${CHAR_MAP["LEGEND"]}
    printf " , not set %s"                              "${CHAR_MAP["LEGEND"]}"

    printf "\n\n "

    for ((x = 1; x < ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function DefaultTableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Parameter"
    printf "%*s" "$((${CONSOLE_MAP["PARAM_PADDING"]} - 9))" ''
    printf "Default Value"
    printf '%*s' "$((${CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]} - 8))" ''
    printf "${EFFECTS["REVERSE_OFF"]}\n\n"
}

function DefaultTableBottom() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Parameters\n"
}

function ListBottom() {
    printf "\n"
}



############################################################################################
## parameter print function
############################################################################################
PrintParameters() {
    local ID
    local TASK_ID
    local TPARAM
    local i
    local keys
    local found

    for ID in ${!DMAP_PARAM_ORIGIN[@]}; do
        if [[ -n "$REQUESTED" ]]; then
            if [[ -z "${RTMAP_REQUESTED_PARAM[$ID]:-}" ]]; then
                continue
            fi
        fi
        if [[ -n "$DEFAULT" ]]; then
            if [[ ! -n "${DMAP_PARAM_DEFVAL[$ID]:-}" ]]; then
                continue
            fi
        fi
        if [[ -n "$STATUS" ]]; then
            if [[ -z "${CONFIG_SRC[$ID]:-}" ]]; then
                if [[ "$STATUS" != "N" ]]; then
                    continue
                fi
            else
                case ${CONFIG_SRC[$ID]} in
                    $STATUS)
                        ;;
                    *)
                        continue
                        ;;
                esac
            fi
        fi
        if [[ -n "$ORIGIN" ]]; then
            if [[ ! "$ORIGIN" == "${DMAP_PARAM_ORIGIN[$ID]}" ]]; then
                continue
            fi
        fi
        if [[ "$INSTALL" == "yes" ]]; then
            found=false
            ## install set, so all parameters _only_ in 'install' tasks
            ## so go through DMAP_TASK_REQ_PARAM_MAN and DMAP_TASK_REQ_PARAM_OPT until we find an 'install' task
            for TASK_ID in ${!DMAP_TASK_REQ_PARAM_MAN[@]}; do
                for TPARAM in ${DMAP_TASK_REQ_PARAM_MAN[$TASK_ID]}; do
                    if [[ "$TPARAM" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
                        found=true
                        break
                    fi
                done
                if [[ $found == true ]]; then
                    break
                fi
            done
            if [[ $found == false ]]; then
                for TASK_ID in ${!DMAP_TASK_REQ_PARAM_OPT[@]}; do
                    for TPARAM in ${DMAP_TASK_REQ_PARAM_OPT[$TASK_ID]}; do
                        if [[ "$TPARAM" == "$ID" && "${DMAP_TASK_MODE_FLAVOR[$TASK_ID]:-}" == "install" ]]; then
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
                if [[ -z "${PARAM_TABLE[$ID]:-}" ]]; then
                    ParameterInTable $ID $PRINT_MODE
                else
                    printf "${PARAM_TABLE[$ID]}"
                fi
                ParameterTagline $ID 3 none
                ;;
            table)
                if [[ -z "${PARAM_TABLE[$ID]:-}" ]]; then
                    ParameterInTable $ID $PRINT_MODE
                else
                    printf "${PARAM_TABLE[$ID]}"
                fi
                ParameterTagline $ID
                ParameterStatus $ID $PRINT_MODE
                ;;
            default-table)
                if [[ -z "${PARAM_TABLE[$ID]:-}" ]]; then
                    ParameterInTable $ID $PRINT_MODE
                else
                    printf "${PARAM_TABLE[$ID]}"
                fi
                printf "%s" "$(ParameterDefvalueDescription $ID $PRINT_MODE)"
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
ConsolePrint info "lp: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintParameters
        ListBottom
        ;;
    table)
        TableTop
        PrintParameters
        TableBottom
        ;;
    default-table)
        DefaultTableTop
        PrintParameters
        DefaultTableBottom
        ;;
esac

ConsolePrint info "lp: done"
exit $TASK_ERRORS
