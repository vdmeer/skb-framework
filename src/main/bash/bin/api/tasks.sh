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
## Functions for tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## function: BuildTaskHelpLine()
## - builds a help line for a task CLI option
## - line is printed when finished, otherwise error messages
## $1: short option, "<none>" if none
## $2: long option
## $3: argument, will be converted to UPPER case, "<none>" if none
## $4: description, tag line
## $5: length of short/long/argument, default value used if empty or not used
##
BuildTaskHelpLine() {
    local SHORT=${1:-}
    local LONG=${2:-}
    local ARGUMENT=${3:-}
    local DESCRIPTION=${4:-}
    local LENGTH=${5:-}

    if [[ -z $SHORT ]]; then
        ConsolePrint error "build task help: no short option set"
        return
    elif [[ "$SHORT" == "<none>" ]]; then
        SHORT=
    fi
    if [[ -z $LONG ]]; then
        ConsolePrint error "build task help: no long option set"
        return
    fi
    if [[ -z $ARGUMENT ]]; then
        ConsolePrint error "build task help: no argument set"
        return
    elif [[ "$ARGUMENT" == "<none>" ]]; then
        ARGUMENT=
    else
        ARGUMENT=${ARGUMENT^^}
    fi
    if [[ -z "$DESCRIPTION" ]]; then
        ConsolePrint error "build task help: no description set"
        return
    fi
    if [[ -z $LENGTH ]]; then
        LENGTH=24
        return
    fi

    local TYPE=
    if [[ -n "$ARGUMENT" ]]; then
        # options with an argument
        if [[ ! -n "$SHORT" ]]; then
            # long-argument
            TYPE="la"
        elif [[ ! -n "$LONG" ]]; then
            # short-argument
            TYPE="sa"
        else
            # short-long-argument
            TYPE="sla"
        fi
    else
        # options w/o an argument
        if [[ ! -n "$SHORT" ]]; then
            # long
            TYPE="l"
        elif [[ ! -n "$LONG" ]]; then
            # short
            TYPE="s"
        else
            # short-long
            TYPE="sl"
        fi
    fi

    local SPRINT="   "
    case "${CONFIG_MAP["PRINT_MODE"]}" in
        ansi)
            case $TYPE in
                la)     SPRINT+="     "$(PrintEffect bold --$LONG)" "$(PrintColor light-blue $ARGUMENT) ;;
                sa)     SPRINT+=$(PrintEffect bold -$SHORT)" "$(PrintColor light-blue $ARGUMENT) ;;
                sla)    SPRINT+=$(PrintEffect bold -$SHORT)" | "$(PrintEffect bold --$LONG)" "$(PrintColor light-blue $ARGUMENT) ;;
                l)      SPRINT+="     "$(PrintEffect bold --$LONG) ;;
                s)      SPRINT+=$(PrintEffect bold -$SHORT) ;;
                sl)     SPRINT+=$(PrintEffect bold -$SHORT)" | "$(PrintEffect bold --$LONG) ;;
            esac
            ;;
        text-anon)
            case $TYPE in
                la)     SPRINT+="     *--"$LONG"* _"$ARGUMENT"_" ;;
                sa)     SPRINT+="*-"$SHORT"* _"$ARGUMENT"_" ;;
                sla)    SPRINT+="*-"$SHORT"* | *--"$LONG"* _"$ARGUMENT"_" ;;
                l)      SPRINT+="     *--"$LONG"*" ;;
                s)      SPRINT+="*-"$SHORT"*" ;;
                sl)     SPRINT+="*-"$SHORT"* | *--"$LONG"*" ;;
            esac
            ;;
        text)
            case $TYPE in
                la)     SPRINT+="     --"$LONG" "$ARGUMENT ;;
                sa)     SPRINT+="-"$SHORT" "$ARGUMENT ;;
                sla)    SPRINT+="-"$SHORT" | --"$LONG" "$ARGUMENT ;;
                l)      SPRINT+="     --"$LONG ;;
                s)      SPRINT+="-"$SHORT ;;
                sl)     SPRINT+="-"$SHORT" | --"$LONG ;;
            esac
            ;;

        *)
            ConsolePrint error "describe-task - unknown print option '$PRINT_OPTION'"
            return
            ;;
    esac

    local LINE="       "$LONG" "$ARGUMENT
    local LINE_LENGTH=${#LINE}
    padding=$(( $LENGTH - $LINE_LENGTH ))
    if [[ ! -n "$ARGUMENT" ]]; then
        padding=$(( $padding +1 ))
    fi
    SPRINT+=$(printf '%*s' "$padding")$DESCRIPTION

    printf "$SPRINT\n"
}



