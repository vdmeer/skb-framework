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
## Set - action to set (change) something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Set() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id property level object entry value program errno doWriteFast=false doWriteSlow=false doVerify=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        app | config | current | last | log | module | print | \
        element | object)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                object-phase)
                    ## Set object phase ID [ print-level | log-level ] to [ all | none LEVEL ]
                    if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 4 "$#"; return; fi
                    if [[ "${3}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                    id="${1}"; property="${2}"; level="${4}"; errno=0
                    Test existing phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    if [[ "${level}" != "all" && "${level}" != "none" ]]; then Test existing level id "${level}"; errno=$?; fi; if [[ "${errno}" != 0 ]]; then return; fi
                    case "${level}" in
                        none)       value="" ;;
                        fatalerror) value=" fatalerror " ;;
                        error)      value=" fatalerror error " ;;
                        text)       value=" fatalerror error text " ;;
                        message)    value=" fatalerror error text message " ;;
                        warning)    value=" fatalerror error text message warning " ;;
                        info)       value=" fatalerror error text message warning info " ;;
                        debug)      value=" fatalerror error text message warning info debug " ;;
                        trace)      value=" fatalerror error text message warning info debug trace " ;;
                        all)        value=" fatalerror error text message warning info debug trace " ;;
                    esac
                    case "${property}" in
                        print-level)    FW_OBJECT_PHA_PRT_LVL[${id}]="${value}" ;;
                        log-level)      FW_OBJECT_PHA_LOG_LVL[${id}]="${value}" ;;
                    esac
                    doWriteFast=true ;;
                object-setting)
                    ## Set object setting ID to VAL
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 3 "$#"; return; fi
                    if [[ "${2}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                    id="${1}"; value="${3}"
                    Test existing setting id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    object=${id,,}; entry=${object##*_}; object=${object%%_*}
                    case ${object}-${entry} in
                        config-file | current-mode | current-phase | current-theme | current-project | current-scenario | current-site | current-task | \
                        last-project | last-scenario | last-site | last-task | log-date-arg | log-dir | log-file | log-format | log-level | print-format | print-format2 | print-level | module-path)
                            Set ${object} ${entry} to "${value}" ;;
                        error-count)    Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E830 setting error ;;
                        warning-count)  Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E830 setting warning ;;
                        error-codes)    Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E831 setting ;;
                        auto-verify | auto-write)   Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E832 setting ${object} ;;
                        *)              FW_OBJECT_SET_VAL["${id}"]="${value}"; FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"; doWriteFast=true ;;
                    esac ;;
                object-themeitem)
                    ## Set object themeitem ID to VAL
                    if [[ "${#}" -lt 3 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 3 "$#"; return; fi
                    if [[ "${2}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                    id="${1}"; value="${3}"
                    Test existing themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_TIM_VAL["${id}"]="${value}"
                    FW_OBJECT_TIM_SOURCE["${id}"]="${FW_CURRENT_THEME_NAME:-API}"
                    doWriteSlow=true ;;


                element-application)
                    ## Set element application ID command to COMMAND
                    ## Set element application ID to COMMAND ARGNUM ARGS
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 2 "$#"; return; fi
                    property=""; value=""
                    if [[ "${#}" == 4 ]]; then
                        id="${1}"; program="${4}"
                        if [[ "${2}" != "command" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                        if [[ "${3}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                    elif [[ "${#}" == 5 ]]; then
                        id="${1}"; program="${3}"; property="${4}"; value="${5}"
                        if [[ "${2}" != "to" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} ${1}" E803 "${2}"; return; fi
                        Test integer "${property}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    else Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 "4/5" "$#"; return; fi
                    Test existing application id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_ELEMENT_APP_COMMAND[${id}]="${program}"
                    FW_ELEMENT_APP_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    if [[ -n "${property}" ]]; then FW_ELEMENT_APP_ARGNUM[${id}]="${property}"; fi
                    if [[ -n "${value}" ]]; then FW_ELEMENT_APP_ARGS[${id}]="${value}"; fi
                    doVerify=true
                    doWriteSlow=true ;;


                app-name | app-name2 | config-file | current-mode | current-phase | current-theme | \
                current-project | current-scenario | current-site | current-task | last-project | last-scenario | last-site | last-task | \
                log-format | print-format | print-format2 | log-level | print-level | log-date-arg | log-dir | log-file | module-path)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        app-name-to | app-name2-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;

                        config-file-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="$(realpath ${1})"; id=${cmd1^^}_${cmd2^^}
                            Test file exists "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test file can read "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;

                        current-mode-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            Test existing mode id "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doVerify=true; doWriteFast=true ;;
                        current-phase-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            Test existing phase id "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}";                                                                  FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["PRINT_LEVEL"]="${FW_OBJECT_PHA_PRT_LVL["${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"]}";   FW_OBJECT_SET_PHA["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["LOG_LEVEL"]="${FW_OBJECT_PHA_LOG_LVL["${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"]}";     FW_OBJECT_SET_PHA["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["ERROR_COUNT"]="${FW_OBJECT_PHA_ERRCNT["${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"]}";    FW_OBJECT_SET_PHA["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["ERROR_CODES"]="${FW_OBJECT_PHA_ERRCOD["${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"]}";    FW_OBJECT_SET_PHA["ERROR_CODES"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["WARNING_COUNT"]="${FW_OBJECT_PHA_WRNCNT["${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"]}";  FW_OBJECT_SET_PHA["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;
                        current-theme-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            Test existing theme id "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}"; Load theme ${value}
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;

                        current-project-to | current-scenario-to | current-site-to | current-task-to | last-project-to | last-scenario-to | last-site-to | last-task-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            Test existing ${cmd2} id "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;

                        log-format-to | print-format-to | print-format2-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"; id=${cmd1^^}_${cmd2^^}
                            Test ${cmd1} format "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_OBJECT_SET_VAL["${id}"]="${value}"
                            FW_OBJECT_SET_PHA["${id}"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            doWriteFast=true ;;

                        log-level-to | print-level-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            level="${1}"; errno=0
                            if [[ "${level}" != "all" && "${level}" != "none" ]]; then Test existing level id "${level}"; errno=$?; fi; if [[ "${errno}" != 0 ]]; then return; fi
                            case "${level}" in
                                none)       value="" ;;
                                fatalerror) value=" fatalerror " ;;
                                error)      value=" fatalerror error " ;;
                                text)       value=" fatalerror error text " ;;
                                message)    value=" fatalerror error text message " ;;
                                warning)    value=" fatalerror error text message warning " ;;
                                info)       value=" fatalerror error text message warning info " ;;
                                debug)      value=" fatalerror error text message warning info debug " ;;
                                trace)      value=" fatalerror error text message warning info debug trace " ;;
                                all)        value=" fatalerror error text message warning info debug trace " ;;
                            esac
                            FW_OBJECT_SET_PHA["${cmd1^^}_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["${cmd1^^}_LEVEL"]="${value}"
                            Set object phase "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" ${cmd1}-level to "${level}" ;;

                        log-date-arg-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"
                            FW_OBJECT_SET_VAL["LOG_DATE_ARG"]="${value}"; doWriteFast=true ;;
                        log-dir-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"
                            FW_OBJECT_SET_VAL["LOG_DIR"]="${value}"; doWriteFast=true ;;
                        log-file-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"
                            FW_OBJECT_SET_VAL["LOG_FILE"]="${value}"; doWriteFast=true ;;

                        module-path-to)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            value="${1}"
                            if [[ ! -n "${value}" ]]; then
                                FW_OBJECT_SET_VAL["MODULE_PATH"]=" "
                                FW_OBJECT_SET_PHA["MODULE_PATH"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                doWriteFast=true
                            else
                                Test dir can read "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                                FW_OBJECT_SET_VAL["MODULE_PATH"]="${FW_OBJECT_SET_VAL["MODULE_PATH"]}${value} "
                                FW_OBJECT_SET_PHA["MODULE_PATH"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                doWriteFast=true
                            fi ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${doWriteFast}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; doWriteFast=false
    elif [[ "${doWriteSlow}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write slow config; doWriteSlow=false; fi

    if [[ "${doVerify}" == true && "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify everything; fi
}
