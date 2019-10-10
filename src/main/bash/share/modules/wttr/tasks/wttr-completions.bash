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
## wttr - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_task_wttr_words(){
    local retval="" name
    local stdOptions="--describe --format --help"
    local locationOptions="--airport --city --country --domain --gps --place --zip"
    local unitOptions="--metric --speed --uscs"
    local periodOptions="--now --today --tomorrow --two-days"
    local formatOptions="--force-ansi --narrow --no-colors --wide"

    case ${COMP_WORDS[COMP_CWORD-1]} in
        wttr)       retval="${stdOptions} ${locationOptions} ${unitOptions} ${periodOptions} ${formatOptions}" ;;

        --help)     retval="--describe --format"
                    case "$COMP_LINE" in
                        *"--describe"*) retval="${retval//"--describe"/}" ;;&
                        *"--format"*)   retval="${retval//"--format"/}" ;;
                    esac ;;
        --describe) retval="--help --format"
                    case "$COMP_LINE" in
                        *"--help"*)     retval="${retval//"--help"/}" ;;&
                        *"--format"*)   retval="${retval//"--format"/}" ;;
                    esac ;;
        --format)   retval="$(Formats has)" ;;

        --airport)      retval="ams cdg sfx dub" ;;
        --city)         retval="Amsterdam Berlin Paris Dublin" ;;
        --country)      retval="Nederland Deutschland France Ireland" ;;
        --domain)       retval="stackoverflow.com github.com" ;;
        --gps)          retval="-78.46,106.79" ;;
        --place)        retval="Eiffel+Tower Fernsehturm" ;;
        --zip)          retval="94107" ;;

        *)  retval="${stdOptions} ${locationOptions} ${unitOptions} ${periodOptions} ${formatOptions}"
            case "$COMP_LINE" in
                *"--help"*)             case "$COMP_LINE" in
                                            *"--describe"*) retval="" ;;
                                            **) retval="describe" ;;
                                        esac ;;
                *"--describe"*)         case "$COMP_LINE" in
                                            *"--help"*) retval="" ;;
                                            **) retval="help" ;;
                                        esac ;;

                *"--airport"*)          for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--city"*)             for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--country"*)          for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--domain"*)           for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--gps"*)              for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--place"*)            for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--zip"*)              for name in ${locationOptions}; do retval="${retval//"${name}"/}"; done ;;&

                *"--metric"*)           retval="${retval//"--metric"/}"; retval="${retval//"--uscs"/}" ;;&
                *"--uscs"*)             retval="${retval//"--uscs"/}"; retval="${retval//"--metric"/}" ;;&

                *"--speed"*)            retval="${retval//"--speed"/}" ;;&

                *"--now"*)              for name in ${periodOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--today"*)            for name in ${periodOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--tomorrow"*)         for name in ${periodOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--two-days"*)         for name in ${periodOptions}; do retval="${retval//"${name}"/}"; done ;;&

                *"--narrow"*)           retval="${retval//"--narrow"/}"; retval="${retval//"--wide"/}" ;;&
                *"--wide"*)             retval="${retval//"--wide"/}"; retval="${retval//"--narrow"/}" ;;&

                *"--force-ansi"*)       retval="${retval//"--force-ansi"/}" ;;&
                *"--no-colors"*)        retval="${retval//"--no-colors"/}" ;;&
            esac
            ;;
    esac
    printf "%s" "${retval}"
}

function __skb_task_wttr_completions(){
    local retval="$(__skb_task_wttr_words)"
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_task_wttr_completions wttr
