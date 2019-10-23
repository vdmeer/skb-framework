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
## Ask - action to ask something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Ask() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno mode
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        has | log | print | project | task | scenario)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                has-warnings?)  if (( ${FW_OBJECT_SET_VAL["WARNING_COUNT"]} > 0 )); then printf yes; else printf no; fi ;;
                has-errors?)    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 ));   then printf yes; else printf no; fi ;;

                print-level?)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"; Test existing level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case ${FW_OBJECT_SET_VAL["PRINT_LEVEL"]} in *" ${id} "*) printf yes ;; *) printf no ;; esac ;;
                log-level?)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"; Test existing level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case ${FW_OBJECT_SET_VAL["LOG_LEVEL"]} in *" ${id} "*)   printf yes ;; *) printf no ;; esac ;;

                project-in | task-in | scenario-in | script-in)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        project-in-mode?)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            id="${1}"; mode="${2:-${FW_OBJECT_SET_VAL["CURRENT_MODE"]}}"
                            if [[ "${mode}" == "test" ]]; then
                                printf "yes"
                            else
                                case "${FW_ELEMENT_PRJ_MODES[${id}]}" in
                                    *"${mode}"*)    printf "yes" ;;
                                    *)              printf "no" ;;
                                esac
                            fi;;

                        task-in-mode?)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            id="${1}"; mode="${2:-${FW_OBJECT_SET_VAL["CURRENT_MODE"]}}"
                            if [[ "${mode}" == "test" ]]; then
                                 printf "yes"
                            else
                                case "${FW_ELEMENT_TSK_MODES[${id}]}" in
                                    *"${mode}"*)    printf "yes" ;;
                                    *)              printf "no" ;;
                                esac
                            fi ;;

                        scenario-in-mode?)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            id="${1}"; mode="${2:-${FW_OBJECT_SET_VAL["CURRENT_MODE"]}}"
                            if [[ "${mode}" == "test" ]]; then
                                 printf "yes"
                            else
                                case "${FW_ELEMENT_SCN_MODES[${id}]}" in
                                    *"${mode}"*)    printf "yes" ;;
                                    *)              printf "no" ;;
                                esac
                            fi ;;

                        script-in-mode?)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            id="${1}"; mode="${2:-${FW_OBJECT_SET_VAL["CURRENT_MODE"]}}"
                            if [[ "${mode}" == "test" ]]; then
                                 printf "yes"
                            else
                                case "${FW_ELEMENT_SCR_MODES[${id}]}" in
                                    *"${mode}"*)    printf "yes" ;;
                                    *)              printf "no" ;;
                                esac
                            fi ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
