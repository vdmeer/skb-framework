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
## internal - internal functions called by the API
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function sf_set_phase_level () {
    local type="${1}" phase="${2}" level="${3}" value

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
    case "${type}" in
        print-level)    FW_OBJECT_PHA_PRT_LVL[${phase}]="${value}"
                        if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                            FW_OBJECT_SET_PHASET["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["PRINT_LEVEL_LEVEL"]="${value}"
                        fi ;;
        log-level)      FW_OBJECT_PHA_LOG_LVL[${phase}]="${value}"
                        if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                            FW_OBJECT_SET_PHASET["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                            FW_OBJECT_SET_VAL["LOG_LEVEL_LEVEL"]="${value}"
                        fi ;;
    esac
    if [[ "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; fi
}


function sf_deac_phase_level () {
    local task="${1}" type="${2}" phase="${3}" level="${4}"
    case "${task}" in
        activate)
            case "${type}" in
                print-level)    FW_OBJECT_PHA_PRT_LVL[${phase}]="${FW_OBJECT_PHA_PRT_LVL[${phase}]}${level} "
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["PRINT_LEVEL"]}${level} "
                                fi ;;
                log-level)      FW_OBJECT_PHA_LOG_LVL[${phase}]="${FW_OBJECT_PHA_LOG_LVL[${phase}]}${level} "
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["LOG_LEVEL"]}${level} "
                                fi ;;
            esac ;;
        deactivate)
            case "${type}" in
                print-level)    FW_OBJECT_PHA_PRT_LVL[${phase}]="${FW_OBJECT_PHA_PRT_LVL[${phase}]/"${level} "/}"
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["PRINT_LEVEL"]="${FW_OBJECT_SET_VAL["PRINT_LEVEL"]/"${level} "/}"
                                fi ;;
                log-level)      FW_OBJECT_PHA_LOG_LVL[${phase}]="${FW_OBJECT_PHA_LOG_LVL[${phase}]/"${level} "/}"
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["LOG_LEVEL"]="${FW_OBJECT_SET_VAL["LOG_LEVEL"]/"${level} "/}"
                                fi ;;
            esac ;;
    esac
    if [[ "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; fi
}


function sf_alter_phase_counts () {
    local task="${1}" type="${2}" phase="${3}" value="${4:-0}"
    case "${task}" in
        increase)
            case "${type}" in
                error-count)    FW_OBJECT_PHA_ERRCNT[${phase}]=$(( FW_OBJECT_PHA_ERRCNT[${phase}] + 1 ))
                                if [[ "${value}" != "0" ]]; then FW_OBJECT_PHA_MSGCOD[${phase}]+=" ${value}"; fi
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=$(( FW_OBJECT_SET_VAL["ERROR_COUNT"] + 1 ))
                                    if [[ "${value}" != "0" ]]; then FW_OBJECT_SET_VAL["MESSAGE_CODES"]+=" ${value}"; fi
                                fi ;;
                warning-count)  FW_OBJECT_PHA_WRNCNT[${phase}]=$(( FW_OBJECT_PHA_WRNCNT[${phase}] + 1 ))
                                if [[ "${value}" != "0" ]]; then FW_OBJECT_PHA_MSGCOD[${phase}]+=" ${value}"; fi
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=$(( FW_OBJECT_SET_VAL["WARNING_COUNT"] + 1 ))
                                    if [[ "${value}" != "0" ]]; then FW_OBJECT_SET_VAL["MESSAGE_CODES"]+=" ${value}"; fi
                                fi ;;
            esac ;;
        decrease)
            case "${type}" in
                error-count)    FW_OBJECT_PHA_ERRCNT[${phase}]=$(( FW_OBJECT_PHA_ERRCNT[${phase}] - 1 ))
                                if (( FW_OBJECT_PHA_ERRCNT[${phase}] < 0 )); then FW_OBJECT_PHA_ERRCNT[${phase}]=0; fi
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=$(( FW_OBJECT_SET_VAL["ERROR_COUNT"] - 1 ))
                                    if (( FW_OBJECT_SET_VAL["ERROR_COUNT"] < 0 )); then FW_OBJECT_SET_VAL["ERROR_COUNT"]=0; fi
                                fi ;;
                warning-count)  FW_OBJECT_PHA_WRNCNT[${phase}]=$(( FW_OBJECT_PHA_WRNCNT[${phase}] - 1 ))
                                if (( FW_OBJECT_PHA_WRNCNT[${phase}] < 0 )); then FW_OBJECT_PHA_WRNCNT[${phase}]=0; fi
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=$(( FW_OBJECT_SET_VAL["WARNING_COUNT"] - 1 ))
                                    if (( FW_OBJECT_SET_VAL["WARNING_COUNT"] < 0 )); then FW_OBJECT_SET_VAL["WARNING_COUNT"]=0; fi
                                fi ;;
            esac ;;
        reset)
            case "${type}" in
                message-codes)  FW_OBJECT_PHA_MSGCOD[${phase}]=""
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["MESSAGE_CODES"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["MESSAGE_CODES"]=""
                                fi ;;
                error-count)    FW_OBJECT_PHA_MSGCOD[${phase}]=""
                                FW_OBJECT_PHA_ERRCNT[${phase}]=0
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=0
                                    FW_OBJECT_SET_PHASET["MESSAGE_CODES"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["MESSAGE_CODES"]=""
                                fi ;;
                warning-count)  FW_OBJECT_PHA_WRNCNT[${phase}]=0
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=0
                                fi ;;
            esac ;;
        set)
            case "${type}" in
                error-count)    FW_OBJECT_PHA_ERRCNT[${phase}]=${value}
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["ERROR_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["ERROR_COUNT"]=${value}
                                fi ;;
                warning-count)  FW_OBJECT_PHA_WRNCNT[${phase}]=${value}
                                if [[ "${phase}" == ${FW_OBJECT_SET_VAL["CURRENT_PHASE"]} ]]; then
                                    FW_OBJECT_SET_PHASET["WARNING_COUNT"]="${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}"
                                    FW_OBJECT_SET_VAL["WARNING_COUNT"]=0
                                fi ;;
            esac ;;
    esac
    if [[ "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write fast config; fi
}


function sf_format_ansi(){
    sf_format_ansi_start "${1}"
    printf "%b" "${2}"
    sf_format_ansi_end "${1}"
}


function sf_format_ansi_start(){
    local i formatArray
    IFS=, read -a formatArray <<< "${1}"
    for i in ${!formatArray[@]}; do
        case ${formatArray[$i]} in
            regular)        printf "\e[22;24m" ;;
            regular-fg)     printf "\e[39m" ;;
            regular-bg)     printf "\e[49m" ;;
            reset-line)     printf "\e[2K\e[1000D" ;;

            bold)           printf "\e[1m" ;;   italic)         printf "\e[3m" ;;
            underline)      printf "\e[4m" ;;   blink)          printf "\e[5m" ;;
            inverse)        printf "\e[7m" ;;   hidden)         printf "\e[8m" ;;

            black)          printf "\e[30m" ;;  red)            printf "\e[31m" ;;
            green)          printf "\e[32m" ;;  yellow)         printf "\e[33m" ;;
            blue)           printf "\e[34m" ;;  purple)         printf "\e[35m" ;;
            cyan)           printf "\e[36m" ;;  white)          printf "\e[37m" ;;

            black-hi)       printf "\e[90m" ;;  red-hi)         printf "\e[91m" ;;
            green-hi)       printf "\e[92m" ;;  yellow-hi)      printf "\e[93m" ;;
            blue-hi)        printf "\e[94m" ;;  purple-hi)      printf "\e[95m" ;;
            cyan-hi)        printf "\e[96m" ;;  white-hi)       printf "\e[97m" ;;

            bg-black)       printf "\e[40m" ;;  bg-red)         printf "\e[41m" ;;
            bg-green)       printf "\e[42m" ;;  bg-yellow)      printf "\e[43m" ;;
            bg-blue)        printf "\e[44m" ;;  bg-purple)      printf "\e[45m" ;;
            bg-cyan)        printf "\e[46m" ;;  bg-white)       printf "\e[47m" ;;

            bg-black-hi)    printf "\e[100m" ;; bg-red-hi)      printf "\e[101m" ;;
            bg-green-hi)    printf "\e[102m" ;; bg-yellow-hi)   printf "\e[103m" ;;
            bg-blue-hi)     printf "\e[104m" ;; bg-purple-hi)   printf "\e[105m" ;;
            bg-cyan-hi)     printf "\e[106m" ;; bg-white-hi)    printf "\e[107m" ;;
        esac
    done
}


