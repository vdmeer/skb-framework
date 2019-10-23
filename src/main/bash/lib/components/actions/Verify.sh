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
## Verify - action to verify something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


##https://www.toolsqa.com/software-testing/difference-between-verification-and-validation/


function Verify() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local i id errno status dir file fileText modid modpath fsMode list element command appName
    if [[ -n "${FW_OBJECT_SET_VAL["APP_NAME2"]}" ]]; then appName="${FW_OBJECT_SET_VAL["APP_NAME2"]}"; else appName="${FW_OBJECT_SET_VAL["APP_NAME"]}"; fi

    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in

        elements)
            __skb_internal_verify_01_reset      "${appName}"
            __skb_internal_verify_02_recurse    "${appName}"

            Report process info "${appName}" "writing medium config file"
            if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" != "Load" ]]; then Write medium config; fi
            #Write medium config file ;;
            ;;


        theme)
            Report process info "${appName}" "verifying theme and themeitems"
            if [[ "${FW_OBJECT_TIM_LONG[*]}" != "" ]]; then
                for id in ${!FW_OBJECT_TIM_LONG[@]}; do
                    FW_OBJECT_TIM_STATUS["${id}"]="N"
                    case ${id} in
                        *Char)
                            case ${id} in
                                ## can be 0 (not set) or 1 (set
                                tableBottomruleChar | tableLegendruleChar | tableMidruleChar | tableStatusruleChar | tableTopruleChar | execEndRuleChar | execStartRuleChar | execLineChar | statsFullruleChar | statsHalfruleChar)
                                    if [[ "${#FW_OBJECT_TIM_VAL["${id}"]}" > 1 ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E816 "theme item" "${id}" 1 ${#FW_OBJECT_TIM_VAL["${id}"]}
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    else
                                        FW_OBJECT_TIM_STATUS["${id}"]="S"
                                    fi ;;
                                    ## can be 0 (not set) or anything (set)
                                *)
                                    if [[ ! -n "${FW_OBJECT_TIM_VAL["${id}"]}" ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E815 "theme item" "${id}"
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    elif [[ "${#FW_OBJECT_TIM_VAL["${id}"]}" > 1 ]]; then
                                        Report process error "${FUNCNAME[0]}" "${cmdString1}" E816 "theme item" "${id}" 1 ${#FW_OBJECT_TIM_VAL["${id}"]}
                                        FW_OBJECT_TIM_STATUS["${id}"]="E"
                                    else
                                        FW_OBJECT_TIM_STATUS["${id}"]="S"
                                    fi ;;
                            esac ;;
                        tableBgrndFmt | describeBgrndFmt | listBgrndFmt | execPrjBgrndFmt | execScnBgrndFmt | execScrBgrndFmt | execSitBgrndFmt | execTskBgrndFmt | repeatTskBgrndFmt | repeatScnBgrndFmt | repeatScrBgrndFmt)
                            FW_OBJECT_TIM_STATUS["${id}"]="S" ;;
                        *)
                            if [[ ! -n "${FW_OBJECT_TIM_VAL["${id}"]}" ]]; then
                                Report process error "${FUNCNAME[0]}" "${cmdString1}" E815 "theme item" "${id}"
                                FW_OBJECT_TIM_STATUS["${id}"]="E"
                            else
                                FW_OBJECT_TIM_STATUS["${id}"]="S"
                            fi ;;
                    esac
                done
            fi
            if [[ "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" != "Load" ]]; then Write slow config; fi ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
