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
## Functions for dependencies
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##



##
## DebugDependency()
## - debugs a dependency, provides all internal information about a dependency
## $1: dependency id
##
DebugDependency() {
    local ID=${1:-}
    if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "debug-dep - unknown dependency '$ID'"
        return
    fi

    local SPRINT=""
    local TMP_VAL
    local FOUND
    local DESCRIPTION=${DMAP_DEP_DESCR[$ID]:-}
    local TEMPLATE="  %ID% - %DESCRIPTION%"
    TEMPLATE=${TEMPLATE//%ID%/$(PrintEffect bold "$ID")}
    TEMPLATE=${TEMPLATE//%DESCRIPTION%/$(PrintEffect italic "$DESCRIPTION")}
    SPRINT+=$TEMPLATE"\n"

    SPRINT+="    - origin:       "${DMAP_DEP_ORIGIN[$ID]}"\n"

    TMP_VAL=${DMAP_DEP_DECL[$ID]}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["FW_HOME"]}/\$FW_HOME}
    TMP_VAL=${TMP_VAL/${CONFIG_MAP["APP_HOME"]}/\$APP_HOME}
    SPRINT+="    - declaration:  "$TMP_VAL"\n"

    SPRINT+="    - command:      "${DMAP_DEP_CMD[$ID]}"\n"

    SPRINT+="    - load status:  "${RTMAP_DEP_STATUS[$ID]:-}"\n"
    if [[ -n "${RTMAP_REQUESTED_DEP[$ID]:-}" ]]; then
        SPRINT+="    - requested by:"${RTMAP_REQUESTED_DEP[$ID]}"\n"
    fi
    if [[ -n "${DMAP_DEP_REQ_DEP[$ID]:-}" ]]; then
        SPRINT+="    - requires dep: "${DMAP_DEP_REQ_DEP[$ID]:-}"\n"
    fi

    printf "$SPRINT\n"
}



##
## function: DependencyDescription()
## - describes the dependency description
## $1: dependency ID
## $2: indentation adjustment, 0 or empty for none
## $3: set to anything to hav no trailing padding (the $2 to a number, e.g. 0)
##
DependencyDescription() {
    local ID=$1
    if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-dep/descr - unknown dependency '$ID'"
        return
    fi

    local ADJUST=${2:-0}
    local DESCRIPTION
    local DESCR_EFFECTIVE
    local PADDING

    local DESCRIPTION=${DMAP_DEP_DESCR[$ID]}
    if [[ "${#DESCRIPTION}" -le "${CONSOLE_MAP["DEP_DESCRIPTION_LENGTH"]}" ]]; then
        printf "%s" "$DESCRIPTION"
        if [[ -z ${3:-} ]]; then
            DESCR_EFFECTIVE=${#DESCRIPTION}
            PADDING=$((${CONSOLE_MAP["DEP_DESCRIPTION_LENGTH"]} - DESCR_EFFECTIVE - ADJUST))
            printf '%*s' "$PADDING"
        fi
    else
        DESCR_EFFECTIVE=$((${CONSOLE_MAP["DEP_DESCRIPTION_LENGTH"]} - 4 - ADJUST))
        printf "%s... " "${DESCRIPTION:0:$DESCR_EFFECTIVE}"
    fi
}



##
## DependencyElemendDescription()
## - description for dependencies
##
DependencyElemendDescription() {
    case $TARGET in
        adoc)
            printf "\n\n== DEPENDENCIES\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/dependencies.adoc
            printf "\n\n"
            ;;
        ansi | text*)
            printf "  "
            PrintEffect bold "DEPENDENCIES" $TARGET
            printf "\n"
            cat ${CONFIG_MAP["MANUAL_SRC"]}/elements/dependencies.txt
            printf "\n"
            ;;
    esac
}



##
## function: DependencyInTable()
## - main dependency details for table views
## $1: ID
## optional $2: print mode (adoc, ansi, text)
##
DependencyInTable() {
    local ID=$1
    if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-dep/table - unknown dependency '$ID'"
        return
    fi

    local PRINT_MODE=${2:-}

    local PADDING
    local PAD_STR
    local PAD_STR_LEN

    local SPRINT=" "$(DescribeDependency $ID standard "none" $PRINT_MODE)

    PAD_STR=$(DescribeDependency $ID standard "none" text)
    PAD_STR_LEN=${#PAD_STR}
    PADDING=$((DEP_PADDING - $PAD_STR_LEN))
    SPRINT=$SPRINT$(printf '%*s' "$PADDING")

    printf "$SPRINT"
}



##
## function: DependencyStatus()
## - describes the dependency status for the dependency screen
## $1: dependency ID
##
DependencyStatus() {
    local ID=$1
    if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-dep/status - unknown dependency '$ID'"
        return
    fi

    printf "%s " "${DMAP_DEP_ORIGIN[$ID]:0:1}"
    case ${RTMAP_DEP_STATUS[$ID]} in
        "N")        PrintColor light-blue ${CHAR_MAP["DIAMOND"]} ;;
        "S")        PrintColor green ${CHAR_MAP["DIAMOND"]} ;;
        "E")        PrintColor light-red ${CHAR_MAP["DIAMOND"]} ;;
        "W")        PrintColor yellow ${CHAR_MAP["DIAMOND"]} ;;
    esac
}



##
## DescribeDependency()
## - describes a dependency using print options and print features
## $1: dependency id
## $2: print option: standard, full
## $3: print features: none, line-indent, enter, post-line, (adoc, ansi, text*)
##
DescribeDependency() {
    local ID=${1:-}
    if [[ -z ${DMAP_DEP_ORIGIN[$ID]:-} ]]; then
        ConsolePrint error "describe-dep - unknown dependency '$ID'"
        return
    fi

    local PRINT_OPTION=${2:-}
    local PRINT_FEATURE=${3:-}
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
                if [[ -n "${4:-}" ]]; then
                    if [[ "$4" == "adoc" ]]; then
                        LINE_INDENT=
                    fi
                fi
            ;;
            post-line)      POST_LINE="::" ;;
            enter)          ENTER="\n" ;;
            adoc)           SOURCE=${DMAP_DEP_DECL[$ID]}.adoc ;;
            ansi | text*)   SOURCE=${DMAP_DEP_DECL[$ID]}.txt ;;
            none | "")      ;;
            *)
                ConsolePrint error "describe-dependency - unknown print feature '$PRINT_FEATURE'"
                return
                ;;
        esac
    done

    SPRINT=$ENTER
    SPRINT+=$LINE_INDENT

    local DESCRIPTION=${DMAP_DEP_DESCR[$ID]:-}

    local TEMPLATE="%ID%"
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
            TEMPLATE=${TEMPLATE//%DESCRIPTION%/"$DESCRIPTION"}
            SPRINT+=$TEMPLATE
            ;;
        *)
            ConsolePrint error "describe-dependency - unknown print option '$PRINT_OPTION'"
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
