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
## Filelists - element representing file lists
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_ELEMENT_FLS_LONG[*]}" == "" ]]; then
    declare -A FW_ELEMENT_FLS_LONG      ## [long]="description"
    declare -A FW_ELEMENT_FLS_ORIG      ## [long]="module-long"
    declare -A FW_ELEMENT_FLS_PHA       ## [long]="phase that did set the value"
    declare -A FW_ELEMENT_FLS_VAL       ## [long]="list of files"
    declare -A FW_ELEMENT_FLS_MOD       ## [long]="file mode: rwxcd"

    declare -A FW_ELEMENT_FLS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
    declare -A FW_ELEMENT_FLS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
    declare -A FW_ELEMENT_FLS_REQUESTED         ## [long]=" is requested, yes | no "
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_FAST+=" FW_ELEMENT_FLS_PHA FW_ELEMENT_FLS_VAL"
    FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_FLS_LONG FW_ELEMENT_FLS_ORIG FW_ELEMENT_FLS_MOD"
    FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_FLS_STATUS FW_ELEMENT_FLS_STATUS_COMMENTS FW_ELEMENT_FLS_REQUESTED"
fi

FW_TABLES_COL1["filelist"]="File List"
FW_TABLES_EXTRAS["filelist"]="Or R S P Modes"
FW_TAGS_ELEMENTS["Filelists"]="element representing file lists"


function Filelists() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_ELEMENT_FLS_LONG[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_FLS_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (%s): %s, %s, %s, %s, %s\n" "${id}" "${FW_ELEMENT_FLS_STATUS[${id}]}" "${FW_ELEMENT_FLS_PHA[${id}]}" "${FW_ELEMENT_FLS_ORIG[${id}]}" "${FW_ELEMENT_FLS_MOD[${id}]}" "${FW_ELEMENT_FLS_VAL[${id}]}" "${FW_ELEMENT_FLS_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
