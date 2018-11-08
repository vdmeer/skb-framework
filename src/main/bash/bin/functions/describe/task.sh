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
## Describe: describe a task
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##

TASK_PADDING=27
TASK_STATUS_LENGHT=9
TASK_LINE_MIN_LENGTH=49
COLUMNS=$(tput cols)
COLUMNS=$((COLUMNS - 2))
DESCRIPTION_LENGTH=$((COLUMNS - TASK_PADDING - TASK_STATUS_LENGHT - 1))


##
## DescribeTask
## - describes a task using print options and print features
## $1: task id, mustbe long form
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeTask() {
    local ID=${1:-}
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsoleError " ->" "describe-task - unknown task ID '$ID'"
        return
    fi

    local PRINT_OPTION="${2:-}"
    local PRINT_FEATURE="${3:-}"
    local SPRINT=""

    local SHORT
    for SHORT in ${!DMAP_TASK_SHORT[@]}; do
        if [[ "${DMAP_TASK_SHORT[$SHORT]}" == "$ID" ]]; then
            break
        fi
    done

    local FEATURE
    local SOURCE=""
    local LINE_INDENT=""
    local POST_LINE=""
    local ENTER=""
    for FEATURE in $PRINT_FEATURE; do
        case "$FEATURE" in
            line-indent)
                LINE_INDENT="      "
                ## exception for adoc, no line indent even if requested
                if [[ -n "${4:-}" ]]; then
                    if [[ "$4" == "adoc" ]]; then
                        LINE_INDENT=
                    fi
                fi
            ;;
            post-line)      POST_LINE="::" ;;
            enter)          ENTER="\n" ;;
            adoc)           SOURCE=${DMAP_TASK_DECL[$ID]}.adoc ;;
            ansi | text*)   SOURCE=${DMAP_TASK_DECL[$ID]}.txt ;;
            none | "")      ;;
            *)
                ConsoleError " ->" "describe-task - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_TASK_DESCR[$ID]:-}

    local TEMPLATE="%ID%, %SHORT%"
    if [[ "$PRINT_OPTION" == "full" ]]; then
        TEMPLATE+=" - %DESCRIPTION%"
    fi
    if [[ "${4:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
        TEMPLATE+=":: "
    fi

    case "$PRINT_OPTION" in
        standard | full)
            local TMP_MODE=${4:-}
            if [[ "$TMP_MODE" == "" ]]; then
                TMP_MODE=${CONFIG_MAP["PRINT_MODE"]}
            fi
            TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%SHORT%/$(PrintEffect bold "$SHORT" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%DESCRIPTION%/"$DESCRIPTION"}
            SPRINT+=$TEMPLATE
            ;;
        *)
            ConsoleError " ->" "describe-task - unknown print option '$PRINT_OPTION'"
            return
            ;;
    esac

    SPRINT+=$POST_LINE
    printf "$SPRINT"

    if [[ -n "$SOURCE" ]]; then
        printf "\n"
        cat $SOURCE
        printf "\n"
    fi

    if [[ "${4:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
        printf "\n\n"
    fi
}



##
## function: DescribeTaskDescription
## - describes the task description
## $1: task ID, must be long form
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
DescribeTaskDescription() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsoleError " ->" "describe-task/descr - unknown task ID '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_TASK_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "$DESCRIPTION_LENGTH" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((DESCRIPTION_LENGTH - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((DESCRIPTION_LENGTH - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## function: DescribeTaskStatus
## - describes the task status for the task screen
## $1: task ID, must be long form
## optional $2: print mode (adoc, ansi, text)
##
DescribeTaskStatus() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsoleError " ->" "describe-task/descr - unknown task ID '$ID'"
        return
    fi

    local MODE
    local STATUS

    printf "%s " "${DMAP_TASK_ORIGIN[$ID]:0:1}"

    MODE=${DMAP_TASK_MODES[$ID]}
    case "$MODE" in
        *dev*)
            PrintColor green ${CHAR_MAP["AVAILABLE"]}
            ;;
        *)
            PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
            ;;
    esac
    printf " "
    case "$MODE" in
        *build*)
            PrintColor green ${CHAR_MAP["AVAILABLE"]}
            ;;
        *)
            PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
            ;;
    esac
    printf " "
    case "$MODE" in
        *use*)
            PrintColor green ${CHAR_MAP["AVAILABLE"]}
            ;;
        *)
            PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
            ;;
    esac

    printf " "
    case ${RTMAP_TASK_STATUS[$ID]} in
        "N")        PrintColor light-blue ${CHAR_MAP["DIAMOND"]} ;;
        "S")        PrintColor green ${CHAR_MAP["DIAMOND"]} ;;
        "E")        PrintColor light-red ${CHAR_MAP["DIAMOND"]} ;;
        "W")        PrintColor yellow ${CHAR_MAP["DIAMOND"]} ;;
    esac
}



##
## function: TaskInTable
## - main task details for table views
## $1: ID, mustbe long form
## optional $2: print mode (adoc, ansi, text)
##
TaskInTable() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsoleError " ->" "describe-task/table - unknown task ID '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}
    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeTask $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeTask $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((TASK_PADDING - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}

