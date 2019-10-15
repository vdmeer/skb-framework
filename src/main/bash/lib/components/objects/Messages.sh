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
## Messages - data object representing the framework's messages
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Messages() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id printString="" keys
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in
        has)
            echo " ${!FW_OBJECT_MSG_LONG[@]} " ;;
        list)
            if [[ "${FW_OBJECT_MSG_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_OBJECT_MSG_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (dec: %s / %s)\n"                    "${id}" "${FW_OBJECT_MSG_DECMDS[${id}]}" "${FW_OBJECT_MSG_DECPHA[${id}]}"
                    printf "        a/type/cat: %s, %s, %s\n"           "${FW_OBJECT_MSG_ARGS[${id}]}" "${FW_OBJECT_MSG_TYPE[${id}]}" "${FW_OBJECT_MSG_CAT[${id}]}"
                    printf "        text:       '%s'\n"                 "${FW_OBJECT_MSG_TEXT[${id}]}"
                    printf "        descr:      %s\n\n"                 "${FW_OBJECT_MSG_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
