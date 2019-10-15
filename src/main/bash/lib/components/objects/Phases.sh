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
## Phases - data object representing the framework's phases
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Phases() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id keys numberArr
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_PHA_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_PHA_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_PHA_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    IFS=" " read -a numberArr <<< "${FW_OBJECT_PHA_MSGCOD[${id}]}"; unset IFS
                    printf "    %s (dec: %s / %s)\n"                    "${id}" "${FW_OBJECT_PHA_DECMDS[${id}]}" "${FW_OBJECT_PHA_DECPHA[${id}]}"
                    printf "        #e/w/m:     %s, %s, %s\n"           "${FW_OBJECT_PHA_ERRCNT[${id}]}" "${FW_OBJECT_PHA_WRNCNT[${id}]}" "${#numberArr[@]}"
                    printf "        msg-codes:  %s\n"                   "${FW_OBJECT_PHA_MSGCOD[${id}]}"
                    printf "        print:      %s\n"                   "${FW_OBJECT_PHA_PRT_LVL[${id}]}"
                    printf "        log:        %s\n"                   "${FW_OBJECT_PHA_LOG_LVL[${id}]}"
                    printf "        descr:      %s\n\n"                 "${FW_OBJECT_PHA_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
