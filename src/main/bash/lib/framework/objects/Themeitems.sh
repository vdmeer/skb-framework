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
## Themeitems - data object representing a theme's items
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_TIM_LONG[*]}" == "" ]]; then
    declare -A FW_OBJECT_TIM_LONG       ## [long]=description
    declare -A FW_OBJECT_TIM_SOURCE     ## [long]=source of setting, theme long
    declare -A FW_OBJECT_TIM_VAL        ## [long]=value, item settings
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_TIM_SOURCE FW_OBJECT_TIM_VAL"
    FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_TIM_LONG"
fi

FW_COMPONENTS_SINGULAR["themeitems"]="themeitem"
FW_COMPONENTS_PLURAL["themeitems"]="themeitems"
FW_COMPONENTS_TITLE_LONG_SINGULAR["themeitems"]="Theme Item"
FW_COMPONENTS_TITLE_LONG_PLURAL["themeitems"]="Theme Items"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["themeitems"]="Theme Item"
FW_COMPONENTS_TITLE_SHORT_PLURAL["themeitems"]="Theme Item"
FW_COMPONENTS_TABLE_DESCR["themeitems"]="Description"
FW_COMPONENTS_TABLE_VALUE["themeitems"]="Set Value"
#FW_COMPONENTS_TABLE_DEFVAL["themeitems"]=""
FW_COMPONENTS_TABLE_EXTRA["themeitems"]="Source Theme"
FW_COMPONENTS_TAGLINE["themeitems"]="data object representing a theme's items"


function Themeitems() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_TIM_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_TIM_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s: %s, %s, %s\n" "${id}" "${FW_OBJECT_TIM_SOURCE[${id}]}" "${FW_OBJECT_TIM_VAL[${id}]}" "${FW_OBJECT_TIM_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
