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
## Configuration - data object representing the framework's configuration
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_OBJECT_CFG_LONG[*]}" == "" ]]; then
    declare -A -g FW_OBJECT_CFG_LONG    ## [long]="description"
    declare -A -g FW_OBJECT_CFG_VAL     ## [long]="value"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_CFG_VAL"
    FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_CFG_LONG"
fi

FW_TABLES_COL1["configuration"]=Configuration
FW_TABLES_EXTRAS["configuration"]=""
FW_TAGS_OBJECTS["Configuration"]="data object representing the framework's configuration"


function Configuration() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_CFG_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_CFG_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_CFG_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s: %s := %s\n" "${id}" "${FW_OBJECT_CFG_LONG[${id}]}" "${FW_OBJECT_CFG_VAL[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