function sf_format_ansi_end(){
    local i formatArray
    IFS=, read -a formatArray <<< "${1}"
    for i in ${!formatArray[@]}; do
        case ${formatArray[$i]} in
            regular)        printf "\e[22;24m" ;;
            regular-fg)     printf "\e[39m" ;;
            regular-bg)     printf "\e[49m" ;;
#            reset-line)     printf "\e[2K\e[1000D" ;;

            bold)           printf "\e[22m" ;;   italic)        printf "\e[23m" ;;
            underline)      printf "\e[24m" ;;   blink)         printf "\e[25m" ;;
            inverse)        printf "\e[27m" ;;   hidden)        printf "\e[28m" ;;

            black)          printf "\e[39m" ;;  red)            printf "\e[39m" ;;
            green)          printf "\e[39m" ;;  yellow)         printf "\e[39m" ;;
            blue)           printf "\e[39m" ;;  purple)         printf "\e[39m" ;;
            cyan)           printf "\e[39m" ;;  white)          printf "\e[39m" ;;

            black-hi)       printf "\e[39m" ;;  red-hi)         printf "\e[39m" ;;
            green-hi)       printf "\e[39m" ;;  yellow-hi)      printf "\e[39m" ;;
            blue-hi)        printf "\e[39m" ;;  purple-hi)      printf "\e[39m" ;;
            cyan-hi)        printf "\e[39m" ;;  white-hi)       printf "\e[39m" ;;

            bg-black)       printf "\e[49m" ;;  bg-red)         printf "\e[49m" ;;
            bg-green)       printf "\e[49m" ;;  bg-yellow)      printf "\e[49m" ;;
            bg-blue)        printf "\e[49m" ;;  bg-purple)      printf "\e[49m" ;;
            bg-cyan)        printf "\e[49m" ;;  bg-white)       printf "\e[49m" ;;

            bg-black-hi)    printf "\e[49m" ;; bg-red-hi)       printf "\e[49m" ;;
            bg-green-hi)    printf "\e[49m" ;; bg-yellow-hi)    printf "\e[49m" ;;
            bg-blue-hi)     printf "\e[49m" ;; bg-purple-hi)    printf "\e[49m" ;;
            bg-cyan-hi)     printf "\e[49m" ;; bg-white-hi)     printf "\e[49m" ;;
        esac
    done
