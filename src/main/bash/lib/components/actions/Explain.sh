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
## Explain - action to explain actions, elements, instances, and objects
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Explain() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id cmd componentID arr keys
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        action | element | instance | object | component)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            componentID="${1}"; Test existing ${cmd1} id "${componentID}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Operations"; printf "\n\n"
            IFS=" " read -a keys <<< "$(Filter operations ${componentID})"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
            for id in "${keys[@]}"; do
                Format tagline for operation "${id}" describe ${#FW_OBJECT_TIM_VAL["explainIndent2"]} 1 ""; printf "\n"
                Format help indentation 3; Format themed text explainTextFmt "${FW_API[${id}]}"
                printf "\n"
            done ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
