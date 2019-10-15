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
## Tablechars - instance that maintains cached table characters
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Tablechars() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id keys element format remove
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in

        build)
            case "${FW_INSTANCE_TABLE_CHARS_BUILT}" in
                *" ${format} "*)
                    ;;
                *)
                    FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]="$(Format themed text elementReqYesFmt "${FW_OBJECT_TIM_VAL["elementReqYesChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]="$(Format themed text elementReqNoFmt  "${FW_OBJECT_TIM_VAL["elementReqNoChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]="$(Format themed text elementModeYesFmt "${FW_OBJECT_TIM_VAL["elementModeYesChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]="$(Format themed text elementModeNoFmt  "${FW_OBJECT_TIM_VAL["elementModeNoChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charStN-${format}"]="$(Format themed text elementStatusNFmt "${FW_OBJECT_TIM_VAL["elementStatusNChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charStE-${format}"]="$(Format themed text elementStatusEFmt "${FW_OBJECT_TIM_VAL["elementStatusEChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charStW-${format}"]="$(Format themed text elementStatusWFmt "${FW_OBJECT_TIM_VAL["elementStatusWChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charStS-${format}"]="$(Format themed text elementStatusSFmt "${FW_OBJECT_TIM_VAL["elementStatusSChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]="$(Format themed text phaLvlNotsetFmt     "${FW_OBJECT_TIM_VAL["phaLvlNotsetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]="$(Format themed text phaLvlFatalSetFmt   "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlE-${format}"]="$(Format themed text phaLvlErrorSetFmt   "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlX-${format}"]="$(Format themed text phaLvlTextSetFmt    "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlM-${format}"]="$(Format themed text phaLvlMessageSetFmt "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlW-${format}"]="$(Format themed text phaLvlWarningSetFmt "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlI-${format}"]="$(Format themed text phaLvlInfoSetFmt    "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlD-${format}"]="$(Format themed text phaLvlDebugSetFmt   "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charLvlT-${format}"]="$(Format themed text phaLvlTraceSetFmt   "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]="$(Format themed text phaseCLIFmt       "${FW_OBJECT_TIM_VAL["phaseCLIChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]="$(Format themed text phaseDefaultFmt   "${FW_OBJECT_TIM_VAL["phaseDefaultChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]="$(Format themed text phaseEnvFmt       "${FW_OBJECT_TIM_VAL["phaseEnvChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]="$(Format themed text phaseFileFmt      "${FW_OBJECT_TIM_VAL["phaseFileChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]="$(Format themed text phaseLoadFmt      "${FW_OBJECT_TIM_VAL["phaseLoadChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]="$(Format themed text phaseProjectFmt   "${FW_OBJECT_TIM_VAL["phaseProjectChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]="$(Format themed text phaseScenarioFmt  "${FW_OBJECT_TIM_VAL["phaseScenarioChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaScr-${format}"]="$(Format themed text phaseScriptFmt    "${FW_OBJECT_TIM_VAL["phaseScriptChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]="$(Format themed text phaseShellFmt     "${FW_OBJECT_TIM_VAL["phaseShellChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]="$(Format themed text phaseSiteFmt      "${FW_OBJECT_TIM_VAL["phaseSiteChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]="$(Format themed text phaseTaskFmt      "${FW_OBJECT_TIM_VAL["phaseTaskChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charDefY-${format}"]="$(Format themed text elementDefYesFmt "${FW_OBJECT_TIM_VAL["elementDefYesChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charDefN-${format}"]="$(Format themed text elementDefNoFmt  "${FW_OBJECT_TIM_VAL["elementDefNoChar"]}")"

                    FW_INSTANCE_TABLE_CHARS["charExexY-${format}"]="$(Format themed text elementExexYesFmt "${FW_OBJECT_TIM_VAL["elementExexYesChar"]}")"
                    FW_INSTANCE_TABLE_CHARS["charExexN-${format}"]="$(Format themed text elementExexNoFmt  "${FW_OBJECT_TIM_VAL["elementExexNoChar"]}")"

                    local legend
                    legend=" - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File, ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load\n"
                    legend+="              ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaScr-${format}"]} Script, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]="${legend}"

                    legend=" - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]="${legend}"

                    legend=" - mode:      ${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} available, ${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} not available\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-mode-${format}"]="${legend}"

                    legend=" - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]} no\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]="${legend}"

                    legend=" - levels     ${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]} not set, ${FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]} (F)atal error, ${FW_INSTANCE_TABLE_CHARS["charLvlE-${format}"]} (E)rror, ${FW_INSTANCE_TABLE_CHARS["charLvlX-${format}"]} te(X)t, ${FW_INSTANCE_TABLE_CHARS["charLvlM-${format}"]} (M)essage\n"
                    legend+="              ${FW_INSTANCE_TABLE_CHARS["charLvlW-${format}"]} (W)arning, ${FW_INSTANCE_TABLE_CHARS["charLvlI-${format}"]} (I)nfo, ${FW_INSTANCE_TABLE_CHARS["charLvlD-${format}"]} (D)ebug, ${FW_INSTANCE_TABLE_CHARS["charLvlT-${format}"]} (T)race\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-levels-${format}"]="${legend}"

                    legend=" - numbers:   $(Format themed text phaWarnNumberFmt 111) warnings, $(Format themed text phaErrNumberFmt 222) errors, $(Format themed text phaMsgNumberFmt 333) message count\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-numbers-${format}"]="${legend}"

                    legend=" - show exec: ${FW_INSTANCE_TABLE_CHARS["charExexY-${format}"]} yes, printf "${FW_INSTANCE_TABLE_CHARS["charExexN-${format}"]}" no\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-showexec-${format}"]="${legend}"

                    legend=" - def value: ${FW_INSTANCE_TABLE_CHARS["charDefY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charDefN-${format}"]} no\n"
                    FW_INSTANCE_TABLE_STRINGS["legend-defval-${format}"]="${legend}"

                    FW_INSTANCE_TABLE_CHARS_BUILT+="${format} " ;;
            esac ;;

        formats)
            echo "${FW_INSTANCE_TABLE_CHARS_BUILT}" ;;

        get)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            if [[ -z "${FW_INSTANCE_TABLE_CHARS["${id}-${format}"]:-}" ]]; then Tablechars build; fi
            printf "${FW_INSTANCE_TABLE_CHARS["${id}-${format}"]:-}" ;;

        has)
            echo " ${!FW_INSTANCE_TABLE_CHARS[@]} " ;;

        list)
            if [[ "${FW_INSTANCE_TABLE_CHARS[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_INSTANCE_TABLE_CHARS[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do printf "    %s :: %s\n" "${id}" "${FW_INSTANCE_TABLE_CHARS[${id}]}"; done
                printf "\n"
                IFS=" " read -a keys <<< "${!FW_INSTANCE_TABLE_STRINGS[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do printf "${FW_INSTANCE_TABLE_STRINGS[${id}]}"; done
            else
                printf "    %s\n" "{}"
            fi ;;

        clear)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                clear-all)
                    declare -A -g FW_INSTANCE_TABLE_CHARS FW_INSTANCE_TABLE_STRINGS
                    FW_INSTANCE_TABLE_CHARS_BUILT=" " ;;

                clear-format)
                    if [[ "${FW_INSTANCE_TABLE_CHARS[*]}" != "" ]]; then
                        remove=""
                        for id in ${!FW_INSTANCE_TABLE_CHARS[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
                        for id in $remove; do unset FW_INSTANCE_TABLE_CHARS[${id}]; done
                    fi
                    if [[ "${FW_INSTANCE_TABLE_STRINGS[*]}" != "" ]]; then
                        remove=""
                        for id in ${!FW_INSTANCE_TABLE_STRINGS[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
                        for id in $remove; do unset FW_INSTANCE_TABLE_STRINGS[${id}]; done
                    fi
                    FW_INSTANCE_TABLE_CHARS_BUILT=${FW_INSTANCE_TABLE_CHARS_BUILT/"${format} "/} ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
