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
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id keys arr width midString i padding current char category leftMargin midPadding longest count showValues showDefValues withLegend withoutStatus withoutExtras col1padding col2padding col2StringLen statusChar phaseChar text format
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        categorized | framework | test | \
        exitcode | \
        clioption | configuration | format | level | message | mode | phase | setting | theme | themeitem | \
        application | dependency | dirlist | dir | filelist | file | module | option | parameter | project | scenario | site | task | \
        action | element | instance | object)
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
                    printf "\n  Some used UTF-8 characters: ◆  ■ ✔ ✘ ═ ─ ▮"
                    printf "\n" ;;
                test-terminal)
                    Print test colors
                    Print test effects
                    Print test characters
                    ;;


                exitcode-descriptions | \
                format-descriptions | level-descriptions | message-descriptions | mode-descriptions | phase-descriptions | theme-descriptions | \
                application-descriptions | dependency-descriptions | dirlist-descriptions | dir-descriptions | filelist-descriptions | file-descriptions | module-descriptions | option-descriptions | parameter-descriptions | project-descriptions | scenario-descriptions | site-descriptions | task-descriptions | \
                action-descriptions | element-descriptions | instance-descriptions | object-descriptions)
                    if [[ "${#}" == 0 ]]; then
                        case ${cmd1} in
                            action | element | instance | object)   arr="$(Framework has "${cmd1}s")" ;;
                            dependency)                             arr="$(Dependencies has)" ;;
                            *)                                      arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)" ;;
                        esac
                    elif [[ "${#}" == 1 ]]; then arr="${1}"; fi
                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    printf "\n"; for id in "${keys[@]}"; do Describe ${cmd1} ${id}; printf "\n"; done ;;


                exitcode-list | \
                clioption-list | configuration-list | format-list | level-list | message-list | mode-list | phase-list | setting-list | theme-list | themeitem-list | \
                application-list | dependency-list | dirlist-list | dir-list | filelist-list | file-list | module-list | option-list | parameter-list | project-list | scenario-list | site-list | task-list | \
                action-list | element-list | instance-list | object-list)
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
                            esac
                            shift
                        done
                    fi
                    case ${cmd1} in
                        action | element | instance | object)   if [[ "${arr}" == "" ]]; then arr="$(Framework has "${cmd1}s")"; fi;                 longest=$(Calculate longest string "${arr}") ;;
                        dependency)                             if [[ "${arr}" == "" ]]; then arr="$(Dependencies has)"; fi;                         longest=$(Calculate longest string "${arr}") ;;
                        clioption)                              if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest clioption "${arr}") ;;
                        option)                                 if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest option "${arr}") ;;
                        *)                                      if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest string "${arr}") ;;
                    esac
                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    for id in "${keys[@]}"; do Format tagline for ${cmd1} "${id}" ${cmd2} 4 2 "${FW_OBJECT_TIM_VAL[listSeparator]}" ${longest} ${showValues} ${showDefValues}; printf "\n"; done ;;


                exitcode-table | \
                clioption-table | configuration-table | format-table | level-table | message-table | mode-table | phase-table | setting-table | theme-table | themeitem-table | \
                application-table | dependency-table | dirlist-table | dirlist-table | dir-table | filelist-table | file-table | module-table | option-table | parameter-table | project-table | scenario-table | site-table | task-table | \
                action-table | element-table | instance-table | object-table)
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
                        action | element | instance | object)   if [[ "${arr}" == "" ]]; then arr="$(Framework has "${cmd1}s")"; fi;                 longest=$(Calculate longest string "${arr}") ;;
                        dependency)                             if [[ "${arr}" == "" ]]; then arr="$(Dependencies has)"; fi;                         longest=$(Calculate longest string "${arr}") ;;
                        clioption)                              if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest clioption "${arr}") ;;
                        option)                                 if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest option "${arr}") ;;
                        *)                                      if [[ "${arr}" == "" ]]; then arr="$(${FW_COMPONENTS_PLURAL["${cmd1}s"]^} has)"; fi; longest=$(Calculate longest string "${arr}") ;;
                    esac
                    IFS=" " read -a keys <<< "${arr}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                    if (( longest < ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${cmd1}s"]} )); then longest=$(( ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${cmd1}"s]} + 2 )); fi
                    if (( longest < 6 )); then longest=6; fi

                    ## prepare most used characters used in extras or legend
                    if [[ "${withoutExtras}" == "no" || "${withLegend}" == "yes" ]]; then
                        case ${cmd1} in
                            application | dependency | dir | dirlist | file | filelist | module | parameter | phase | project | scenario | setting | task)
                                Tablechars build
                                if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi
                        esac
                    fi

                    leftMargin=1; midPadding=2
                    width=$(tput cols); midString="${FW_OBJECT_TIM_VAL[tableSeparator]}"
                    char=$(Format themed text tableHeadFmt " ")

                    Format table topline ${width}
                    printf " "
                    Format themed text tableHeadFmt "${FW_COMPONENTS_TITLE_SHORT_SINGULAR["${cmd1}s"]}"
                    col1padding=$(( longest + midPadding - ${#FW_COMPONENTS_TITLE_SHORT_SINGULAR["${cmd1}s"]} ))
                    for ((i = 1; i <= ${col1padding}; i++)); do printf "${char}"; done

                    case ${showValues} in
                        yes)    case ${cmd1} in
                                    dependency) Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_VALUE["${cmd1}"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_VALUE["${cmd1}"]} ;;
                                    *)          Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_VALUE["${cmd1}s"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_VALUE["${cmd1}s"]} ;;
                                esac ;;
                        *)      case ${showDefValues} in
                                    yes)    Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_DEFVAL["${cmd1}s"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_DEFVAL["${cmd1}s"]} ;;
                                    *)      case ${cmd1} in
                                                dependency) Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_DESCR["${cmd1}"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_DESCR["${cmd1}"]} ;;
                                                *)          Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_DESCR["${cmd1}s"]}"; col2StringLen=${#FW_COMPONENTS_TABLE_DESCR["${cmd1}s"]} ;;
                                            esac
                                            ;;
                                esac
                    esac

                    col2padding=$(( width - leftMargin - longest - midPadding - col2StringLen ))
                    if [[ "${withoutExtras}" == "no" ]]; then col2padding=$(( col2padding - ${#FW_COMPONENTS_TABLE_EXTRA["${cmd1}s"]} )); fi
                    for ((i = 1; i < ${col2padding}; i++)); do printf "${char}"; done
                    if [[ "${withoutExtras}" == "no" ]]; then Format themed text tableHeadFmt "${FW_COMPONENTS_TABLE_EXTRA["${cmd1}s"]}"; fi
                    printf "\n"
                    Format table midline ${width}

                    count=0
                    for id in "${keys[@]}"; do
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
                            project)        case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_PRJ_FILE[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_PRJ_LONG[${id}]} ;; esac ;;
                            scenario)       case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_SCN_PATH_TEXT[${id}]} ;; *) col2StringLen=${#FW_ELEMENT_SCN_LONG[${id}]} ;; esac ;;
                            site)           case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_SIT_FILE[${id}]} ;;      *) col2StringLen=${#FW_ELEMENT_SIT_LONG[${id}]} ;; esac ;;
                            setting)        case ${showValues} in yes) col2StringLen=${#FW_OBJECT_SET_VAL[${id}]} ;;        *) col2StringLen=${#FW_OBJECT_SET_LONG[${id}]}  ;; esac ;;
                            task)           case ${showValues} in yes) col2StringLen=${#FW_ELEMENT_TSK_PATH_TEXT[${id}]} ;; *) col2StringLen=${#FW_ELEMENT_TSK_LONG[${id}]} ;; esac ;;
                            theme)          case ${showValues} in yes) col2StringLen=${#FW_OBJECT_THM_PATH[${id}]} ;;       *) col2StringLen=${#FW_OBJECT_THM_LONG[${id}]}  ;; esac ;;
                            themeitem)      case ${showValues} in yes) col2StringLen=${#FW_OBJECT_TIM_VAL[${id}]} ;;        *) col2StringLen=${#FW_OBJECT_TIM_LONG[${id}]}  ;; esac ;;

                            action | element | instance | object)
                                col2StringLen=${#FW_COMPONENTS_TAGLINE[${id,,}]} ;;
                        esac
                        col2padding=$(( width - leftMargin - longest - midPadding - ${#midString} - col2StringLen ))
                        if [[ "${withoutExtras}" == "no" ]]; then col2padding=$(( col2padding - ${#FW_COMPONENTS_TABLE_EXTRA["${cmd1}s"]} )); fi
                        for ((i = 1; i < ${col2padding}; i++)); do printf " "; done


                        if [[ "${withoutExtras}" == "no" ]]; then
                            case ${cmd1} in
                                application)    Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_APP_ORIG[${id}]}"]}"
                                                printf " %s" "${FW_ELEMENT_APP_ARGNUM[${id}]}"
                                                if [[ -n "${FW_ELEMENT_APP_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_APP_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_APP_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}" ;;
                                dependency)     Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DEP_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_DEP_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_DEP_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}" ;;
                                dirlist)        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DLS_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_DLS_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_DLS_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_DLS_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}"
                                                printf " %s" "${FW_ELEMENT_DLS_MOD[${id}]}" ;;
                                dir)            Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_DIR_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_DIR_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_DIR_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_DIR_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}"
                                                printf " %s" "${FW_ELEMENT_DIR_MOD[${id}]}" ;;
                                filelist)       Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FLS_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_FLS_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_FLS_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_FLS_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}"
                                                printf " %s" "${FW_ELEMENT_FLS_MOD[${id}]}" ;;
                                file)           Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_FIL_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_FIL_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_FIL_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_FIL_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}"
                                                printf " %s" "${FW_ELEMENT_FIL_MOD[${id}]}" ;;
                                message)        text="${FW_OBJECT_MSG_TYPE[${id}]^^}"
                                                printf "%s" "${text:0:1}"
                                                printf " %s" "${FW_OBJECT_MSG_ARGS[${id}]}"
                                                printf " %s" "${FW_OBJECT_MSG_CAT[${id}]:0:8}" ;;
                                module)         printf "%s " "${FW_ELEMENT_MDS_ACR[${id}]}"
                                                case ${FW_ELEMENT_MDS_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf "${phaseChar}" ;;
                                option)         if [[ "${FW_ELEMENT_OPT_CAT[${id}]}" == "Exit+Options" ]]; then printf "exit"; else printf "run" ; fi ;;
                                parameter)      Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PAR_ORIG[${id}]}"]}"
                                                if [[ -n "${FW_ELEMENT_PAR_DEFVAL[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charDefY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charDefN-${format}"]}"; fi
                                                if [[ -n "${FW_ELEMENT_PAR_REQUESTED[${id}]:-}" ]]; then printf " ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf " ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_PAR_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar}"
                                                case ${FW_ELEMENT_PAR_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf " ${phaseChar}" ;;
                                phase)          case ${FW_OBJECT_PHA_PRT_LVL[${id}]} in *" fatalerror "*) printf "${FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]}" ;; esac
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
                                                Format themed text phaErrNumberFmt ${FW_OBJECT_PHA_ERRCNT[${id}]} ;;
                                project)        Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_PRJ_ORIG[${id}]}"]}"
                                                case "${FW_ELEMENT_PRJ_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar} "
                                                case ${FW_ELEMENT_PRJ_MODES[${id}]} in all | test) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_PRJ_MODES[${id}]} in all | dev) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_PRJ_MODES[${id}]} in all | build) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_PRJ_MODES[${id}]} in all | use) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]}" ;; esac ;;
                                scenario)       Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SCN_ORIG[${id}]}"]}"
                                                case "${FW_ELEMENT_SCN_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar} "
                                                case ${FW_ELEMENT_SCN_MODES[${id}]} in all | test) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_SCN_MODES[${id}]} in all | dev) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_SCN_MODES[${id}]} in all | build) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_SCN_MODES[${id}]} in all | use) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]}" ;; esac ;;
                                setting)        case ${FW_OBJECT_SET_PHA[${id}]} in CLI) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]}";; Default) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]}";; Env) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]}";; File) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]}";; Load) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]}";; Project) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]}";; Scenario) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]}";; Shell) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]}";; Site) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]}";; Task) phaseChar="${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]}";; esac
                                                printf "${phaseChar}" ;;
                                site)           Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_SIT_ORIG[${id}]}"]}" ;;
                                task)           Format themed text tableOriginFmt "${FW_ELEMENT_MDS_ACR["${FW_ELEMENT_TSK_ORIG[${id}]}"]}"
                                                printf " "
                                                if [[ -n "${FW_ELEMENT_TSK_REQUESTED[${id}]:-}" ]]; then printf "${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]}"; else printf "${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}"; fi
                                                case "${FW_ELEMENT_TSK_STATUS[${id}]}" in N) statusChar="${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]}";; E) statusChar="${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]}";; W) statusChar="${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]}";; S) statusChar="${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]}";; esac; printf " ${statusChar} "
                                                case ${FW_ELEMENT_TSK_MODES[${id}]} in all | test) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_TSK_MODES[${id}]} in all | dev) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_TSK_MODES[${id}]} in all | build) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} " ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} " ;; esac
                                                case ${FW_ELEMENT_TSK_MODES[${id}]} in all | use) printf "${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]}" ;; *) printf "${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]}" ;; esac ;;
                                themeitem)      Format themed text tableSourceFmt "${FW_OBJECT_TIM_SOURCE[${id}]}" ;;
