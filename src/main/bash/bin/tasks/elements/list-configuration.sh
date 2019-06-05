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
## list-configuration - list configuration
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
PRINT_MODE=
LS_FORMAT=list

FILTER=
ALL=false

CHANGE_SET=false
CLI_SET=false



##
## set CLI options and parse CLI
##
CLI_OPTIONS=AcdefhiP:T
CLI_LONG_OPTIONS=all,help,print-mode:,table
CLI_LONG_OPTIONS+=,cli,default,file,env,internal

! PARSED=$(getopt --options "$CLI_OPTIONS" --longoptions "$CLI_LONG_OPTIONS" --name list-configuration -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    ConsolePrint error "list-configuration: unknown CLI options"
    exit 51
fi
eval set -- "$PARSED"

PRINT_PADDING=25
while true; do
    case "$1" in
        -A | --all)
            ALL=true
            CLI_SET=true
            shift
            ;;
        -h | --help)
            CACHED_HELP=$(TaskGetCachedHelp "list-configuration")
            if [[ -z ${CACHED_HELP:-} ]]; then
                printf "\n   options\n"
                BuildTaskHelpLine h help        "<none>"    "print help screen and exit"                $PRINT_PADDING
                BuildTaskHelpLine P print-mode  "MODE"      "print mode: ansi, text, adoc"              $PRINT_PADDING
                BuildTaskHelpLine T table       "<none>"    "print as table with more information"      $PRINT_PADDING
                printf "\n   filters\n"
                BuildTaskHelpLine A all         "<none>"    "all settings, disables all other filters"              $PRINT_PADDING
                BuildTaskHelpLine c cli         "<none>"    "only settings from CLI options"                        $PRINT_PADDING
                BuildTaskHelpLine d default     "<none>"    "only settings from default value"                      $PRINT_PADDING
                BuildTaskHelpLine e env         "<none>"    "only settings from environment"                        $PRINT_PADDING
                BuildTaskHelpLine f file        "<none>"    "only settings from configuration file"                 $PRINT_PADDING
                BuildTaskHelpLine i internal    "<none>"    "only internal settings"                                $PRINT_PADDING
            else
                cat $CACHED_HELP
            fi
            exit 0
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

        -c | --cli)
            FILTER=$FILTER" cli"
            CLI_SET=true
            shift
            ;;
        -d | --default)
            FILTER=$FILTER" default"
            CLI_SET=true
            shift
            ;;
        -e | --env)
            FILTER=$FILTER" env"
            CLI_SET=true
            shift
            ;;
        -f | --file)
            FILTER=$FILTER" file"
            CLI_SET=true
            shift
            ;;
        -i | --internal)
            FILTER=$FILTER" internal"
            CLI_SET=true
            shift
            ;;

        --)
            shift
            break
            ;;
        *)
            ConsolePrint fatal "list-configuration: internal error (task): CLI parsing bug"
            exit 52
    esac
done



############################################################################################
## test CLI, set columns, test columns, write L1 if necessary
############################################################################################
if [[ $ALL == true  || $CLI_SET == false ]]; then
    FILTER="cli default env file internal"
fi
case $LS_FORMAT in
    list | table)
        ;;
    *)
        ConsolePrint fatal "lcfg: internal error: unknown list format '$LS_FORMAT'"
        exit 69
        ;;
esac

if (( ${CONSOLE_MAP["CONFIG_LINE_MIN_LENGTH"]} > ${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]} )); then
    ConsolePrint error "lcfg: not enough columns for table, need ${CONSOLE_MAP["CONFIG_LINE_MIN_LENGTH"]} found ${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]}"
    exit 60
fi



