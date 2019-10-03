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
## Console functions for loader, shell, and tasks
## - these functions print tagged messages according to CONSOLE/SHELL/TASK-LEVEL
## - they behave similar to Java logging frameworks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## A map with console calculations for printing well-formed lines
## - used by all element-related tasks for length and padding and the like
##
declare -A CONSOLE_MAP



##
## function ConsoleCalculate()
## - calculates values for printing to console (e.g. padding)
## - function is called when file is included, call repeatedly in longer running process (e.g. the shell)
##
ConsoleCalculate(){
    CONSOLE_MAP["COLUMNS"]=$(tput cols)

    CONSOLE_MAP["CMD_PADDING"]=32
    CONSOLE_MAP["CMD_STATUS_LENGHT"]=0
    CONSOLE_MAP["CMD_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["CMD_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["CMD_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["CMD_COLUMNS_PADDED"]} - ${CONSOLE_MAP["CMD_PADDING"]} - ${CONSOLE_MAP["CMD_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["DEP_PADDING"]=20
    CONSOLE_MAP["DEP_STATUS_LENGHT"]=3
    CONSOLE_MAP["DEP_LINE_MIN_LENGTH"]=43
    CONSOLE_MAP["DEP_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["DEP_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["DEP_COLUMNS_PADDED"]} - ${CONSOLE_MAP["DEP_PADDING"]} - ${CONSOLE_MAP["DEP_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["EC_PADDING"]=6
    CONSOLE_MAP["EC_STATUS_LENGHT"]=16
    CONSOLE_MAP["EC_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["EC_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["EC_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["EC_COLUMNS_PADDED"]} - ${CONSOLE_MAP["EC_PADDING"]} - ${CONSOLE_MAP["EC_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["OPT_PADDING"]=27
    CONSOLE_MAP["OPT_STATUS_LENGHT"]=4
    CONSOLE_MAP["OPT_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["OPT_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["OPT_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["OPT_COLUMNS_PADDED"]} - ${CONSOLE_MAP["OPT_PADDING"]} - ${CONSOLE_MAP["OPT_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["PARAM_PADDING"]=22
    CONSOLE_MAP["PARAM_STATUS_LENGHT"]=5
    CONSOLE_MAP["PARAM_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["PARAM_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["PARAM_COLUMNS_PADDED"]} - ${CONSOLE_MAP["PARAM_PADDING"]} - ${CONSOLE_MAP["PARAM_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["SCN_PADDING"]=27
    CONSOLE_MAP["SCN_STATUS_LENGHT"]=11
    CONSOLE_MAP["SCN_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["SCN_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["SCN_COLUMNS_PADDED5"]=$((${CONSOLE_MAP["COLUMNS"]} - 5))
    CONSOLE_MAP["SCN_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["SCN_COLUMNS_PADDED"]} - ${CONSOLE_MAP["SCN_PADDING"]} - ${CONSOLE_MAP["SCN_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["TASK_PADDING"]=27
    CONSOLE_MAP["TASK_STATUS_LENGHT"]=11
    CONSOLE_MAP["TASK_LINE_MIN_LENGTH"]=49
    CONSOLE_MAP["TASK_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["TASK_COLUMNS_PADDED5"]=$((${CONSOLE_MAP["COLUMNS"]} - 5))
    CONSOLE_MAP["TASK_DESCRIPTION_LENGTH"]=$((${CONSOLE_MAP["TASK_COLUMNS_PADDED"]} - ${CONSOLE_MAP["TASK_PADDING"]} - ${CONSOLE_MAP["TASK_STATUS_LENGHT"]} - 1))

    CONSOLE_MAP["CONFIG_PADDING"]=22
    CONSOLE_MAP["CONFIG_STATUS_LENGHT"]=1
    CONSOLE_MAP["CONFIG_LINE_MIN_LENGTH"]=35
    CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]=$((${CONSOLE_MAP["COLUMNS"]} - 2))
    CONSOLE_MAP["CONFIG_COLUMNS_PADDED5"]=$((${CONSOLE_MAP["COLUMNS"]} - 5))
    CONSOLE_MAP["VALUE_LENGTH"]=$((${CONSOLE_MAP["CONFIG_COLUMNS_PADDED"]} - ${CONSOLE_MAP["CONFIG_PADDING"]} - ${CONSOLE_MAP["CONFIG_STATUS_LENGHT"]} - 1))
}
ConsoleCalculate



##
## function ConsoleHas()
## - tests the requested counter for > 0
##   - returns true if requested counter is larger than 0, false otherwise
## $1: requested counter
##
ConsoleHas() {
    local COUNTER
    case $1 in
        errors)
            case ${CONFIG_MAP["RUNNING_IN"]} in
                loader) COUNTER=$LOADER_ERRORS ;;
                shell)  COUNTER=$SHELL_ERRORS ;;
                task)   COUNTER=$TASK_ERRORS ;;
            esac
            if (( $COUNTER > 0 )); then
                return 0
            else
                return 1
            fi
            ;;
        warnings)
            case ${CONFIG_MAP["RUNNING_IN"]} in
                loader) COUNTER=$LOADER_WARNINGS ;;
                shell)  COUNTER=$SHELL_WARNINGS ;;
                task)   COUNTER=$TASK_WARNINGS ;;
            esac
            if (( $COUNTER > 0 )); then
                return 0
            else
                return 1
            fi
            ;;
        *)
            ConsolePrint error "console-has: unknown counter $1"
            ;;
    esac
}



##
## function: ConsoleIs()
## - returns requested console status.
## $1: requested status, one of: message
##
ConsoleIs(){
    case $1 in
        debug)
            case $(GetSetting level) in
                all | debug | trace)    return 0;;
                *)                      return 1;;
            esac
            ;;
        message)
            case $(GetSetting quiet) in
                on)     return 1;;
                off)    return 0;;
            esac
            ;;
        prompt)
            case ${CONFIG_MAP["SHELL_SNP"]} in
                on)     return 1;;
                off)    return 0;;
            esac
            ;;
        trace)
            case $(GetSetting level) in
                all | trace)    return 0;;
                *)              return 1;;
            esac
            ;;
        *)
            ConsolePrint error "console-is: unknown status $1"
            ;;
    esac
}



