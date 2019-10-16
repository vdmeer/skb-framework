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


function Get() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id property errno
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        pid)        printf "%s" "${FW_OBJECT_CFG_VAL["PID"]}" ;;
        system)     printf "%s" "${FW_OBJECT_CFG_VAL["SYSTEM"]}" ;;
        version)    printf "%s" "${FW_OBJECT_CFG_VAL["VERSION"]}" ;;

        app | auto | cache | config | current | default | error | file | home | last | log | message | module | option | primary | print | show | start | status | strict | user | warning | \
        element | object)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                cache-dir | default-theme | file-string | home-dir | start-time | user-config)
                    printf "%s" "${FW_OBJECT_CFG_VAL["${cmd1^^}_${cmd2^^}"]}" ;;

                app-name | app-name2 | auto-verify | auto-write | config-file | \
                current-mode | current-phase | current-theme | current-project | current-scenario | current-script | current-site | current-task | \
                last-project | last-scenario | last-script | last-site | last-task | \
                log-dir | log-file | log-format | log-level | log-date-arg | \
                message-codes | module-path | print-format | print-format2 | print-level | \
                strict-mode | error-count | warning-count | \
                show-execution | show-execution2)
                    printf "%s" "${FW_OBJECT_SET_VAL["${cmd1^^}_${cmd2^^}"]}" ;;

                option-id)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"; Test existing option id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
                    if [[ "${FW_ELEMENT_OPT_LONG[*]}" != "" && -n "${FW_ELEMENT_OPT_LONG[${id}]:-}" ]];  then printf "${id}"; else printf "${FW_ELEMENT_OPT_SHORT[${id}]}"; fi ;;

                status-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"; Test element status "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then printf ""; return; fi
                    id=${id:0:1}; echo "${id^}" ;;


                object-configuration)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_CFG_LONG[${id}]}" ;;
                        value)          printf "%s" "${FW_OBJECT_CFG_VAL[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-format)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_FMT_LONG[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-level)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    id="${1}"; property="${2:}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_OBJECT_LVL_LONG[${id}]}" ;;
                        character)          printf "%s" "${FW_OBJECT_LVL_CHAR_ABBR[${id}]}" ;;
                        theme-string)       printf "%s" "${FW_OBJECT_LVL_STRING_THM[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-message)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_MSG_LONG[${id}]}" ;;
                        arguments)      printf "%s" "${FW_OBJECT_MSG_ARGS[${id}]}" ;;
                        type)           printf "%s" "${FW_OBJECT_MSG_TYPE[${id}]}" ;;
                        text)           printf "%s" "${FW_OBJECT_MSG_TEXT[${id}]}" ;;
                        category)       printf "%s" "${FW_OBJECT_MSG_CAT[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-mode)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_MOD_LONG[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-phase)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_PHA_LONG[${id}]}" ;;
                        print-level)    printf "%s" "${FW_OBJECT_PHA_PRT_LVL[${id}]}" ;;
                        log-level)      printf "%s" "${FW_OBJECT_PHA_LOG_LVL[${id}]}" ;;
                        message-codes)  printf "%s" "${FW_OBJECT_PHA_MSGCOD[${id}]}" ;;
                        error-count)    printf "%s" "${FW_OBJECT_PHA_ERRCNT[${id}]}" ;;
                        warning-count)  printf "%s" "${FW_OBJECT_PHA_WRNCNT[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-setting)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_SET_LONG[${id}]}" ;;
                        phase)          printf "%s" "${FW_OBJECT_SET_PHASET[${id}]}" ;;
                        value)          printf "%s" "${FW_OBJECT_SET_VAL[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-theme)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_THM_LONG[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-themeitem)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_TIM_LONG[${id}]}" ;;
                        source)         printf "%s" "${FW_OBJECT_TIM_SOURCE[${id}]}" ;;
                        value)          printf "%s" "${FW_OBJECT_TIM_VAL[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                object-variable)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing ${cmd2} id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)    printf "%s" "${FW_OBJECT_VAR_LONG[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;


                element-application)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing application id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_APP_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_APP_DECMDS[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_APP_PHA[${id}]}" ;;
                        command)            printf "%s" "${FW_ELEMENT_APP_COMMAND[${id}]}" ;;
                        argnum)             printf "%s" "${FW_ELEMENT_APP_ARGNUM[${id}]}" ;;
                        arguments)          printf "%s" "${FW_ELEMENT_APP_ARGS[${id}]}" ;;
                        status)             printf "%s" "${FW_ELEMENT_APP_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_APP_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_APP_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-dependency)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing dependency id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_DEP_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DEP_DECMDS[${id}]}" ;;
                        command)            printf "%s" "${FW_ELEMENT_DEP_CMD[${id}]}" ;;
                        requirements)       printf "%s" "${FW_ELEMENT_DEP_REQUIRED_DEP[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_DEP_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_DEP_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_DEP_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-dirlist)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_DLS_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DLS_DECMDS[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_DLS_PHA[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_DLS_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_DLS_MOD[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_DLS_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_DLS_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_DLS_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-dir)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_DIR_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_DIR_DECMDS[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_DIR_PHA[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_DIR_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_DIR_MOD[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_DIR_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_DIR_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_DIR_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-filelist)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_FLS_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_FLS_DECMDS[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_FLS_PHA[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_FLS_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_FLS_MOD[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_FLS_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_FLS_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_FLS_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-file)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_FIL_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_FIL_DECMDS[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_PHA_ORIG[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_FIL_VAL[${id}]:-}" ;;
                        mode)               printf "%s" "${FW_ELEMENT_FIL_MOD[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_FIL_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_FIL_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_FIL_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-module)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing module id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_MDS_LONG[${id}]}" ;;
                        acronym)            printf "%s" "${FW_ELEMENT_MDS_ACR[${id}]}" ;;
                        path)               printf "%s" "${FW_ELEMENT_MDS_PATH[${id}]}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_MDS_ORIG[${id}]}" ;;
                        requirements)       printf "%s" "${FW_ELEMENT_MDS_REQUIRED_MDS[${id}]:-}" ;;
                        status)             printf "%s" "${FW_ELEMENT_MDS_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_MDS_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_MDS_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-option)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing option id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    id="$(Get option id ${id})"
                    case "${property}" in
                        description)    printf "%s" "${FW_ELEMENT_OPT_LONG[${id}]}" ;;
                        short)          printf "%s" "${FW_ELEMENT_OPT_LS[${id}]}" ;;
                        argument)       printf "%s" "${FW_ELEMENT_OPT_ARG[${id}]}" ;;
                        category)       printf "%s" "${FW_ELEMENT_OPT_CAT[${id}]}" ;;
                        length)         printf "%s" "${FW_ELEMENT_OPT_LEN[${id}]}" ;;
                        set)            printf "%s" "${FW_ELEMENT_OPT_SET[${id}]}" ;;
                        value)          printf "%s" "${FW_ELEMENT_OPT_VAL[${id}]}" ;;
                        *)              Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-parameter)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing parameter id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)        printf "%s" "${FW_ELEMENT_PAR_LONG[${id}]}" ;;
                        origin)             printf "%s" "${FW_ELEMENT_PAR_DECMDS[${id}]}" ;;
                        default-value)      printf "%s" "${FW_ELEMENT_PAR_DEFVAL[${id}]:-}" ;;
                        phase)              printf "%s" "${FW_ELEMENT_PAR_PHA[${id}]}" ;;
                        value)              printf "%s" "${FW_ELEMENT_PAR_VAL[${id}]}" ;;
                        status)             printf "%s" "${FW_ELEMENT_PAR_STATUS[${id}]}" ;;
                        status-comments)    printf "%s" "${FW_ELEMENT_PAR_STATUS_COMMENTS[${id}]}" ;;
                        requested)          printf "%s" "${FW_ELEMENT_PAR_REQUESTED[${id}]}" ;;
                        *)                  Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-project)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing project id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)            printf "%s" "${FW_ELEMENT_PRJ_LONG[${id}]}" ;;
                        origin)                 printf "%s" "${FW_ELEMENT_PRJ_DECMDS[${id}]}" ;;
                        modes)                  printf "%s" "${FW_ELEMENT_PRJ_MODES[${id}]}" ;;
                        path)                   printf "%s" "${FW_ELEMENT_PRJ_PATH[${id}]}" ;;
                        path-text)              printf "%s" "${FW_ELEMENT_PRJ_PATH_TEXT[${id}]}" ;;
                        root-dir)               printf "%s" "${FW_ELEMENT_PRJ_RDIR[${id}]}" ;;
                        targets)                printf "%s" "${FW_ELEMENT_PRJ_TGTS[${id}]:-}" ;;
                        status)                 printf "%s" "${FW_ELEMENT_PRJ_STATUS[${id}]}" ;;
                        status-comments)        printf "%s" "${FW_ELEMENT_PRJ_STATUS_COMMENTS[${id}]}" ;;
                        required-applications)  printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_APP[${id}]:-}" ;;
                        required-parameters)    printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_PAR[${id}]:-}" ;;
                        required-dependencies)  printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_DEP[${id}]:-}" ;;
                        required-projects)      printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_PRJ[${id}]:-}" ;;
                        required-scenarios)     printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_SCN[${id}]:-}" ;;
                        required-sites)         printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_SIT[${id}]:-}" ;;
                        required-tasks)         printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_TSK[${id}]:-}" ;;
                        required-files)         printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_FIL[${id}]:-}" ;;
                        required-filelists)     printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_FLS[${id}]:-}" ;;
                        required-directories)   printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_DIR[${id}]:-}" ;;
                        required-dirlists)      printf "%s" "${FW_ELEMENT_PRJ_REQUIRED_DLS[${id}]:-}" ;;
                        *)                      Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-scenario)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing scenario id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)            printf "%s" "${FW_ELEMENT_SCN_LONG[${id}]}" ;;
                        origin)                 printf "%s" "${FW_ELEMENT_SCN_DECMDS[${id}]}" ;;
                        modes)                  printf "%s" "${FW_ELEMENT_SCN_MODES[${id}]}" ;;
                        path)                   printf "%s" "${FW_ELEMENT_SCN_PATH[${id}]}" ;;
                        path-text)              printf "%s" "${FW_ELEMENT_SCN_PATH_TEXT[${id}]}" ;;
                        status)                 printf "%s" "${FW_ELEMENT_SCN_STATUS[${id}]}" ;;
                        status-comments)        printf "%s" "${FW_ELEMENT_SCN_STATUS_COMMENTS[${id}]}" ;;
                        required-applications)  printf "%s" "${FW_ELEMENT_SCN_REQUIRED_APP[${id}]:-}" ;;
                        required-scenarios)     printf "%s" "${FW_ELEMENT_SCN_REQUIRED_SCN[${id}]:-}" ;;
                        required-tasks)         printf "%s" "${FW_ELEMENT_SCN_REQUIRED_TSK[${id}]:-}" ;;
                        *)                      Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-script)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing script id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)            printf "%s" "${FW_ELEMENT_SCR_LONG[${id}]}" ;;
                        origin)                 printf "%s" "${FW_ELEMENT_SCR_DECMDS[${id}]}" ;;
                        modes)                  printf "%s" "${FW_ELEMENT_SCR_MODES[${id}]}" ;;
                        path)                   printf "%s" "${FW_ELEMENT_SCR_PATH[${id}]}" ;;
                        path-text)              printf "%s" "${FW_ELEMENT_SCR_PATH_TEXT[${id}]}" ;;
                        root-dir)               printf "%s" "${FW_ELEMENT_SCR_RDIR[${id}]}" ;;
                        status)                 printf "%s" "${FW_ELEMENT_SCR_STATUS[${id}]}" ;;
                        status-comments)        printf "%s" "${FW_ELEMENT_SCR_STATUS_COMMENTS[${id}]}" ;;
                        required-applications)  printf "%s" "${FW_ELEMENT_SCR_REQUIRED_APP[${id}]:-}" ;;
                        required-parameters)    printf "%s" "${FW_ELEMENT_SCR_REQUIRED_PAR[${id}]:-}" ;;
                        required-dependencies)  printf "%s" "${FW_ELEMENT_SCR_REQUIRED_DEP[${id}]:-}" ;;
                        required-projects)      printf "%s" "${FW_ELEMENT_SCR_REQUIRED_PRJ[${id}]:-}" ;;
                        required-scenarios)     printf "%s" "${FW_ELEMENT_SCR_REQUIRED_SCN[${id}]:-}" ;;
                        required-scripts)       printf "%s" "${FW_ELEMENT_SCR_REQUIRED_SCR[${id}]:-}" ;;
                        required-sites)         printf "%s" "${FW_ELEMENT_SCR_REQUIRED_SIT[${id}]:-}" ;;
                        required-tasks)         printf "%s" "${FW_ELEMENT_SCR_REQUIRED_TSK[${id}]:-}" ;;
                        required-files)         printf "%s" "${FW_ELEMENT_SCR_REQUIRED_FIL[${id}]:-}" ;;
                        required-filelists)     printf "%s" "${FW_ELEMENT_SCR_REQUIRED_FLS[${id}]:-}" ;;
                        required-directories)   printf "%s" "${FW_ELEMENT_SCR_REQUIRED_DIR[${id}]:-}" ;;
                        required-dirlists)      printf "%s" "${FW_ELEMENT_SCR_REQUIRED_DLS[${id}]:-}" ;;
                        *)                      Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-site)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing site id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)            printf "%s" "${FW_ELEMENT_SIT_LONG[${id}]}" ;;
                        origin)                 printf "%s" "${FW_ELEMENT_SIT_DECMDS[${id}]}" ;;
                        path)                   printf "%s" "${FW_ELEMENT_SIT_PATH[${id}]}" ;;
                        path-text)              printf "%s" "${FW_ELEMENT_SIT_PATH_TEXT[${id}]}" ;;
                        root-dir)               printf "%s" "${FW_ELEMENT_SIT_RDIR[${id}]}" ;;
                        status)                 printf "%s" "${FW_ELEMENT_SIT_STATUS[${id}]}" ;;
                        status-comments)        printf "%s" "${FW_ELEMENT_SIT_STATUS_COMMENTS[${id}]}" ;;
                        required-applications)  printf "%s" "${FW_ELEMENT_SIT_REQUIRED_APP[${id}]:-}" ;;
                        required-parameters)    printf "%s" "${FW_ELEMENT_SIT_REQUIRED_PAR[${id}]:-}" ;;
                        required-dependencies)  printf "%s" "${FW_ELEMENT_SIT_REQUIRED_DEP[${id}]:-}" ;;
                        required-scenarios)     printf "%s" "${FW_ELEMENT_SIT_REQUIRED_SCN[${id}]:-}" ;;
                        required-tasks)         printf "%s" "${FW_ELEMENT_SIT_REQUIRED_TSK[${id}]:-}" ;;
                        required-files)         printf "%s" "${FW_ELEMENT_SIT_REQUIRED_FIL[${id}]:-}" ;;
                        required-filelists)     printf "%s" "${FW_ELEMENT_SIT_REQUIRED_FLS[${id}]:-}" ;;
                        required-directories)   printf "%s" "${FW_ELEMENT_SIT_REQUIRED_DIR[${id}]:-}" ;;
                        required-dirlists)      printf "%s" "${FW_ELEMENT_SIT_REQUIRED_DLS[${id}]:-}" ;;
                        *)                      Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;
                element-task)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; property="${2}"
                    Test existing task id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${property}" in
                        description)            printf "%s" "${FW_ELEMENT_TSK_LONG[${id}]}" ;;
                        origin)                 printf "%s" "${FW_ELEMENT_TSK_DECMDS[${id}]}" ;;
                        modes)                  printf "%s" "${FW_ELEMENT_TSK_MODES[${id}]}" ;;
                        path)                   printf "%s" "${FW_ELEMENT_TSK_PATH[${id}]}" ;;
                        path-text)              printf "%s" "${FW_ELEMENT_TSK_PATH_TEXT[${id}]}" ;;
                        status)                 printf "%s" "${FW_ELEMENT_TSK_STATUS[${id}]}" ;;
                        status-comments)        printf "%s" "${FW_ELEMENT_TSK_STATUS_COMMENTS[${id}]}" ;;
                        required-applications)  printf "%s" "${FW_ELEMENT_TSK_REQUIRED_APP[${id}]:-}" ;;
                        required-dependencies)  printf "%s" "${FW_ELEMENT_TSK_REQUIRED_DEP[${id}]:-}" ;;
                        required-parameters)    printf "%s" "${FW_ELEMENT_TSK_REQUIRED_PAR[${id}]:-}" ;;
                        required-tasks)         printf "%s" "${FW_ELEMENT_TSK_REQUIRED_TSK[${id}]:-}" ;;
                        required-files)         printf "%s" "${FW_ELEMENT_TSK_REQUIRED_FIL[${id}]:-}" ;;
                        required-filelists)     printf "%s" "${FW_ELEMENT_TSK_REQUIRED_FLS[${id}]:-}" ;;
                        required-directories)   printf "%s" "${FW_ELEMENT_TSK_REQUIRED_DIR[${id}]:-}" ;;
                        required-dirlists)      printf "%s" "${FW_ELEMENT_TSK_REQUIRED_DLS[${id}]:-}" ;;
                        *)                      Report process error "${FUNCNAME[0]}" "${cmdString2}" E879 "${cmd2}" "${property}" ;;
                    esac ;;

                primary-module)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        primary-module-path)
                            printf "%s" "${FW_OBJECT_CFG_VAL["PRIMAY_MODULE_PATH"]}" ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
