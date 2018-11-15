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
## Functions to execute a tasks and scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.1
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## function: ExecuteTask
## - executes a task
## $1: full command line for the task, first word being the task ID (short or long form)
##
ExecuteTask() {
    local COLUMNS=$(tput cols)
    COLUMNS=$((COLUMNS - 2))

    local TASK=$(echo $1 | cut -d' ' -f1)
    local ID=$(GetTaskID $TASK)

    if [[ ! -n "$ID" ]]; then
        ConsoleError " ->" "unknown task '$TASK'"
        printf "\n"
        return
    fi

    if [[ -z "${RTMAP_TASK_LOADED[$ID]:-}" ]]; then
        ConsoleError " ->" "task '$ID' unknown or not loaded in mode '${CONFIG_MAP["APP_MODE"]}'"
        printf "\n"
        return
    fi

    local TARG="$(echo $1 | cut -d' ' -f2-)"
    if [[ "$TARG" == "$ID" || "$TARG" == "$TASK" ]]; then
        TARG=
    fi

    local ERRNO

    local DO_EXTRAS=true
    local DO_HELP=false
    local DO_WAIT=false
    case $ID in
        list-* | describe-* | set | "set "* | setting | "setting "* | m | "m "* | manual | "manual "* | stats | "stats "* | statistics | "statistics "*)
            DO_EXTRAS=false
            ;;
        w | "w "* | wait | "wait "*)
            DO_EXTRAS=false
            if [[ "$TARG" != "-h" && "$TARG" != "--help" ]]; then
                DO_WAIT=true
            fi
            ;;
        *)
            if ConsoleIsMessage; then DO_EXTRAS=true; else DO_EXTRAS=false; fi
            ;;
    esac
    case "$TARG" in
        "-h" | "--help" | "-h "* | "--help "* | *" -h" | *" --help")
            DO_EXTRAS=false
            local DO_HELP=true
            ;;
    esac

    local TIME=
    local RUNTIME
    local TS
    local TE
    local SPRINT
    local ET_INT
    local BC_CALC

    if $DO_EXTRAS; then
        printf "\n "
        for ((x = 1; x < $COLUMNS; x++)); do
            printf %s "${CHAR_MAP["TOP_LINE"]}"
        done
        printf "\n"

        TIME=$(date +"%T")

        PrintEffect bold "  $ID"
        PrintEffect italic " $TIME executing task"
        if [[ -n "$TARG" ]]; then
            printf " with option(s): "
            PrintEffect bold "$TARG"
        fi
        printf "\n\n"
    elif $DO_HELP; then
        
        SPRINT=$(DescribeTask $ID full ${CONFIG_MAP["PRINT_MODE"]})
        printf "\n\n   %s\n" "$SPRINT"
    else
        printf "\n"
    fi

    TS=$(date +%s.%N)
    set +e
    ${DMAP_TASK_EXEC[$ID]} $TARG
    ERRNO=$?
    set -e
    TE=$(date +%s.%N)

    if $DO_EXTRAS; then
        if [[ $ERRNO != 0 ]]; then
            ConsoleError " ->" "error executing: '$ID $TARG'"
        fi
        printf "\n"
        PrintEffect bold "  done"
        TIME=$(date +"%T")

        ET_INT=$(echo "scale=0;($TE-$TS)/1" | bc -l)
        if (( ET_INT == 0 )); then
            BC_CALC=$(echo "scale=4;($TE-$TS)/1" | bc -l)
            RUNTIME=$(printf "0%s seconds\n" "$BC_CALC")
        elif (( ET_INT < 60 )); then
            BC_CALC=$(echo "scale=4;($TE-$TS)/1" | bc -l)
            RUNTIME=$(printf "%s seconds\n" "$BC_CALC")
        else
            local BC_CALC=$(echo "scale=2;($TE-$TS)/60" | bc -l)
            RUNTIME=$(printf "%s minutes\n" "$BC_CALC")
        fi

        PrintEffect italic " $TIME, $RUNTIME, status: $ERRNO"
        printf " - "
        if [[ $ERRNO == 0 ]]; then
            PrintColor light-green "success"
        else
            PrintColor light-red "error"
        fi

        printf "\n "
        for ((x = 1; x < $COLUMNS; x++)); do
            printf %s "${CHAR_MAP["TOP_LINE"]}"
        done
        printf "\n\n"
    elif $DO_WAIT; then
        RUNTIME=$(echo "$TE-$TS" | bc -l)
        printf "    wait: $RUNTIME seconds\n\n"
    else
        printf "\n"
    fi
}



##
## function: ExecuteScenario
## - executes a scenario
## $1: scenario ID, short or long form
##
ExecuteScenario() {
    local SCENARIO=$(GetScenarioID $1)
    if [[ -z ${SCENARIO} || -z ${DMAP_SCN_ORIGIN[$SCENARIO]:-} ]]; then
        ConsoleError " ->" "execute scenario - unknown scenario '$1'"
        return
    fi

    local FILE=${DMAP_SCN_EXEC[$SCENARIO]}
    if [[ ! -f $FILE ]]; then
        ConsoleError " ->" "did not find file for scenario $SCENARIO"
        return
    fi

    local COUNT=1
    local LENGTH

    while IFS='' read -r line || [[ -n "$line" ]]; do
        LENGTH=${#line}
        if [[ "${line:0:1}" != "#" ]] && (( LENGTH > 1 )); then
            ConsoleResetErrors
            ExecuteTask "$line"
            if ConsoleHasErrors; then
                ConsoleError " ->" "error in line $COUNT of senario $SCENARIO"
                return
            fi
        fi
        COUNT=$(( COUNT + 1 ))
    done < "$FILE"
}
