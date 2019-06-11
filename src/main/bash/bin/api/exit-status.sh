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
## Functions for exit status (error codes)
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## DescribeExitstatus()
## - describes an exit status with various options.
## $1: exitstatus id
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeExitstatus() {
    local ID=${1:-}
    if [[ ! -n "${DMAP_ES[$ID]:-}" ]]; then
        ConsolePrint error "describe-exitstatus - unknown exitstatus ID '$ID'"
        return
    fi

    local PRINT_OPTION=${2:-}
    local PRINT_FEATURE=${3:-}
    local PRINT_MODE="${4:-${CONFIG_MAP["PRINT_MODE"]}}"

    local SPRINT=""
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
                if [[ "${PRINT_MODE}" == "adoc" ]]; then
                        LINE_INDENT=
                fi
            ;;
            post-line)      POST_LINE="::" ;;
            enter)          ENTER="\n" ;;
            adoc)           SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["EXITSTATUS"]}/$ID.adoc ;;
            ansi | text*)   SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["EXITSTATUS"]}/$ID.txt ;;
            none | "")      ;;
            *)
                ConsolePrint error "describe-exitstatus - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION="${DMAP_ES_DESCR[$ID]:-}"

    local TEMPLATE+="%ID%"
    if [[ "$PRINT_OPTION" == "full" ]]; then
        TEMPLATE+=" - %DESCRIPTION%"
    fi
    if [[ "${PRINT_MODE}" == "adoc" ]]; then
        TEMPLATE+=":: "
    fi

    case "$PRINT_OPTION" in
        standard | full)
            TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID" $PRINT_MODE)}
            TEMPLATE=${TEMPLATE//%DESCRIPTION%/"$DESCRIPTION"}
            SPRINT+=$TEMPLATE
            ;;
        *)
            ConsolePrint error "describe-exitstatus - unknown print option '$PRINT_OPTION'"
            return
            ;;
    esac

    SPRINT+=$POST_LINE
    printf %b "$SPRINT"

    if [[ -n "$SOURCE" ]]; then
        printf "\n"
        cat $SOURCE
        printf "\n"
    fi

    if [[ "${PRINT_MODE}" == "adoc" ]]; then
        printf "\n\n"
    fi
}



##
## DescribeElementExitStatus()
## - description for exit status
## $1: print mode
##
ExitStatusElementDescription() {
    case $1 in
        adoc)
            printf "\n\n== EXIT STATUS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/exit-status.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "EXIT STATUS" $1
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/exit-status.txt
            printf "\n"
            ;;
    esac
}



##
## function: ExitstatusInTable()
## - main exitstatus details for table views
## $1: ID
## optional $2: print mode (adoc, ansi, text)
##
ExitstatusInTable() {
    local ID=$1
    if [[ -z ${DMAP_ES[$ID]:-} ]]; then
        ConsolePrint error "exitstatus-in-table - unknown exitstatus '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}
    local PADDING
    local PAD_STR
    local PAD_STR_LEN
    local SPRINT

    SPRINT=" "$(DescribeExitstatus $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeExitstatus $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((${CONSOLE_MAP["ES_PADDING"]} - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: ExitstatusStatus()
## - prints formatted exit status code status information.
## $1: exitstatus ID
##
ExitstatusStatus() {
    local ID=$1
    if [[ -z ${DMAP_ES[$ID]:-} ]]; then
        ConsolePrint error "exitstatus-status - unknown exitstatus '$ID'"
        return
    fi

    local PROBLEM
    local ORIGIN=${DMAP_ES[$ID]}
    case $ORIGIN in
        all)        PrintColor green $ORIGIN; printf "   " ;;
        app)        PrintColor green $ORIGIN; printf "   " ;;
        fw)         PrintColor light-blue $ORIGIN; printf "    " ;;
        loader)     PrintColor light-blue $ORIGIN ;;
        shell)      PrintColor light-blue $ORIGIN; printf " " ;;
        task)       PrintColor light-blue $ORIGIN; printf "  " ;;
        *)          ConsolePrint error "describe-exit/status - unknown origin '$ORIGIN'"
    esac

    printf "  "

    PROBLEM=${DMAP_ES_PROBLEM[$ID]}
    case $PROBLEM in
        external)   PrintColor green $PROBLEM ;;
        internal)   PrintColor light-blue $PROBLEM ;;
        *)          ConsolePrint error "describe-exit/status - unknown problem '$PROBLEM'"
    esac
}



##
## function: ExitstatusTagline()
## - prints the exit status tagline with formatting (padding).
## $1: exitstatus ID
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to have no trailing padding (the $2 to a number, e.g. 0)
##
ExitstatusTagline() {
    local ID=$1
    if [[ -z ${DMAP_ES[$ID]:-} ]]; then
        ConsolePrint error "exitstatus-tagline - unknown exitstatus '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_ES_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["ES_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["ES_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["ES_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}
