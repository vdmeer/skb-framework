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
## Scenarios - element representing scenarios
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_ELEMENT_SCN_LONG[*]}" == "" ]]; then
    declare -A FW_ELEMENT_SCN_LONG      ## [long]=description
    declare -A FW_ELEMENT_SCN_ORIG      ## [long]=module-long
    declare -A FW_ELEMENT_SCN_MODES     ## [long]=app-mode
    declare -A FW_ELEMENT_SCN_PATH      ## [long]=path
    declare -A FW_ELEMENT_SCN_PATH_TEXT ## [long]=module::path

    declare -A FW_ELEMENT_SCN_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
    declare -A FW_ELEMENT_SCN_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"

    declare -A FW_ELEMENT_SCN_REQUIRED_APP          ## [long]="required applications, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_DEP          ## [long]="required dependencies, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_PAR          ## [long]="required parameters, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_TSK          ## [long]="required tasks, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_FILE         ## [long]="required files, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_FILELIST     ## [long]="required file lists, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_DIR          ## [long]="required directories, normal list"
    declare -A FW_ELEMENT_SCN_REQUIRED_DIRLIST      ## [long]="required directory lists, normal list"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_SCN_LONG FW_ELEMENT_SCN_ORIG FW_ELEMENT_SCN_MODES FW_ELEMENT_SCN_PATH FW_ELEMENT_SCN_PATH_TEXT FW_ELEMENT_SCN_REQUIRED_APP FW_ELEMENT_SCN_REQUIRED_DEP FW_ELEMENT_SCN_REQUIRED_PAR FW_ELEMENT_SCN_REQUIRED_TSK FW_ELEMENT_SCN_REQUIRED_FILE FW_ELEMENT_SCN_REQUIRED_FILELIST FW_ELEMENT_SCN_REQUIRED_DIR FW_ELEMENT_SCN_REQUIRED_DIRLIST"
    FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_SCN_STATUS FW_ELEMENT_SIT_STATUS_COMMENTS"
fi

FW_TABLES_COL1["scenario"]=Scenario
FW_TABLES_EXTRAS["scenario"]="Or S T D B U"
FW_TAGS_ELEMENTS["Scenarios"]="element representing scenarios"


function Scenarios() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_ELEMENT_SCN_LONG[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_SCN_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (%s): %s, %s, %s, %s\n" "${id}" "${FW_ELEMENT_SCN_STATUS[${id}]}" "${FW_ELEMENT_SCN_ORIG[${id}]}" "${FW_ELEMENT_SCN_MODES[${id}]}" "${FW_ELEMENT_SCN_PATH[${id}]}" "${FW_ELEMENT_SCN_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
