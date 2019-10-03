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
## skb-framework - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_skb_framework_completions(){
    local retval=""
    local exitOptions="--execute-command --execute-task --execute-scenario --help --option --runtime-tests --test-characters --test-colors --test-effects --test-terminal --version"
    local runOptions="--all-mode --build-mode --config-file --dev-mode --format --no-runtime-tests --strict-mode --use-mode"

    case ${COMP_WORDS[COMP_CWORD-1]} in
        skb-framework)  retval="${exitOptions} ${runOptions}" ;;

        ## these options required an argument
        --config-file)      retval="" ;;
        --format)           retval="" ;;
        --execute-command)  retval="" ;;
        --execute-scenario) retval="" ;;
        --execute-task)     retval="" ;;
        --option)           retval="" ;;

        *)  retval="${exitOptions} ${runOptions}"
            case "$COMP_LINE" in

                *"--execute-command"*)  retval="${retval//"--execute-command"/}" ;;&
                *"--execute-task"*)     retval="${retval//"--execute-task"/}" ;;&
                *"--help"*)             retval="${retval//"--help"/}" ;;&
                *"--option"*)           retval="${retval//"--option"/}" ;;&
                *"--execute-scenario"*) retval="${retval//"--execute-scenario"/}" ;;&
                *"--runtime-tests"*)    retval="${retval//"--runtime-tests"/}" ;;&
                *"--test-colors"*)      retval="${retval//"--test-colors"/}" ;;&
                *"--test-effects"*)     retval="${retval//"--test-effects"/}" ;;&
                *"--test-characters"*)  retval="${retval//"--test-characters"/}" ;;&
                *"--test-terminal"*)    retval="${retval//"--test-terminal"/}" ;;&
                *"--version"*)          retval="${retval//"--version"/}" ;;&

                *"--all-mode"*)         retval="${retval//"--all-mode"/}";   retval="${retval//"--build-mode"/}"; retval="${retval//"--dev-mode"/}"   ;;&
                *"--build-mode"*)       retval="${retval//"--build-mode"/}"; retval="${retval//"--all-mode"/}";   retval="${retval//"--dev-mode"/}"   ;;&
                *"--dev-mode"*)         retval="${retval//"--dev-mode"/}";   retval="${retval//"--all-mode"/}";   retval="${retval//"--build-mode"/}" ;;&
                *"--config-file"*)      retval="${retval//"--config-file"/}" ;;&
                *"--format"*)           retval="${retval//"--format"/}" ;;&
                *"--no-runtime-tests"*) retval="${retval//"--no-runtime-tests"/}" ;;&
                *"--strict-mode"*)      retval="${retval//"--strict-mode"/}" ;;&
                *"--use-mode"*)         retval="${retval//"--use-mode"/}" ;;
            esac ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_skb_framework_completions skb-framework