############################################################################################
## top and bottom functions for list and table
############################################################################################
function TableTop() {
    printf "\n "
    for ((x = 1; x < ${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["TOP_LINE"]}"
    done
    printf "\n ${EFFECTS["REVERSE_ON"]}Name"
    printf "%*s" "$((${CONSOLE_MAP["CONFIG_PADDING"]} - 4))" ''
    printf "Value"
    printf '%*s' "$((${CONSOLE_MAP["VALUE_LENGTH"]} - 5))" ''
    printf "S${EFFECTS["REVERSE_OFF"]}\n\n"
}

function TableBottom() {
    printf " "
    for ((x = 1; x < ${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["MID_LINE"]}"
    done
    printf "\n\n"

    printf " flags: (S) source\n"
    printf " - colors:"
    printf " internal ";        PrintColor light-blue   ${CHAR_MAP["LEGEND"]}
    printf " , CLI ";           PrintColor light-cyan   ${CHAR_MAP["LEGEND"]}
    printf " , environment ";   PrintColor light-green  ${CHAR_MAP["LEGEND"]}
    printf " , file ";          PrintColor yellow       ${CHAR_MAP["LEGEND"]}
    printf " , default ";       PrintColor light-red    ${CHAR_MAP["LEGEND"]}

    printf "\n\n "
    for ((x = 1; x < ${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]}; x++)); do
        printf %s "${CHAR_MAP["BOTTOM_LINE"]}"
    done
    printf "\n\n"
}

function ListTop() {
    printf "\n  Configuration\n"
}

function ListBottom() {
    printf "\n"
}



############################################################################################
## configuration print function
############################################################################################
PrintConfiguration() {
    local ID
    local i
    local keys
    local found

    for ID in ${!CONFIG_MAP[@]}; do
        found=false
        for fil in $FILTER; do
            SOURCE=${CONFIG_SRC[$ID]:-}
            case "$fil" in
                cli)
                    if [[ "$SOURCE" == "O" ]]; then
                        found=true
                    fi
                    ;;
                default)
                    if [[ "$SOURCE" == "D" ]]; then
                        found=true
                    fi
                    ;;
                env)
                    if [[ "$SOURCE" == "E" ]]; then
                        found=true
                    fi
                    ;;
                file)
                    if [[ "$SOURCE" == "F" ]]; then
                        found=true
                    fi
                    ;;
                internal)
                    if [[ "$SOURCE" == "" ]]; then
                        found=true
                    fi
                    ;;
            esac
        done
        if [[ $found == false ]]; then
            continue
        fi
        keys=(${keys[@]:-} $ID)
    done
    keys=($(printf '%s\n' "${keys[@]:-}"|sort))

    local INDENT
    local str_len
    local padding
    local sc_str
    case $LS_FORMAT in
        list)
            INDENT="   "
            ;;
        table)
            INDENT=""
            ;;
    esac

    for i in ${!keys[@]}; do
        ID=${keys[$i]}
        printf " %s%s" "$INDENT" "$ID"
        str_len=${#ID}
        padding=$((${CONSOLE_MAP["CONFIG_PADDING"]} - $str_len))
        printf '%*s' "$padding"

        sc_str=${CONFIG_MAP[$ID]}
        case $ID in
            LOADER_LEVEL)
                PrintSetting loader-level
                ;;
            SHELL_LEVE)
                PrintSetting shell-level
                ;;
            TASK_LEVEL)
                PrintSetting task-level
                ;;
            LOADER_QUIET)
                PrintSetting loader-quiet
                ;;
            SHELL_QUIET)
                PrintSetting shell-quiet
                ;;
            TASK_QUIET)
                PrintSetting task-quiet
                ;;
            SHELL_SNP)
                PrintSetting shell-snp
                ;;
            STRICT)
                PrintSetting strict
                ;;
            APP_MODE)
                PrintSetting app-mode
                ;;
            APP_MODE_FLAVOR)
                PrintSetting app-mode-flavor
                ;;
            FLAVOR)
                PrintEffect bold "$sc_str"
                ;;
            FW_HOME | APP_HOME)
                printf '%s' "$sc_str"
                ;;
            *)
                sc_str=${sc_str/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
                sc_str=${sc_str/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
                printf '%s' "$sc_str"
                ;;
        esac

        case $LS_FORMAT in
            list)
                ;;
            table)
                str_len=${#sc_str}
                if [[ "$ID" == "SHELL_PROMPT" ]]; then
                    str_len=${CONFIG_MAP["PROMPT_LENGTH"]}
                fi
                PADDING=$((${CONSOLE_MAP["VALUE_LENGTH"]} - str_len))
                printf '%*s' "$PADDING"

                case ${CONFIG_SRC[$ID]:-} in
                    "E")    PrintColor green        ${CHAR_MAP["DIAMOND"]} ;;
                    "F")    PrintColor yellow       ${CHAR_MAP["DIAMOND"]} ;;
                    "D")    PrintColor light-red    ${CHAR_MAP["DIAMOND"]} ;;
                    "O")    PrintColor light-cyan   ${CHAR_MAP["DIAMOND"]} ;;
                    *)      PrintColor light-blue   ${CHAR_MAP["DIAMOND"]} ;;
                esac
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
ConsolePrint info "lcfg: starting task"

case $LS_FORMAT in
    list)
        ListTop
        PrintConfiguration
        ListBottom
        ;;
    table)
        TableTop
        PrintConfiguration
        TableBottom
        ;;
esac

ConsolePrint info "lcfg: done"
exit $TASK_ERRORS
