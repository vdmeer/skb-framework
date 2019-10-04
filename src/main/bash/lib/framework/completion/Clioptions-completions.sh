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
## Clioptions - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Clioptions_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Clioptions) retval="add has list long short shorts" ;;

        add)        retval="general option" ;;
        general)    retval="option" ;;
        option)     if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "add" ]]; then
                        retval="help format describe table show-values with-legend without-extras without-status"
                        retval+=" filter-id filter-mode filter-origin filter-requested filter-status filter-tested filter-not-core"
                        retval+=" filter-exitop filter-runtop"
                        retval+=" task-none-all task-none-build task-none-debug task-none-describe task-none-list task-none-dl task-none-dll"
                        retval+=" task-only-build task-only-debug task-only-describe task-only-list"
                        retval+=" target-all"
                    fi ;;

        long | short)   retval="string" ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Clioptions_completions Clioptions
