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
## Report - action to report something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_COMPONENTS_TAGLINE["report"]="action to report something"


function Report() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id i message messageID level strictString themeItem nameString typeString template arr str logFile logString t1 t2 t3
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        process | application)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in
                    process-fatalerror |     process-error |     process-text |     process-message |     process-warning |     process-info |     process-debug |     process-trace | \
                application-fatalerror | application-error | application-text | application-message | application-warning | application-info | application-debug | application-trace | \
                process-strictwarning | application-strictwarning \
                )
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 1 "$#"; return; fi
                    messageID=""
                    if [[ "${#}" == 1 ]]; then
                        if [[ -n "${FW_OBJECT_MSG_LONG["${1}"]:-}" ]]; then
                            messageID="${1}"
                            message="$(Build message ${messageID})"
                        else
                            message="${1}"
                        fi
                    elif [[ "${#}" == 2 ]]; then
                        if [[ -n "${FW_OBJECT_MSG_LONG["${1}"]:-}" ]]; then
                            messageID="${1}"
                            message="$(Build message ${1} "${2}")"
                        elif [[ -n "${FW_OBJECT_MSG_LONG["${2}"]:-}" ]]; then
                            messageID="${2}"
                             message="${1}: $(Build message ${2})"
                        else
                            message="${1}: ${2}"
                        fi
                    else
                        if [[ -n "${FW_OBJECT_MSG_LONG["${1}"]:-}" ]]; then
                            messageID="${1}"; shift
                            message="$(Build message ${messageID} "${@}")"
                        elif [[ -n "${FW_OBJECT_MSG_LONG["${2}"]:-}" ]]; then
                            t1="${1}"; messageID="${2}"; shift 2
                            message="${t1}: $(Build message ${messageID} "${@}")"
                        elif [[ -n "${FW_OBJECT_MSG_LONG["${3}"]:-}" ]]; then
                            t1="${1}"; t2="${2}"; messageID="${3}"; shift 3
                            message="${t1}(${t2}): $(Build message ${messageID} "${@}")"
                        else
                            t1="${1}"; t2="${2}"; shift 2
                            message="${t1}(${t2}): ${@}"
                        fi
                    fi

                    level="${cmd2}"; strictString=""
                    if [[ "${cmd2}" == "strictwarning" ]]; then
                        strictString="-strict"
                        case ${FW_OBJECT_SET_VAL["STRICT_MODE"]} in
                            on)     level=error ;;
                            off)    level=warning ;;
                        esac
                    fi
                    case ${level} in
                        fatalerror | error) FW_OBJECT_PHA_ERRCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}]=$(( FW_OBJECT_PHA_ERRCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}] + 1 ))
                                            FW_OBJECT_SET_VAL["ERROR_COUNT"]="${FW_OBJECT_PHA_ERRCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}]}"
                                            if [[ "${messageID:0:1}" == "E" ]]; then FW_OBJECT_PHA_ERRCOD[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}]+=" ${messageID}"; fi
                                            if [[ "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; fi ;;
                        warning)            FW_OBJECT_PHA_WRNCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}]=$(( FW_OBJECT_PHA_WRNCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}] + 1 ))
                                            FW_OBJECT_SET_VAL["WARNING_COUNT"]="${FW_OBJECT_PHA_WRNCNT[${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}]}"
                                            if [[ "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; fi ;;
                    esac

                    themeItem="${FW_OBJECT_LVL_STRING_THM[${level}]}"
                    if [[ -n "${FW_OBJECT_SET_VAL["APP_NAME2"]}" ]]; then nameString="${FW_OBJECT_SET_VAL["APP_NAME2"]}"; else nameString="${FW_OBJECT_SET_VAL["APP_NAME"]}"; fi
                    if [[ "${cmd1}" == "application" ]]; then typeString="App"; else typeString="Proc"; fi

                    ## do print for level
                    case ${FW_OBJECT_SET_VAL["PRINT_LEVEL"]} in *" ${level} "*)
                        template="${FW_OBJECT_TIM_VAL["rpt${typeString}${FW_OBJECT_LVL_STRING_THM[${level}]}Tpl"]}"
                        for (( i=1; i < ${#template}; i++ )); do if [[ "${template:$i:1}" == " " ]]; then printf " "; else break; fi; done
                        read -r -a arr <<< "${template}"
                        for str in "${arr[@]}"; do
                            case "${str}" in
                                *"##APPNAME##"*)    printf " %s" "${str%"##APPNAME##"*}"
                                                    printf "%s"  "${nameString}"
                                                    printf "%s"  "${str#*"##APPNAME##"}"
                                                    ;;
                                *"##LEVEL##"*)      printf " %s" "${str%"##LEVEL##"*}"
                                                    if [[ "${cmd1}" == "process" ]]; then
                                                        Format themed text rpt${themeItem}LvlFmt ${level^}
                                                    else
                                                        Format themed text rpt${themeItem}LvlFmt ${level}
                                                    fi
                                                    printf "%s" "${strictString}${str#*"##LEVEL##"}"
                                                    ;;
                                *"##TEXT##"*)       printf " %s" "${str%"##TEXT##"*}"
                                                    Format themed text rpt${themeItem}TextFmt "${message}"
                                                    printf "%s" "${str#*"##TEXT##"}"
                                                    ;;
                                *)                  printf " %s" "${str}"
                                                    ;;
                            esac
                        done
                        printf "\n" ;;
                    esac

                    ## do log for level
                    case ${FW_OBJECT_SET_VAL["LOG_LEVEL"]} in *" ${level} "*)
                        FW_OBJECT_SET_VAL["PRINT_FORMAT2"]="${FW_OBJECT_SET_VAL["LOG_FORMAT"]}"
                        template="${FW_OBJECT_TIM_VAL["rpt${typeString}${FW_OBJECT_LVL_STRING_THM[${level}]}Tpl"]}"
                        logFile="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"

                        printf "%s" "$(date ${FW_OBJECT_SET_VAL["LOG_DATE_ARG"]})" >> ${logFile}
                        for (( i=1; i < ${#template}; i++ )); do if [[ "${template:$i:1}" == " " ]]; then printf " " >> ${logFile}; else break; fi; done
                        read -r -a arr <<< "${template}"
                        for str in "${arr[@]}"; do
                            case "${str}" in
                                *"##APPNAME##"*)    printf " %s" "${str%"##APPNAME##"*}" >> ${logFile}
                                                    printf "%s"  "${nameString}" >> ${logFile}
                                                    printf "%s"  "${str#*"##APPNAME##"}" >> ${logFile}
                                                    ;;
                                *"##LEVEL##"*)      printf " %s" "${str%"##LEVEL##"*}" >> ${logFile}
                                                    if [[ "${cmd1}" == "process" ]]; then
                                                        Format themed text rpt${themeItem}LvlFmt ${level^} >> ${logFile}
                                                    else
                                                        Format themed text rpt${themeItem}LvlFmt ${level} >> ${logFile}
                                                    fi
                                                    printf "%s" "${strictString}${str#*"##LEVEL##"}" >> ${logFile}
                                                    ;;
                                *"##TEXT##"*)       printf " %s" "${str%"##TEXT##"*}" >> ${logFile}
                                                    Format themed text rpt${themeItem}TextFmt "${message}" >> ${logFile}
                                                    printf "%s" "${str#*"##TEXT##"}" >> ${logFile}
                                                    ;;
                                *)                  printf " %s" "${str}" >> ${logFile}
                                                    ;;
                            esac
                        done
                        printf "\n" >> ${logFile}
                        FW_OBJECT_SET_VAL["PRINT_FORMAT2"]="" ;;
                    esac ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
