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


function __skb_internal_store_build_characters () {
    local format="${1}"

    case "${FW_OBJECT_STO_STORED}" in
        *"characters-${format} "*) ;;

        *)
            FW_OBJECT_STO_CHARS["charModeSet-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementModeYesFmt"]}"    "${FW_OBJECT_TIM_VAL["elementModeYesChar"]}")"
            FW_OBJECT_STO_CHARS["charModeNot-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementModeNoFmt"]}"     "${FW_OBJECT_TIM_VAL["elementModeNoChar"]}")"

            FW_OBJECT_STO_CHARS["charStN-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementStatusNFmt"]}"        "${FW_OBJECT_TIM_VAL["elementStatusNChar"]}")"
            FW_OBJECT_STO_CHARS["charStE-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementStatusEFmt"]}"        "${FW_OBJECT_TIM_VAL["elementStatusEChar"]}")"
            FW_OBJECT_STO_CHARS["charStW-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementStatusWFmt"]}"        "${FW_OBJECT_TIM_VAL["elementStatusWChar"]}")"
            FW_OBJECT_STO_CHARS["charStS-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementStatusSFmt"]}"        "${FW_OBJECT_TIM_VAL["elementStatusSChar"]}")"

            FW_OBJECT_STO_CHARS["charLvlN-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlNotsetFmt"]}"         "${FW_OBJECT_TIM_VAL["phaLvlNotsetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlF-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlFatalSetFmt"]}"       "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlE-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlErrorSetFmt"]}"       "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlX-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlTextSetFmt"]}"        "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlM-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlMessageSetFmt"]}"     "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlW-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlWarningSetFmt"]}"     "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlI-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlInfoSetFmt"]}"        "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlD-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlDebugSetFmt"]}"       "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"
            FW_OBJECT_STO_CHARS["charLvlT-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaLvlTraceSetFmt"]}"       "${FW_OBJECT_TIM_VAL["phaLvlSetChar"]}")"

            FW_OBJECT_STO_CHARS["charPhaCli-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseCLIFmt"]}"           "${FW_OBJECT_TIM_VAL["phaseCLIChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaDef-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseDefaultFmt"]}"       "${FW_OBJECT_TIM_VAL["phaseDefaultChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaEnv-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseEnvFmt"]}"           "${FW_OBJECT_TIM_VAL["phaseEnvChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaFil-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseFileFmt"]}"          "${FW_OBJECT_TIM_VAL["phaseFileChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaLoa-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseLoadFmt"]}"          "${FW_OBJECT_TIM_VAL["phaseLoadChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaPrj-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseProjectFmt"]}"       "${FW_OBJECT_TIM_VAL["phaseProjectChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaScn-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseScenarioFmt"]}"      "${FW_OBJECT_TIM_VAL["phaseScenarioChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaScr-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseScriptFmt"]}"        "${FW_OBJECT_TIM_VAL["phaseScriptChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaShl-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseShellFmt"]}"         "${FW_OBJECT_TIM_VAL["phaseShellChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaSit-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseSiteFmt"]}"          "${FW_OBJECT_TIM_VAL["phaseSiteChar"]}")"
            FW_OBJECT_STO_CHARS["charPhaTsk-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phaseTaskFmt"]}"          "${FW_OBJECT_TIM_VAL["phaseTaskChar"]}")"

            FW_OBJECT_STO_CHARS["charDefY-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementDefYesFmt"]}"        "${FW_OBJECT_TIM_VAL["elementDefYesChar"]}")"
            FW_OBJECT_STO_CHARS["charDefN-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementDefNoFmt"]}"         "${FW_OBJECT_TIM_VAL["elementDefNoChar"]}")"

            FW_OBJECT_STO_CHARS["charExexY-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementExexYesFmt"]}"      "${FW_OBJECT_TIM_VAL["elementExexYesChar"]}")"
            FW_OBJECT_STO_CHARS["charExexN-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["elementExexNoFmt"]}"       "${FW_OBJECT_TIM_VAL["elementExexNoChar"]}")"

            FW_OBJECT_STO_CHARS["charXIsSet-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["xIsSetFmt"]}"             "${FW_OBJECT_TIM_VAL["xIsSetChar"]}")"
            FW_OBJECT_STO_CHARS["charXIsNotSet-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["xIsNotSetFmt"]}"       "${FW_OBJECT_TIM_VAL["xIsNotSetChar"]}")"

            FW_OBJECT_STO_CHARS["charXHasValue-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["xHasValueFmt"]}"       "${FW_OBJECT_TIM_VAL["xHasValueChar"]}")"
            FW_OBJECT_STO_CHARS["charXHasNoValue-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["xHasNoValueFmt"]}"   "${FW_OBJECT_TIM_VAL["xHasNoValueChar"]}")"

            FW_OBJECT_STO_STORED+="characters-${format} "
        ;;
    esac
}



