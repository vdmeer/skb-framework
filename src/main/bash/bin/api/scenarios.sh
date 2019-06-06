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
## Functions for scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## DebugScenario()
## - debugs a scenario, provides all internal information about a scenario
## $1: scenario id, short or long form
##
DebugScenario() {
    local ID=${1:-}
    SCN_ID=$(GetScenarioID $ID)
    if [[ -z ${SCN_ID:-} ]]; then
        ConsolePrint error "debug-scn - unknown scenario ID '$ID'"
        return
    fi
    ID=$SCN_ID

    local SHORT
    for SHORT in ${!DMAP_SCN_SHORT[@]}; do
        if [[ "${DMAP_SCN_SHORT[$SHORT]}" == "$ID" ]]; then
            break
        fi
    done

    local SPRINT=""
    local TMP_VAL
    local FOUND
    local DESCRIPTION=${DMAP_SCN_DESCR[$ID]:-}
    local TEMPLATE="  %ID%, %SHORT% - %DESCRIPTION%"
    TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID")}
    TEMPLATE=${TEMPLATE//%SHORT%/$(PrintEffect bold "$SHORT")}
    TEMPLATE=${TEMPLATE//%DESCRIPTION%/$(PrintEffect italic "$DESCRIPTION")}
    SPRINT+=$TEMPLATE"\n"

    SPRINT+="    - origin:      "${DMAP_SCN_ORIGIN[$ID]}"\n"
    SPRINT+="    - modes:       "${DMAP_SCN_MODES[$ID]}"\n"
    SPRINT+="    - mode flavor: "${DMAP_SCN_MODE_FLAVOR[$ID]}"\n"

    TMP_VAL=${DMAP_SCN_DECL[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - declaration: "$TMP_VAL"\n"

    TMP_VAL=${DMAP_SCN_EXEC[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - executable:  "$TMP_VAL"\n"

    SPRINT+="\n    "$(PrintEffect italic "Requirements and dependencies")"\n"
    FOUND=false
    if [[ -n "${DMAP_SCN_REQ_TASK_MAN[$ID]:-}" ]]; then
        SPRINT+="      - tasks, mandatory:  "${DMAP_SCN_REQ_TASK_MAN[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ -n "${DMAP_SCN_REQ_TASK_OPT[$ID]:-}" ]]; then
        SPRINT+="      - tasks, optional:   "${DMAP_SCN_REQ_TASK_OPT[$ID]:-}"\n"
        FOUND=true
    fi
    if [[ $FOUND == false ]]; then
        SPRINT+="      none\n"
    fi

    SPRINT+="\n    "$(PrintEffect italic "Load and status")"\n"
    SPRINT+="      - load status:   "${RTMAP_SCN_STATUS[$ID]:-}"\n"
    if [[ -n "${RTMAP_SCN_LOADED[$ID]:-}" ]]; then
        SPRINT+="      - load comments:"${RTMAP_SCN_LOADED[$ID]:-}"\n"
    fi
    if [[ -n "${RTMAP_SCN_UNLOADED[$ID]:-}" ]]; then
        SPRINT+="      "$(PrintColor light-red "unloaded")"\n"
    fi

    printf "$SPRINT\n"
}



##
## DescribeScenario()
## - describes a scenario using print options and print features
## $1: scenario id, must be long form
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeScenario() {
    local ID=${1:-}
    if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-scn - unknown scenario ID '$ID'"
        return
    fi

    local PRINT_OPTION="${2:-}"
    local PRINT_FEATURE="${3:-}"
    local SPRINT=""

    local SHORT
    for SHORT in ${!DMAP_SCN_SHORT[@]}; do
        if [[ "${DMAP_SCN_SHORT[$SHORT]}" == "$ID" ]]; then
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
            adoc)           SOURCE=${DMAP_SCN_DECL[$ID]}.adoc ;;
            ansi | text*)   SOURCE=${DMAP_SCN_DECL[$ID]}.txt ;;
            none | "")      ;;
            *)
                ConsolePrint error "describe-scn - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_SCN_DESCR[$ID]:-}

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
            ConsolePrint error "describe-SCN - unknown print option '$PRINT_OPTION'"
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
## function: ExecuteScenario()
## - executes a scenario
## $1: scenario ID, short or long form
##
ExecuteScenario() {
    local SCENARIO=$(GetScenarioID $1)
    if [[ -z ${SCENARIO} || -z ${DMAP_SCN_ORIGIN[$SCENARIO]:-} ]]; then
        ConsolePrint error "execute scenario - unknown scenario '$1'"
        return
    fi

    if [[ -z "${RTMAP_SCN_LOADED[$SCENARIO]:-}" ]]; then
        ConsolePrint error "scenario '$SCENARIO' unknown, not loaded in mode '${CONFIG_MAP["APP_MODE"]}' / flavor '${CONFIG_MAP["APP_MODE_FLAVOR"]}'"
        printf "\n"
        return
    fi

    local FILE=${DMAP_SCN_EXEC[$SCENARIO]}
    if [[ ! -f $FILE ]]; then
        ConsolePrint error "did not find file for scenario $SCENARIO"
        return
    fi

    local DO_EXTRAS=true
    if $(ConsoleIs message); then DO_EXTRAS=true; else DO_EXTRAS=false; fi
    local TIME=
    local RUNTIME
    local TS
    local TE
    local ET_INT
    local BC_CALC
    if $DO_EXTRAS; then
        printf "\n "
        for ((x = 1; x < ${CONSOLE_MAP["DEP_COLUMNS_PADDED"]}; x++)); do
            printf %s "${CHAR_MAP["TOP_LINE"]}"
        done
        printf "\n"

        TIME=$(date +"%T")

        PrintEffect bold "  $SCENARIO"
        PrintEffect italic " $TIME executing scenario"
        printf "\n\n"
    else
        printf "\n"
    fi

    local ES_ERRNO=0
    local COUNT=1
    local LENGTH
    local ERRORS
    TS=$(date +%s.%N)
    set +e
    while IFS='' read -r line || [[ -n "$line" ]]; do
        LENGTH=${#line}
        if [[ "${line:0:1}" != "#" ]] && (( LENGTH > 1 )); then
            ResetCounter errors
            ExecuteTask "$line" in-scenario
            ERRORS=$(GetCounter errors)
            ES_ERRNO=$((ES_ERRNO + ERRORS))
            if $(ConsoleHas errors); then
                ConsolePrint error "error in line $COUNT of senario $SCENARIO"
                break
            fi
        fi
        COUNT=$(( COUNT + 1 ))
    done < "$FILE"
    set -e
    TE=$(date +%s.%N)

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

        PrintEffect italic " $TIME, $RUNTIME, status: $ES_ERRNO"
        printf " - "
        if [[ $ES_ERRNO == 0 ]]; then
            PrintColor light-green "success"
        else
            PrintColor light-red "error"
        fi

        printf "\n "
        for ((x = 1; x < ${CONSOLE_MAP["SCN_COLUMNS_PADDED"]}; x++)); do
            printf %s "${CHAR_MAP["TOP_LINE"]}"
        done
        printf "\n\n"
    else
        printf "\n"
    fi

}



##
## function: GetScenarioID()
## - returns a scenario ID for a given ID or SHORT, empty string if not declared
## $1: ID to process
##
GetScenarioID() {
    local ID=$1
    local SHORT
    local TMP_ID
    local FOUND=false

    if [[ ! -z ${ID:-} ]]; then
        if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
            for SHORT in ${!DMAP_SCN_SHORT[@]}; do
                if [[ "$SHORT" == "$ID" ]]; then
                    TMP_ID=${DMAP_SCN_SHORT[$SHORT]}
                    if [[ ! -z ${DMAP_SCN_ORIGIN[$TMP_ID]:-} ]]; then
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
## function: ScenarioDescription()
## - describes the scenario description
## $1: scenario ID, must be long form
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
ScenarioDescription() {
    local ID=$1
    if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-scn/descr - unknown scenario ID '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_SCN_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["SCN_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["SCN_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["SCN_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## ScenarioElementDescription()
## - description for scenarios
##
ScenarioElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n== SCENARIOS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/scenarios.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "SCENARIOS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/scenarios.txt
            printf "\n"
            ;;
    esac
}



##
## function: ScenarioInTable()
## - main scenario details for table views
## $1: ID, must be long form
## optional $2: print mode (adoc, ansi, text)
##
ScenarioInTable() {
    local ID=$1
    if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-scn/table - unknown scenario ID '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}
    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeScenario $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeScenario $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((${CONSOLE_MAP["SCN_PADDING"]} - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: ScenarioStatus()
## - describes the scenario status for the scenario screen
## $1: scenario ID, must be long form
## optional $2: print mode (adoc, ansi, text)
##
ScenarioStatus() {
    local ID=$1
    if [[ -z ${DMAP_SCN_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-scn/descr - unknown scenario ID '$ID'"
        return
    fi

    local MODE
    local STATUS

    printf "%s " "${DMAP_SCN_ORIGIN[$ID]:0:1}"

    FLAVOR=${DMAP_SCN_MODE_FLAVOR[$ID]}
    case "$FLAVOR" in
        std)
            PrintColor cyan S
            ;;
        install)
            PrintColor purple I
            ;;
    esac
    printf " "

    MODE=${DMAP_SCN_MODES[$ID]}
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
    case ${RTMAP_SCN_STATUS[$ID]} in
        "N")        PrintColor light-blue ${CHAR_MAP["DIAMOND"]} ;;
        "S")        PrintColor green ${CHAR_MAP["DIAMOND"]} ;;
        "E")        PrintColor light-red ${CHAR_MAP["DIAMOND"]} ;;
        "W")        PrintColor yellow ${CHAR_MAP["DIAMOND"]} ;;
    esac
}

