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
## Phases - data object representing the framework's phases
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_PHA_LONG[*]}" == "" ]]; then
    declare -A FW_OBJECT_PHA_LONG       ## [long]="description"
    declare -A FW_OBJECT_PHA_PRT_LVL    ## [long]=" print levels "
    declare -A FW_OBJECT_PHA_LOG_LVL    ## [long]=" log levels "
    declare -A FW_OBJECT_PHA_ERRCNT     ## [long]="error count, integer"
    declare -A FW_OBJECT_PHA_WRNCNT     ## [long]="warning count, integer"
    declare -A FW_OBJECT_PHA_ERRCOD     ## [long]="list of recorded error codes"
    declare -A FW_OBJECT_PHA_PATH       ## [long]="path to description"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_PHA_PRT_LVL FW_OBJECT_PHA_LOG_LVL FW_OBJECT_PHA_ERRCNT FW_OBJECT_PHA_WRNCNT FW_OBJECT_PHA_ERRCOD"
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_PHA_LONG FW_OBJECT_PHA_PATH"
fi

FW_TABLES_COL1["phase"]=Phase
FW_TABLES_EXTRAS["phase"]="FEXMWIDT  FEXMWIDT  WRN ERR"
FW_TAGS_OBJECTS["Phases"]="data object representing the framework's phases"


function Phases() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_PHA_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_PHA_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s: %s/%s, %s/%s (%s), %s, %s\n" "${id}" "${FW_OBJECT_PHA_PRT_LVL[${id}]}" "${FW_OBJECT_PHA_LOG_LVL[${id}]}" "${FW_OBJECT_PHA_ERRCNT[${id}]}" "${FW_OBJECT_PHA_WRNCNT[${id}]}" "${FW_OBJECT_PHA_ERRCOD[${id}]}" "${FW_OBJECT_PHA_LONG[${id}]}" "${FW_OBJECT_PHA_PATH[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
