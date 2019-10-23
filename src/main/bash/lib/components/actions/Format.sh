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
## Format - action to format something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Format() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local themeType id printId count idLength leftMargin rightMargin padding midString longest current width i short value values defValues mode format file parOptions type number numberArr format0 format1 format100 format10000 padChar
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        text)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            __skb_internal_format_${format} "${1}" "${2}" ;;

        4d | ansi | available | defval | element | exec | execution | has-value | help | is-set | list | paragraph | phase | requested | status | table | tagline | themed)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                4d-number)
                    if [[ "${#}" -lt 5 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 5 "$#"; return; fi
                    format0="${1}"; format1="${2}"; format100="${3}"; format10000="${4}"; number="${5}"; padChar=${6:-" "}
                    if [[ "${number}" -gt 9999 ]]; then
                        Format themed text ${format10000} ">>${padChar}${padChar}"
                    elif [[ "${number}" -gt 99 ]]; then
                        Format themed text ${format100} "${padChar}${number}"
                    elif [[ "${number}" -gt 9 ]]; then
                        Format themed text ${format1} "${padChar}${padChar}${number}"
                    elif [[ "${number}" -gt 0 ]]; then
                        Format themed text ${format1} "${padChar}${padChar}${padChar}${number}"
                    else
                        Format themed text ${format0} "${padChar}${padChar}${padChar}${number}"
                    fi ;;

                ansi-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    file="${1}"
                    Test file can read "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case ${format} in
                        ansi)   cat ${file}; return ;;
                        *)      sed -r "${FW_OBJECT_CFG_VAL["PATTERN_REMOVE_ANSI"]}" ${file} ;;
                    esac ;;

                ansi-start)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    if [[ "${format}" == "ansi" ]]; then __skb_internal_format_ansi_start "${1}"; fi ;;

                ansi-end)
                    if [[ "${format}" == "ansi" ]]; then printf "\e[0m"; fi ;;

                element-status)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    id="${1}"
                    Test element status "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    id="$(Get status char ${id})"
                    Format themed text elementStatus${id}Fmt "${id}" ;;

                help-indentation)
                    case "${1:-}" in
                        2)  printf "${FW_OBJECT_TIM_VAL["explainIndent2"]}" ;;
                        3)  printf "${FW_OBJECT_TIM_VAL["explainIndent3"]}" ;;
                        *)  printf "${FW_OBJECT_TIM_VAL["explainIndent1"]}" ;;
                    esac ;;

                execution-line)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    width="${1}"; format="${2}"
                    if [[ -n "${FW_OBJECT_TIM_VAL["${format}Char"]}" ]]; then
                        Format themed text execLineFmt " "
                        Repeat print formatted character $(( width - 2 )) "${FW_OBJECT_TIM_VAL["${format}Char"]}" ${format}Fmt
                        Format themed text execLineFmt " "
                    fi ;;

                available-char)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    if [[ "${2}" == "test" ]]; then
                        printf "${FW_OBJECT_STO_CHARS["charModeSet-${format}"]}"
                    else
                        case "${1}" in
                            *"${2}"*)   printf "${FW_OBJECT_STO_CHARS["charModeSet-${format}"]}" ;;
                            *)          printf "${FW_OBJECT_STO_CHARS["charModeNot-${format}"]}" ;;
                        esac
                    fi ;;
                defval-char)
                    if [[ -n "${1:-}" ]]; then printf "${FW_OBJECT_STO_CHARS["charDefY-${format}"]}"; else printf "${FW_OBJECT_STO_CHARS["charDefN-${format}"]}"; fi ;;
                exec-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    if [[ "${1}" == "y" ]]; then printf "${FW_OBJECT_STO_CHARS["charExexY-${format}"]}"; else printf "${FW_OBJECT_STO_CHARS["charExexN-${format}"]}"; fi ;;
                has-value-char)
                    if [[ -n "${1:-}" ]]; then printf "${FW_OBJECT_STO_CHARS["charXHasValue-${format}"]}"; else printf "${FW_OBJECT_STO_CHARS["charXHasNoValue-${format}"]}"; fi ;;
                is-set-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    if [[ "${1}" == "yes" ]]; then printf "${FW_OBJECT_STO_CHARS["charXIsSet-${format}"]}"; else printf "${FW_OBJECT_STO_CHARS["charXIsNotSet-${format}"]}"; fi ;;
                phase-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    case ${1} in
                        CLI)        printf "${FW_OBJECT_STO_CHARS["charPhaCli-${format}"]}" ;;
                        Default)    printf "${FW_OBJECT_STO_CHARS["charPhaDef-${format}"]}" ;;
                        Env)        printf "${FW_OBJECT_STO_CHARS["charPhaEnv-${format}"]}" ;;
                        File)       printf "${FW_OBJECT_STO_CHARS["charPhaFil-${format}"]}" ;;
                        Load)       printf "${FW_OBJECT_STO_CHARS["charPhaLoa-${format}"]}" ;;
                        Project)    printf "${FW_OBJECT_STO_CHARS["charPhaPrj-${format}"]}" ;;
                        Scenario)   printf "${FW_OBJECT_STO_CHARS["charPhaScn-${format}"]}" ;;
                        Script)     printf "${FW_OBJECT_STO_CHARS["charPhaScr-${format}"]}" ;;
                        Shell)      printf "${FW_OBJECT_STO_CHARS["charPhaShl-${format}"]}" ;;
                        Site)       printf "${FW_OBJECT_STO_CHARS["charPhaSit-${format}"]}" ;;
                        Task)       printf "${FW_OBJECT_STO_CHARS["charPhaTsk-${format}"]}" ;;
                    esac ;;
                status-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    case "${1}" in
                        N)  printf "${FW_OBJECT_STO_CHARS["charStN-${format}"]}" ;;
                        E)  printf "${FW_OBJECT_STO_CHARS["charStE-${format}"]}" ;;
                        W)  printf "${FW_OBJECT_STO_CHARS["charStW-${format}"]}" ;;
                        S)  printf "${FW_OBJECT_STO_CHARS["charStS-${format}"]}" ;;
                    esac ;;

                table-toprule | table-midrule | table-bottomrule | table-legendrule | table-statusrule)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    if [[ ! -n "${FW_OBJECT_TIM_VAL["table${cmd2^}Char"]}" ]]; then return; fi
                    width="${1}"
                    printf " "
                    Repeat print formatted character $(( width - 2 )) "${FW_OBJECT_TIM_VAL["table${cmd2^}Char"]}" table${cmd2^}Fmt
                    printf " \n" ;;

                themed-text)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    id="${1}"; Test existing themeitem id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    __skb_internal_format_${format} "${FW_OBJECT_TIM_VAL[${id}]}" "${2}" ;;

                list-from | paragraph-from | table-extras | table-legend | tagline-for)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        list-from-file | paragraph-from-file)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 1 "$#"; return; fi
                            file="${1}"; Test file can read "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            leftMargin="${2:-4}"; rightMargin="${3:-4}"
                            width=$(( $(tput cols) - leftMargin - rightMargin ))
                            parOptions="w${width}${FW_OBJECT_CFG_VAL["PAR_PARA"]}"
                            if [[ "$cmd1" == "list" ]]; then parOptions="${FW_OBJECT_CFG_VAL["PAR_LIST"]}${parOptions}"; fi
                            padding="$(printf "%*s" ${leftMargin})"
                            ## faster than: sed -e "s/^/${padding}/" <<< $(par ${parOptions} < ${file})
                            par ${parOptions} < ${file} | sed -e "s/^/${padding}/" ;;

                        tagline-for-clioption)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 2 "$#"; return; fi
                            id="${1}"; if [[ "${id:0:1}" == "#" ]]; then id="${id:2}"; fi
                            themeType="${2}"; idLength=${#id}; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-${FW_INSTANCE_CLI_LEN[${id}]}}"; values="${7:-no}"
                            current=$(( 5 + ${#id} ))
                            printf "%*s" ${leftMargin}
                            if [[ -n "${FW_INSTANCE_CLI_LS[${id}]:-}" ]]; then printf "%s" "-"; Format themed text ${themeType}NameFmt "${FW_INSTANCE_CLI_LS[${id}]}"; printf ", "; else printf "    "; fi
                            printf "%s" "--"; Format themed text ${themeType}NameFmt "${id}"
                            if [[ -n "${FW_INSTANCE_CLI_ARG[${id}]:-}" ]]; then printf " "; Format themed text ${themeType}ArgFmt "${FW_INSTANCE_CLI_ARG[${id}]}"; current=$(( current + ${#FW_INSTANCE_CLI_ARG[${id}]} +1 )) ; fi
                            printf "%*s" $(( longest - current + padding -1 ))
                            printf "%s" "${midString}"
                            case ${values} in
                                yes)    Format themed text ${themeType}ValueFmt "${FW_INSTANCE_CLI_SET[${id}]}" ;;
                                *)      Format themed text ${themeType}DescrFmt "${FW_INSTANCE_CLI_LONG[${id}]}" ;;
                            esac ;;

                        tagline-for-option)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 2 "$#"; return; fi
                            id="${1}"; if [[ "${id:0:1}" == "#" ]]; then id="${id:2}"; fi
                            themeType="${2}"; idLength=${#id}; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-${FW_ELEMENT_OPT_LEN[${id}]}}"; values="${7:-no}"
                            current=$(( 5 + ${#id} ))
                            printf "%*s" ${leftMargin}
                            case ${themeType} in
                                describe)   if [[ -n "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then printf "%s" "-"; Format themed text ${themeType}NameFmt "${FW_ELEMENT_OPT_LS[${id}]}"; printf ", "; fi ;;
                                *)          if [[ -n "${FW_ELEMENT_OPT_LS[${id}]:-}" ]]; then printf "%s" "-"; Format themed text ${themeType}NameFmt "${FW_ELEMENT_OPT_LS[${id}]}"; printf ", "; else printf "    "; fi ;;
                            esac
                            printf "%s" "--"; Format themed text ${themeType}NameFmt "${id}"
                            if [[ -n "${FW_ELEMENT_OPT_ARG[${id}]:-}" ]]; then printf " "; Format themed text ${themeType}ArgFmt "${FW_ELEMENT_OPT_ARG[${id}]}"; current=$(( current + ${#FW_ELEMENT_OPT_ARG[${id}]} + 1 )) ; fi
                            printf "%*s" $(( longest - current + padding - 1 ))
                            printf "%s" "${midString}"
                            case ${values} in
                                yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_OPT_SET[${id}]}" ;;
                                *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_OPT_LONG[${id}]}" ;;
                            esac ;;

                        tagline-for-operation)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 2 "$#"; return; fi
                            id="${1}"; themeType="${2}"; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-0}"; values="${7:-no}"; defValues="${8:-no}"
                            printId=${id%%\%*}
                            if (( longest == 0 )); then longest=${#printId}; fi
                            printf "%*s" ${leftMargin}
                            Format themed text explainComponentFmt "${printId}"
                            printf "%*s" $(( longest - ${#printId} + padding ))
                            printf "%s" "${midString}"
                            IFS="%" read -r -a current <<< "${id#*\%}"; unset IFS
                            count=0
                            for value in "${current[@]}"; do
                                if (( count > 0 )); then printf " "; fi
                                case "${value}" in
                                    @*@)    Format themed text explainArgFmt "${value//@/}" ;;
                                    *)      Format themed text explainOperationFmt "${value}" ;;
                                esac
                                count=$(( count + 1 ))
                            done ;;

                        tagline-for-exitcode | \
                        tagline-for-configuration | tagline-for-format | tagline-for-level | tagline-for-message | tagline-for-mode | tagline-for-phase | tagline-for-setting | tagline-for-theme | tagline-for-themeitem | tagline-for-variable | \
                        tagline-for-application | tagline-for-dependency | tagline-for-dirlist | tagline-for-dir | tagline-for-filelist | tagline-for-file | tagline-for-module | tagline-for-parameter | tagline-for-project | tagline-for-scenario | tagline-for-script | tagline-for-site | tagline-for-task | \
                        tagline-for-action | tagline-for-element | tagline-for-instance | tagline-for-object | tagline-for-framework)
                            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E802 2 "$#"; return; fi
                            id="${1}"; themeType="${2}"; idLength=${#id}; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-$idLength}"; values="${7:-no}"; defValues="${8:-no}"
                            printId="${id}"
                            printf "%*s" ${leftMargin}
                            if [[ "${cmd3}" == "exitcode" && "${id:0:1}" == "0" ]]; then printId=" ${id:1:1}"; fi
                            Format themed text ${themeType}NameFmt "${printId}"
                            printf "%*s" $(( longest - ${#id} + padding ))
                            printf "%s" "${midString}"
                            case ${cmd3} in
                                application)    case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_APP_COMMAND[${id}]} ${FW_ELEMENT_APP_ARGS[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_APP_LONG[${id}]}" ;;
                                                esac ;;
                                configuration)  case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_OBJECT_CFG_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_CFG_LONG[${id}]}" ;;
                                                esac ;;
                                dependency)     case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_DEP_COMMAND[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_DEP_LONG[${id}]}" ;;
                                                esac ;;
                                dirlist)        case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_DLS_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_DLS_LONG[${id}]}" ;;
                                                esac ;;
                                dir)            case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_DIR_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_DIR_LONG[${id}]}" ;;
                                                esac;;
                                exitcode)       Format themed text ${themeType}DescrFmt "${FW_INSTANCE_EXC_LONG[${id}]}" ;;
                                filelist)       case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_FLS_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_FLS_LONG[${id}]}" ;;
                                                esac ;;
                                file)           case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_FIL_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_FIL_LONG[${id}]}" ;;
                                                esac;;
                                format)         Format themed text ${themeType}DescrFmt "${FW_OBJECT_FMT_LONG[${id}]}" ;;
                                level)          Format themed text ${themeType}DescrFmt "${FW_OBJECT_LVL_LONG[${id}]}" ;;
                                message)        case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_OBJECT_MSG_TEXT[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_MSG_LONG[${id}]}" ;;
                                                esac;;
                                mode)           Format themed text ${themeType}DescrFmt "${FW_OBJECT_MOD_LONG[${id}]}" ;;
                                module)         case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_MDS_PATH[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_MDS_LONG[${id}]}" ;;
                                                esac ;;
                                phase)          Format themed text ${themeType}DescrFmt "${FW_OBJECT_PHA_LONG[${id}]}" ;;
                                parameter)      case ${defValues} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_PAR_DEFVAL[${id}]}" ;;
                                                    *)      case ${values} in
                                                                yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_PAR_VAL[${id}]}" ;;
                                                                *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_PAR_LONG[${id}]}" ;;
                                                            esac;;
                                                esac ;;
                                project)        case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_PRJ_RDIR[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_PRJ_LONG[${id}]}" ;;
                                                esac ;;
                                scenario)       case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_SCN_PATH_TEXT[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_SCN_LONG[${id}]}" ;;
                                                esac ;;
                                setting)        case ${values} in
                                                    yes)    case ${id} in
                                                                CURRENT_MODE)   printf "${FW_OBJECT_STO_SET["mode-${FW_OBJECT_SET_VAL[${id}]}-${format}"]}" ;;
                                                                CURRENT_PHASE)  printf "${FW_OBJECT_STO_SET["phase-${FW_OBJECT_SET_VAL[${id}]}-${format}"]}" ;;
                                                                LOG_LEVEL)      printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do printf "${FW_OBJECT_STO_SET["level-${i}-${format}"]} "; done ;;
                                                                PRINT_LEVEL)    printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do printf "${FW_OBJECT_STO_SET["level-${i}-${format}"]} ";  done ;;
                                                                *)              Format themed text ${themeType}ValueFmt "${FW_OBJECT_SET_VAL[${id}]}" ;;
                                                            esac ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_SET_LONG[${id}]}" ;;
                                                esac ;;
                                script)         case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_SCR_RDIR[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_SCR_LONG[${id}]}" ;;
                                                esac ;;
                                site)           case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_SIT_RDIR[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_SIT_LONG[${id}]}" ;;
                                                esac ;;
                                task)           case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_TSK_PATH_TEXT[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_TSK_LONG[${id}]}" ;;
                                                esac ;;
                                theme)          Format themed text ${themeType}DescrFmt "${FW_OBJECT_THM_LONG[${id}]}" ;;
                                themeitem)      case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_OBJECT_TIM_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_TIM_LONG[${id}]}" ;;
                                                esac ;;
                                variable)       Format themed text ${themeType}DescrFmt "${FW_OBJECT_VAR_LONG[${id}]}" ;;

                                action | element | instance | object | framework)
                                    Format themed text ${themeType}DescrFmt "${FW_COMPONENTS_TAGLINE[${id}]}" ;;
                            esac ;;


                            table-extras-for)
                                if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 2 "$#"; return; fi
                                type="${1}"; id="${2}"
                                case ${type} in
                                    configuration)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_CFG_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_CFG_DECPHA[${id}]} ;;
                                    format)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_FMT_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_FMT_DECPHA[${id}]} ;;
                                    level)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_LVL_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_LVL_DECPHA[${id}]} ;;

                                    message)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_MSG_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_MSG_DECPHA[${id}]}
                                        text="${FW_OBJECT_MSG_TYPE[${id}]^^}"
                                        printf " %s %s %s " "${text:0:1}" "${FW_OBJECT_MSG_ARGS[${id}]}" "${FW_OBJECT_MSG_CAT[${id}]:0:8}" ;;

                                    mode)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_MOD_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_MOD_DECPHA[${id}]} ;;

                                    phase)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_PHA_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_PHA_DECPHA[${id}]}
                                        printf "  "
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" fatalerror "*) printf "${FW_OBJECT_STO_CHARS["charLvlF-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" error "*)      printf "${FW_OBJECT_STO_CHARS["charLvlE-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" text "*)       printf "${FW_OBJECT_STO_CHARS["charLvlX-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" message "*)    printf "${FW_OBJECT_STO_CHARS["charLvlM-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" warning "*)    printf "${FW_OBJECT_STO_CHARS["charLvlW-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" info "*)       printf "${FW_OBJECT_STO_CHARS["charLvlI-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" debug "*)      printf "${FW_OBJECT_STO_CHARS["charLvlD-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" trace "*)      printf "${FW_OBJECT_STO_CHARS["charLvlT-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        printf "  "
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" fatalerror "*) printf "${FW_OBJECT_STO_CHARS["charLvlF-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" error "*)      printf "${FW_OBJECT_STO_CHARS["charLvlE-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" text "*)       printf "${FW_OBJECT_STO_CHARS["charLvlX-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" message "*)    printf "${FW_OBJECT_STO_CHARS["charLvlM-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" warning "*)    printf "${FW_OBJECT_STO_CHARS["charLvlW-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" info "*)       printf "${FW_OBJECT_STO_CHARS["charLvlI-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" debug "*)      printf "${FW_OBJECT_STO_CHARS["charLvlD-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" trace "*)      printf "${FW_OBJECT_STO_CHARS["charLvlT-${format}"]}" ;; *) printf "${FW_OBJECT_STO_CHARS["charLvlN-${format}"]}" ;; esac
                                        printf "  "; Format 4d number numWarning0Fmt numWarning1Fmt numWarning100Fmt numWarning10000Fmt ${FW_OBJECT_PHA_WRNCNT[${id}]}
                                        printf " ";  Format 4d number numError0Fmt   numError1Fmt   numError100Fmt   numError10000Fmt   ${FW_OBJECT_PHA_ERRCNT[${id}]}
                                        printf " ";  Format 4d number numMessage0Fmt numMessage1Fmt numMessage100Fmt numMessage10000Fmt ${FW_OBJECT_PHA_MSGCODCNT[${id}]} ;;

                                    setting)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_SET_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_SET_DECPHA[${id}]}
                                        printf " "
                                        Format phase char ${FW_OBJECT_SET_PHASET[${id}]} ;;

                                    theme)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_THM_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_THM_DECPHA[${id}]}
                                        ;;

                                    themeitem)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_OBJECT_TIM_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_OBJECT_TIM_DECPHA[${id}]}
                                        printf " "; Format status char ${FW_OBJECT_TIM_STATUS[${id}]}
                                        printf " "; Format themed text tableSourceFmt "${FW_OBJECT_TIM_SOURCE[${id}]}" ;;

                                    variable)
                                        printf "${FW_OBJECT_VAR_CAT[${id}]}"
                                        ;;


                                    application)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_APP_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_APP_DECPHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_APP_ARGNUM[${id}]}"
                                        printf " ";  Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt "${FW_ELEMENT_APP_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_APP_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_APP_PHA[${id}]} ;;

                                    dependency)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DEP_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_DEP_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_DEP_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_DEP_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_DEP_STATUS[${id}]} ;;

                                    dirlist)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DLS_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_DLS_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt "${FW_ELEMENT_DLS_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_DLS_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_DLS_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_DLS_MOD[${id}]}" ;;

                                    dir)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DIR_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_DIR_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt "${FW_ELEMENT_DIR_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_DIR_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_DIR_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_DIR_MOD[${id}]}" ;;

                                    filelist)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FLS_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_FLS_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt "${FW_ELEMENT_FLS_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_FLS_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_FLS_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_FLS_MOD[${id}]}" ;;

                                    file)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FIL_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_FIL_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt numReqin1Fmt numReqin100Fmt numReqin10000Fmt "${FW_ELEMENT_FIL_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_FIL_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_FIL_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_FIL_MOD[${id}]}" ;;

                                    module)
                                        printf "%s" "${FW_ELEMENT_MDS_ACR[${id}]}"
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_MDS_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_MDS_REQOUT_COUNT[${id}]}
                                        printf "  "; Format phase char ${FW_ELEMENT_MDS_DECPHA[${id}]} ;;

                                    option)
                                        Format is-set char "${FW_ELEMENT_OPT_SET[${id}]:-""}"
                                        printf " "; Format has-value char "${FW_ELEMENT_OPT_VAL[${id}]}"
                                        printf " "; if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Exit+Options" ]]; then printf "exit"; else printf "run" ; fi ;;

                                    parameter)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PAR_DECMDS[${id}]}"]}"
                                        printf " ";  Format phase char ${FW_ELEMENT_PAR_DECPHA[${id}]}
                                        printf " ";  Format defval char ${FW_ELEMENT_PAR_DEFVAL[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_PAR_REQIN_COUNT[${id}]:-}"
                                        printf "  "; Format status char ${FW_ELEMENT_PAR_STATUS[${id}]}
                                        printf " ";  Format phase char ${FW_ELEMENT_PAR_PHA[${id}]} ;;

                                    project)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PRJ_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_PRJ_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_PRJ_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_PRJ_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_PRJ_STATUS[${id}]}
                                        printf " ";  Format available char "${FW_ELEMENT_PRJ_MODES[${id}]}" test
                                        printf " ";  Format available char "${FW_ELEMENT_PRJ_MODES[${id}]}" dev
                                        printf " ";  Format available char "${FW_ELEMENT_PRJ_MODES[${id}]}" build
                                        printf " ";  Format available char "${FW_ELEMENT_PRJ_MODES[${id}]}" use
                                        printf "  "; Format exec char ${FW_ELEMENT_PRJ_SHOW_EXEC[${id}]} ;;

                                    scenario)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SCN_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SCN_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_SCN_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_SCN_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_SCN_STATUS[${id}]}
                                        printf " ";  Format available char "${FW_ELEMENT_SCN_MODES[${id}]}" test
                                        printf " ";  Format available char "${FW_ELEMENT_SCN_MODES[${id}]}" dev
                                        printf " ";  Format available char "${FW_ELEMENT_SCN_MODES[${id}]}" build
                                        printf " ";  Format available char "${FW_ELEMENT_SCN_MODES[${id}]}" use
                                        printf "  "; Format exec char ${FW_ELEMENT_SCN_SHOW_EXEC[${id}]} ;;

                                    script)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SCR_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SCR_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_SCR_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_SCR_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_SCR_STATUS[${id}]}
                                        printf " ";  Format available char "${FW_ELEMENT_SCR_MODES[${id}]}" test
                                        printf " ";  Format available char "${FW_ELEMENT_SCR_MODES[${id}]}" dev
                                        printf " ";  Format available char "${FW_ELEMENT_SCR_MODES[${id}]}" build
                                        printf " ";  Format available char "${FW_ELEMENT_SCR_MODES[${id}]}" use
                                        printf "  "; Format exec char ${FW_ELEMENT_SCR_SHOW_EXEC[${id}]} ;;

                                    site)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SIT_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SIT_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_SIT_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_SIT_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_SIT_STATUS[${id}]}
                                        printf " ";  Format available char "${FW_ELEMENT_SIT_MODES[${id}]}" test
                                        printf " ";  Format available char "${FW_ELEMENT_SIT_MODES[${id}]}" dev
                                        printf " ";  Format available char "${FW_ELEMENT_SIT_MODES[${id}]}" build
                                        printf " ";  Format available char "${FW_ELEMENT_SIT_MODES[${id}]}" use
                                        printf "  "; Format exec char ${FW_ELEMENT_SIT_SHOW_EXEC[${id}]} ;;

                                    task)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_TSK_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_TSK_DECPHA[${id}]}
                                        printf " ";  Format 4d number numReqin0Fmt  numReqin1Fmt  numReqin100Fmt  numReqin10000Fmt "${FW_ELEMENT_TSK_REQIN_COUNT[${id}]:-}"
                                        printf " ";  Format 4d number numReqout0Fmt numReqout1Fmt numReqout100Fmt numReqout10000Fmt ${FW_ELEMENT_TSK_REQOUT_COUNT[${id}]}
                                        printf "  "; Format status char ${FW_ELEMENT_TSK_STATUS[${id}]}
                                        printf " ";  Format available char "${FW_ELEMENT_TSK_MODES[${id}]}" test
                                        printf " ";  Format available char "${FW_ELEMENT_TSK_MODES[${id}]}" dev
                                        printf " ";  Format available char "${FW_ELEMENT_TSK_MODES[${id}]}" build
                                        printf " ";  Format available char "${FW_ELEMENT_TSK_MODES[${id}]}" use
                                        printf "  "; Format exec char ${FW_ELEMENT_TSK_SHOW_EXEC[${id}]} ;;


                                    clioption)
                                        Format is-set char "${FW_OBJECT_CLI_SET[${id}]:-""}"
                                        printf " "; Format has-value char "${FW_OBJECT_CLI_VAL[${id}]}" ;;
                                    exitcode)
                                        ;;

                                    action)
                                        ;;
                                    element)
                                        ;;
                                    instance)
                                        ;;
                                    object)
                                        ;;
                                esac ;;


                            table-legend-for)
                                if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                                type="${1}"
                                case ${type} in
                                    configuration)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    format)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    level)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    message)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (T) type, (A) number of arguments, Category of message\n"
                                        printf " - type:      E  error, W warning, M message, X text, I info, D debug, T trace\n" ;;
                                    mode)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    phase)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              print level and log level as FEXMWIDT\n"
                                        printf "              number of warnings (WRN) and errors (ERR)\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["levels-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["phase-numbers-${format}"]}" ;;
                                    setting)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase, (P) set in phase\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}" ;;
                                    theme)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    themeitem)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase, (S)tatus\n"
                                        printf "              Source-Theme - source for item setting, short theme ID\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}" ;;
                                    variable)
                                        ;;

                                    application)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (A) number of arguments, (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}" ;;
                                    dependency)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (REQ) number of requirements, (R) requested, (S) status\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqout-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}" ;;
                                    dir | dirlist | file | filelist)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}"
                                        printf " - modes:     (r) read, (w) write, (x) execute, (c) create, (d) delete, (-) not set\n" ;;
                                    module)
                                        printf " properties:  (SH) acronym, (REQ) number of requirements, (P) set in phase\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqout-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}" ;;
                                    option)
                                        printf " properties:  (I) option is set, (H) option has value, Type category\n"
                                        printf " - types:     Exit - exit option, Run - runtime option\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["isset-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["hasvalue-${format}"]}" ;;
                                    parameter)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (D) default value, (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["defval-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}" ;;
                                    project | scenario | script | site | task)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase, (RQ) in / out, (S)tatus\n"
                                        printf "              (T)est mode, (D)evelopment mode, (B)uild mode, (U)se mode, (X) show execution\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["phases-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqin-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["reqout-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["status-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["mode-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["showexec-${format}"]}" ;;

                                    clioption)
                                        printf " properties:  (I) option is set, (H) option has value\n"
                                        printf "${FW_OBJECT_STO_LEGENDS["isset-${format}"]}"
                                        printf "${FW_OBJECT_STO_LEGENDS["hasvalue-${format}"]}" ;;

                                    exitcode)
                                        ;;

                                    action)
                                        ;;
                                    element)
                                        ;;
                                    instance)
                                        ;;
                                    object)
                                        ;;
                                esac ;;


                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}



## - bash print settings, e.g colors and effects
## - https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
## - see http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
## - see https://stackoverflow.com/questions/4332478/read-the-current-text-color-in-a-xterm/4332530#4332530
## - see https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux#5947802
## - see https://stackoverflow.com/questions/4414297/unix-bash-script-to-embolden-underline-italicize-specific-text
## - see https://raw.githubusercontent.com/demure/dotfiles/master/subbash/prompt

#padding
#https://stackoverflow.com/questions/4409399/padding-characters-in-printf
#https://wiki.bash-hackers.org/commands/builtin/printf#modifiers
