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
## list-dirlists - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_task_list_dirlists_words(){
    local retval=""
    local stdOptions="--describe --format --help --table --show-values"
    local taskOptions="--origin --requested --status --tested --not-core"
    local tableOptions="--without-status --with-legend --without-extras"

    case ${COMP_WORDS[COMP_CWORD-1]} in
        list-dirlists)  retval="${stdOptions} ${taskOptions}" ;;

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

        --origin)       retval="$(Modules has long)" ;;
        --requested)    retval="yes no" ;;
        --status)       retval="N E W S" ;;
        --tested)       retval="yes no" ;;

        *)  retval="${stdOptions} ${taskOptions}"
            case "$COMP_LINE" in
                *"--help"*)             case "$COMP_LINE" in
                                            *"--describe"*) retval="" ;;
                                            **) retval="describe" ;;
                                        esac ;;
                *"--describe"*)         case "$COMP_LINE" in
                                            *"--help"*) retval="" ;;
                                            **) retval="help" ;;
                                        esac ;;

                *"--table"*)            retval="${retval//"--table"/}"; retval+=" ${tableOptions}" ;;&
                *"--with-legend"*)      retval="${retval//"--with-legend"/}" ;;&
                *"--without-extras"*)   retval="${retval//"--without-extras"/}"; retval="${retval//"--with-legend"/}" ;;&
                *"--without-status"*)   retval="${retval//"--without-status"/}" ;;&
                *"--format"*)           retval="${retval//"--format"/}" ;;&
                *"--show-values"*)      retval="${retval//"--show-values"/}" ;;&
                *"--origin"*)           retval="${retval//"--origin"/}" ;;&
                *"--requested"*)        retval="${retval//"--requested"/}" ;;&
                *"--status"*)           retval="${retval//"--status"/}" ;;&
                *"--tested"*)           retval="${retval//"--tested"/}" ;;&
                *"--not-core"*)         retval="${retval//"--not-core"/}" ;;
            esac
            ;;
    esac
    printf "%s" "${retval}"
}

function __skb_task_list_dirlists_completions(){
    local retval="$(__skb_task_list_dirlists_words)"
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_task_list_dirlists_completions list-dirlists