##TODO Limit string to N characters
                            esac
                        fi
                        printf "\n"
                        count=$(($count + 1))
                    done

                    if [[ "${withoutStatus}" == "no" ]]; then
                        Format table midline ${width}
                        printf " found %i ${cmd1}s" "${count}"
                        printf "\n"
                    fi
                    if [[ "${withLegend}" == "yes" ]]; then
                        case ${cmd1} in
                            application)
                                Format table midline ${width}
                                printf " properties:  (MD) declaring module acronym, (A) number of arguments, (R) requested, (S) status, (P) set in phase\n"
                                printf " - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]} no\n"
                                printf " - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n"
                                printf " - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load, ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n" ;;
                            dependency)
                                Format table midline ${width}
                                printf " properties:  (MD) declaring module acronym, (R) requested, (S) status\n"
                                printf " - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]} no\n"
                                printf " - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n" ;;
                            dir | dirlist | file | filelist)
                                Format table midline ${width}
                                printf " properties:  (MD) declaring module acronym, (R) requested, (S) status, (P) set in phase\n"
                                printf " - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]} no\n"
                                printf " - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n"
                                printf " - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load, ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n"
                                printf " - modes:     (r) read, (w) write, (x) execute, (c) create, (d) delete, (-) not set\n" ;;
                            message)
                                Format table midline ${width}
                                printf " properties:  (T) type, (A) number of arguments, Category of message\n"
                                printf " - type:      E  error, W warning, M message, X text, I info, D debug, T trace\n" ;;
                            module)
                                Format table midline ${width}
                                printf " properties:  (SH) acronym, (P) set in phase\n"
                                printf " - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load, ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n" ;;
                            option)
                                Format table midline ${width}
                                printf " types: Exit - exit option, Run - runtime option\n" ;;
                            parameter)
                                Format table midline ${width}
                                printf " properties:  (MD) declaring module acronym, (D) default value, (R) requested, (S) status, (P) set in phase\n"
                                printf " - def value: ${FW_INSTANCE_TABLE_CHARS["charDefY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charDefN-${format}"]} no\n"
                                printf " - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, ${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]} no\n"
                                printf " - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n"
                                printf " - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load, ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n" ;;
                            phase)
                                Format table midline ${width}
                                printf " properties:  print level and log level as FEXMWIDT\n"
                                printf "              number of warnings (WRN) and errors (ERR)\n"
                                printf " - levels     ${FW_INSTANCE_TABLE_CHARS["charLvlN-${format}"]} not set, ${FW_INSTANCE_TABLE_CHARS["charLvlF-${format}"]} (F)atal error, ${FW_INSTANCE_TABLE_CHARS["charLvlE-${format}"]} (E)rror, ${FW_INSTANCE_TABLE_CHARS["charLvlX-${format}"]} te(X)t, ${FW_INSTANCE_TABLE_CHARS["charLvlM-${format}"]} (M)essage\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charLvlW-${format}"]} (W)arning, ${FW_INSTANCE_TABLE_CHARS["charLvlI-${format}"]} (I)nfo, ${FW_INSTANCE_TABLE_CHARS["charLvlD-${format}"]} (D)ebug, ${FW_INSTANCE_TABLE_CHARS["charLvlT-${format}"]} (T)race\n"
                                printf " - numbers:   "; Format themed text phaWarnNumberFmt 111; printf " warnings, "; Format themed text phaErrNumberFmt  222; printf " errors\n" ;;
                            project | scenario | task)
                                Format table midline ${width}
                                if [[ "${cmd1}" == "task" ]]; then printf " properties:  (MD) declaring module acronym, (R)equested, (S)tatus\n"; else printf " properties:  (MD) declaring module acronym, (S)tatus\n"; fi
                                printf "              (T)est, (D)evelopment, (B)uild, (U)se\n"
                                if [[ "${cmd1}" == "task" ]]; then
                                    printf " - requested: ${FW_INSTANCE_TABLE_CHARS["charReqY-${format}"]} yes, printf "${FW_INSTANCE_TABLE_CHARS["charReqN-${format}"]}" no\n"
                                fi
                                printf " - status:    ${FW_INSTANCE_TABLE_CHARS["charStN-${format}"]} not-tested, ${FW_INSTANCE_TABLE_CHARS["charStE-${format}"]} error, ${FW_INSTANCE_TABLE_CHARS["charStW-${format}"]} warning, ${FW_INSTANCE_TABLE_CHARS["charStS-${format}"]} success\n"
                                printf " - mode:      ${FW_INSTANCE_TABLE_CHARS["charModeSet-${format}"]} available, ${FW_INSTANCE_TABLE_CHARS["charModeNot-${format}"]} not available\n" ;;
                            setting)
                                Format table midline ${width}
                                printf " properties:  (P) set in phase\n"
                                printf " - phase:     ${FW_INSTANCE_TABLE_CHARS["charPhaCli-${format}"]} CLI, ${FW_INSTANCE_TABLE_CHARS["charPhaDef-${format}"]} Default (value), ${FW_INSTANCE_TABLE_CHARS["charPhaEnv-${format}"]} Environment, ${FW_INSTANCE_TABLE_CHARS["charPhaFil-${format}"]} File\n"
                                printf "              ${FW_INSTANCE_TABLE_CHARS["charPhaLoa-${format}"]} Load, ${FW_INSTANCE_TABLE_CHARS["charPhaPrj-${format}"]} Project, ${FW_INSTANCE_TABLE_CHARS["charPhaScn-${format}"]} Scenario, ${FW_INSTANCE_TABLE_CHARS["charPhaShl-${format}"]} Shell, ${FW_INSTANCE_TABLE_CHARS["charPhaSit-${format}"]} Site, ${FW_INSTANCE_TABLE_CHARS["charPhaTsk-${format}"]} Task\n" ;;
                            site)
                                Format table midline ${width}
                                printf " properties:  (MD) declaring module acronym\n" ;;
                            themeitem)
                                Format table midline ${width}
                                printf " properties:  Src - source for item setting, short theme ID\n" ;;
                        esac
                    fi
                    Format table bottomline ${width} ;;


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