##
## DebugTask()
## - debugs a task, provides all internal information about a task
## $1: task id, short or long form
##
DebugTask() {
    local ID=${1:-}
    TASK_ID=$(GetTaskID $ID)
    if [[ -z "${TASK_ID:-}" ]]; then
         ConsolePrint error "debug-task - unknown task ID '$ID'"
        return
    fi
    ID=$TASK_ID

    local SHORT
    for SHORT in ${!DMAP_TASK_SHORT[@]}; do
        if [[ "${DMAP_TASK_SHORT[$SHORT]}" == "$ID" ]]; then
            break
        fi
    done

    local SPRINT=""
    local TMP_VAL
    local FOUND
    local DESCRIPTION=${DMAP_TASK_DESCR[$ID]:-}
    local TEMPLATE="  %ID%, %SHORT% - %DESCRIPTION%"
    TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID")}
    TEMPLATE=${TEMPLATE//%SHORT%/$(PrintEffect bold "$SHORT")}
    TEMPLATE=${TEMPLATE//%DESCRIPTION%/$(PrintEffect italic "$DESCRIPTION")}
    SPRINT+=$TEMPLATE"\n"

    SPRINT+="    - origin:      "${DMAP_TASK_ORIGIN[$ID]}"\n"
    SPRINT+="    - modes:       "${DMAP_TASK_MODES[$ID]}"\n"
    SPRINT+="    - mode flavor: "${DMAP_TASK_MODE_FLAVOR[$ID]}"\n"

    TMP_VAL=${DMAP_TASK_DECL[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - declaration: "$TMP_VAL"\n"

    TMP_VAL=${DMAP_TASK_EXEC[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - executable:  "$TMP_VAL"\n"

    SPRINT+="\n    "$(PrintEffect italic "Requirements and dependencies")"\n"
    FOUND=false
    if [[ -n "${DMAP_TASK_REQ_PARAM_MAN[$ID]:-}" ]]; then
        SPRINT+="      - parameters, mandatory:   "${DMAP_TASK_REQ_PARAM_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_PARAM_OPT[$ID]:-}" ]]; then
        SPRINT+="      - parameters, optional:    "${DMAP_TASK_REQ_PARAM_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_DEP_MAN[$ID]:-}" ]]; then
        SPRINT+="      - dependencies, mandatory: "${DMAP_TASK_REQ_DEP_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_DEP_OPT[$ID]:-}" ]]; then
        SPRINT+="      - dependencies, optional:  "${DMAP_TASK_REQ_DEP_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_TASK_MAN[$ID]:-}" ]]; then
        SPRINT+="      - other tasks, mandatory:  "${DMAP_TASK_REQ_TASK_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_TASK_OPT[$ID]:-}" ]]; then
        SPRINT+="      - other tasks, optional:   "${DMAP_TASK_REQ_TASK_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_DIR_MAN[$ID]:-}" ]]; then
        SPRINT+="      - directories, mandatory:  "${DMAP_TASK_REQ_DIR_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_DIR_OPT[$ID]:-}" ]]; then
        SPRINT+="      - directories, optional:   "${DMAP_TASK_REQ_DIR_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_FILE_MAN[$ID]:-}" ]]; then
        SPRINT+="      - files, mandatory:        "${DMAP_TASK_REQ_FILE_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_TASK_REQ_FILE_OPT[$ID]:-}" ]]; then
        SPRINT+="      - files, optional:         "${DMAP_TASK_REQ_FILE_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ $FOUND == false ]]; then
        SPRINT+="      none\n"
    fi

    SPRINT+="\n    "$(PrintEffect italic "Load and status")"\n"
    SPRINT+="      - load status:   "${RTMAP_TASK_STATUS[$ID]:-}"\n"
    if [[ -n "${RTMAP_TASK_LOADED[$ID]:-}" ]]; then
        SPRINT+="      - load comments:"${RTMAP_TASK_LOADED[$ID]:-}"\n"
    fi
    if [[ -n "${RTMAP_TASK_UNLOADED[$ID]:-}" ]]; then
        SPRINT+="      "$(PrintColor light-red "unloaded")"\n"
    fi

    printf "$SPRINT\n"
}



##
## DescribeTask()
## - describes a task using print options and print features
## $1: task id, must be long form
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeTask() {
    local ID=${1:-}
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-task - unknown task ID '$ID'"
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
                ConsolePrint error "describe-task - unknown print feature '$PRINT_FEATURE'"
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
            ConsolePrint error "describe-task - unknown print option '$PRINT_OPTION'"
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
## function: ExecuteTask()
## - executes a task
## $1: full command line for the task, first word being the task ID (short or long form)]
## $2: special setting for scenarios: in-scenario (no extras inside scenarios)
##
ExecuteTask() {
    ConsoleCalculate

    local TASK=$(echo $1 | cut -d' ' -f1)
    local ID=$(GetTaskID $TASK)

    if [[ ! -n "$ID" ]]; then
        ConsolePrint error "unknown task '$TASK'"
        printf "\n"
        return
    fi

    if [[ -z "${RTMAP_TASK_LOADED[$ID]:-}" ]]; then
        ConsolePrint error "task '$ID' unknown, not loaded in mode '${CONFIG_MAP["APP_MODE"]}' / flavor '${CONFIG_MAP["APP_MODE_FLAVOR"]}'"
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
            if $(ConsoleIs message); then DO_EXTRAS=true; else DO_EXTRAS=false; fi
            ;;
    esac
    case "$TARG" in
        "-h" | "--help" | "-h "* | "--help "* | *" -h" | *" --help")
            DO_EXTRAS=false
            DO_HELP=true
            ;;
    esac

    ## overwrite any EXTRA/HELP/WAIT setting if $2 is set to "in-scenario"
    if [[ ! -z ${2:-} && "$2" == "in-scenario" ]]; then
        DO_EXTRAS=false
#        DO_HELP=false
#        DO_WAIT=false
    fi

    local TIME=
    local RUNTIME
    local TS
    local TE
    local SPRINT
    local ET_INT
    local BC_CALC

    if $DO_EXTRAS; then
        printf "\n "
        for ((x = 1; x < ${CONSOLE_MAP["TASK_COLUMNS_PADDED"]}; x++)); do
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

    if [[ $ERRNO != 0 ]]; then
        ConsolePrint error "error executing: '$ID $TARG'"
    fi

    if $DO_EXTRAS; then
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
        for ((x = 1; x < ${CONSOLE_MAP["TASK_COLUMNS_PADDED"]}; x++)); do
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
## function ExitOnTaskErrors()
## - tests if task errors are recorded, and calls exit if any found
##
ExitOnTaskErrors(){
    if [[ $TASK_ERRORS != 0 ]]; then
        exit $TASK_ERRORS
    fi
}



##
## function: GetTaskID()
## - returns a task ID for a given ID or SHORT, empty string if not declared
## $1: ID to process
##
GetTaskID() {
    local ID=$1
    local SHORT
    local TMP_ID
    local FOUND=false

    if [[ ! -z ${ID:-} ]]; then
        if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
            for SHORT in ${!DMAP_TASK_SHORT[@]}; do
                if [[ "$SHORT" == "$ID" ]]; then
                    TMP_ID=${DMAP_TASK_SHORT[$SHORT]}
                    if [[ ! -z ${DMAP_TASK_ORIGIN[$TMP_ID]:-} ]]; then
                        printf $TMP_ID
                        FOUND=true
                        break
                    fi
                fi
            done
            if [[ $FOUND == false ]]; then
                printf ""
            fi
        else
            printf $ID
        fi
    else
        printf ""
    fi
}



##
## function: TaskGetCachedHelp()
## - returns a file name with cached help screen for current print-mode, none if none found
## $1: task ID - must be long version
##
TaskGetCachedHelp() {
    local ID=${1:-}
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "help-cache - unknown task ID '$ID'"
        return
    fi

    local REMPATH=${APP_PATH_MAP["TASK_DECL"]}

    local TPATH=${DMAP_TASK_DECL[$ID]}
    TPATH=${TPATH#*$REMPATH/}
    TPATH=${TPATH%/*}

    local FILE="${CONFIG_MAP["CACHE_DIR"]}/tasks/$TPATH/$ID.${CONFIG_MAP["PRINT_MODE"]}"
    if [[ -f $FILE ]]; then
        printf $FILE
    else
        printf ""
    fi
}



##
## function: TaskDescription()
## - describes the task description
## $1: task ID, must be long form
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
TaskDescription() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-task/descr - unknown task ID '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_TASK_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["TASK_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["TASK_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["TASK_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## TaskElementDescription()
## - description for tasks
##
TaskElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n== TASKS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/tasks.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "TASKS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/tasks.txt
            printf "\n"
            ;;
    esac
}



##
## function: TaskInTable()
## - main task details for table views
## $1: ID, must be long form
## optional $2: print mode (adoc, ansi, text)
##
TaskInTable() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-task/table - unknown task ID '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}
    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeTask $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeTask $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((${CONSOLE_MAP["TASK_PADDING"]} - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: TaskStatus()
## - describes the task status for the task screen
## $1: task ID, must be long form
## optional $2: print mode (adoc, ansi, text)
##
TaskStatus() {
    local ID=$1
    if [[ -z ${DMAP_TASK_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-task/descr - unknown task ID '$ID'"
        return
    fi

    local FLAVOR
    local MODE
    local STATUS

    printf "%s " "${DMAP_TASK_ORIGIN[$ID]:0:1}"

    FLAVOR=${DMAP_TASK_MODE_FLAVOR[$ID]}
    case "$FLAVOR" in
        std)
            PrintColor cyan S
            ;;
        install)
            PrintColor purple I
            ;;
    esac
    printf " "

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
