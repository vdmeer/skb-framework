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
## validate-installation - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_task_validate_installation_words(){
    local retval=""
    local stdOptions="--describe --format --help"
    local taskOptions="--all --applications --dependencies --dirlists --dirs --exit-options --filelists --files --modules --options --parameters --projects --runtime-options --scenarios --sites --tasks"

    case ${COMP_WORDS[COMP_CWORD-1]} in
        validate-installation)  retval="${stdOptions} ${taskOptions}" ;;

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

                *"--all"*)              retval="" ;;
                *"--format"*)           retval="${retval//"--format"/}" ;;&
                *"--applications"*)     retval="${retval//"--applications"/}" ;;&
                *"--dependencies"*)     retval="${retval//"--dependencies"/}" ;;&
                *"--dirlists"*)         retval="${retval//"--dirlists"/}" ;;&
                *"--dirs"*)             retval="${retval//"--dirs"/}" ;;&
                *"--exit-options"*)     retval="${retval//"--exit-options"/}" ;;&
                *"--filelists"*)        retval="${retval//"--filelists"/}" ;;&
                *"--files"*)            retval="${retval//"--files"/}" ;;&
                *"--modules"*)          retval="${retval//"--modules"/}" ;;&
                *"--options"*)          retval="${retval//"--options"/}" ;;&
                *"--parameters"*)       retval="${retval//"--parameters"/}" ;;&
                *"--projects"*)         retval="${retval//"--projects"/}" ;;&
                *"--runtime-options"*)  retval="${retval//"--runtime-options"/}" ;;&
                *"--scenarios"*)        retval="${retval//"--scenarios"/}" ;;&
                *"--sites"*)            retval="${retval//"--sites"/}" ;;&
                *"--tasks"*)            retval="${retval//"--tasks"/}" ;;
            esac
            ;;
    esac
    printf "%s" "${retval}"
}

function __skb_task_validate_installation_completions(){
    local retval="$(__skb_task_validate_installation_words)"
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_task_validate_installation_completions validate-installation