function __skb_internal_store_show_characters () {
    if [[ "${FW_OBJECT_STO_CHARS[*]}" != "" ]]; then
        IFS=" " read -a keys <<< "${!FW_OBJECT_STO_CHARS[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
        for id in "${keys[@]}"; do printf "    %s :: %b\n" "${id}" "${FW_OBJECT_STO_CHARS[${id}]}"; done
        printf "\n"
    else
        printf "    %s\n" "{}"
    fi
}



function __skb_internal_store_build_legends () {
    local format="${1}" legend

    case "${FW_OBJECT_STO_STORED}" in
        *"legends-${format} "*) ;;

        *)
            legend=" - phase:     ${FW_OBJECT_STO_CHARS["charPhaCli-${format}"]} CLI, ${FW_OBJECT_STO_CHARS["charPhaDef-${format}"]} Default (value), ${FW_OBJECT_STO_CHARS["charPhaEnv-${format}"]} Environment, ${FW_OBJECT_STO_CHARS["charPhaFil-${format}"]} File, ${FW_OBJECT_STO_CHARS["charPhaLoa-${format}"]} Load\n"
            legend+="              ${FW_OBJECT_STO_CHARS["charPhaPrj-${format}"]} Project, ${FW_OBJECT_STO_CHARS["charPhaScn-${format}"]} Scenario, ${FW_OBJECT_STO_CHARS["charPhaScr-${format}"]} Script, ${FW_OBJECT_STO_CHARS["charPhaShl-${format}"]} Shell, ${FW_OBJECT_STO_CHARS["charPhaSit-${format}"]} Site, ${FW_OBJECT_STO_CHARS["charPhaTsk-${format}"]} Task\n"
            FW_OBJECT_STO_LEGENDS["phases-${format}"]="${legend}"

            legend=" - status:    ${FW_OBJECT_STO_CHARS["charStN-${format}"]} not-tested, ${FW_OBJECT_STO_CHARS["charStE-${format}"]} error, ${FW_OBJECT_STO_CHARS["charStW-${format}"]} warning, ${FW_OBJECT_STO_CHARS["charStS-${format}"]} success\n"
            FW_OBJECT_STO_LEGENDS["status-${format}"]="${legend}"

            legend=" - mode:      ${FW_OBJECT_STO_CHARS["charModeSet-${format}"]} available, ${FW_OBJECT_STO_CHARS["charModeNot-${format}"]} not available\n"
            FW_OBJECT_STO_LEGENDS["mode-${format}"]="${legend}"

            legend=" - req ◀◀:    $(Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt 0 ␣), $(Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt 10 ␣), $(Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt 500 ␣), $(Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt 10000 ␣)\n"
            FW_OBJECT_STO_LEGENDS["reqin-${format}"]="${legend}"

            legend=" - req ▶▶:    $(Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt 0 ␣), $(Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt 10 ␣), $(Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt 500 ␣), $(Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt 10000 ␣)\n"
            FW_OBJECT_STO_LEGENDS["reqout-${format}"]="${legend}"

            legend=" - levels     ${FW_OBJECT_STO_CHARS["charLvlN-${format}"]} not set, ${FW_OBJECT_STO_CHARS["charLvlF-${format}"]} (F)atal error, ${FW_OBJECT_STO_CHARS["charLvlE-${format}"]} (E)rror, ${FW_OBJECT_STO_CHARS["charLvlX-${format}"]} te(X)t, ${FW_OBJECT_STO_CHARS["charLvlM-${format}"]} (M)essage\n"
            legend+="              ${FW_OBJECT_STO_CHARS["charLvlW-${format}"]} (W)arning, ${FW_OBJECT_STO_CHARS["charLvlI-${format}"]} (I)nfo, ${FW_OBJECT_STO_CHARS["charLvlD-${format}"]} (D)ebug, ${FW_OBJECT_STO_CHARS["charLvlT-${format}"]} (T)race\n"
            FW_OBJECT_STO_LEGENDS["levels-${format}"]="${legend}"

            legend=" - numbers:   warnings: $(Format 4d number numWarning0Fmt numWarning1Fmt numWarning100Fmt numWarning10000Fmt 0 ␣), $(Format 4d number numWarning0Fmt numWarning1Fmt numWarning100Fmt numWarning10000Fmt 10 ␣), $(Format 4d number numWarning0Fmt numWarning1Fmt numWarning100Fmt numWarning10000Fmt 500 ␣), $(Format 4d number numWarning0Fmt numWarning1Fmt numWarning100Fmt numWarning10000Fmt 10000 ␣), errors: $(Format 4d number numError0Fmt numError1Fmt numError100Fmt numError10000Fmt 0 ␣), $(Format 4d number numError0Fmt numError1Fmt numError100Fmt numError10000Fmt 10 ␣), $(Format 4d number numError0Fmt numError1Fmt numError100Fmt numError10000Fmt 500 ␣), $(Format 4d number numError0Fmt numError1Fmt numError100Fmt numError10000Fmt 10000 ␣), messages: $(Format 4d number numMessage0Fmt numMessage1Fmt numMessage100Fmt numMessage10000Fmt 0 ␣), $(Format 4d number numMessage0Fmt numMessage1Fmt numMessage100Fmt numMessage10000Fmt 10 ␣), $(Format 4d number numMessage0Fmt numMessage1Fmt numMessage100Fmt numMessage10000Fmt 500 ␣), $(Format 4d number numMessage0Fmt numMessage1Fmt numMessage100Fmt numMessage10000Fmt 10000 ␣)\n"
            FW_OBJECT_STO_LEGENDS["phase-numbers-${format}"]="${legend}"

            legend=" - show exec: ${FW_OBJECT_STO_CHARS["charExexY-${format}"]} yes, printf "${FW_OBJECT_STO_CHARS["charExexN-${format}"]}" no\n"
            FW_OBJECT_STO_LEGENDS["showexec-${format}"]="${legend}"

            legend=" - def value: ${FW_OBJECT_STO_CHARS["charDefY-${format}"]} yes, ${FW_OBJECT_STO_CHARS["charDefN-${format}"]} no\n"
            FW_OBJECT_STO_LEGENDS["defval-${format}"]="${legend}"

            legend=" - is set:    ${FW_OBJECT_STO_CHARS["charXIsSet-${format}"]} yes, ${FW_OBJECT_STO_CHARS["charXIsNotSet-${format}"]} no\n"
            FW_OBJECT_STO_LEGENDS["isset-${format}"]="${legend}"

            legend=" - has value: ${FW_OBJECT_STO_CHARS["charXHasValue-${format}"]} yes, ${FW_OBJECT_STO_CHARS["charXHasNoValue-${format}"]} no\n"
            FW_OBJECT_STO_LEGENDS["hasvalue-${format}"]="${legend}"

            FW_OBJECT_STO_STORED+="legends-${format} "
        ;;
    esac
}



