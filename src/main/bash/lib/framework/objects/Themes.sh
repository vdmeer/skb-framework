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
    declare -A FW_OBJECT_THM_PATH       ## [long]=path
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_THM_LONG FW_OBJECT_THM_PATH"
fi

FW_COMPONENTS_SINGULAR["themes"]="theme"
FW_COMPONENTS_PLURAL["themes"]="themes"
FW_COMPONENTS_TITLE_LONG_SINGULAR["themes"]="Theme"
FW_COMPONENTS_TITLE_LONG_PLURAL["themes"]="Themes"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["themes"]="Theme"
FW_COMPONENTS_TITLE_SHORT_PLURAL["themes"]="Themes"
FW_COMPONENTS_TABLE_DESCR["themes"]="Description"
FW_COMPONENTS_TABLE_VALUE["themes"]="Path to Theme File"
#FW_COMPONENTS_TABLE_DEFVAL["themes"]=""
FW_COMPONENTS_TABLE_EXTRA["themes"]=""
FW_COMPONENTS_TAGLINE["themes"]="data object representing the framework's themes"


function Themes() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_THM_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_THM_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_THM_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s: %s, %s\n" "${id}" "${FW_OBJECT_THM_PATH[${id}]}" "${FW_OBJECT_THM_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
