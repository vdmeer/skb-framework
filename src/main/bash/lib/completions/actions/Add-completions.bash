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
## Add - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Add_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Add)            retval="element object" ;;

        element)        retval="application dependency module parameter project scenario site task file filelist dir dirlist" ;;
        object)         retval="configuration format level message mode phase setting theme themeitem" ;;

        *)  ## Add element module -> finished here
            if [[ "${COMP_LINE}" == "Add element module " ]]; then
                :

            ## Add object [cfg|fmt|lvl|msg|mod|pha|set|thm|tim] ID(1) with(2) 3...
            elif [[ "${COMP_CWORD}" -gt 2 && "${COMP_WORDS[COMP_CWORD-3]}" == "Add" && "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then
                retval="ID NAME"
            elif [[ "${COMP_CWORD}" -gt 3 && "${COMP_WORDS[COMP_CWORD-4]}" == "Add" && "${COMP_WORDS[COMP_CWORD-3]}" == "object" ]]; then
                retval="with"

            ## Add element [app|dep|dir|dirlist|file|filelist|par|prj|scn|scr|sit|tsk] ID(1) with(2) 3...
            elif [[ "${COMP_CWORD}" -gt 2 && "${COMP_WORDS[COMP_CWORD-3]}" == "Add" && "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then
                retval="ID NAME"
            elif [[ "${COMP_CWORD}" -gt 3 && "${COMP_WORDS[COMP_CWORD-4]}" == "Add" && "${COMP_WORDS[COMP_CWORD-3]}" == "element" ]]; then
                retval="with"

            fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Add_completions Add