function __skb_internal_store_show_legends () {
    if [[ "${FW_OBJECT_STO_LEGENDS[*]}" != "" ]]; then
        IFS=" " read -a keys <<< "${!FW_OBJECT_STO_LEGENDS[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
        for id in "${keys[@]}"; do printf "    %s ::\n %b\n" "${id}" "${FW_OBJECT_STO_LEGENDS[${id}]}"; done
        printf "\n"
    else
        printf "    %s\n" "{}"
    fi
}



__skb_internal_store_build_settings () {
    local format="${1}" string mode level phase themeItem

    case "${FW_OBJECT_STO_STORED}" in
        *"settings-${format} "*) ;;

        *)
            for level in ${!FW_OBJECT_LVL_LONG[@]}; do
                FW_OBJECT_STO_SET["level-${level}-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["lvl${level^}Fmt"]}" "${level}")"

                themeItem="${FW_OBJECT_LVL_STRING_THM[${level}]}"
                FW_OBJECT_STO_SET["level-${level}-process-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["rpt${themeItem}LvlFmt"]}" ${level^})"
                FW_OBJECT_STO_SET["level-${level}-application-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["rpt${themeItem}LvlFmt"]}" ${level})"
            done

            for mode in ${!FW_OBJECT_MOD_LONG[@]}; do
                FW_OBJECT_STO_SET["mode-${mode}-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["mode${mode^}Fmt"]}" ${mode})"
            done

            for phase in ${!FW_OBJECT_PHA_LONG[@]}; do
                FW_OBJECT_STO_SET["phase-${phase}-${format}"]="$(__skb_internal_format_${format} "${FW_OBJECT_TIM_VAL["phase${phase}Fmt"]}" "${phase}")"
            done

            FW_OBJECT_STO_STORED+="settings-${format} "
        ;;
    esac
}



