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
## Execute - action to execute something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Execute() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id errno bgrnd text arg showExecution thisPhase thisAppname tsStart tsEnd count length line
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        application)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            id="${1}"; Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            bgrnd="${2}"; shift 2

            case "${FW_ELEMENT_APP_STATUS[${id}]}" in
                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E853 application "${id}"; return ;;
                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 application "${id}"; return ;;
                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 application "${id}"; return ;;
            esac

            if [[ "${#}" -lt "${FW_ELEMENT_APP_ARGNUM[${id}]}" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 ${FW_ELEMENT_APP_ARGNUM[${id}]} "$#"; return; fi
            text="${FW_ELEMENT_APP_ARGS[${id}]}"; count=1
            for arg in "$@"; do text=${text/"##ARG$((count++))##"/"${arg}"}; done
            if [[ "${bgrnd}" == "yes" ]]; then 
                ${FW_ELEMENT_APP_COMMAND[${id}]} ${text} >& /dev/null &
            else
                ${FW_ELEMENT_APP_COMMAND[${id}]} ${text} >& /dev/null
            fi ;;

        project)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            ;;

        script)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            ;;

        site)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            ;;

        scenario)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" == "test" ]]; then
                : # always available in test mode
            else
                case "${FW_ELEMENT_SCN_MODES[${id}]}" in
                    *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
                    *) Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 ${cmd1} "${id}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"; return ;;
                esac
            fi

            case "${FW_ELEMENT_SCN_STATUS[${id}]}" in
                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E853 ${cmd1} "${id}"; return ;;
                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 ${cmd1} "${id}"; return ;;
                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 ${cmd1} "${id}"; return ;;
            esac

            case "${@}" in
                -D | --describe)    printf "\n"; Describe scenario ${id}; return ;;
                "")                 ;;
                *)                  Report process error "${FUNCNAME[0]}" "${cmdString1}" E804 "scenario argument" "${@}"; return ;;
            esac

            showExecution="${FW_OBJECT_SET_VAL["SHOW_EXECUTION2"]}"
            if [[ "${showExecution}" == "on" ]]; then showExecution="${FW_OBJECT_SET_VAL["SHOW_EXECUTION"]}"; fi
            if [[ "${FW_ELEMENT_SCN_SHOW_EXEC[${id}]}" == "n" ]]; then showExecution="off"; fi

            if [[ "${showExecution}" == "on" ]]; then Show ${cmd1} execution start "${id}"; fi
            thisPhase="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            thisAppname="${FW_OBJECT_SET_VAL["APP_NAME2"]}"
            Prepare ${cmd1} execution "${id}"
            if [[ "${showExecution}" == "on" ]]; then tsStart="$(date +%s.%N)"; fi

            count=0; length=""; errno=0
            while IFS='' read -r line || [[ -n "${line}" ]]; do
                length=${#line}
                if [[ "${line:0:1}" != "#" ]] && (( length > 1 )); then
                    case "$line" in
                        "Execute application "*)    ${line} ;;
                        "Execute scenario "*)       ${line} ;;
                        "wait "*)                   line=${line//wait/sleep}; ${line} ;;
                        *)                          Execute task ${line}
                                                    if [[ "${FW_OBJECT_PHA_ERRCNT["Task"]}" > 0 ]]; then
                                                        Report application error E827 "task: ${line}"
                                                        FW_OBJECT_PHA_ERRCNT["Scenario"]="${FW_OBJECT_SET_VAL["ERROR_COUNT"]}"
                                                        break
                                                    fi ;;
                    esac
                fi
                count=$(( count + 1 ))
            done < "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.scn"

            if [[ "${showExecution}" == "on" ]]; then tsEnd="$(date +%s.%N)"; fi
            Finalize ${cmd1} execution "${id}" "${thisPhase}" "${thisAppname}"
            if [[ "${showExecution}" == "on" ]]; then Show ${cmd1} execution end "${id}" "${tsStart}" "${tsEnd}"; fi ;;

        task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

            if [[ "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}" == "test" ]]; then
                : # always available in test mode
            else
                case "${FW_ELEMENT_TSK_MODES[${id}]}" in
                    *"${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"*) ;;
                    *) Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 ${cmd1} "${id}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"; return ;;
                esac
            fi

            case "${FW_ELEMENT_TSK_STATUS[${id}]}" in
                N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E853 ${cmd1} "${id}"; return ;;
                E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 ${cmd1} "${id}"; return ;;
                W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 ${cmd1} "${id}"; return ;;
             esac

            showExecution="${FW_OBJECT_SET_VAL["SHOW_EXECUTION2"]}"
            if [[ "${showExecution}" == "on" ]]; then showExecution="${FW_OBJECT_SET_VAL["SHOW_EXECUTION"]}"; fi
            case "${@}" in *"-h"* | *"--help"* | *"-D"* | *"--describe"* ) showExecution="off" ;; esac
            if [[ "${FW_ELEMENT_TSK_SHOW_EXEC[${id}]}" == "n" ]]; then showExecution="off"; fi

            if [[ "${showExecution}" == "on" ]]; then Show ${cmd1} execution start "${id}"; fi
            thisPhase="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            thisAppname="${FW_OBJECT_SET_VAL["APP_NAME2"]}"
            Prepare ${cmd1} execution "${id}"
            if [[ "${showExecution}" == "on" ]]; then tsStart="$(date +%s.%N)"; fi

            ${FW_ELEMENT_TSK_PATH[${id}]}/${id}.sh ${@}; errno=$?
            if [[ "${errno}" != 0 ]]; then FW_OBJECT_PHA_ERRCNT["Task"]=$(( ${FW_OBJECT_PHA_ERRCNT["Task"]} + errno)); fi
            if [[ "${FW_OBJECT_PHA_ERRCNT["Task"]}" > 0 ]]; then Report application error E827 ${cmd1}; fi

            if [[ "${showExecution}" == "on" ]]; then tsEnd="$(date +%s.%N)"; fi
            Finalize ${cmd1} execution "${id}" "${thisPhase}" "${thisAppname}"
            if [[ "${showExecution}" == "on" ]]; then Show ${cmd1} execution end "${id}" "${tsStart}" "${tsEnd}"; fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
