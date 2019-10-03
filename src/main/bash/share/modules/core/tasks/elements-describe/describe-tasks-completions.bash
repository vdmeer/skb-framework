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
## describe-tasks - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_task_describe_tasks_words(){
    local retval="" name
    local stdOptions="--describe --format --help"
    local filterOptions="--id --mode --origin --requested --status --tested --not-core"
    local noneFilterOptions="--none-all --none-build --none-debug --none-describe --none-list --none-dl --none-ddl"
    local onlyFilterOptions="--only-build --only-debug --only-describe --only-list"

    case ${COMP_WORDS[COMP_CWORD-1]} in
        describe-tasks)  retval="${stdOptions} ${filterOptions} ${noneFilterOptions} ${onlyFilterOptions}" ;;

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

        --id)           retval="$(Tasks has)" ;;
        --mode)         retval="$(Modes has)" ;;
        --origin)       retval="$(Modules has long)" ;;
        --requested)    retval="yes no" ;;
        --status)       retval="N E W S" ;;
        --tested)       retval="yes no" ;;

        *)  retval="${stdOptions} ${filterOptions} ${noneFilterOptions} ${onlyFilterOptions}"
            case "$COMP_LINE" in
                *"--help"*)             case "$COMP_LINE" in
                                            *"--describe"*) retval="" ;;
                                            **) retval="describe" ;;
                                        esac ;;
                *"--describe"*)         case "$COMP_LINE" in
                                            *"--help"*) retval="" ;;
                                            **) retval="help" ;;
                                        esac ;;

                *"--id"*)               retval="" ;;
                *"--format"*)           retval="${retval//"--format"/}" ;;&
                *"--mode"*)             retval="${retval//"--mode"/}" ;;&
                *"--origin"*)           retval="${retval//"--origin"/}" ;;&
                *"--requested"*)        retval="${retval//"--requested"/}" ;;&
                *"--status"*)           retval="${retval//"--status"/}" ;;&
                *"--tested"*)           retval="${retval//"--tested"/}" ;;&
                *"--not-core"*)         retval="${retval//"--not-core"/}" ;;&

                *"--none-all"*)         for name in ${noneFilterOptions}; do retval="${retval//"${name}"/}"; done; for name in ${onlyFilterOptions}; do retval="${retval//"${name}"/}"; done ;;&
                *"--none-build"*)       retval="${retval//"--none-build"/}"; retval="${retval//"--only-build"/}" ;;&
                *"--none-debug"*)       retval="${retval//"--none-debug"/}"; retval="${retval//"--only-debug"/}" ;;&
                *"--none-describe"*)    retval="${retval//"--none-describe"/}"; retval="${retval//"--only-describe"/}" ;;&
                *"--none-list"*)        retval="${retval//"--none-list"/}"; retval="${retval//"--only-list"/}" ;;&
                *"--none-dl"*)          retval="${retval//"--none-dl"/}";  retval="${retval//"--none-describe"/}"; retval="${retval//"--none-list"/}"; retval="${retval//"--only-describe"/}"; retval="${retval//"--only-list"/}" ;;&
                *"--none-ddl"*)         retval="${retval//"--none-ddl"/}"; retval="${retval//"--none-debug"/}"; retval="${retval//"--none-describe"/}"; retval="${retval//"--none-list"/}"; retval="${retval//"--only-debug"/}"; retval="${retval//"--only-describe"/}"; retval="${retval//"--only-list"/}" ;;&

                *"--only-build"*)       retval="${retval//"--none-build"/}"; retval="${retval//"--only-build"/}" ;;&
                *"--only-debug"*)       retval="${retval//"--none-debug"/}"; retval="${retval//"--only-debug"/}" ;;&
                *"--only-describe"*)    retval="${retval//"--none-describe"/}"; retval="${retval//"--only-describe"/}" ;;&
                *"--only-list"*)        retval="${retval//"--none-list"/}"; retval="${retval//"--only-list"/}" ;;&
            esac
            ;;
    esac
    printf "%s" "${retval}"
}

function __skb_task_describe_tasks_completions(){
    local retval="$(__skb_task_describe_tasks_words)"
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_task_describe_tasks_completions describe-tasks
