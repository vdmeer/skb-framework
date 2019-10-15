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

    local themeType id printId count idLength leftMargin rightMargin padding midString longest current width i short value values defValues mode format file parOptions type number numberArr
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        text)
            if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 2 "$#"; return; fi
            sf_format_${format} "${1}" "${2}" ;;

        level)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"; Test existing level id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            Format themed text lvl${id^}Fmt "${id}" ;;

        mode)
            id="${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
            if [[ "${#}" == 1 ]]; then id="${1}"; fi
            Test existing mode id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            Format themed text mode${id^}Fmt "${id}" ;;

        ansi | available | defval | element | exec | execution | help | list | paragraph | phase | requested | status | table | tagline | themed)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                ansi-file)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    file="${1}"
                    Test file can read "${file}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    case ${format} in
                        ansi)   printf "%b\n" "$(cat ${file})"; return ;;
                        *)      printf "%b\n" "$(cat ${file})" | sed -r "${FW_OBJECT_CFG_VAL["PATTERN_REMOVE_ANSI"]}" ;;
                    esac ;;

                ansi-start)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    if [[ "${format}" == "ansi" ]]; then sf_format_ansi_start "${1}"; fi ;;

                ansi-end)
                    printf "\e[0m" ;;

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
                        printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]}"
                    else
                        case ${1} in
                            all | ${2}) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]}" ;;
                            *)          printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]}" ;;
                        esac
                    fi ;;

                defval-char)
                    if [[ -n "${1:-}" ]]; then printf "${FW_INSTANCE_TABLE_CHARS["charDefY-${format}"]}"; else printf "${FW_INSTANCE_TABLE_CHARS["charDefN-${format}"]}"; fi ;;

                exec-char)
                    if [[ "${1}" == "y" ]]; then printf "${FW_INSTANCE_TABLE_CHARS["charExexY-${format}"]}"; else printf "${FW_INSTANCE_TABLE_CHARS["charExexN-${format}"]}"; fi ;;

                phase-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    case ${1} in
                        CLI)        printf "${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}" ;;
                        Default)    printf "${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}" ;;
                        Env)        printf "${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}" ;;
                        File)       printf "${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}" ;;
                        Load)       printf "${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}" ;;
                        Project)    printf "${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}" ;;
                        Scenario)   printf "${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}" ;;
                        Script)     printf "${FW_INSTANCE_TABLE_CHARS["charPhaScr-${format}"]}" ;;
                        Shell)      printf "${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}" ;;
                        Site)       printf "${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}" ;;
                        Task)       printf "${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}" ;;
                    esac ;;

                requested-char)
                    if [[ -n "${1:-}" ]]; then printf "${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf "${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi ;;

                status-char)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    case "${1}" in
                        N)  printf "${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}" ;;
                        E)  printf "${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}" ;;
                        W)  printf "${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}" ;;
                        S)  printf "${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}" ;;
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
                    sf_format_${format} "${FW_OBJECT_TIM_VAL[${id}]}" "${2}" ;;

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
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_DEP_CMD[${id}]}" ;;
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
                                                                CURRENT_MODE)   Format mode "${FW_OBJECT_SET_VAL[${id}]}" ;;
                                                                LOG_LEVEL)      printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do Format level "${i}"; printf " "; done ;;
                                                                PRINT_LEVEL)    printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do Format level "${i}"; printf " ";  done ;;
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
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" fatalerror "*) printf "${FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" error "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlE-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" text "*)       printf "${FW_INSTANCE_TABLE_CHARS["charLvlX-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" message "*)    printf "${FW_INSTANCE_TABLE_CHARS["charLvlM-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" warning "*)    printf "${FW_INSTANCE_TABLE_CHARS["charLvlW-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" info "*)       printf "${FW_INSTANCE_TABLE_CHARS["charLvlI-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" debug "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlD-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" trace "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlT-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        printf "  "
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" fatalerror "*) printf "${FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" error "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlE-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" text "*)       printf "${FW_INSTANCE_TABLE_CHARS["charLvlX-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" message "*)    printf "${FW_INSTANCE_TABLE_CHARS["charLvlM-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" warning "*)    printf "${FW_INSTANCE_TABLE_CHARS["charLvlW-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" info "*)       printf "${FW_INSTANCE_TABLE_CHARS["charLvlI-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" debug "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlD-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        case ${FW_OBJECT_PHA_LOG_LVL[${id}]} in *" trace "*)      printf "${FW_INSTANCE_TABLE_CHARS["charLvlT-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
                                        printf "  "
                                        ## faster print than printf "%3s"
                                        if (( ${FW_OBJECT_PHA_WRNCNT[${id}]} < 99 )); then printf " "; fi
                                        if (( ${FW_OBJECT_PHA_WRNCNT[${id}]} < 9 )); then printf " "; fi
                                        Format themed text phaWarnNumberFmt ${FW_OBJECT_PHA_WRNCNT[${id}]}
                                        printf " "
                                        ## faster print than printf "%3s"
                                        if (( ${FW_OBJECT_PHA_ERRCNT[${id}]} < 99 )); then printf " "; fi
                                        if (( ${FW_OBJECT_PHA_ERRCNT[${id}]} < 9 )); then printf " "; fi
                                        Format themed text phaErrNumberFmt ${FW_OBJECT_PHA_ERRCNT[${id}]}
                                        printf " "
                                        ## faster print than printf "%3s"
                                        IFS=" " read -a numberArr <<< "${FW_OBJECT_PHA_MSGCOD[${id}]}"; unset IFS
                                        number="${#numberArr[@]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text phaMsgNumberFmt ${number} ;;

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
                                        printf " "; Format themed text tableSourceFmt "${FW_OBJECT_TIM_SOURCE[${id}]}" ;;

                                    variable)
                                        printf "${FW_OBJECT_VAR_CAT[${id}]}"
                                        ;;


                                    application)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_APP_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_APP_DECPHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_APP_ARGNUM[${id}]}"

                                        printf " "; Format requested char "${FW_ELEMENT_APP_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_APP_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_APP_PHA[${id}]} ;;

                                    dependency)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DEP_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_DEP_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_DEP_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format requested char "${FW_ELEMENT_DEP_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_DEP_STATUS[${id}]} ;;

                                    dirlist)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DLS_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_DLS_DECPHA[${id}]}
                                        printf " "; Format requested char "${FW_ELEMENT_DLS_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_DLS_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_DLS_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_DLS_MOD[${id}]}" ;;

                                    dir)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DIR_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_DIR_DECPHA[${id}]}
                                        printf " "; Format requested char "${FW_ELEMENT_DIR_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_DIR_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_DIR_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_DIR_MOD[${id}]}" ;;

                                    filelist)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FLS_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_FLS_DECPHA[${id}]}
                                        printf " "; Format requested char "${FW_ELEMENT_FLS_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_FLS_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_FLS_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_FLS_MOD[${id}]}" ;;

                                    file)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FIL_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_FIL_DECPHA[${id}]}
                                        printf " "; Format requested char "${FW_ELEMENT_FIL_REQUESTED[${id}]:-""}"
                                        printf " "; Format status char ${FW_ELEMENT_FIL_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_FIL_PHA[${id}]}
                                        printf " %s" "${FW_ELEMENT_FIL_MOD[${id}]}" ;;

                                    module)
                                        printf "%s" "${FW_ELEMENT_MDS_ACR[${id}]}"
                                        printf " "
                                        number="${FW_ELEMENT_MDS_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format phase char ${FW_ELEMENT_MDS_DECPHA[${id}]} ;;

                                    option)
                                        if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Exit+Options" ]]; then printf "exit"; else printf "run" ; fi ;;

                                    parameter)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PAR_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_PAR_DECPHA[${id}]}
                                        printf " "; Format defval char ${FW_ELEMENT_PAR_DEFVAL[${id}]}
                                        printf " "; Format requested char ${FW_ELEMENT_PAR_REQUESTED[${id}]}
                                        printf " "; Format status char ${FW_ELEMENT_PAR_STATUS[${id}]}
                                        printf " "; Format phase char ${FW_ELEMENT_PAR_PHA[${id}]} ;;

                                    project)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PRJ_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_PRJ_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_PRJ_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format exec char ${FW_ELEMENT_PRJ_SHOW_EXEC[${id}]}
                                        printf " "; Format status char ${FW_ELEMENT_PRJ_STATUS[${id}]}
                                        printf " "; Format available char ${FW_ELEMENT_PRJ_MODES[${id}]} test
                                        printf " "; Format available char ${FW_ELEMENT_PRJ_MODES[${id}]} dev
                                        printf " "; Format available char ${FW_ELEMENT_PRJ_MODES[${id}]} build
                                        printf " "; Format available char ${FW_ELEMENT_PRJ_MODES[${id}]} use ;;

                                    scenario)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SCN_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SCN_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_SCN_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format exec char ${FW_ELEMENT_SCN_SHOW_EXEC[${id}]}
                                        printf " "; Format status char ${FW_ELEMENT_SCN_STATUS[${id}]}
                                        printf " "; Format available char ${FW_ELEMENT_SCN_MODES[${id}]} test
                                        printf " "; Format available char ${FW_ELEMENT_SCN_MODES[${id}]} dev
                                        printf " "; Format available char ${FW_ELEMENT_SCN_MODES[${id}]} build
                                        printf " "; Format available char ${FW_ELEMENT_SCN_MODES[${id}]} use ;;

                                    script)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SCR_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SCR_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_SCR_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format exec char ${FW_ELEMENT_SCR_SHOW_EXEC[${id}]} ;;

                                    site)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SIT_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_SIT_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_SIT_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format exec char ${FW_ELEMENT_SIT_SHOW_EXEC[${id}]} ;;

                                    task)
                                        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_TSK_DECMDS[${id}]}"]}"
                                        printf " "; Format phase char ${FW_ELEMENT_TSK_DECPHA[${id}]}
                                        printf " "
                                        number="${FW_ELEMENT_TSK_REQNUM[${id}]}"
                                        if (( ${number} < 99 )); then printf " "; fi
                                        if (( ${number} < 9 )); then printf " "; fi
                                        Format themed text tableReqNumberFmt ${number}
                                        printf " "; Format exec char ${FW_ELEMENT_TSK_SHOW_EXEC[${id}]}
                                        printf " "; Format requested char ${FW_ELEMENT_TSK_REQUESTED[${id}]}
                                        printf " "; Format status char ${FW_ELEMENT_TSK_STATUS[${id}]}
                                        printf " "; Format available char ${FW_ELEMENT_TSK_MODES[${id}]} test
                                        printf " "; Format available char ${FW_ELEMENT_TSK_MODES[${id}]} dev
                                        printf " "; Format available char ${FW_ELEMENT_TSK_MODES[${id}]} build
                                        printf " "; Format available char ${FW_ELEMENT_TSK_MODES[${id}]} use ;;


                                    clioption)
                                        ;;
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
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-levels-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-numbers-${format}"]}" ;;
                                    setting)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase, (P) set in phase\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}" ;;
                                    theme)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n" ;;
                                    themeitem)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              Src - source for item setting, short theme ID\n" ;;
                                    variable)
                                        ;;

                                    application)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (A) number of arguments, (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}" ;;
                                    dependency)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (REQ) number of requirements, (R) requested, (S) status\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}" ;;
                                    dir | dirlist | file | filelist)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}"
                                        printf " - modes:     (r) read, (w) write, (x) execute, (c) create, (d) delete, (-) not set\n" ;;
                                    module)
                                        printf " properties:  (SH) acronym, (REQ) number of requirements, (P) set in phase\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}" ;;
                                    option)
                                        printf " types: Exit - exit option, Run - runtime option\n" ;;
                                    parameter)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (D) default value, (R) requested, (S) status, (P) set in phase\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-defval-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}" ;;
                                    project | scenario)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase, (S)tatus\n"
                                        printf "              (REQ) number of requirements, (T)est mode, (D)evelopment mode, (B)uild mode, (U)se mode\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-showexec-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-mode-${format}"]}" ;;
                                    script)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (REQ) number of requirements, (X) show execution\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-showexec-${format}"]}" ;;
                                    site)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (REQ) number of requirements, (X) show execution\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-showexec-${format}"]}" ;;
                                    task)
                                        printf " properties:  (MD/P) declaring MOdule (acronym) and Phase\n"
                                        printf "              (REQ) number of requirements, (X) show execution, (R)equested, (S)tatus\n"
                                        printf "              (T)est mode, (D)evelopment mode, (B)uild mode, (U)se mode\n"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-phases-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-showexec-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-requested-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-status-${format}"]}"
                                        printf "${FW_INSTANCE_TABLE_STRINGS["legend-mode-${format}"]}" ;;

                                    clioption)
                                        ;;
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