#    printf "\e[0m"
}


function sf_format_plain(){
    printf "%s" "${2}"
}


function sf_format_adoc(){
    local i formatArray endString=""
    IFS=, read -a formatArray <<< "${1}"
    for i in ${!formatArray[@]}; do
        case ${formatArray[$i]} in
            bold)   printf "*"; endString="*${endString}" ;;
            italic) printf "_"; endString="_${endString}" ;;
        esac
    done
    printf "%s%s" "${2}" "${endString}"
}


function sf_format_mdoc(){
    local i formatArray endString=""
    IFS=, read -a formatArray <<< "${1}"
    for i in ${!formatArray[@]}; do
        case ${formatArray[$i]} in
            bold)       printf "*"; endString="*${endString}" ;;
            italic)     printf "_"; endString="_${endString}" ;;
            black)      printf "<span style=\"color: #000000\">"; endString="</span>${endString}" ;;
            red)        printf "<span style=\"color: #FF0000\">"; endString="</span>${endString}" ;;
            green)      printf "<span style=\"color: #00FF00\">"; endString="</span>${endString}" ;;
            yellow)     printf "<span style=\"color: #A52A2A\">"; endString="</span>${endString}" ;;
            blue)       printf "<span style=\"color: #0000FF\">"; endString="</span>${endString}" ;;
            purple)     printf "<span style=\"color: #800080\">"; endString="</span>${endString}" ;;
            cyan)       printf "<span style=\"color: #00FFFF\">"; endString="</span>${endString}" ;;
            white)      printf "<span style=\"color: #A9A9A9\">"; endString="</span>${endString}" ;;
            black-hi)   printf "<span style=\"color: #A9A9A9\">"; endString="</span>${endString}" ;;
            red-hi)     printf "<span style=\"color: #FF6600\">"; endString="</span>${endString}" ;;
            green-hi)   printf "<span style=\"color: #90EE90\">"; endString="</span>${endString}" ;;
            yellow-hi)  printf "<span style=\"color: #FFFF00\">"; endString="</span>${endString}" ;;
            blue-hi)    printf "<span style=\"color: #5C5CFF\">"; endString="</span>${endString}" ;;
            purple-hi)  printf "<span style=\"color: #B695C0\">"; endString="</span>${endString}" ;;
            cyan-hi)    printf "<span style=\"color: #E0FFFF\">"; endString="</span>${endString}" ;;
            white-hi)   printf "<span style=\"color: #D3D3D3\">"; endString="</span>${endString}" ;;
        esac
    done
    printf "%s%s" "${2}" "${endString}"
}
