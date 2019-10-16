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
## internal / levels - internal functions called by the API, managing levels
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_internal_set_phase_level () {
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


function __skb_internal_deac_phase_level () {
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
