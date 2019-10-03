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
## Parse - command to parse something
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

FW_TAGS_COMMANDS["Parse"]="command to parse something"

function Parse() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local appName shortString longString helpList doExit=false
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in
        cli | get | has | is)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                cli-arguments)
                    if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 1 "$#"; return; fi
                    helpList="${1}"; shift
                    case "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" in
                        CLI)    appName="skb-framework"
                                shortString="$(Options short string)"
                                longString="$(Options long string)" ;;
                        Task)   appName="${FW_OBJECT_SET_VAL["CURRENT_TASK"]}"
                                shortString="$(Cli short string)"
                                longString="$(Cli long string)" ;;
                        *)
##ERROR MESSAGE
;;
                    esac

                    unset -v FW_PARSED_ARG_MAP FW_PARSED_VAL_MAP FW_PARSED_EXTRA
                    declare -A -g FW_PARSED_ARG_MAP FW_PARSED_VAL_MAP; declare -g FW_PARSED_EXTRA=""

                    ! PARSED=$(getopt --options "${shortString}" --longoptions "${longString}" --name "${appName}" -- "$@")
                    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
                        Report application error "${FUNCNAME[0]}" "${cmdString2}" E814
                        case "${FW_OBJECT_SET_VAL["CURRENT_PHASE"]}" in
                            CLI)    Terminate 1 ;;
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
                        CLI)    if [[ "${FW_PARSED_ARG_MAP[F]:-${FW_PARSED_ARG_MAP[format]:-no}}" == yes ]]; then Set print format "${FW_PARSED_VAL_MAP[F]:-${FW_PARSED_VAL_MAP[format]}}"; fi
                                if [[ ${FW_PARSED_ARG_MAP[h]:-${FW_PARSED_ARG_MAP[help]:-no}} == yes ]]; then Print help; Terminate 0; fi ;;
                        Task)   if [[ "${FW_PARSED_ARG_MAP[F]:-${FW_PARSED_ARG_MAP[format]:-no}}" == yes ]]; then FW_OBJECT_SET_VAL["PRINT_FORMAT2"]="${FW_PARSED_VAL_MAP[F]:-${FW_PARSED_VAL_MAP[format]}}"; fi
                                if [[ ${FW_PARSED_ARG_MAP[D]:-${FW_PARSED_ARG_MAP[describe]:-no}} == yes ]]; then printf "\n"; Describe task "${FW_OBJECT_SET_VAL["CURRENT_TASK"]}"; doExit=true; fi
                                if [[ ${FW_PARSED_ARG_MAP[h]:-${FW_PARSED_ARG_MAP[help]:-no}} == yes ]]; then List categorized clioptions ${helpList}; doExit=true; fi
                                if [[ "${doExit}" == true ]]; then exit 0; fi ;;
                    esac
                    unset -v FW_PARSE_HELP_LIST

                    ;;

                is-set)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    shortOpt="${1}"; longOpt="${2}"
                    if [[ -n "${shortOpt}" && -n "${FW_PARSED_ARG_MAP[${shortOpt}]:-}" ]]; then printf yes; return; fi
                    if [[ -n "${longOpt}"  && -n "${FW_PARSED_ARG_MAP[${longOpt}]:-}"  ]]; then printf yes; return; fi
                    printf no ;;

                has-value)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    shortOpt="${1}"; longOpt="${2}"
                    if [[ -n "${shortOpt}" && -n "${FW_PARSED_VAL_MAP[${shortOpt}]:-}" ]]; then printf yes; return; fi
                    if [[ -n "${longOpt}"  && -n "${FW_PARSED_VAL_MAP[${longOpt}]:-}"  ]]; then printf yes; return; fi
                    printf no ;;

                get-value)
                    if [[ "${#}" -lt 2 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString2}" E801 2 "$#"; return; fi
                    shortOpt="${1}"; longOpt="${2}"
                    if [[ -n "${shortOpt}" && -n "${FW_PARSED_VAL_MAP[${shortOpt}]:-}" ]]; then printf "${FW_PARSED_VAL_MAP[${shortOpt}]}"; return; fi
                    if [[ -n "${longOpt}"  && -n "${FW_PARSED_VAL_MAP[${longOpt}]:-}"  ]]; then printf "${FW_PARSED_VAL_MAP[${longOpt}]}"; return; fi
                    printf ""; return 1 ;;

                get-extra)
                    printf "%s" "${FW_PARSED_EXTRA}" ;;

                *)
                    Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
