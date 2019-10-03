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
## Execute - command to execute something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_TAGS_COMMANDS["Execute"]="command to execute something"

function Execute() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local id errno i doExtras width time tsStart tsEnd execTime runtime bcalc text arg count length line bgrnd=false tmpPhase tmpAppname2 padding lineLength char
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        application)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            Test existing ${cmd1} id ${1}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            id="${1}"; bgrnd="${2}"; shift 2

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

        scenario | task)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; shift 1
            Test existing ${cmd1} id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            tmpPhase="$(Get current phase)"

            case ${cmd1} in
                scenario)
                    case ${FW_ELEMENT_SCN_MODES[${id}]} in
                        all | ${FW_OBJECT_SET_VAL["CURRENT_MODE"]}) ;;
                        *) Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 ${cmd1} "${id}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"; return ;;
                    esac
                    case "${FW_ELEMENT_SCN_STATUS[${id}]}" in
                        N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E853 ${cmd1} "${id}"; return ;;
                        E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 ${cmd1} "${id}"; return ;;
                        W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 ${cmd1} "${id}"; return ;;
                    esac
                    case "${FW_OBJECT_PHA_PRT_LVL["Scenario"]}" in *" message "*) doExtras=true;; *) doExtras=false;; esac
                    if [[ "${FW_EXEC_SCENARIO_DOEXTRAS:-yes}" == no ]]; then doExtras=false; fi ;;
                task)
                    case ${FW_ELEMENT_TSK_MODES[${id}]} in
                        all | ${FW_OBJECT_SET_VAL["CURRENT_MODE"]}) ;;
                        *) Report application error "${FUNCNAME[0]}" "${cmdString1}" E856 ${cmd1} "${id}" "${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"; return ;;
                    esac
                    case "${FW_ELEMENT_TSK_STATUS[${id}]}" in
                        N)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E853 ${cmd1} "${id}"; return ;;
                        E)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E854 ${cmd1} "${id}"; return ;;
                        W)  Report application error "${FUNCNAME[0]}" "${cmdString1}" E855 ${cmd1} "${id}"; return ;;
                    esac
                    case "${FW_OBJECT_PHA_PRT_LVL["Task"]}" in *" message "*) doExtras=true;; *) doExtras=false;; esac
                    case "${id}" in
                        debug-* | describe-* | list-*) doExtras=false ;;
                        *)                             doExtras=true ;;
                    esac
                    if [[ "${tmpPhase}" == "Project" || "${tmpPhase}" == "Scenario" || "${tmpPhase}" == "Site" ]]; then doExtras=false; fi
                    case "${@}" in *"-h"* | *"--help"* | *"-D"* | *"--describe"* ) doExtras=false; ;; esac
                    if [[ "${FW_EXEC_TASK_DOEXTRAS:-yes}" == no ]]; then doExtras=false; fi ;;
            esac

            width=$(( $(tput cols) - 2 ))
            if [[ ${doExtras} == true ]]; then
                printf "\n"
                Format themed text execLineFmt " "
                char="$(Format themed text execLineFmt "${FW_OBJECT_TIM_VAL["execLineChar"]}")"
                for (( i=1; i <= width; i++ )); do printf "%s" "${char}"; done
                Format themed text execLineFmt " "
                printf "\n"
                Format themed text execStartNameFmt "  ${id} "
                time=$(date +"%T")
                Format themed text execStartTimeFmt " ${time} "
                Format themed text execStartTextFmt " executing ${cmd1}"
                lineLength=$(( 5 + ${#id} + ${#time} + 9 + ${#cmd1} ))
                padding=$(( width - lineLength ))
                char="$(Format themed text execStartTextFmt " ")"
                for (( i=1; i <= padding; i++ )); do printf "%s" "${char}"; done
                printf "\n\n"
            fi

            tmpAppname2="${FW_OBJECT_SET_VAL["APP_NAME2"]}"
            Prepare ${cmd1} execution "${id}"
            tsStart=$(date +%s.%N)
            case ${cmd1} in
                scenario)
                    count=0; length=""; errno=0
                    while IFS='' read -r line || [[ -n "${line}" ]]; do
                        length=${#line}
                        if [[ "${line:0:1}" != "#" ]] && (( length > 1 )); then
                            case "$line" in
                                "Execute application "*)    $line ;;
                                *)                          Execute task $line ;;
                            esac
                            if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then break; fi
                        fi
                        count=$(( count + 1 ))
                    done < "${FW_ELEMENT_SCN_PATH[${id}]}/${id}.scn" ;;
                task)
                    ${FW_ELEMENT_TSK_PATH[${id}]}/${id}.sh ${@}
                    errno=$? ;;
            esac
            tsEnd=$(date +%s.%N)
            Finalize ${cmd1} execution "${id}" "${tmpPhase}" "${tmpAppname2}"
            if [[ "${errno}" != 0 ]]; then
                Report application error E827 ${cmd1} "${id}"
                if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" == "Scenario" ]]; then return; fi
            fi

            if [[ ${doExtras} == true ]]; then
                time=$(date +"%T")
                execTime=$(echo "scale=0;(${tsEnd}-${tsStart})/1" | bc -l)
                if (( execTime == 0 )); then
                    bcalc=$(echo "scale=4;(${tsEnd}-${tsStart})/1" | bc -l)
                    runtime=$(printf "0%s seconds\n" "$bcalc")
                elif (( execTime < 60 )); then
                    bcalc=$(echo "scale=4;(${tsEnd}-${tsStart})/1" | bc -l)
                    runtime=$(printf "%s seconds\n" "$bcalc")
                else
                    local bcalc=$(echo "scale=2;(${tsEnd}-${tsStart})/60" | bc -l)
                    runtime=$(printf "%s minutes\n" "$bcalc")
                fi

                printf "\n\n"
                errno="${FW_OBJECT_PHA_ERRCNT[${cmd1^}]}"
                Format themed text execEndDoneFmt "  done "
                Format themed text execEndTimeFmt " ${time} (${runtime}) "
                Format themed text execEndStatusFmt " status: ${errno} - "
                if (( ${errno} == 0 )); then
                    Format themed text execEndSuccessFmt "success "
                    lineLength=7
                else
                    Format themed text execEndErrorFmt "error "
                    lineLength=5
                fi
                lineLength=$(( lineLength + 23 + ${#time} + ${#runtime} + ${#errno} ))
                padding=$(( width - lineLength ))
                char="$(Format themed text execEndDoneFmt " ")"
                for (( i=1; i <= padding; i++ )); do printf "%s" "${char}"; done
                printf "\n"
                Format themed text execLineFmt " "
                char="$(Format themed text execLineFmt "${FW_OBJECT_TIM_VAL["execLineChar"]}")"
                for (( i=1; i <= width; i++ )); do printf "%s" "${char}"; done
                Format themed text execLineFmt " "
                printf "\n"
            fi ;;

        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
