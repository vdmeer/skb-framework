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
## Modules - element representing modules
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_ELEMENT_MDS_LONG[*]}" == "" ]]; then
    declare -A FW_ELEMENT_MDS_LONG      ## [long]="description"
    declare -A FW_ELEMENT_MDS_ACR       ## [long]=acronym
    declare -A FW_ELEMENT_MDS_PATH      ## [long]=path
    declare -A FW_ELEMENT_MDS_PHA       ## [long]="phase that did set the value"

    declare -A FW_ELEMENT_MDS_REQUIRED_MODULES  ## [long]="depends on other modules, normal list"

    declare -A FW_ELEMENT_MDS_STATUS            ## [long]="N|E|W|S" - Not-attempted, Error, Warning, Success
    declare -A FW_ELEMENT_MDS_STATUS_COMMENTS   ## [long]="comments on the status, mainly for debug"
    declare -A FW_ELEMENT_MDS_REQUESTED         ## [long]=" is requested, yes | no "

    declare -A FW_ELEMENT_MDS_KNOWN             ## [ID]="map of known/found modules"
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_SLOW+=" FW_ELEMENT_MDS_LONG FW_ELEMENT_MDS_ACR FW_ELEMENT_MDS_PHA FW_ELEMENT_MDS_PATH FW_ELEMENT_MDS_REQUIRED_MODULES"
    FW_RUNTIME_MAPS_MEDIUM+=" FW_ELEMENT_MDS_STATUS FW_ELEMENT_MDS_STATUS_COMMENTS FW_ELEMENT_MDS_REQUESTED"
fi

FW_COMPONENTS_SINGULAR["modules"]="module"
FW_COMPONENTS_PLURAL["modules"]="modules"
FW_COMPONENTS_TITLE_LONG_SINGULAR["modules"]="Module"
FW_COMPONENTS_TITLE_LONG_PLURAL["modules"]="Modules"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["modules"]="Module"
FW_COMPONENTS_TITLE_SHORT_PLURAL["modules"]="Modules"
FW_COMPONENTS_TABLE_DESCR["modules"]="Description"
FW_COMPONENTS_TABLE_VALUE["modules"]="Path to Module"
#FW_COMPONENTS_TABLE_DEFVAL["modules"]=""
FW_COMPONENTS_TABLE_EXTRA["modules"]="SH P"
FW_COMPONENTS_TAGLINE["modules"]="element representing modules"


function Modules() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id printString="" errno keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        knows)
            echo " ${!FW_ELEMENT_MDS_KNOWN[@]} " ;;
        search)
            local path="$(Get module path)" dir modFile modId
            unset -v FW_ELEMENT_MDS_KNOWN
            declare -A -g FW_ELEMENT_MDS_KNOWN
            for dir in ${path}; do
                Test dir exists "${dir}"; errno=$?; if [[ "${errno}" != 0 ]]; then continue; fi
                Test dir can read "${dir}"; errno=$?; if [[ "${errno}" != 0 ]]; then continue; fi
                for modFile in ${dir}/**/*.module; do
                    if [[ "${modFile}" == "${dir}/**/*.module" ]]; then continue; fi
                    modId=${modFile##*/}; modId=${modId%.*}
                    FW_ELEMENT_MDS_KNOWN["${modId}"]="${modFile}"
                done
            done ;;

        has)
            echo " ${!FW_ELEMENT_MDS_LONG[@]} " ;;

        list)
            if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_MDS_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (%s, %s): %s, {%s}, %s\n" "${id}" "${FW_ELEMENT_MDS_ACR[${id}]}" "${FW_ELEMENT_MDS_PHA[${id}]}" "${FW_ELEMENT_MDS_PATH[${id}]}" "${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]:-}" "${FW_ELEMENT_MDS_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
