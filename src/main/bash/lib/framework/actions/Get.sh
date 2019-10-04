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
## Get - action to get something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["get"]="action to get something"


function Get() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id property errno
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        pid)        printf "%s" "${FW_OBJECT_CFG_VAL["PID"]}" ;;
        system)     printf "%s" "${FW_OBJECT_CFG_VAL["SYSTEM"]}" ;;
        version)    printf "%s" "${FW_OBJECT_CFG_VAL["VERSION"]}" ;;

        app | auto | cache | config | current | default | error | file | home | last | log | long | module | option | print | status | strict | theme | user | warning | \
        element | object \
        )
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                cache-dir | default-theme | file-string | home-dir | user-config)
                    printf "%s" "${FW_OBJECT_CFG_VAL["${cmd1^^}_${cmd2^^}"]}" ;;

                app-name | app-name2 | auto-verify | auto-write | config-file | \
                current-mode | current-phase | current-theme | current-project | current-scenario | current-site | current-task | \
                last-project | last-scenatio | last-site | last-task | \
                log-dir | log-file | log-format | log-level | log-date-arg | \
                module-path | print-format | print-format2 | print-level | \
                strict-mode | error-count | warning-count )
                    printf "%s" "${FW_OBJECT_SET_VAL["${cmd1^^}_${cmd2^^}"]}" ;;

                option-id)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"
                    Test existing option id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
                    if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" && -n "${FW_ELEMENT_OPT_LONG[${id}]:-}" ]];  then printf "${id}"; else printf "${FW_ELEMENT_OPT_SHORT[${id}]}"; fi ;;

                status-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"
                    Test element status "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
                    id=${id:0:1}; echo "${id^}" ;;

                error-codes)    printf "%s" "$(Get object phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error codes)" ;;

                object-configuration)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test configuration "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_CFG_LONG[${id}]}" ;;
                        value)              printf "%s" "${FW_OBJECT_CFG_VAL[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-format)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test format "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_FMT_LONG[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-level)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test level "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_LVL_LONG[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-message)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing message id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_MSG_LONG[${id}]}" ;;
                        arguments)          printf "%s" "${FW_OBJECT_MSG_ARGS[${id}]}" ;;
                        type)               printf "%s" "${FW_OBJECT_MSG_TYPE[${id}]}" ;;
                        text)               printf "%s" "${FW_OBJECT_MSG_TEXT[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-mode)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing mode id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_MOD_LONG[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-phase)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; cmd2="${2:-}"; cmd3="${3:-}"
                    Test existing phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${cmd2}-${cmd3}" in
                        description- | "-") printf "%s" "${FW_OBJECT_PHA_LONG[${id}]}" ;;
                        print-level)        printf "%s" "${FW_OBJECT_PHA_PRT_LVL[${id}]}" ;;
                        log-level)          printf "%s" "${FW_OBJECT_PHA_LOG_LVL[${id}]}" ;;
                        error-codes)        printf "%s" "${FW_OBJECT_PHA_ERRCOD[${id}]}" ;;
                        error-count)        printf "%s" "${FW_OBJECT_PHA_ERRCNT[${id}]}" ;;
                        warning-count)      printf "%s" "${FW_OBJECT_PHA_WRNCNT[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${cmd3}" ;;
                    esac ;;
                object-setting)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing setting id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_SET_LONG[${id}]}" ;;
                        phase)              printf "%s" "${FW_OBJECT_SET_PHA[${id}]}" ;;
                        value)              printf "%s" "${FW_OBJECT_SET_VAL[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-theme)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing theme id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_OBJECT_THM_LONG[${id}]}" ;;
                        path)               printf "%s" "${FW_OBJECT_THM_PATH[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                object-themeitem)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"
                    Test existing themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    printf "${FW_OBJECT_TIM_VAL[${id}]}" ;;

                element-dependency)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_DEP_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DEP_ORIG[${id}]}" ;;
                        command)            printf "%s" "${FW_ELEMENT_DEP_CMD[${id}]}" ;;
                        requirements)       printf "%s" "${FW_ELEMENT_DEP_REQUIRED_DEPENDENCIES[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-module)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_MDS_LONG[${id}]}" ;;
                        acronym)            printf "%s" "${FW_ELEMENT_MDS_ACR[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_MDS_PATH[${id}]}" ;;
                        requirements)       printf "%s" "${FW_ELEMENT_MDS_REQUIRED_MODULES[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-parameter)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_PAR_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_PAR_ORIG[${id}]}" ;;
                        default-value)      printf "%s" "${FW_ELEMENT_PAR_DEFVAL[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-project)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_PRJ_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_PRJ_ORIG[${id}]}" ;;
                        modes)              printf "%s" "${FW_ELEMENT_PRJ_MODES[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_PRJ_PATH[${id}]}" ;;
                        targets)            printf "%s" "${FW_ELEMENT_PRJ_TGTS[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-scenario)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_SCN_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_SCN_ORIG[${id}]}" ;;
                        modes)              printf "%s" "${FW_ELEMENT_SCN_MODES[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_SCN_PATH[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-site)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_SIT_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_SIT_ORIG[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_SIT_PATH[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-task)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_TSK_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_TSK_ORIG[${id}]}" ;;
                        modes)              printf "%s" "${FW_ELEMENT_TSK_MODES[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_TSK_PATH[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                element-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_FIL_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_FIL_ORIG[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_FIL_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_FIL_MOD[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-filelist)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_FLS_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_FLS_ORIG[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_FLS_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_FLS_MOD[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-dir)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_DIR_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DIR_ORIG[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_DIR_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_DIR_MOD[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-dirlist)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:-""}"
                    Test existing dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description | "")   printf "%s" "${FW_ELEMENT_DLS_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DLS_ORIG[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_DLS_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_DLS_MOD[${id}]:-}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
