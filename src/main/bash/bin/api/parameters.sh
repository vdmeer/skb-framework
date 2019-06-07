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
## Functions for parameters
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## DebugParameter()
## - debugs a parameter, provides all internal information about a parameter
## $1: parameter id
##
DebugParameter() {
    local ID=${1:-}
    PARAM_ID=$(GetParameterID $ID)
    if [[ -z "${PARAM_ID:-}" ]]; then
         ConsolePrint error "debug-parameter - unknown parameter ID '$ID'"
        return
    fi
    ID=$PARAM_ID

    local SPRINT=""
    local TMP_VAL
    local FOUND
    local DESCRIPTION=${DMAP_PARAM_DESCR[$ID]:-}
    local TEMPLATE="  %ID% - %DESCRIPTION%"
    TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID")}
    TEMPLATE=${TEMPLATE//%DESCRIPTION%/$(PrintEffect italic "$DESCRIPTION")}
    SPRINT+=$TEMPLATE"\n"

    SPRINT+="    - origin:        "${DMAP_PARAM_ORIGIN[$ID]}"\n"
    SPRINT+="    - default value: "$(ParameterDefvalueDescription $ID)"\n"
    if [[ -n "${DMAP_PARAM_IS[$ID]:-}" ]]; then
        SPRINT+="    - param is:      "${DMAP_PARAM_IS[$ID]}"\n"
    fi

    TMP_VAL=${DMAP_PARAM_DECL[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - declaration:   "$TMP_VAL"\n"

    if [[ -n "${RTMAP_REQUESTED_PARAM[$ID]:-}" ]]; then
        SPRINT+="    - requested by: "${RTMAP_REQUESTED_PARAM[$ID]}"\n"
    fi

    printf "$SPRINT\n"
}



##
## DescribeParameter()
## - describes a parameter using print options and print features
## $1: parameter id
## $2: print option: standard, full, default-value
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
## optional $4: print mode (adoc, ansi, text)
##
DescribeParameter() {
    local ID=${1:-}
    if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-param - unknown parameter '$ID'"
        return
    fi

    local PRINT_OPTION="${2:-}"
    local PRINT_FEATURE="${3:-}"

    local SPRINT=""
    local FEATURE
    local SOURCE=""
    local LINE_INDENT=""
    local POST_LINE=""
    local ENTER=""
    local DEF_TEMPLATE=""

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
            adoc)
                SOURCE=${DMAP_PARAM_DECL[$ID]}.adoc
                DEF_TEMPLATE="\n+\ndefault value:"
                ;;
            ansi | text*)
                SOURCE=${DMAP_PARAM_DECL[$ID]}.txt
                DEF_TEMPLATE="        default value:"
                ;;
            none | "")      ;;
            *)
                ConsolePrint error "describe-param - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_PARAM_DESCR[$ID]:-}
    local DEFAULT_VALUE=$(ParameterDefvalueDescription $ID ${4:-})

    local TEMPLATE="%ID%"
    if [[ "$PRINT_OPTION" == "full" ]]; then
        TEMPLATE+=" - %DESCRIPTION%"
    fi
    if [[ "$PRINT_OPTION" == "default-value" ]]; then
        TEMPLATE="%DEFAULT_VALUE%"
    fi
    if [[ "${4:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
        TEMPLATE+=":: "
    fi

    case "$PRINT_OPTION" in
        standard | full | default-value)
            local TMP_MODE=${4:-}
            if [[ "$TMP_MODE" == "" ]]; then
                TMP_MODE=${CONFIG_MAP["PRINT_MODE"]}
            fi
            TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%DEFAULT_VALUE%/$(PrintEffect italic "$DEFAULT_VALUE" $TMP_MODE)}
            TEMPLATE=${TEMPLATE//%DESCRIPTION%/"$DESCRIPTION"}
            SPRINT+=$TEMPLATE
            ;;
        *)
            ConsolePrint error "describe-param - unknown print option '$PRINT_OPTION'"
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
    if [[ -n "$DEF_TEMPLATE" ]]; then
        printf "$DEF_TEMPLATE $DEFAULT_VALUE\n\n"
    fi
}



##
## function: GetParameterID()
## - returns a parameter ID for a given ID (upper or lower case spelling), empty string if not declared
## $1: ID to process
##
GetParameterID() {
    local ID="${1^^}"
    local SHORT
    local TMP_ID

    if [[ ! -z ${ID:-} ]]; then
        if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
            printf ""
        else
            printf $ID
        fi
    else
        printf ""
    fi
}



##
## function: ParameterDefvalueDescription()
## - prints the parameter default value with path shortening and formatting
## $1: param ID
##
ParameterDefvalueDescription() {
    local ID=$1
    if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-parameter/defval - unknown '$ID'"
        return
    fi

    local DEFAULT_VALUE=${DMAP_PARAM_DEFVAL[$ID]}
    if [[ "$DEFAULT_VALUE" == "" ]]; then
        DEFAULT_VALUE="none defined"
    else
        DEFAULT_VALUE=${DEFAULT_VALUE/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
        DEFAULT_VALUE=${DEFAULT_VALUE/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
        if [[ "${2:-}" == "adoc" || "${CONFIG_MAP["PRINT_MODE"]}" == "adoc" ]]; then
            DEFAULT_VALUE="\`"$DEFAULT_VALUE"\`"
        else
            DEFAULT_VALUE='"'$DEFAULT_VALUE'"'
        fi
    fi
    printf "%s" "$DEFAULT_VALUE"
}



##
## function: ParameterDescription()
## - describes the parameter description
## $1: parameter ID
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to have no trailing padding (the $2 to a number, e.g. 0)
##
ParameterDescription() {
    local ID=$1
    if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-parameter/descr - unknown '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_PARAM_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["PARAM_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## ParameterElementDescription()
## - description for parameters
##
ParameterElementDescription() {
    case $TARGET in
        adoc)
            printf "\n\n== PARAMETERS\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/parameters.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "PARAMETERS" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/parameters.txt
            printf "\n"
            ;;
    esac
}



##
## function: ParameterInTable()
## - main parameter details for table views
## $1: ID
## optional $2: print mode (adoc, ansi, text)
##
ParameterInTable() {
    local ID=$1
    if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-parameter/table - unknown '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}

    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeParameter $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeParameter $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((${CONSOLE_MAP["PARAM_PADDING"]} - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: ParameterStatus()
## - describes the parameter status for the parameter screen
## $1: param ID
## optional $2: print mode (adoc, ansi, text)
##
ParameterStatus() {
    local ID=$1
    if [[ -z ${DMAP_PARAM_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-parameter/status - unknown '$ID'"
        return
    fi

    printf "%s " "${DMAP_PARAM_ORIGIN[$ID]:0:1}"

    if [[ -n "${DMAP_PARAM_DEFVAL[$ID]:-}" ]]; then
        PrintColor green ${CHAR_MAP["AVAILABLE"]}
    else
        PrintColor light-red ${CHAR_MAP["NOT_AVAILABLE"]}
    fi
    printf " "
    case ${CONFIG_SRC[$ID]:-} in
        "O")        PrintColor light-blue ${CHAR_MAP["DIAMOND"]} ;;
        "E")        PrintColor green ${CHAR_MAP["DIAMOND"]} ;;
        "F")        PrintColor brown ${CHAR_MAP["DIAMOND"]} ;;
        "D")        PrintColor yellow ${CHAR_MAP["DIAMOND"]} ;;
        *)          printf "${CHAR_MAP["DIAMOND"]}"
    esac
}
