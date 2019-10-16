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
## Print - action to print something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Print() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local id keys arr componentClass width midString i current char category leftMargin midPadding longest count showValues showDefValues withLegend withoutStatus withoutExtras col2padding col2StringLen statusChar phaseChar text format number numberArr paddingChar=" "
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        categorized | framework | test | \
        exitcode | clioption | \
        configuration | format | level | message | mode | phase | setting | theme | themeitem | variable | \
        application | dependency | dirlist | dir | filelist | file | module | option | parameter | project | scenario | script | site | task | \
        action | element | instance | object | operation)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                framework-version)
                    printf "\n%s version %s\n" "$(Get app name)" "${SF_VERSION}" ;;
                framework-help)
                    printf "\n%s - the SKB Framework\n\n" "$(Get app name)"
                    printf "  Usage: %s [options]\n" "$(Get app name)"
                    List categorized options Runtime+Options Exit+Options ;;

                test-colors)
                    printf "\n  ANSI colors, print format: %s" "$(Get print format)"
                    printf "\n    - regular: "
                        Format text regular,black "black"; printf ",    "
                        Format text regular,red "red"; printf ",    "
                        Format text regular,green "green"; printf ",    "
                        Format text regular,yellow "yellow"; printf ",    "
                        Format text regular,blue "blue"; printf ",    "
                        Format text regular,purple "purple"; printf ",    "
                        Format text regular,cyan "cyan"; printf ",    "
                        Format text regular,white "white"
                    printf "\n    - bold:    "
                        Format text bold,black "black"; printf ",    "
                        Format text bold,red "red"; printf ",    "
                        Format text bold,green "green"; printf ",    "
                        Format text bold,yellow "yellow"; printf ",    "
                        Format text bold,blue "blue"; printf ",    "
                        Format text bold,purple "purple"; printf ",    "
                        Format text bold,cyan "cyan"; printf ",    "
                        Format text bold,white "white"
                    printf "\n    - regular: "
                        Format text regular,black-hi "black-hi"; printf ", "
                        Format text regular,red-hi "red-hi"; printf ", "
                        Format text regular,green-hi "green-hi"; printf ", "
                        Format text regular,yellow-hi "yellow-hi"; printf ", "
                        Format text regular,blue-hi "blue-hi"; printf ", "
                        Format text regular,purple-hi "purple-hi"; printf ", "
                        Format text regular,cyan-hi "cyan-hi"; printf ", "
                        Format text regular,white-hi "white-hi"
                    printf "\n    - bold:    "
                        Format text bold,black-hi "black-hi"; printf ", "
                        Format text bold,red-hi "red-hi"; printf ", "
                        Format text bold,green-hi "green-hi"; printf ", "
                        Format text bold,yellow-hi "yellow-hi"; printf ", "
                        Format text bold,blue-hi "blue-hi"; printf ", "
                        Format text bold,purple-hi "purple-hi"; printf ", "
                        Format text bold,cyan-hi "cyan-hi"; printf ", "
                        Format text bold,white-hi "white-hi"
                    printf "\n" ;;
                test-effects)
                    printf "\n  ANSI effects, print format: %s" "$(Get print format)"
                    printf "\n    - "
                        Format text regular regular; printf ", "
                        Format text regular-fg regular-fg; printf ", "
                        Format text regular-bg regular-bg
                    printf "\n    - "
                        Format text bold bold; printf ", "
                        Format text italic italic; printf ", "
                        Format text underline underline; printf ", "
                        Format text inverse inverse; printf ", "
                        Format text blink blink; printf ", "
                        Format text hidden hidden
                    printf "\n" ;;
                test-characters)
                    printf "\n  Some used UTF-8 characters"
                    printf "\n    ✓ ✔ ✕ ✖ ✗ ✘ 🗷 🗶 🗸 🗹 🗙 ◆  ■ ═ ─ ▮ ░ ▒ ▓"
                    printf "\n    ✅ ␣ ⎵ ▀ ⛔ ○ ● ◍ ⬒ ⬓ ⬛ ⬜ ⬤ ⭕ ⬮ ⬯ ⭙ ⮽ ⮾ ⮿ ︽ ︾ ︿ ﹀ ｟ ｠"
                    printf "\n" ;;
                test-terminal)
                    Print test colors
                    Print test effects
                    Print test characters ;;


                exitcode-descriptions | \
                format-descriptions | level-descriptions | message-descriptions | mode-descriptions | phase-descriptions | theme-descriptions | themeitem-descriptions | variable-descriptions | \
                application-descriptions | dependency-descriptions | dirlist-descriptions | dir-descriptions | filelist-descriptions | file-descriptions | module-descriptions | option-descriptions | parameter-descriptions | project-descriptions | scenario-descriptions | script-descriptions | site-descriptions | task-descriptions | \
                action-descriptions | element-descriptions | instance-descriptions | object-descriptions)
                    case ${cmd1} in
                        dependency)     componentClass="Dependencies" ;;
                        *)              componentClass="${cmd1^}s" ;;
                    esac

                    if [[ "${#}" == 0 ]]; then
                        case ${cmd1} in
                            option)
                                arr="$(echo ${FW_ELEMENT_OPT_SORT[@]})" ;;
                            action | element | instance | object)   arr="$(Framework has "${cmd1}s")" ;;
                            *)                                      arr="$(${componentClass} has)" ;;
                        esac
                    elif [[ "${#}" == 1 ]]; then arr="${1}"; fi
                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    printf "\n"; for id in "${keys[@]}"; do Describe ${cmd1} ${id}; printf "\n"; done ;;


                clioption-list | exitcode-list | \
                configuration-list | format-list | level-list | message-list | mode-list | phase-list | setting-list | theme-list | themeitem-list | variable-list | \
                application-list | dependency-list | dirlist-list | dir-list | filelist-list | file-list | module-list | option-list | parameter-list | project-list | scenario-list | script-list | site-list | task-list | \
                action-list | element-list | instance-list | object-list | operation-list)
                    case ${cmd1} in
                        dependency)     componentClass="Dependencies" ;;
                        *)              componentClass="${cmd1^}s" ;;
                    esac

                    arr=""; showValues="no"; showDefValues="no"
                    if [[ "${#}" == 1 ]]; then
                        case "${1}" in
                            show-values)    showValues=yes ;;
                            show-defvalues) showDefValues=yes ;;
                            *)              arr="${1}" ;;
                        esac
                    elif [[ "${#}" > 1 ]]; then
                        while [[ "${#}" > 0 ]]; do
                            case "${1}" in
                                show-values)    showValues=yes ;;
                                show-defvalues) showDefValues=yes ;;
                                *)              arr="${1}" ;;
                            esac
                            shift
                        done
                    fi
                    char="${FW_OBJECT_TIM_VAL[listSeparator]}"
                    case ${cmd1} in
                        action | element | instance | object)   if [[ "${arr}" == "" ]]; then arr="$(Framework has "${cmd1}s")"; fi;            longest=$(Calculate longest string "${arr}") ;;
                        operation)                              if [[ "${arr}" == "" ]]; then arr="${!SF_OPERATIONS[@]}"; fi;                          longest=$(Calculate longest operation "${arr}");    char="" ;;
                        dependency)                             if [[ "${arr}" == "" ]]; then arr="$(Dependencies has)"; fi;                    longest=$(Calculate longest string "${arr}") ;;
                        clioption)                              if [[ "${arr}" == "" ]]; then arr="$(echo ${FW_INSTANCE_CLI_SORT[@]})"; fi;     longest=$(Calculate longest clioption "${arr}") ;;
                        option)                                 if [[ "${arr}" == "" ]]; then arr="$(echo ${FW_ELEMENT_OPT_SORT[@]})"; fi;      longest=$(Calculate longest option "${arr}") ;;
                        *)                                      if [[ "${arr}" == "" ]]; then arr="$(${componentClass} has)"; fi;               longest=$(Calculate longest string "${arr}") ;;
                    esac
                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    Format ansi start "${FW_OBJECT_TIM_VAL["listBgrndFmt"]}"
                    for id in "${keys[@]}"; do Format tagline for ${cmd1} "${id}" ${cmd2} 4 2 "${char}" ${longest} ${showValues} ${showDefValues}; printf "\n"; done
                    Format ansi end ;;


                clioption-table | exitcode-table | \
                configuration-table | format-table | level-table | message-table | mode-table | phase-table | setting-table | theme-table | themeitem-table | variable-table | \
                application-table | dependency-table | dirlist-table | dir-table | filelist-table | file-table | module-table | option-table | parameter-table | project-table | scenario-table | script-table | site-table | task-table | \
                action-table | element-table | instance-table | object-table | operation-table)
                    case ${cmd1} in
                        dependency)     componentClass="Dependencies" ;;
                        *)              componentClass="${cmd1^}s" ;;
                    esac

                    arr=""; showValues="no"; showDefValues="no"; withLegend="no"; withoutStatus="no"; withoutExtras="no"
                    if [[ "${#}" == 1 ]]; then
                        case "${1}" in
                            show-values)    showValues=yes ;;
                            show-defvalues) showDefValues=yes ;;
                            with-legend)    withLegend=yes ;;
                            without-status) withoutStatus=yes ;;
                            without-extras) withoutExtras=yes ;;
                            *)              arr="${1}" ;;
                        esac
                    elif [[ "${#}" > 1 ]]; then
                        while [[ "${#}" > 0 ]]; do
                            case "${1}" in
                                show-values)    showValues=yes ;;
                                show-defvalues) showDefValues=yes ;;
                                with-legend)    withLegend=yes ;;
                                without-status) withoutStatus=yes ;;
                                without-extras) withoutExtras=yes ;;
                            esac
                            shift
                        done
                    fi
                    if [[ "${showDefValues}" == "yes" && "${cmd1}" != "parameter" ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E804 "${cmd1} table property" "show-defvalues"; return; fi

                    case ${cmd1} in
                        action | element | instance | object)   if [[ "${arr}" == "" ]]; then arr="$(Framework has "${cmd1}s")"; fi;            longest=$(Calculate longest string "${arr}") ;;
                        operation)                              if [[ "${arr}" == "" ]]; then arr="${!SF_OPERATIONS[@]}"; fi;                          longest=$(Calculate longest operation "${arr}") ;;
                        dependency)                             if [[ "${arr}" == "" ]]; then arr="$(Dependencies has)"; fi;                    longest=$(Calculate longest string "${arr}") ;;
                        clioption)                              if [[ "${arr}" == "" ]]; then arr="$(echo ${FW_INSTANCE_CLI_SORT[@]})"; fi;     longest=$(Calculate longest clioption "${arr}") ;;
                        option)                                 if [[ "${arr}" == "" ]]; then arr="$(echo ${FW_ELEMENT_OPT_SORT[@]})"; fi;      longest=$(Calculate longest option "${arr}") ;;
                        *)                                      if [[ "${arr}" == "" ]]; then arr="$(${componentClass} has)"; fi;               longest=$(Calculate longest string "${arr}") ;;
                    esac
                    if (( longest < ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${componentClass}"]} )); then longest=$(( ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${componentClass}"]} + 2 )); fi
                    if (( longest < 6 )); then longest=6; fi

                    ## prepare most used characters used in extras or legend
                    if [[ "${withoutExtras}" == "no" || "${withLegend}" == "yes" ]]; then
                        case ${cmd1} in
                            application | configuration | clioption | dependency | dir | dirlist | file | filelist | format | level | message | mode | module | parameter | option | phase | project | scenario | setting | site | script | task | themeitem | theme)
                                Tablechars build
                                if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi
                        esac
                    fi

                    leftMargin=1; midPadding=2
                    width=$(tput cols); midString="${FW_OBJECT_TIM_VAL[tableSeparator]}"
                    if [[ "${componentClass}" == "Operations" ]]; then midString=""; fi

                    Format ansi start "${FW_OBJECT_TIM_VAL["tableBgrndFmt"]}"
                    Format table toprule ${width}
                    printf "${paddingChar}"
                    Format themed text tableHeadFmt "${FW_COMPONENTS_TITLE_SHORT_SINGULAR["${componentClass}"]}"
                    Repeat print formatted character $(( longest + midPadding - ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${componentClass}"]} )) "${paddingChar}" tableHeadFmt

                    case ${showValues} in
                        yes)    Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_VALUE["${componentClass}"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_VALUE["${componentClass}"]} ;;
                        *)      case ${showDefValues} in
                                    yes)    Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_DEFVAL["${componentClass}"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_DEFVAL["${componentClass}"]} ;;
                                    *)      Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_DESCR["${componentClass}"]}";  col2StringLen=${#FW_COMPONENTS_TABLE_DESCR["${componentClass}"]} ;;
                                esac
                    esac

                    col2padding=$(( width - leftMargin - longest - midPadding - col2StringLen ))
                    if [[ "${withoutExtras}" == "no" ]]; then col2padding=$(( col2padding - ${#FW_COMPONENTS_TABLE_EXTRA["${componentClass}"]} )); fi
                    Repeat print formatted character $(( col2padding -1 )) "${paddingChar}" tableHeadFmt
                    if [[ "${withoutExtras}" == "no" ]]; then Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_EXTRA["${componentClass}"]}"; fi
                    printf "\n"
                    Format table midrule ${width}

                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    count=0
                    for id in "${keys[@]}"; do
                        if [[ "${id:0:1}" == "#" ]]; then id="${id:2}"; fi
                        Format tagline for ${cmd1} "${id}" ${cmd2} ${leftMargin} ${midPadding} "${midString}" ${longest} ${showValues} ${showDefValues}
                        case ${cmd1} in
                            application)    case ${showValues} in yes) col2StringLen=$(( ${#FW_ELEMENT_APP_COMMAND[${id}]} + 1 + ${#FW_ELEMENT_APP_ARGS[${id}]} )) ;; *) col2StringLen=${#FW_ELEMENT_APP_LONG[${id}]} ;; esac ;;
                            clioption)      case ${showValues} in yes) col2StringLen=${#FW_INSTANCE_CLI_SET[${id}]} ;;      *) col2StringLen=${#FW_INSTANCE_CLI_LONG[${id}]} ;; esac ;;
                            configuration)  case ${showValues} in yes) col2StringLen=${#FW_OBJECT_CFG_VAL[${id}]} ;;        *) col2StringLen=${#FW_OBJECT_CFG_LONG[${id}]}  ;; esac ;;
                            dependency)     case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_DEP_CMD[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_DEP_LONG[${id}]} ;; esac ;;
                            dirlist)        case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_DLS_VAL[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_DLS_LONG[${id}]} ;; esac ;;
                            dir)            case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_DIR_VAL[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_DIR_LONG[${id}]} ;; esac ;;
                            exitcode)       col2StringLen=${#FW_INSTANCE_EXC_LONG[${id}]} ;;
                            filelist)       case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_FLS_VAL[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_FLS_LONG[${id}]} ;; esac ;;
                            file)           case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_FIL_VAL[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_FIL_LONG[${id}]} ;; esac ;;
                            format)         col2StringLen=${#FW_OBJECT_FMT_LONG[${id}]} ;;
                            level)          col2StringLen=${#FW_OBJECT_LVL_LONG[${id}]} ;;
                            message)        case ${showValues} in yes) col2StringLen=${#FW_OBJECT_MSG_TEXT[${id}]} ;;       *) col2StringLen=${#FW_OBJECT_MSG_LONG[${id}]}  ;; esac ;;
                            mode)           col2StringLen=${#FW_OBJECT_MOD_LONG[${id}]} ;;
                            module)         case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_MDS_PATH[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_MDS_LONG[${id}]} ;; esac ;;
                            option)         case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_OPT_SET[${id}]} ;;       *) col2StringLen=${#FW_ELEMENT_OPT_LONG[${id}]} ;; esac ;;
                            parameter)      case ${showDefValues} in
                                                yes)    col2StringLen=${#FW_ELEMENT_PAR_DEFVAL[${id}]} ;;
                                                *)      case ${showValues} in
                                                            yes)    col2StringLen=${#FW_ELEMENT_PAR_VAL[${id}]} ;;
                                                            *)      col2StringLen=${#FW_ELEMENT_PAR_LONG[${id}]} ;;
                                                        esac;;
                                            esac ;;
                            phase)          col2StringLen=${#FW_OBJECT_PHA_LONG[${id}]} ;;
                            project)        case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_PRJ_RDIR[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_PRJ_LONG[${id}]} ;; esac ;;
                            scenario)       case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_SCN_PATH_TEXT[${id}]} ;; *) col2StringLen=${#FW_ELEMENT_SCN_LONG[${id}]} ;; esac ;;
                            script)         case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_SCR_RDIR[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_SCR_LONG[${id}]} ;; esac ;;
                            site)           case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_SIT_RDIR[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_SIT_LONG[${id}]} ;; esac ;;
                            setting)        case ${showValues} in yes) col2StringLen=${#FW_OBJECT_SET_VAL[${id}]} ;;        *) col2StringLen=${#FW_OBJECT_SET_LONG[${id}]}  ;; esac ;;
                            task)           case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_TSK_PATH_TEXT[${id}]} ;; *) col2StringLen=${#FW_ELEMENT_TSK_LONG[${id}]} ;; esac ;;
                            theme)          col2StringLen=${#FW_OBJECT_THM_LONG[${id}]} ;;
                            themeitem)      case ${showValues} in yes) col2StringLen=${#FW_OBJECT_TIM_VAL[${id}]} ;;        *) col2StringLen=${#FW_OBJECT_TIM_LONG[${id}]}  ;; esac ;;
                            variable)       col2StringLen=${#FW_OBJECT_VAR_LONG[${id}]} ;;

                            action | element | instance | object)
                                col2StringLen=${#FW_COMPONENTS_TAGLINE["${id}"]} ;;
                            operation)
                                current=${id#*\%}; current=${current//@/}; col2StringLen=${#current} ;;
                        esac
                        col2padding=$(( width - leftMargin - longest - midPadding - ${#midString} - col2StringLen ))
                        if [[ "${withoutExtras}" == "no" ]]; then col2padding=$(( col2padding - ${#FW_COMPONENTS_TABLE_EXTRA["${componentClass}"]} )); fi
                        Repeat print character $(( col2padding -1 )) "${paddingChar}"

                        if [[ "${withoutExtras}" == "no" ]]; then Format table extras for ${cmd1} ${id}; fi
                        printf "\n"
                        count=$(($count + 1))
                    done

                    if [[ "${withoutStatus}" == "no" ]]; then
                        Format table statusrule ${width}
                        printf " found %i ${cmd1}s\n" "${count}"
                    fi
                    if [[ "${withLegend}" == "yes" ]]; then
                        Format table legendrule ${width}
                        Format table legend for ${cmd1}
                    fi
                    Format table bottomrule ${width}
                    Format ansi end ;;


                categorized-option | categorized-message)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        categorized-option-table)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            Print option table "$(Filter options ${1})" ;;

                        categorized-message-table)
                            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString3}" E801 1 "$#"; return; fi
                            Print message table "$(Filter messages ${1})" ;;

                        *)  Report process error "${FUNCNAME[0]}" "cmd3" E803 "${cmdString3}"; return ;;
                    esac ;;
                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
