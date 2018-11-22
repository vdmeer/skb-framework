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
## Describe: describe a (shell) command
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.3
##

CMD_PADDING=32
CMD_STATUS_LENGHT=0
CMD_LINE_MIN_LENGTH=49
COLUMNS=$(tput cols)
COLUMNS=$((COLUMNS - 2))
DESCRIPTION_LENGTH=$((COLUMNS - CMD_PADDING - CMD_STATUS_LENGHT - 1))


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## DescribeCommand
## - describes a command using print options and print features
## $1: command id, mustbe long form
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeCommand() {
    local ID=${1:-}
    if [[ -z ${DMAP_CMD[$ID]:-} ]]; then
        ConsoleError " ->" "describe-cmd - unknown command '$ID'"
        return
    fi

    local PRINT_OPTION=${2:-}
    local PRINT_FEATURE=${3:-}

    local SPRINT=""
    local SHORT
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
            adoc)           SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["COMMANDS"]}/$ID.adoc ;;
            ansi | text*)   SOURCE=${CONFIG_MAP["FW_HOME"]}/${FW_PATH_MAP["COMMANDS"]}/$ID.txt ;;
            none | "")      ;;
            *)
                ConsoleError " ->" "describe-command - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_CMD_DESCR[$ID]:-}
    local LONG=$ID
    SHORT=${DMAP_CMD[$ID]:-}
    local ARGUMENT=${DMAP_CMD_ARG[$ID]:-}

    local TEMPLATE=""
    if [[ "$SHORT" == "--" ]]; then
        TEMPLATE+="%LONG%"
    elif [[ ! -n "$LONG" ]]; then
        TEMPLATE+="%SHORT%"
    else
        TEMPLATE+="%SHORT%, %LONG%"
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
            ConsoleError " ->" "describe-command - unknown print option '$PRINT_OPTION'"
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

    if [[ "${4:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
        printf "\n\n"
    fi
}



##
## function: DescribeCommandDescription
## - describes the command description
## $1: command ID, mustbe long form
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
DescribeCommandDescription() {
    local ID=$1
    if [[ -z ${DMAP_CMD[$ID]:-} ]]; then
        ConsoleError " ->" "describe-cmd/descr - unknown command '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_CMD_DESCR[$ID]}
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
## function: CommandInTable
## - main command details for table views
## $1: ID, mustbe long form
## optional $2: print mode (adoc, ansi, text)
##
CommandInTable() {
    local ID=$1
    if [[ -z ${DMAP_CMD[$ID]:-} ]]; then
        ConsoleError " ->" "describe-cmd/table - unknown command '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}

    local PADDING
    local PAD_STR
    local PAD_STR_LEN
    local SPRINT=" "$(DescribeCommand $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeCommand $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((CMD_PADDING - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}