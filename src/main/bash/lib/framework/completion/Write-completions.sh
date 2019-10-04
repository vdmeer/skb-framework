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
## Write - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Write_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Write)                          retval="all cache everything framework fast full load medium slow theme" ;;

        all)                            retval="themes" ;;
        full)                           retval="cache" ;;

        framework)                      retval="cache" ;;
        theme)                          retval="$(Themes has)" ;;
        fast | load | medium | slow)    retval="config" ;;

        cache)                          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Write" ]]; then retval="for"; fi ;;
        for)                            retval="module" ;;
        module)                         retval="$(Modules has)" ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Write_completions Write