__skb_internal_store_show_settings () {
    if [[ "${FW_OBJECT_STO_SET[*]}" != "" ]]; then
        IFS=" " read -a keys <<< "${!FW_OBJECT_STO_SET[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
        for id in "${keys[@]}"; do printf "    %s :: %b\n" "${id}" "${FW_OBJECT_STO_SET[${id}]}"; done
        printf "\n"
    else
        printf "    %s\n" "{}"
    fi
}



__skb_internal_store_build_templates () {
    local format="${1}"

    case "${FW_OBJECT_STO_STORED}" in
        *"templates-${format} "*) ;;

        *)

            FW_OBJECT_STO_STORED+="templates-${format} "
        ;;
    esac
}



__skb_internal_store_show_templates () {
    if [[ "${FW_OBJECT_STO_TEMPLATES[*]}" != "" ]]; then
        IFS=" " read -a keys <<< "${!FW_OBJECT_STO_TEMPLATES[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
        for id in "${keys[@]}"; do printf "    %s ::\n %b\n" "${id}" "${FW_OBJECT_STO_TEMPLATES[${id}]}"; done
        printf "\n"
    else
        printf "    %s\n" "{}"
    fi
}



function __skb_internal_store_clear_format () {
    local format="${1}"

    if [[ "${FW_OBJECT_STO_CHARS[*]}" != "" ]]; then
        remove=""
        for id in ${!FW_OBJECT_STO_CHARS[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
        for id in $remove; do unset FW_OBJECT_STO_CHARS[${id}]; done
    fi
    FW_OBJECT_STO_STORED=${FW_OBJECT_STO_STORED/"characters-${format} "/}

    if [[ "${FW_OBJECT_STO_LEGENDS[*]}" != "" ]]; then
        remove=""
        for id in ${!FW_OBJECT_STO_LEGENDS[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
        for id in $remove; do unset FW_OBJECT_STO_LEGENDS[${id}]; done
    fi
    FW_OBJECT_STO_STORED=${FW_OBJECT_STO_STORED/"legends-${format} "/}

    if [[ "${FW_OBJECT_STO_SET[*]}" != "" ]]; then
        remove=""
        for id in ${!FW_OBJECT_STO_SET[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
        for id in $remove; do unset FW_OBJECT_STO_SET[${id}]; done
    fi
    FW_OBJECT_STO_STORED=${FW_OBJECT_STO_STORED/"settings-${format} "/}

    if [[ "${FW_OBJECT_STO_TEMPLATES[*]}" != "" ]]; then
        remove=""
        for id in ${!FW_OBJECT_STO_TEMPLATES[@]}; do if [[ "${id#*-}" == "${format}" ]]; then remove+=" "$id; fi; done
        for id in $remove; do unset FW_OBJECT_STO_TEMPLATES[${id}]; done
    fi
    FW_OBJECT_STO_STORED=${FW_OBJECT_STO_STORED/"templates-${format} "/}
}

