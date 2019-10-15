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
## Repeat - action to repeat something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Repeat() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno i count number wait arguments="" width lineLength char format string
    # doExtras time tsStart tsEnd execTime runtime bcalc
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        application | scenario | task | print)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in
                application-execution)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    number="${1}"; wait="${2}"; id="${3}"; shift 3
                    case ${number} in '' | *[!0-9.]* | '.' | *.*.*) Report process error "${FUNCNAME[0]}" "${cmdString2}" E829 repeat repetitions "${number}"; return ;; esac
                    case ${wait}   in '' | *[!0-9.]* | '.' | *.*.*) Report process error "${FUNCNAME[0]}" "${cmdString2}" E829 repeat wait "${wait}"; return ;; esac
                    Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi ;;

                scenario-execution | task-execution)
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    number="${1}"; wait="${2}"; id="${3}"; shift 3; arguments="${@}"
                    case ${number} in '' | *[!0-9.]* | '.' | *.*.*) Report process error "${FUNCNAME[0]}" "${cmdString2}" E829 repeat repetitions "${number}"; return ;; esac
                    case ${wait}   in '' | *[!0-9.]* | '.' | *.*.*) Report process error "${FUNCNAME[0]}" "${cmdString2}" E829 repeat wait "${wait}"; return ;; esac
                    Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Deactivate show execution2

                    width=$(( $(tput cols) - 2 ))
                    lineLength=$(( 1 + 4 + ${#FW_OBJECT_TIM_VAL["repeatSepLeftChar"]} + ${#FW_OBJECT_TIM_VAL["repeatSepRightChar"]} + ${#cmd1} + ${#number} + ${#FW_OBJECT_TIM_VAL["repeatTextSepStr"]} + ${#id} + ${#arguments} + 11 ))
                    for (( count=1; count <= number; count++ )); do
                        printf "\n"
                        case ${cmd1} in
                            task)       Format ansi start "${FW_OBJECT_TIM_VAL["repeatTskBgrndFmt"]}" ;;
                            scenario)   Format ansi start "${FW_OBJECT_TIM_VAL["repeatScnBgrndFmt"]}" ;;
                        esac
                        Format themed text repeatLineFmt " "
                        Repeat print formatted character 4 "${FW_OBJECT_TIM_VAL["repeatLineChar"]}" repeatLineFmt
                        Format themed text repeatSepLeftFmt "${FW_OBJECT_TIM_VAL["repeatSepLeftChar"]}"
                        Format themed text repeatTextFmt " ${cmd1} run ${count} of ${number}${FW_OBJECT_TIM_VAL["repeatTextSepStr"]}"
                        Format themed text repeatCmdFmt "${id} ${arguments}"
                        Format themed text repeatTextFmt " "
                        Format themed text repeatSepRightFmt "${FW_OBJECT_TIM_VAL["repeatSepRightChar"]}"
                        Repeat print formatted character $(( width - lineLength - ${#count} )) "${FW_OBJECT_TIM_VAL["repeatLineChar"]}" repeatLineFmt
                        Format themed text repeatLineFmt " "
                        Format ansi end
                        printf "\n\n"
                        Execute ${cmd1} ${id} ${arguments}
                        sleep ${wait}
                        printf "\n"
                    done
                    Activate show execution2 ;;

                print-character)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    count="${1}"; char="${2}"; string=""
                    for (( i=1; i <= count; i++ )); do string+="${char}"; done
                    printf "%s" "${string}" ;;

                print-formatted)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        print-formatted-character)
                            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 3 "$#"; return; fi
                            count="${1}"; char="${2}"; format="${3}"; string=""
                            for (( i=1; i <= count; i++ )); do string+="${char}"; done
                            Format themed text ${format} "${string}" ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
