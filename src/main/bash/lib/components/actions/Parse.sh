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
## Parse - action to parse CLI arguments for the framework or tasks
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_PARSED_ARG_MAP[*]}" == "" ]]; then
    declare -A FW_PARSED_ARG_MAP    ## map of parsed values
    declare -A FW_PARSED_VAL_MAP    ## map of parsed arguments, options that are used with an argument
    declare FW_PARSED_EXTRA=""      ## extra parts of command line, after final '--'
fi


function Parse() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
##TODO
        printf "\n"; return
    fi

    local id appName shortString longString helpList doExit=false
    local cmd1="${1,,}" cmdString1="${1,,}"
    shift; case "${cmd1}" in

        cli)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmd1}" E801 1 "$#"; return; fi
            helpList="${1}"; shift
            case "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" in
                CLI)    appName="skb-framework"
                        shortString="$(Options short string)"
                        longString="$(Options long string)" ;;
                Task)   appName="${FW_OBJECT_SET_VAL["CURRENT_TASK"]}"
                        shortString="$(Clioptions short string)"
                        longString="$(Clioptions long string)" ;;
                *)
##ERROR MESSAGE
;;
            esac

            unset -v FW_PARSED_ARG_MAP FW_PARSED_VAL_MAP FW_PARSED_EXTRA
            declare -A -g FW_PARSED_ARG_MAP FW_PARSED_VAL_MAP; declare -g FW_PARSED_EXTRA=""

            ! PARSED=$(getopt --options "${shortString}" --longoptions "${longString}" --name "${appName}" -- "$@")
            if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
                Report application error "${FUNCNAME[0]}" "${cmd1}" E814
                case "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" in
                    CLI)    Terminate framework 1 ;;
                    Task)   exit 1;;
                esac
            fi
            eval set -- "$PARSED"
            while true; do
                case "${1}" in
                    --)     shift; if [[ -z ${1:-} ]]; then break; fi; FW_PARSED_EXTRA="$(printf '%s' "$*")"; break ;;
                    "--"*)  case ${longString} in
                                *${1#--}":"*)   FW_PARSED_ARG_MAP["${1#--}"]="yes"; FW_PARSED_VAL_MAP["${1#--}"]="$2"; shift 2 ;;
                                *${1#--}*)      FW_PARSED_ARG_MAP["${1#--}"]="yes"; shift ;;
                            esac ;;
                    "-"*)   case ${shortString} in
                                *${1#-}":"*)    FW_PARSED_ARG_MAP["${1#-}"]="yes"; FW_PARSED_VAL_MAP["${1#-}"]="$2"; shift 2 ;;
                                *${1#-}*)       FW_PARSED_ARG_MAP["${1#-}"]="yes"; shift ;;
                            esac ;;
                esac
            done

            case "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" in
                CLI)    for id in "${!FW_PARSED_ARG_MAP[@]}"; do if (( ${#id} == 1 )); then FW_ELEMENT_OPT_SET["${FW_ELEMENT_OPT_SHORT[${id}]}"]="yes"; else FW_ELEMENT_OPT_SET["${id}"]="yes"; fi; done
                        for id in "${!FW_PARSED_VAL_MAP[@]}"; do if (( ${#id} == 1 )); then FW_ELEMENT_OPT_VAL["${FW_ELEMENT_OPT_SHORT[${id}]}"]="${FW_PARSED_VAL_MAP[${id}]}"; else FW_ELEMENT_OPT_VAL["${id}"]="${FW_PARSED_VAL_MAP[${id}]}"; fi; done
                        FW_ELEMENT_OPT_EXTRA="${FW_PARSED_EXTRA}"

                        if [[ "${FW_ELEMENT_OPT_SET["format"]}" == "yes" ]];            then Set print format "${FW_ELEMENT_OPT_VAL["format"]}"; fi
                        if [[ "${FW_ELEMENT_OPT_SET["help"]}" == "yes" ]];              then Print framework help; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["version"]}" == "yes" ]];           then Print framework version; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["option"]}" == "yes" ]];            then printf "\n"; Describe option "${FW_ELEMENT_OPT_VAL["option"]}"; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["test-colors"]}" == "yes" ]];       then Print test colors; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["test-effects"]}" == "yes" ]];      then Print test effects; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["test-characters"]}" == "yes" ]];   then Print test characters; Terminate framework 0; fi
                        if [[ "${FW_ELEMENT_OPT_SET["test-terminal"]}" == "yes" ]];     then Print test terminal; Terminate framework 0; fi ;;

                Task)   for id in "${!FW_PARSED_ARG_MAP[@]}"; do if (( ${#id} == 1 )); then FW_INSTANCE_CLI_SET["${FW_INSTANCE_CLI_SHORT[${id}]}"]="yes"; else FW_INSTANCE_CLI_SET["${id}"]="yes"; fi; done
                        for id in "${!FW_PARSED_VAL_MAP[@]}"; do if (( ${#id} == 1 )); then FW_INSTANCE_CLI_VAL["${FW_INSTANCE_CLI_SHORT[${id}]}"]="${FW_PARSED_VAL_MAP[${id}]}"; else FW_INSTANCE_CLI_VAL["${id}"]="${FW_PARSED_VAL_MAP[${id}]}"; fi; done
                        FW_INSTANCE_CLI_EXTRA="${FW_PARSED_EXTRA}"

                        if [[ "${FW_INSTANCE_CLI_SET["format"]}" == "yes" ]];     then FW_OBJECT_SET_VAL["PRINT_FORMAT2"]="${FW_INSTANCE_CLI_VAL["format"]}"; fi
                        if [[ "${FW_INSTANCE_CLI_SET["describe"]}" == "yes" ]];   then printf "\n"; Describe task "${FW_OBJECT_SET_VAL["CURRENT_TASK"]}"; doExit=true; fi
                        if [[ "${FW_INSTANCE_CLI_SET["help"]}" == "yes" ]];       then List categorized clioptions ${helpList}; doExit=true; fi
                        if [[ "${doExit}" == true ]]; then exit 0; fi ;;
            esac
            unset -v FW_PARSE_HELP_LIST ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
