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
## Dirlists - element representing directory lists
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_ELEMENT_DLS_LONG[*]}" == "" ]]; then
    declare -A FW_ELEMENT_DLS_LONG      ## [long]="description"
    declare -A FW_ELEMENT_DLS_ORIG      ## [long]="module-long"
    declare -A FW_ELEMENT_DLS_PHA       ## [long]="phase that did set the value"
    declare -A FW_ELEMENT_DLS_VAL       ## [long]="the list of directories"
    declare -A FW_ELEMENT_DLS_MOD       ## [long]="dir mode: rwxcd"

    declare -A FW_ELEMENT_DLS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
    declare -A FW_ELEMENT_DLS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
    declare -A FW_ELEMENT_DLS_REQUESTED         ## [long]=" is requested, yes | no "
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_DLS_PHA FW_ELEMENT_DLS_VAL"
    FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_DLS_LONG FW_ELEMENT_DLS_ORIG FW_ELEMENT_DLS_MOD"
    FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_DLS_STATUS FW_ELEMENT_DLS_STATUS_COMMENTS FW_ELEMENT_DLS_REQUESTED"
fi

FW_TABLES_COL1["dirlist"]="Dir List"
FW_TABLES_EXTRAS["dirlist"]="Or R S P Modes"
FW_TAGS_ELEMENTS["Dirlists"]="element representing directory lists"


function Dirlists() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_ELEMENT_DLS_LONG[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_DLS_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (%s): %s, %s, %s, %s, %s\n" "${id}" "${FW_ELEMENT_DLS_STATUS[${id}]}" "${FW_ELEMENT_DLS_PHA[${id}]}" "${FW_ELEMENT_DLS_ORIG[${id}]}" "${FW_ELEMENT_DLS_MOD[${id}]}" "${FW_ELEMENT_DLS_VAL[${id}]}" "${FW_ELEMENT_DLS_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
