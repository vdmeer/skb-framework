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


function Modules() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno keys numberArr
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        knows)
            echo " ${!FW_ELEMENT_MDS_KNOWN[@]} " ;;

        search)
            local path="$(Get primary module path) $(Get module path)" dir modFile modId
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
                    printf "    %s (acr: %s, dec: %s)\n"                "${id}" "${FW_ELEMENT_MDS_ACR[${id}]}" "${FW_ELEMENT_MDS_DECPHA[${id}]}"
                    printf "        status:     s: %s, c: %s\n"         "${FW_ELEMENT_MDS_STATUS[${id}]}" "${FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]}" "${[${id}]}"

                    IFS=" " read -a numberArr <<< "${FW_ELEMENT_MDS_REQUESTED[${id}]}"; unset IFS
                    printf "        #req-in:    %s\n"                   "${#numberArr[@]}"
                    printf "        req-in:     %s\n"                   "${FW_ELEMENT_MDS_REQUESTED[${id}]}"
                    printf "        #req-out:   %s\n"                   "${FW_ELEMENT_MDS_REQOUT_NUM[${id}]}"
                    printf "        req-mod:    %s\n"                   "${FW_ELEMENT_MDS_REQUIRED_MDS[${id}]:-none}"
                    printf "        path:       %s\n"                   "${FW_ELEMENT_MDS_PATH[${id}]}"
                    printf "        descr:      %s\n\n"                 "${FW_ELEMENT_MDS_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
