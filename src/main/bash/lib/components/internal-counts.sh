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
## internal / counts - internal functions called by the API, managing counts
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_internal_alter_phase_counts () {
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
