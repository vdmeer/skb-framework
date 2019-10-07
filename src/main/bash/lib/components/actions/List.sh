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
## List - action to list something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##





function List() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local keys id category format longest showValues="" arr command dir
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        logs)
            dir="${FW_OBJECT_SET_VAL["LOG_DIR"]}"
            if [[ -d "${dir}" ]]; then printf "\nLog directory: ${dir}\n\n$(ls -l "${dir}")\n"; else Report process error "${FUNCNAME[0]}" "${cmd1}" E852 "${dir}"; fi ;;

        exitcodes | \
        clioptions | configurations | formats | levels | messages | modes | phases | settings | themes | themeitems | tasks | \
        applications | dependencies | dirlists | dirs | filelists | files | modules | options | parameters | projects | scenarios | sites | tasks | \
        actions | elements | instances | objects )
            case "${1:-}" in
                "show-values")  showValues="show-values" ;;
            esac
            case ${cmd1} in
                actions | elements | instances | objects)
                    arr="$(Framework has ${cmd1})" ;;
                *)
                    arr="$(${cmd1^} has)" ;;
            esac
            printf "\n  "
            Format themed text listHeadFmt "${FW_COMPONENTS_TITLE_LONG_PLURAL["${cmd1}"]}"
            printf "\n"
            Print ${FW_COMPONENTS_SINGULAR["${cmd1}"]} list "${arr}" ${showValues} ;;


        framework | categorized)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in
                framework-cache)
                    dir="${FW_OBJECT_SET_VAL["LOG_DIR"]}"
                    if [[ -d "${dir}" ]]; then printf "\n"Log directory: ${dir}"\n\n$(ls -l "${dir}")\n"; else Report process error "${FUNCNAME[0]}" "${cmdString2}" E852 "${dir}"; fi ;;

                categorized-clioptions | categorized-options)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi
                    for category in $@; do
                        printf "\n"
                        if [[ "${format}" == "mdoc" ]]; then printf "#tag::%s[]\n" "${category}"; fi
                        printf "  "; Format themed text listCatFmt "${category//+/ }"
                        printf "\n"
                        Print ${cmd2::-1} list "$(Filter ${cmd2} ${category})"
                        if [[ "${format}" == "mdoc" ]]; then printf "#end::%s[]\n" "${category}"; fi
                    done ;;

                categorized-messages)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    for category in $@; do
                        printf "\n  "
                        Format themed text listCatFmt "${category//+/ }"
                        printf "\n"
                        Print message list "$(Filter messages ${category})"
                    done ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
