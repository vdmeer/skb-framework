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
## Show - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Show_completions(){
    local retval="" list file dir
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Show)       retval="cache log statistics fast load medium slow project scenario script site task" ;;

        cache)      retval="file" ;;
        log)        retval="file" ;;
        file)       if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "cache" ]]; then
                        dir="$(Get cache dir)"
                        for file in ${dir}/**/*.cache; do
                            if [[ "${file}" == "${dir}/**/*.cache" ]]; then break; fi
                            file=${file//"${dir}/"/}; retval+=" ${file//.cache/}"
                        done
                    fi ;;

        fast)       retval="runtime" ;;
        load)       retval="runtime" ;;
        medium)     retval="runtime" ;;
        slow)       retval="runtime" ;;

        statistics) retval="overview for" ;;
        for)        retval="applications dependencies dirlists dirs filelists files options parameters projects scenarios sites tasks"
                    retval+=" messages phases settings themeitems"
                    retval+=" time" ;;

        project)    retval="execution" ;;
        scenario)   retval="execution" ;;
        script)     retval="execution" ;;
        site)       retval="execution" ;;
        task)       retval="execution" ;;

        execution)  retval="start end" ;;

    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Show_completions Show
