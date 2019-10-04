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


if [[ "${FW_ELEMENT_OPT_LONG[*]}" == "" ]]; then
    declare -A FW_ELEMENT_OPT_LONG      ## [long]="description"
    declare -A FW_ELEMENT_OPT_SHORT     ## [short]=long
    declare -A FW_ELEMENT_OPT_LS        ## [long]=short
    declare -A FW_ELEMENT_OPT_ARG       ## [long]="argument"
    declare -A FW_ELEMENT_OPT_CAT       ## [long]="category+name"
    declare -A FW_ELEMENT_OPT_LEN       ## [long]="length: long + arg" + 5 for short/long dashes and short and blank, plus 1 if arg is set
    declare -A FW_ELEMENT_OPT_SET       ## [long]="yes if option was set, no otherwise"
    declare -A FW_ELEMENT_OPT_VAL       ## [long]="parsed value"
               FW_ELEMENT_OPT_EXTRA=""  ## string with extra arguments parsed
fi

if [[ -n "${FW_INIT:-}" ]]; then
    FW_RUNTIME_MAPS_LOAD+=" FW_ELEMENT_OPT_LONG FW_ELEMENT_OPT_SHORT FW_ELEMENT_OPT_LS FW_ELEMENT_OPT_ARG FW_ELEMENT_OPT_CAT FW_ELEMENT_OPT_LEN FW_ELEMENT_OPT_SET FW_ELEMENT_OPT_VAL FW_ELEMENT_OPT_EXTRA"
fi

FW_COMPONENTS_SINGULAR["options"]="option"
FW_COMPONENTS_PLURAL["options"]="options"
FW_COMPONENTS_TITLE_LONG_SINGULAR["options"]="Option"
FW_COMPONENTS_TITLE_LONG_PLURAL["options"]="Options"
FW_COMPONENTS_TITLE_SHORT_SINGULAR["options"]="Option"
FW_COMPONENTS_TITLE_SHORT_PLURAL["options"]="Options"
FW_COMPONENTS_TABLE_DESCR["options"]="Description"
FW_COMPONENTS_TABLE_VALUE["options"]="Value from Command Line"
#FW_COMPONENTS_TABLE_DEFVAL["options"]=""
FW_COMPONENTS_TABLE_EXTRA["options"]="Type"
FW_COMPONENTS_TAGLINE["options"]="element representing options"


function Options() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id shortId printString="" retval category keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in

        has)    echo " ${!FW_ELEMENT_OPT_LONG[@]} " ;;
        shorts) echo " ${!FW_ELEMENT_OPT_SHORT[@]} " ;;
        list)
            if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_ELEMENT_OPT_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    -%s --%s [%s]: %s, %s, %s\n" "${FW_ELEMENT_OPT_LS[${id}]}" "${id}" "${FW_ELEMENT_OPT_ARG[${id}]}" "${FW_ELEMENT_OPT_CAT[${id}]}" "${FW_ELEMENT_OPT_VAL[${id}]}" "${FW_ELEMENT_OPT_LONG[${id}]}"
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
