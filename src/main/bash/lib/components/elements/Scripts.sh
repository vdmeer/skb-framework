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
## Scripts - element representing scripts
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Scripts() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id printString="" keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_ELEMENT_SCR_LONG[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_SCR_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_SCR_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
#                    printf "    %s (dec: %s / %s, set: %s)\n" "${id}" "${FW_ELEMENT_APP_DECMDS[${id}]}" "${FW_ELEMENT_APP_DECPHA[${id}]}" "${FW_ELEMENT_APP_PHA[${id}]}"
#                    printf "        status:     s: %s, c: %s, r: %s\n" "${FW_ELEMENT_APP_STATUS[${id}]}" "${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}" "${FW_ELEMENT_APP_REQUESTED[${id}]}"
#                    printf "        print:      %s\n" "${FW_OBJECT_PHA_PRT_LVL[${id}]}"
#                    printf "        log:        %s\n" "${FW_OBJECT_PHA_LOG_LVL[${id}]}"
#                    printf "        path:       %s\n" "${FW_OBJECT_PHA_PATH[${id}]}"
#                    printf "        descr:      %s\n\n" "${FW_OBJECT_PHA_LONG[${id}]}"


                    printf "    %s: %s, %s, %s, %s\n" "${id}" "${FW_ELEMENT_SCR_DECMDS[${id}]}" "${FW_ELEMENT_SCR_PATH[${id}]}" "${FW_ELEMENT_SCR_SHOW_EXEC[${id}]}" "${FW_ELEMENT_SCR_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
