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
## Set - command to set (change) something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_TAGS_COMMANDS["Set"]="command to set (change) something"

function Set() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local idForPhase="" id property object entry value sourcePhase program errno doWriteFast=false doWriteSlow=false doVerify=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        value)
            ## Set value for XXX to YYY
            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 4 "$#"; return; fi
            cmd2=${1,,}; cmd3=${3,,}; id=${2}; value=${4}
            case ${cmd2} in
                for)
                    Test existing setting id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case ${cmd3} in
                        to) object=${id,,}; entry=${object##*_}; object=${object%%_*}
                            case ${object}-${entry} in
                                auto-verify | auto-write | config-file | current-mode | current-phase | current-theme | current-project | current-scenario | current-site | current-task | last-project | last-scenario | last-site | last-task | error-count | log-date-arg | log-dir | log-file | log-format | log-level | print-format | print-format2 | print-level | strict-mode | warning-count) Set ${object} ${entry} "${value}" ;;
                                *) FW_OBJECT_SET_VAL["${id}"]="${value}"; idForPhase=${id}
                                   doWriteFast=true ;;
                            esac ;;
                        *)  Report process error "${FUNCNAME[0]}" "${cmd1} ${cmd2} ${id} ${cmd3}" E803 "${cmd3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "${cmd1} ${cmd2}" E803 "${cmd2}"; return ;;
            esac ;;

        phase)
            if [[ "${#}" -lt 4 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 4 "$#"; return; fi
            id="${1}"; cmd2="${2:-}"; cmd3="${3:-}"; value="${4}"; property="${cmd2}-${cmd3}"
            Test existing phase id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            case "${cmd2}-${cmd3}" in
                log-level)
                    object="${value##*+}"; object="${object##*-}"; errno=0
                    if [[ "${value}" != "all" && "${value}" != "none" ]]; then Test ${cmd2} ${cmd3} "${object}"; errno=$?; fi
                    if [[ "${errno}" == 0 ]]; then
                        if [[ "${value}" == "all" ]]; then
                            FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message warning info debug trace "
                        elif [[ "${value}" == "none" ]]; then
                            FW_OBJECT_PHA_LOG_LVL[${id}]=" "
                        elif [[ "${value:0:1}" == "+" ]]; then
                            FW_OBJECT_PHA_LOG_LVL[${id}]="${FW_OBJECT_PHA_LOG_LVL[${id}]}${object} "
                        elif [[ "${value:0:1}" == "-" ]]; then
                            FW_OBJECT_PHA_LOG_LVL[${id}]=${FW_OBJECT_PHA_LOG_LVL[${id}]/"${object} "/}
                        else
                            case ${value} in
                                fatalerror) FW_OBJECT_PHA_LOG_LVL[${id}]=" fatalerror " ;;
                                error)      FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error " ;;
                                text)       FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text " ;;
                                message)    FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message " ;;
                                warning)    FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message warning " ;;
                                info)       FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message warning info " ;;
                                debug)      FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message warning info debug " ;;
                                trace)      FW_OBJECT_PHA_LOG_LVL[${id}]=" fatal error text message warning info debug trace " ;;
                            esac
                        fi
                        doWriteFast=true
                    else
                        return
                    fi ;;
                print-level)
                    object="${value##*+}"; object="${object##*-}"; errno=0
                    if [[ "${value}" != "all" && "${value}" != "none" ]]; then Test ${cmd2} ${cmd3} "${object}"; errno=$?; fi
                    if [[ "${errno}" == 0 ]]; then
                        if [[ "${value}" == "all" ]]; then
                            FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message warning info debug trace "
                        elif [[ "${value}" == "none" ]]; then
                            FW_OBJECT_PHA_PRT_LVL[${id}]=" "
                        elif [[ "${value:0:1}" == "+" ]]; then
                            FW_OBJECT_PHA_PRT_LVL[${id}]="${FW_OBJECT_PHA_PRT_LVL[${id}]}${object} "
                        elif [[ "${value:0:1}" == "-" ]]; then
                            FW_OBJECT_PHA_PRT_LVL[${id}]=${FW_OBJECT_PHA_PRT_LVL[${id}]/"${object} "/}
                        else
                            case ${value} in
                                fatalerror) FW_OBJECT_PHA_PRT_LVL[${id}]=" fatalerror " ;;
                                error)      FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error " ;;
                                text)       FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text " ;;
                                message)    FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message " ;;
                                warning)    FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message warning " ;;
                                info)       FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message warning info " ;;
                                debug)      FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message warning info debug " ;;
                                trace)      FW_OBJECT_PHA_PRT_LVL[${id}]=" fatal error text message warning info debug trace " ;;
                            esac
                        fi
                        doWriteFast=true
                    else
                        return
                    fi ;;
                error-count)
                    Test error count "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    if [[ "${value:0:1}" == "+" ]]; then FW_OBJECT_PHA_ERRCNT[${id}]=$(( FW_OBJECT_PHA_ERRCNT[${id}] + ${value} )); else FW_OBJECT_PHA_ERRCNT[${id}]="${value}"; fi
                    doWriteFast=true ;;
                warning-count)
                    Test warning count "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    if [[ "${value:0:1}" == "+" ]]; then FW_OBJECT_PHA_WRNCNT[${id}]=$(( FW_OBJECT_PHA_WRNCNT[${id}] + ${value} )); else FW_OBJECT_PHA_WRNCNT[${id}]="${value}"; fi
                    doWriteFast=true ;;
                error-codes)
                    entry="${value##*+}"
                    if [[ "${value}" == "" ]]; then
                        FW_OBJECT_PHA_ERRCOD[${id}]=""
                    else
                        Test existing message id "${entry}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                        if [[ "${value}:0:1" == "+" ]]; then
                            FW_OBJECT_PHA_ERRCOD[${id}]=" ${value}"
                        else
                            if [[ "${FW_OBJECT_PHA_ERRCOD[${id}]}" == "" ]]; then
                                FW_OBJECT_PHA_ERRCOD[${id}]="${value}"
                            else
                                FW_OBJECT_PHA_ERRCOD[${id}]+=" ${entry}"
                            fi
                        fi
                        doWriteFast=true
                    fi ;;
                *)  Report process error "${FUNCNAME[0]}" "${cmdString1}" E879 "${cmd1}" "${cmd2} ${cmd3}"; return ;;
            esac
            ;;

        themeitem)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            Test existing themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            FW_OBJECT_TIM_VAL["${id}"]="${value}"
            FW_OBJECT_TIM_SOURCE["${id}"]="${FW_CURRENT_THEME_NAME:-API}"
            doWriteSlow=true ;;

        application)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 2 "$#"; return; fi
            if [[ "${#}" == 2 ]];   then  id="${1}"; program="${2}"
            elif [[ "${#}" == 4 ]]; then id="${1}"; program="${2}"; property="${3}"; value="${4}"
            else Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 "2/4" "$#"; return; fi
            Test existing application id ${id}; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            FW_ELEMENT_APP_COMMAND[${id}]="${program}"
            FW_ELEMENT_APP_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            if [[ "${#}" == 4 ]]; then
                FW_ELEMENT_APP_ARGNUM[${id}]="${property}"
                FW_ELEMENT_APP_ARGS[${id}]="${value}"
            fi
            doVerify=true
            doWriteSlow=true ;;

        file)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            Test existing file id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            FW_ELEMENT_FIL_VAL["${id}"]="${value}"
            FW_ELEMENT_FIL_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            doVerify=true
            doWriteFast=true ;;
        filelist)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            object="${value##*+}"; object="${object##*-}";
            Test existing filelist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ "${value:0:1}" == "+" ]]; then
                FW_ELEMENT_FLS_VAL[${id}]="${FW_ELEMENT_FLS_VAL[${id}]} ${object} "
            elif [[ "${value:0:1}" == "-" ]]; then
                FW_ELEMENT_FLS_VAL[${id}]=${FW_ELEMENT_FLS_VAL[${id}]/"${object} "/}
            else
                FW_ELEMENT_FLS_VAL[${id}]=" ${value} "
            fi
            FW_ELEMENT_FLS_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            doVerify=true
            doWriteFast=true ;;
        dir)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            Test existing dir id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            FW_ELEMENT_DIR_VAL["${id}"]="${value}"
            FW_ELEMENT_DIR_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            doVerify=true
            doWriteFast=true ;;
        dirlist)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            object="${value##*+}"; object="${object##*-}";
            Test existing dirlist id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ "${value:0:1}" == "+" ]]; then
                FW_ELEMENT_DLS_VAL[${id}]="${FW_ELEMENT_DLS_VAL[${id}]} ${object} "
            elif [[ "${value:0:1}" == "-" ]]; then
                FW_ELEMENT_DLS_VAL[${id}]=${FW_ELEMENT_DLS_VAL[${id}]/"${object} "/}
            else
                FW_ELEMENT_DLS_VAL[${id}]=" ${value} "
            fi
            FW_ELEMENT_DLS_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            doVerify=true
            doWriteFast=true ;;
        parameter)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            id="${1}"; value="${2}"
            FW_ELEMENT_PAR_VAL[${id}]="${value}"
            FW_ELEMENT_PAR_PHA[${id}]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
            doVerify=true
            doWriteFast=true ;;

        app | auto | config | current | error | last | log | module | print | strict | warning)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                app-name | app-name2)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doWriteFast=true ;;

                auto-verify)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    case "${value}" in
                        false | true)   FW_OBJECT_SET_VAL[${id}]="${value}"
                                        idForPhase=${id}
                                        doWriteFast=true ;;
                    esac ;;
                auto-write)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    case "${value}" in
                        false | true)   FW_OBJECT_SET_VAL[${id}]="${value}"
                                        idForPhase=${id}
                                        doWriteFast=true ;;
                    esac ;;

                config-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="$(realpath ${1})"; id=${cmd1^^}_${cmd2^^}
                    Test file exists "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Test file can read "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doWriteFast=true ;;

                current-mode)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test current mode "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doVerify=true
                    doWriteFast=true ;;
                current-phase)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test current phase "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    object="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                    FW_OBJECT_SET_VAL["PRINT_LEVEL"]="${FW_OBJECT_PHA_PRT_LVL[${object}]}"
                    FW_OBJECT_SET_VAL["LOG_LEVEL"]="${FW_OBJECT_PHA_LOG_LVL[${object}]}"
                    FW_OBJECT_SET_VAL["ERROR_COUNT"]="${FW_OBJECT_PHA_ERRCNT[${object}]}"
                    FW_OBJECT_SET_VAL["WARNING_COUNT"]="${FW_OBJECT_PHA_WRNCNT[${object}]}"
                    idForPhase=${id}
                    doWriteFast=true ;;
                current-theme)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test current theme "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    Load theme ${value}
                    idForPhase=${id}
                    doWriteFast=true ;;

                current-project | current-scenario | current-site | current-task | last-project | last-scenario | last-site | last-task)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test existing ${cmd2} id "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doWriteFast=true ;;


                log-format | print-format | print-format2)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test ${cmd1} format "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doWriteFast=true ;;
                log-level | print-level)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; object="${1##*+}"; object="${object##*-}"; id=${cmd1^^}_${cmd2^^}; errno=0
                    if [[ "${value}" != "all" && "${value}" != "none" ]]; then Test ${cmd1} ${cmd2} "${object}"; errno=$?; fi
                    if [[ "${errno}" == 0 ]]; then Set phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ${cmd1} ${cmd2} ${value}; FW_OBJECT_SET_VAL["${id}"]="$(Get object phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ${cmd1} ${cmd2})"; idForPhase=${id}; else return; fi
                    doWriteFast=true ;;

                log-date-arg)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"
                    FW_OBJECT_SET_VAL["LOG_DATE_ARG"]="${value}"
                    doWriteFast=true ;;
                log-dir)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"
                    FW_OBJECT_SET_VAL["LOG_DIR"]="${value}"
                    doWriteFast=true ;;
                log-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"
                    FW_OBJECT_SET_VAL["LOG_FILE"]="${value}"
                    doWriteFast=true ;;

                module-path)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"
                    object="${value##*+}"; object="${object##*-}";
                    if [[ "${value:0:1}" == "+" ]]; then
                        FW_OBJECT_SET_VAL["MODULE_PATH"]="${FW_OBJECT_SET_VAL["MODULE_PATH"]} ${object}"
                    elif [[ "${value:0:1}" == "-" ]]; then
                        FW_OBJECT_SET_VAL["MODULE_PATH"]=${FW_OBJECT_SET_VAL["MODULE_PATH"]/"${object} "/}
                    else
                        FW_OBJECT_SET_VAL["MODULE_PATH"]=" ${value} "
                    fi
                    doWriteFast=true ;;

                strict-mode)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test ${cmd1} mode "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    FW_OBJECT_SET_VAL["${id}"]="${value}"
                    idForPhase=${id}
                    doWriteFast=true ;;

                error-count)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test ${cmd1} ${cmd2} "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Set phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error count ${value}
                    FW_OBJECT_SET_VAL["ERROR_COUNT"]="$(Get object phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error count)"
                    idForPhase=ERROR_COUNT ;;
                warning-count)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; id=${cmd1^^}_${cmd2^^}
                    Test ${cmd1} ${cmd2} "${value}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Set phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} warning count ${value}
                    FW_OBJECT_SET_VAL["WARNING_COUNT"]="$(Get object phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} warning count)"
                    idForPhase=WARNING_COUNT ;;

                error-codes)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    value="${1}"; entry="${1##*+}"
                    if [[ "${value}" == "" ]]; then
                       Set phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error codes ""
                    else
                        Test existing message id "${entry}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                        Set phase ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} error codes "${value}"
                    fi ;;

                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac

    if [[ "${idForPhase}" != "" ]]; then
        sourcePhase="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
        FW_OBJECT_SET_PHA[${idForPhase}]=${sourcePhase}
    fi

    if [[ "${idForPhase:-}" == "AUTO_WRITE" ]]; then Write fast config; doWriteFast=false
    elif [[ "${doWriteFast}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; doWriteFast=false
    elif [[ "${doWriteSlow}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write slow config; doWriteSlow=false; fi

    if [[ "${doVerify}" == true && "${FW_OBJECT_SET_VAL["AUTO_VERIFY"]:-false}" != false ]]; then Verify everything; fi
}
