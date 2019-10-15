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
## Test - action to test something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Test() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id shortId value valueText program functionName="${FUNCNAME[1]:-$FUNCNAME[0]}" errno char fsRetVal=0
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        command)
            if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 3 "$#"; return; fi
            program="${1}"; value="${2}"; valueText="${3}"
            if [[ "${program:0:1}" == "/" ]]; then
                if [[ ! -n "$($program)" ]]; then Report application error "${functionName}" "${cmd1}" E886 "${program}" "${value}" "${valueText}"; return 1; fi
            else
                if [[ ! -x "$(command -v ${program})" ]]; then Report application error "${functionName}" "${cmd1}" E886 "${program}" "${value}" "${valueText}"; return 1; fi
            fi ;;

        integer)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            value="${1}"; if [[ "${value}" == 0 || "${value}" =~ ^[1-9][0-9]*$ ]]; then return 0; else Report application error "${functionName}" "${cmdString1}" E880 "${value}"; return 1; fi ;;

        yesno)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            value="${1}"; id="${2}"
            case "${value,,}" in
                y | yes | n | no) ;;
                *)  Report application error "${functionName}" "${cmdString1}" E835 "${id}"
                    return 1 ;;
            esac ;;

        dir | element | error | existing | file | fs | known | log | print | used | warning)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                element-status)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"
                    case "${value,,}" in
                        s | success | e | errors | error | w | warnings | warning | n | not-attempted | not-tested) ;;
                        *)  Report application error "${functionName}" "${cmdString2}" E836 "${value}"
                            return 1 ;;
                    esac ;;

                fs-mode)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; value="${2}"; errno=0
                    if [[ ${#value} -lt 5 ]]; then Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value}"; return 1; fi
                    case ${value:0:1} in
                        r | -)  ;;
                        *)      Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value:0:1}"; return 1 ;;
                    esac
                    case ${value:1:1} in
                        w | -)  ;;
                        *)      Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value:1:1}"; return 1 ;;
                    esac
                    case ${value:2:1} in
                        x | -)  ;;
                        *)      Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value:2:1}"; return 1 ;;
                    esac
                    case ${value:3:1} in
                        c | -)  ;;
                        *)      Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value:3:1}"; return 1 ;;
                    esac
                    case ${value:4:1} in
                        d | -)  ;;
                        *)      Report application error "${functionName}" "${cmdString2}" E839 "${id}" "${value:4:1}"; return 1 ;;
                    esac
                    return ${errno} ;;

                file-exists)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    value="${1}"; valueText="${2:-$value}"
                    if [[ ! -f "${value}" ]]; then Report application error "${functionName}" "${cmdString2}" E820 "file" "${valueText}"; return 1; fi ;;
                dir-exists)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    value="${1}"; valueText="${2:-$value}"
                    if [[ ! -d "${value}" ]]; then Report application error "${functionName}" "${cmdString2}" E820 "directory" "${valueText}"; return 1; fi ;;

                known-module)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; if [[ "${FW_ELEMENT_MDS_KNOWN[*]}" == "" || ! -n "${FW_ELEMENT_MDS_KNOWN[${value}]:-}" ]]; then Report application error "${functionName}" "${cmdString2}" E837 "${value}"; return 1; fi ;;

                log-format | print-format)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; if [[ ! -n "${FW_OBJECT_FMT_LONG[${value}]:-}" ]]; then Report application error "${functionName}" "${cmdString2}" E804 "${cmd1} ${cmd2}" "${value}"; return 1; fi ;;
                log-level | print-level)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; if [[ ! -n "${FW_OBJECT_LVL_LONG[${value}]:-}" ]]; then Report application error "${functionName}" "${cmdString2}" E804 "${cmd1} ${cmd2}" "${value}"; return 1; fi ;;

                existing-exitcode | \
                existing-action | existing-element | existing-instance | existing-object | existing-component | \
                existing-clioption | existing-configuration | existing-format | existing-level | existing-message | existing-mode | existing-phase | existing-setting | existing-theme | existing-themeitem | existing-variable | \
                    used-clioption | used-configuration     |     used-format |     used-level |     used-message |     used-mode |     used-phase |     used-setting |     used-theme |     used-themeitem |     used-variable | \
                existing-application | existing-dependency | existing-module | existing-option | existing-parameter | existing-project | existing-scenario | existing-script | existing-site | existing-task | \
                    used-application |     used-dependency |     used-module |                       used-parameter |     used-project |     used-scenario |     used-script |     used-site |     used-task | \
                existing-file | existing-filelist | existing-dir | existing-dirlist | \
                    used-file |     used-filelist |     used-dir |     used-dirlist | \
                file-can | dir-can)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        file-can-read)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ ! -f "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E821 "file" "${valueText}"; fsRetVal=1; fi
                            if [[ ! -r "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E821 "file" "${valueText}"; fsRetVal=1; fi
                            return ${fsRetVal} ;;
                        file-can-write)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ ! -f "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E822 "file" "${valueText}"; fsRetVal=1; fi
                            if [[ ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E822 "file" "${valueText}"; fsRetVal=1; fi
                            return ${fsRetVal} ;;
                        file-can-execute)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ ! -f "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E823 "${valueText}"; fsRetVal=1; fi
                            if [[ ! -x "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E823 "${valueText}"; fsRetVal=1; fi
                            return ${fsRetVal} ;;
                        file-can-create)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ -f "${value}" && ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E824 "file" "${valueText}"; return 1; fi
                            if [[ ! -w "${value%/*}" ]]; then Report application error "${functionName}" "${cmdString3}" E824 "file" "${valueText}"; return 1; fi ;;
                        file-can-delete)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ -f "${value}" && ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E825 "file" "${valueText}"; return 1; fi
                            if [[ ! -w "${value%/*}" ]]; then Report application error "${functionName}" "${cmdString3}" E825 "file" "${valueText}"; return 1; fi ;;
                        dir-can-read)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ ! -d "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E821 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ ! -r "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E821 "directory" "${valueText}"; fsRetVal=1; fi
                            return ${fsRetVal} ;;
                        dir-can-write)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ ! -d "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E822 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E822 "directory" "${valueText}"; fsRetVal=1; fi
                            return ${fsRetVal} ;;
                        dir-can-create)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ -f "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E824 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ -d "${value}" && ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E824 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ ${fsRetVal} == 1 ]]; then return ${fsRetVal}; fi
                            if [[ ! -w "${value%/*}" ]]; then Report application error "${functionName}" "${cmdString3}" E824 "directory" "${valueText}"; return 1; fi ;;
                        dir-can-delete)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            value="${1}"; valueText="${2:-$value}"
                            if [[ -f "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E825 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ -d "${value}" && ! -w "${value}" ]]; then Report application error "${functionName}" "${cmdString3}" E825 "directory" "${valueText}"; fsRetVal=1; fi
                            if [[ ${fsRetVal} == 1 ]]; then return ${fsRetVal}; fi
                            if [[ ! -w "${value%/*}" ]]; then Report application error "${functionName}" "${cmdString3}" E825 "directory" "${valueText}"; return 1; fi ;;


                        existing-configuration-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_CFG_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-format-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_FMT_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-level-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_LVL_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-message-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_MSG_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-mode-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_MOD_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-phase-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_PHA_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-setting-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_SET_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-theme-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_THM_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-themeitem-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_TIM_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;
                        existing-variable-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ ! -n "${FW_OBJECT_VAR_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1; fi ;;


                        existing-application-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" && -n "${FW_ELEMENT_APP_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-dependency-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" && -n "${FW_ELEMENT_DEP_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-dirlist-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" && -n "${FW_ELEMENT_DLS_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-dir-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" && -n "${FW_ELEMENT_DIR_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-filelist-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" && -n "${FW_ELEMENT_FLS_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-file-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" && -n "${FW_ELEMENT_FIL_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-module-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" && -n "${FW_ELEMENT_MDS_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-option-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"
                            if [[ "${FW_ELEMENT_OPT_LONG[*]}"  != "" && -n "${FW_ELEMENT_OPT_LONG[${id}]:-}" ]];  then return; fi
                            if [[ "${FW_ELEMENT_OPT_SHORT[*]}" != "" && -n "${FW_ELEMENT_OPT_SHORT[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-parameter-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" && -n "${FW_ELEMENT_PAR_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-project-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_PRJ_LONG[*]}" != "" && -n "${FW_ELEMENT_PRJ_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-scenario-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SCN_LONG[*]}" != "" && -n "${FW_ELEMENT_SCN_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-script-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SCR_LONG[*]}" != "" && -n "${FW_ELEMENT_SCR_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-site-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SIT_LONG[*]}" != "" && -n "${FW_ELEMENT_SIT_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-task-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_TSK_LONG[*]}" != "" && -n "${FW_ELEMENT_TSK_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;


                        existing-clioption-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"
                            if [[ "${FW_INSTANCE_CLI_LONG[*]}"  != "" && -n "${FW_INSTANCE_CLI_LONG[${id}]:-}" ]];  then return; fi
                            if [[ "${FW_INSTANCE_CLI_SHORT[*]}" != "" && -n "${FW_INSTANCE_CLI_SHORT[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-exitcode-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_INSTANCE_EXC_LONG[*]}" != "" && -n "${FW_INSTANCE_EXC_LONG[${id}]:-}" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;


                        existing-action-id | existing-element-id | existing-instance-id | existing-object-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -f "${SF_HOME}/lib/components/${cmd2}s/${id}.sh" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;
                        existing-component-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"
                            if [[ -f "${SF_HOME}/lib/components/actions/${id}.sh" ]]; then return; fi
                            if [[ -f "${SF_HOME}/lib/components/elements/${id}.sh" ]]; then return; fi
                            if [[ -f "${SF_HOME}/lib/components/instances/${id}.sh" ]]; then return; fi
                            if [[ -f "${SF_HOME}/lib/components/objects/${id}.sh" ]]; then return; fi
                            Report application error "${functionName}" "${cmdString3}" E805 "${cmd2}" "${id}"; return 1 ;;


                        used-application-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_APP_LONG[*]}" != "" && -n "${FW_ELEMENT_APP_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-dependency-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DEP_LONG[*]}" != "" && -n "${FW_ELEMENT_DEP_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-dirlist-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DLS_LONG[*]}" != "" && -n "${FW_ELEMENT_DLS_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-dir-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_DIR_LONG[*]}" != "" && -n "${FW_ELEMENT_DIR_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-filelist-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_FLS_LONG[*]}" != "" && -n "${FW_ELEMENT_FLS_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-file-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_FIL_LONG[*]}" != "" && -n "${FW_ELEMENT_FIL_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-module-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_MDS_LONG[*]}" != "" && -n "${FW_ELEMENT_MDS_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-parameter-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_PAR_LONG[*]}" != "" && -n "${FW_ELEMENT_PAR_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-project-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_PRJ_LONG[*]}"  != "" && -n "${FW_ELEMENT_PRJ_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-scenario-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SCN_LONG[*]}"  != "" && -n "${FW_ELEMENT_SCN_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-script-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SCR_LONG[*]}"  != "" && -n "${FW_ELEMENT_SCR_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-site-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ "${FW_ELEMENT_SIT_LONG[*]}"  != "" && -n "${FW_ELEMENT_SIT_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-task-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"
                            if [[ "${FW_ELEMENT_TSK_LONG[*]}"  != "" && -n "${FW_ELEMENT_TSK_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi
                            if [[ "${id}" == "bye" || "${id}" == "quit" || "${id}" == "exit" ]];                  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;


                        used-configuration-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_CFG_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-format-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_FMT_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-level-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_LVL_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-message-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_MSG_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-mode-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_MOD_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-phase-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_PHA_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-setting-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_SET_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-theme-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_THM_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-themeitem-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_TIM_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-variable-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"; if [[ -n "${FW_OBJECT_VAR_LONG[${id}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;


                        used-clioption-long-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            id="${1}"
                            if [[ "${FW_INSTANCE_CLI_LONG[*]}"  != "" && -n "${FW_INSTANCE_CLI_LONG[${id}]:-}" ]];  then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${id}"; return 1; fi ;;
                        used-clioption-short-id)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            shortId="${1}"
                            if [[ "${shortId}" == "" ]]; then return; fi
                            if [[ "${FW_INSTANCE_CLI_SHORT[*]}" != "" && -n "${FW_INSTANCE_CLI_SHORT[${shortId}]:-}" ]]; then Report application error "${functionName}" "${cmdString3}" E807 "${cmd2}" "${shortId}"; return 1; fi ;;

                        *) Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *) Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *) Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
