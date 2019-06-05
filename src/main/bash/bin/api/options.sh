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
## Functions for (CLI) options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## DescribeOption()
## - describes a option using print options and print features
## $1: option id, mustbe long form
## $2: print option: standard, full
## $3: print features: none, line-indent, sl-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeOption() {
    local ID=${1:-}
    if [[ -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-opt - unknown option '$ID'"
        return
    fi

    local PRINT_OPTION=${2:-}
    local PRINT_FEATURE=${3:-}
    local SPRINT=""
    local FEATURE
    local SOURCE=""
    local LINE_INDENT=""
    local SL_INDENT=""
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
            sl-indent)      SL_INDENT="    " ;;
            post-line)      POST_LINE="::" ;;
            enter)          ENTER="\n" ;;
            adoc)           SOURCE=$ID.adoc ;;
            ansi | text*)   SOURCE=$ID.txt ;;
            none | "")      ;;
            *)
                ConsolePrint error "describe-option - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_OPT_DESCR[$ID]:-}

    local LONG=$ID
    local SHORT=${DMAP_OPT_SHORT[$ID]:-}
    local ARGUMENT=${DMAP_OPT_ARG[$ID]:-}

    local TEMPLATE=""
    if [[ ! -n "$SHORT" ]]; then
        TEMPLATE+=$SL_INDENT"%LONG%"
        LONG="--"$LONG
    elif [[ ! -n "$LONG" ]]; then
        TEMPLATE+="%SHORT%"
        SHORT="-"$SHORT
    else
        TEMPLATE+="%SHORT%, %LONG%"
        LONG="--"$LONG
        SHORT="-"$SHORT
    fi
    if [[ -n "$ARGUMENT" ]]; then
        TEMPLATE+=" %ARGUMENT%"
    fi
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
            TEMPLATE=${TEMPLATE//%SHORT%/$(PrintEffect bold "$SHORT" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%LONG%/$(PrintEffect bold "$LONG" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%ARGUMENT%/$(PrintColor light-blue "$ARGUMENT" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%DESCRIPTION%/"$DESCRIPTION"}
            SPRINT+=$TEMPLATE
            ;;
        *)
            ConsolePrint error "describe-option - unknown print option '$PRINT_OPTION'"
            return
            ;;
    esac

    SPRINT+=$POST_LINE
    printf %b "$SPRINT"

    if [[ -n "$SOURCE" ]]; then
        printf "\n"
        case "${DMAP_OPT_ORIGIN[$ID]}" in
            exit)
                cat ${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["OPTIONS"]}/exit/$SOURCE
                ;;
            run)
                cat ${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["OPTIONS"]}/run/$SOURCE
                ;;
        esac
        printf "\n"
    fi

    if [[ "${4:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
        printf "\n\n"
    fi
}



##
## ExitOptionElementDescription()
## - description for exit options
##
ExitOptionElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n=== Exit OPTIONS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/exit-options.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "    "
            PrintEffect bold "Exit OPTIONS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/exit-options.txt
            printf "\n"
            ;;
    esac
}



##
## function: OptionDescription()
## - describes the option description
## $1: option ID, mustbe long form
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
OptionDescription() {
    local ID=$1
    if [[ -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-opt/descr - unknown option '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_OPT_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["OPT_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["OPT_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["OPT_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## OptionElementDescription()
## - description for options
##
OptionElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n== OPTIONS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/options.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "OPTIONS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/options.txt
            printf "\n"
            ;;
    esac
}



##
## function: OptionInTable()
## - main option details for table views
## $1: ID, mustbe long form
## optional $2: print mode (adoc, ansi, text)
##
OptionInTable() {
    local ID=$1
    if [[ -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-opt/table - unknown option '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}
    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeOption $ID standard sl-indent $PRINT_MODE)

    PAD_STR=$(DescribeOption $ID standard sl-indent text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((${CONSOLE_MAP["OPT_PADDING"]} - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: OptionStatus()
## - describes the option status
## $1: option ID, mustbe long form
##
OptionStatus() {
    local ID=$1
    if [[ -z ${DMAP_OPT_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-opt/status - unknown option '$ID'"
        return
    fi

    local ORIGIN=${DMAP_OPT_ORIGIN[$ID]}
    case $ORIGIN in
        exit)   PrintColor green $ORIGIN ;;
        run)    PrintColor light-blue $ORIGIN ;;
        *)      ConsolePrint error "describe-opt/status - unknown origin '$ORIGIN'"
    esac
}



##
## RuntimeOptionElementDescription()
## - description for exit options
##
RuntimeOptionElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n=== Runtime OPTIONS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/run-options.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "    "
            PrintEffect bold "Runtime OPTIONS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/run-options.txt
            printf "\n"
            ;;
    esac
}
