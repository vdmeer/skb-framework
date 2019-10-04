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
## Themes - data object representing the framework's themes
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_THM_LONG[*]}" == "" ]]; then
    declare -A FW_OBJECT_THM_LONG       ## [long]=description
    declare -A FW_OBJECT_THM_SHORT      ## [short]=long
    declare -A FW_OBJECT_THM_LS         ## [long]=short
    declare -A FW_OBJECT_THM_PATH       ## [long]=path
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_THM_LONG FW_OBJECT_THM_SHORT FW_OBJECT_THM_LS FW_OBJECT_THM_PATH"
fi

FW_TABLES_COL1["theme"]=Theme
FW_TABLES_EXTRAS["theme"]=""
FW_TAGS_OBJECTS["Themes"]="data object representing the framework's themes"


function Themes() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        list)
            if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_THM_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (%s): %s, %s\n" "${id}" "${FW_OBJECT_THM_LS[${id}]}" "${FW_OBJECT_THM_PATH[${id}]}" "${FW_OBJECT_THM_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        has)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in
                has-long)   echo " ${!FW_OBJECT_THM_LONG[@]} " ;;
                has-short)  echo " ${!FW_OBJECT_THM_SHORT[@]} " ;;
                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
