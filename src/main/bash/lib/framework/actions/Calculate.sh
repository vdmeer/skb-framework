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
## Calculate - action to calculate something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["calculate"]="action to calculate something"


function Calculate() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local arr keys longest current argCount new short
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        longest)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                longest-clioption)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    arr="${1}"; IFS=" " read -a keys <<< "${arr}"; longest=0
                    for id in "${keys[@]}"; do
                        if (( longest < ${FW_INSTANCE_CLI_LEN[${id}]} )); then longest=${FW_INSTANCE_CLI_LEN[${id}]}; fi
                    done
                    printf ${longest} ;;
                longest-option)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    arr="${1}"; IFS=" " read -a keys <<< "${arr}"; longest=0
                    for id in "${keys[@]}"; do
                        if (( longest < ${FW_ELEMENT_OPT_LEN[${id}]} )); then longest=${FW_ELEMENT_OPT_LEN[${id}]}; fi
                    done
                    printf ${longest} ;;
                longest-string)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    arr="${1}"; IFS=" " read -a keys <<< "${arr}"; longest=0
                    for id in ${keys[*]}; do
                        if (( longest < ${#id} )); then longest=${#id}; fi
                    done
                    printf ${longest} ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
