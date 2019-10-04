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


FW_COMPONENTS_TAGLINE["format"]="action to format something"


function Format() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local themeType id printId idLength leftMargin rightMargin padding midString longest current width i char short value values defValues mode format file parOptions
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        text)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return
            elif [[ "${#}" == 1 ]]; then format_${format} ""     "${1}"
            elif [[ "${#}" == 2 ]]; then format_${format} "${1}" "${2}"
#            elif [[ "${#}" == 3 ]]; then format_${1} "${2}" "${3}"
            else Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi ;;
## TODO wrong error message, need too many

        level)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            id="${1}"
            Test level "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            Format themed text lvl${id^}Fmt "${id}" ;;

        ansi | current | element | help | list | paragraph | table | tagline | themed)
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

                current-mode)
                    id="${FW_OBJECT_SET_VAL["CURRENT_MODE"]}"
                    if [[ "${#}" == 1 ]]; then id="${1}"; fi
                    Test current mode "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Format themed text mode${id^}Fmt "${id}" ;;

                element-status)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
                    id="${1}"
                    Test element status "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                    Format themed text elementStatus${id}Fmt "${id}" ;;

                help-indentation)
                    case "${1:-}" in
                        2)  printf "${FW_OBJECT_TIM_VAL["explainIndent2"]}" ;;
                        3)  printf "${FW_OBJECT_TIM_VAL["explainIndent3"]}" ;;
                        *)  printf "${FW_OBJECT_TIM_VAL["explainIndent1"]}" ;;
                    esac ;;

                table-topline)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    width="${1}"; width=$(( width - 2 ))
                    char="$(Format themed text tabTopruleFmt "${FW_OBJECT_TIM_VAL["tabTopruleChar"]}")"
                    printf " "
                    for ((i = 1; i <= ${width}; i++)); do
                        printf "%s" "${char}"
                    done
                    printf "\n" ;;

                table-midline)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    width="${1}"; width=$(( width - 2 ))
                    char="$(Format themed text tabMidruleFmt "${FW_OBJECT_TIM_VAL["tabMidruleChar"]}")"
                    printf " "
                    for ((i = 1; i <= ${width}; i++)); do
                        printf "%s" "${char}"
                    done
                    printf "\n" ;;

                table-bottomline)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    width="${1}"; width=$(( width - 2 ))
                    char="$(Format themed text tabBottomruleFmt "${FW_OBJECT_TIM_VAL["tabBottomruleChar"]}")"
                    printf " "
                    for ((i = 1; i <= ${width}; i++)); do
                        printf "%s" "${char}"
                    done
                    printf "\n" ;;

                themed-text)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E802 2 "$#"; return
                    elif [[ "${#}" == 2 ]]; then format_${format} "${FW_OBJECT_TIM_VAL[${1}]}" "${2}"
#                    elif [[ "${#}" == 3 ]]; then format_${1} "${FW_OBJECT_TIM_VAL[${2}]}" "${3}"
                    else Report process error "${FUNCNAME[0]}" "${cmdString1}" E802 1 "$#"; return; fi ;;
## TODO wrong error message, need too many

                list-from | paragraph-from | tagline-for)
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
                            id="${1}"; themeType="${2}"; idLength=${#id}; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-${FW_INSTANCE_CLI_LEN[${id}]}}"; values="${7:-no}"
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
                            id="${1}"; themeType="${2}"; idLength=${#id}; leftMargin="${3:-4}"; padding="${4:-2}"; midString="${5:-""}"; longest="${6:-${FW_ELEMENT_OPT_LEN[${id}]}}"; values="${7:-no}"
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


                        tagline-for-exitcode | \
                        tagline-for-configuration | tagline-for-format | tagline-for-level | tagline-for-message | tagline-for-mode | tagline-for-phase | tagline-for-setting | tagline-for-theme | tagline-for-themeitem | \
                        tagline-for-application | tagline-for-dependency | tagline-for-dirlist | tagline-for-dir | tagline-for-filelist | tagline-for-file | tagline-for-module | tagline-for-parameter | tagline-for-project | tagline-for-scenario | tagline-for-site | tagline-for-task | \
                        tagline-for-action | tagline-for-element | tagline-for-instance | tagline-for-object)

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
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_PRJ_FILE[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_PRJ_LONG[${id}]}" ;;
                                                esac ;;
                                scenario)       case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_SCN_PATH_TEXT[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_SCN_LONG[${id}]}" ;;
                                                esac ;;
                                setting)        case ${values} in
                                                    yes)    case ${id} in
                                                                CURRENT_MODE)   Format current mode "${FW_OBJECT_SET_VAL[${id}]}" ;;
                                                                LOG_LEVEL)      printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do Format level "${i}"; printf " "; done ;;
                                                                PRINT_LEVEL)    printf " "; for i in ${FW_OBJECT_SET_VAL[${id}]}; do Format level "${i}"; printf " ";  done ;;
                                                                *)              Format themed text ${themeType}ValueFmt "${FW_OBJECT_SET_VAL[${id}]}" ;;
                                                            esac ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_SET_LONG[${id}]}" ;;
                                                esac ;;
                                site)           case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_SIT_FILE[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_SIT_LONG[${id}]}" ;;
                                                esac ;;
                                task)           case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_ELEMENT_TSK_PATH_TEXT[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_ELEMENT_TSK_LONG[${id}]}" ;;
                                                esac ;;
                                theme)          case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_OBJECT_THM_PATH[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_THM_LONG[${id}]}" ;;
                                                esac ;;
                                themeitem)      case ${values} in
                                                    yes)    Format themed text ${themeType}ValueFmt "${FW_OBJECT_TIM_VAL[${id}]}" ;;
                                                    *)      Format themed text ${themeType}DescrFmt "${FW_OBJECT_TIM_LONG[${id}]}" ;;
                                                esac ;;

                                action | element | instance | object)
                                    Format themed text ${themeType}DescrFmt "${FW_COMPONENTS_TAGLINE[${id,,}]}" ;;
                            esac ;;

                        *)
                            Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}


function format_ansi(){
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
    printf "%b\e[0m" "${2}"
}

function format_plain(){
    printf "%s" "${2}"
}

function format_adoc(){
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

function format_mdoc(){
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
