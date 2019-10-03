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
## Settings - data object representing the framework's settings
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_SET_LONG[*]}" == "" ]]; then
    declare -A FW_OBJECT_SET_LONG       ## [long]="description"
    declare -A FW_OBJECT_SET_PHA        ## [long]="phase that did set the value"
    declare -A FW_OBJECT_SET_VAL        ## [long]="the value"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_SET_PHA FW_OBJECT_SET_VAL"
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_SET_LONG"
fi

FW_TABLES_COL1["setting"]=Setting
FW_TABLES_EXTRAS["setting"]="P"
FW_TAGS_OBJECTS["Settings"]="data object representing the framework's settings"


function Settings() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_SET_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_SET_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_SET_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s [%s]: %s := %s\n" "${id}" "${FW_OBJECT_SET_PHA[${id}]}" "${FW_OBJECT_SET_LONG[${id}]}" "${FW_OBJECT_SET_VAL[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
