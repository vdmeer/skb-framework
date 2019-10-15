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
## Options - element representing options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Options() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id shortId printString="" retval category keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in

        has)    echo " ${!FW_ELEMENT_OPT_LONG[@]} " ;;
        shorts) echo " ${!FW_ELEMENT_OPT_SHORT[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_OPT_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    %s (len: %s, short: %s)\n"              "${id}" "${FW_ELEMENT_OPT_LEN[${id}]}" "${FW_ELEMENT_OPT_LS[${id}]}"
                    printf "        arg:        %s\n"                   "${FW_ELEMENT_OPT_ARG[${id}]}"
                    printf "        sort:       %s\n"                   "${FW_ELEMENT_OPT_SORT[${id}]}"
                    printf "        cat:        %s\n"                   "${FW_ELEMENT_OPT_CAT[${id}]}"
                    printf "        set:        %s\n"                   "${FW_ELEMENT_OPT_SET[${id}]}"
                    printf "        value:      %s\n"                   "${FW_ELEMENT_OPT_VAL[${id}]}"
                    printf "        descr:      %s\n\n"                 "${FW_ELEMENT_OPT_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        long | short)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                long-string)
                    retval="${!FW_ELEMENT_OPT_LONG[@]}"
                    for id in ${!FW_ELEMENT_OPT_ARG[@]}; do
                        if [[ -n "${FW_ELEMENT_OPT_ARG[${id}]:-}" ]]; then retval=${retval/"${id}"/"${id}:"}; fi
                    done
                    retval=${retval//" "/","}
                    printf "${retval}" ;;

                short-string)
                    retval="${!FW_ELEMENT_OPT_SHORT[@]}"
                    for id in ${!FW_ELEMENT_OPT_ARG[@]}; do
                        if [[ -n "${FW_ELEMENT_OPT_ARG[${id}]:-}" ]]; then shortId=${FW_ELEMENT_OPT_LS[${id}]}; retval=${retval//"${shortId}"/"${shortId}:"}; fi
                    done
                    retval=${retval//" "/""}
                    printf "${retval}" ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