##
## function ConsolePrint()
## - prints a message for given type and optional level
## $1: message type, one of: fatal, error, warn-strict, warn, info, debug, trace, message
## $2: message
## $3: optional level, default is 1, new level should be higher
##
## counters will be increased for type fatal, error, warn-strict, and warn
##
ConsolePrint() {
    local SPRINT

    case $1 in
        fatal)
            Counters increase errors
            case $(GetSetting level) in
                all | fatal | error | warn-strict | warn | info | debug | trace)
                    SPRINT=$(printf "  -> [")
                    SPRINT+=$(PrintColor red "Fatal")
                    SPRINT+=$(printf "] %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    ;;
                off)
                    ;;
            esac
            ;;
        error)
            Counters increase errors
            case $(GetSetting level) in
                all | error | warn-strict | warn | info | debug | trace)
                    SPRINT=$(printf "  -> [")
                    SPRINT+=$(PrintColor light-red "Error")
                    SPRINT+=$(printf "] %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    ;;
                *)
                    ;;
            esac
            ;;
        warn-strict)
            if [[ ${CONFIG_MAP["STRICT"]} == "on" ]]; then
                ## all warnings are errors
                Counters increase errors
                case $(GetSetting level) in
                    all | error | warn-strict | warn | info | debug | trace)
                        SPRINT=$(printf "  -> [")
                        SPRINT+=$(PrintColor light-red "Error")
                        SPRINT+=$(printf "/")
                        SPRINT+=$(PrintColor yellow "strict")
                        SPRINT+=$(printf "] %s" "$2")
                        printf %b "$SPRINT" 1>&2
                        printf "\n" 1>&2
                        ;;
                    *)
                        ;;
                esac
            else
                ## warnings are just warnings
                Counters increase warnings
                case $(GetSetting level) in
                    all | warn-strict | warn | info | debug | trace)
                        SPRINT=$(printf "  -> [")
                        SPRINT+=$(PrintColor yellow "Warning")
                        SPRINT+=$(printf "/")
                        SPRINT+=$(PrintColor light-red "strict")
                        SPRINT+=$(printf "] %s" "$2")
                        printf %b "$SPRINT" 1>&2
                        printf "\n" 1>&2
                        ;;
                    *)
                        ;;
                esac
            fi
            ;;
        warn)
            Counters increase warnings
            case $(GetSetting level) in
                all | warn | info | debug | trace)
                    SPRINT=$(printf "  -> [")
                    SPRINT+=$(PrintColor yellow "Warning")
                    SPRINT+=$(printf "] %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    ;;
                *)
                    ;;
            esac
            ;;
        info)
            case $(GetSetting level) in
                all | info | debug | trace)
                    SPRINT=$(printf "  --> [")
                    SPRINT+=$(PrintColor light-blue "Info")
                    SPRINT+=$(printf "] %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    if [[ "$2" == "done" ]]; then
                        printf "\n" 1>&2
                    fi
                    ;;
                *)
                    ;;
            esac
            ;;
        debug)
            case $(GetSetting level) in
                all | debug | trace)
                    SPRINT=$(printf "    ")
                    SPRINT+=$(PrintEffect bold ">")
                    SPRINT+=$(printf " %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    ;;
                *)
                    ;;
            esac
            ;;
        trace)
            case $(GetSetting level) in
                all | trace)
                    SPRINT=$(printf "      ")
                    SPRINT+=$(PrintEffect italic ">")
                    SPRINT+=$(printf " %s" "$2")
                    printf %b "$SPRINT" 1>&2
                    printf "\n" 1>&2
                    ;;
                *)
                    ;;
            esac
            ;;
        message)
            case $(GetSetting quiet) in
                off)    printf %b "$2" 1>&2;;
                on)     ;;
            esac
            ;;
        *)
            ConsolePrint error "console-print: unknown message type $1"
            ;;
    esac
}
