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
## Cli - instance representing CLI options for tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_INSTANCE_CLI_LONG[*]}" == "" ]]; then
    declare -A FW_INSTANCE_CLI_LONG     ## [long]="description"
    declare -A FW_INSTANCE_CLI_SHORT    ## [short]=long
    declare -A FW_INSTANCE_CLI_LS       ## [long]=short
    declare -A FW_INSTANCE_CLI_ARG      ## [long]="argument"
    declare -A FW_INSTANCE_CLI_CAT      ## [long]="category+name"
    declare -A FW_INSTANCE_CLI_LEN      ## [long]="length: short + long + arg" +3 for short/long dashes, plus 1 if arg is set
fi

FW_TAGS_INSTANCES["Cli"]="instance representing CLI options for tasks"


function Cli() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add general option"; printf " "; Format themed text explainArgFmt "LONG SHORT FORMAT DESCR CATEGORY"; printf "\n"
            Format help indentation 3; Format themed text explainTextFmt "adds a new cli option, use empty string if no SHORT required"; printf "\n"


        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-not-core"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-origin"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-requested"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-runtop"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-status"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option filter-tested"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option format"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option help"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option show-values"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option table"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option target-all"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-all"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-build"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-debug"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-describe"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-dl"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-dll"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-none-list"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-only-build"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-only-debug"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-only-describe"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option task-only-list"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option with-legend"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option without-extras"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "add option without-status"; printf "\n"

        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "get string"; printf "\n"

        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "has long"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "has short"; printf "\n"

        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "list"; printf "\n"

        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "long string"; printf "\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "short string"; printf "\n"
        printf "\n"; return
    fi

    local id shortId printString="" retval category keys
    local cmd1="${1,,}" cmd2 cmdString1="${1,,}" cmdString2
    shift; case "${cmd1}" in
        list)
            if [[ "${FW_INSTANCE_CLI_LONG[*]}" != "" ]]; then
                IFS=" " read -a keys <<< "${!FW_INSTANCE_CLI_LONG[@]}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
                for id in "${keys[@]}"; do
                    printf "    -%s --%s [%s]: %s, %s\n" "${FW_INSTANCE_CLI_LS[${id}]}" "${id}" "${FW_INSTANCE_CLI_ARG[${id}]}" "${FW_INSTANCE_CLI_CAT[${id}]}" "${FW_INSTANCE_CLI_LONG[${id}]}"
                done
            else
                printf "    %s\n" "{}"
            fi ;;

        add | get | has | long | run | short)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                get-string)
                    # Cli get string LONG
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    id="${1}"
                    if [[ -n "${FW_INSTANCE_CLI_LS[${id}]:-}" ]]; then printf "${FW_INSTANCE_CLI_LS[${id}]} ${id}"; return; fi
                    return 1;
                    ;;

                has-long)   echo " ${!FW_INSTANCE_CLI_LONG[@]} " ;;
                has-short)  echo " ${!FW_INSTANCE_CLI_SHORT[@]} " ;;

                long-string)
                    retval="${!FW_INSTANCE_CLI_LONG[@]}"
                    for id in ${!FW_INSTANCE_CLI_ARG[@]}; do
                        if [[ -n "${FW_INSTANCE_CLI_ARG[${id}]:-}" ]]; then retval=${retval/"${id}"/"${id}:"}; fi
                    done
                    retval=${retval//" "/","}
                    printf "${retval}" ;;
                short-string)
                    retval="${!FW_INSTANCE_CLI_SHORT[@]}"
                    for id in ${!FW_INSTANCE_CLI_ARG[@]}; do
                        if [[ -n "${FW_INSTANCE_CLI_ARG[${id}]:-}" ]]; then shortId=${FW_INSTANCE_CLI_LS[${id}]}; retval=${retval//"${shortId}"/"${shortId}:"}; fi
                    done
                    retval=${retval//" "/""}
                    printf "${retval}" ;;

                add-general | add-option)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2} cmd3" E802 1 "$#"; return; fi
                    cmd3=${1,,}; shift; cmdString3="${cmd1} ${cmd2} ${cmd3}"
                    case "${cmd1}-${cmd2}-${cmd3}" in

                        add-general-option)
                            # Cli add option LONG SHORT FORMAT DESCR CATEGORY
                            if [[ "${#}" -lt 5 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 5 "$#"; return; fi
                            id="${1}"; shortId="${2}"; value="${3}"; description="${4}"; category="${5}"
                            if [[ ! -n "${id}" ]]; then Report application error "${FUNCNAME[0]}" "${cmdString2}" E813; return; fi
                            Test used clioption long-id "${id}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            Test used clioption short-id "${shortId}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
                            FW_INSTANCE_CLI_LONG["${id}"]="${description}"
                            optionLength=$(( 4 + ${#id} ))
                            if [[ "${shortId}" != "" ]]; then FW_INSTANCE_CLI_SHORT["${shortId}"]="${id}"; fi
                            FW_INSTANCE_CLI_LS["${id}"]="${shortId}"
                            FW_INSTANCE_CLI_ARG["${id}"]="${value}"
                            if [[ -n "${value}" ]]; then
                                optionLength=$(( optionLength + 1 + ${#value} ))
                            fi
                            FW_INSTANCE_CLI_CAT["${id}"]="${category}"
                            FW_INSTANCE_CLI_LEN["${id}"]=${optionLength} ;;

                        add-option-help)            Cli add general option      help            h  ""       "print a help screen with CLI options" "Options" ;;
                        add-option-format)          Cli add general option      format          F  "FORMAT" "sets format for printed text" "Options" ;;
                        add-option-describe)        Cli add general option      describe        D  ""       "prints a description" "Options" ;;

                        add-option-table)           Cli add general option      table           T  ""       "table format with additional information"  "Options" ;;
                        add-option-show-values)     Cli add general option      show-values     V  ""       "show values instead of description text"   "Options" ;;

                        add-option-with-legend)     Cli add general option      with-legend     W  ""       "print a legend if table format is used"                    "Table+Options" ;;
                        add-option-without-extras)  Cli add general option      without-extras  E  ""       "do not show extra information if table format is used"     "Table+Options" ;;
                        add-option-without-status)  Cli add general option      without-status  S  ""       "do not show status information if table format is used"    "Table+Options" ;;

                        add-option-filter-id)           Cli add general option  id          i   "ID"        "only ${1:-} ${2:-} ID, disables all other filters"                         "Filters" ;;
                        add-option-filter-mode)         Cli add general option  mode        m   "MODE"      "only ${1:-} available in mode MODE"                                        "Filters" ;;
                        add-option-filter-origin)       Cli add general option  origin      o   "MODULE"    "only ${1:-} with origin module MODULE"                                     "Filters" ;;
                        add-option-filter-requested)    Cli add general option  requested   r   "REQ"       "only requested ${1:-}, yes or no"                                          "Filters" ;;
                        add-option-filter-status)       Cli add general option  status      s   "STATUS"    "only ${1:-} with status: (s)uccess, (w)arning, (e)rror, (n)ot attempted"   "Filters" ;;
                        add-option-filter-tested)       Cli add general option  tested      t   "TESTED"    "only tested ${1:-}, yes or no"                                             "Filters" ;;
                        add-option-filter-not-core)     Cli add general option  not-core    n   ""          "no ${1:-} with origin module Core"                                         "Filters" ;;

                        add-option-filter-exitop)       Cli add general option  exit        e   ""      "show exit options"     "Filters" ;;
                        add-option-filter-runtop)       Cli add general option  runtime     r   ""      "show runtime options"  "Filters" ;;

                        add-option-task-none-all)       Cli add general option  none-all        N   ""  "activates all 'no' name filters"                               "Name+Filters,+none" ;;
                        add-option-task-none-build)     Cli add general option  none-build      b   ""  "exclude tasks starting with 'build-'"                          "Name+Filters,+none" ;;
                        add-option-task-none-debug)     Cli add general option  none-debug      ""  ""  "exclude tasks starting with 'debug-'"                          "Name+Filters,+none" ;;
                        add-option-task-none-describe)  Cli add general option  none-describe   d   ""  "exclude tasks starting with 'describe-'"                       "Name+Filters,+none" ;;
                        add-option-task-none-list)      Cli add general option  none-list       l   ""  "exclude tasks starting with 'list-'"                           "Name+Filters,+none" ;;
                        add-option-task-none-dl)        Cli add general option  none-dl         ""  ""  "exclude tasks starting with 'describe-' or 'list-'"            "Name+Filters,+none" ;;
                        add-option-task-none-dll)       Cli add general option  none-ddl        ""  ""  "exclude tasks starting with 'debug-', 'describe-' or 'list-'"  "Name+Filters,+none" ;;

                        add-option-task-only-build)     Cli add general option  only-build      B   ""  "show only tasks starting with 'build-'"        "Name+Filters,+only" ;;
                        add-option-task-only-debug)     Cli add general option  only-debug      ""  ""  "show only tasks starting with 'debug-'"        "Name+Filters,+only" ;;
                        add-option-task-only-describe)  Cli add general option  only-describe   ""  ""  "show only tasks starting with 'describe-'"     "Name+Filters,+only" ;;
                        add-option-task-only-list)      Cli add general option  only-list       L   ""  "show only tasks starting with 'list-'"         "Name+Filters,+only" ;;

                        add-option-target-all)  Cli add general option  all A   ""  "all targets" "Targets" ;;

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
