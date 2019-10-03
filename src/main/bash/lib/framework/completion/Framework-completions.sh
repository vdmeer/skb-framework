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
## Framework - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __Framework_component_completions(){
    local retval="" index

    case "${#COMP_WORDS[@]}" in
        1)  ;;
        2)  for index in ${SF_HOME}/lib/framework/{commands,elements,objects,instances}/*.sh; do index=${index##*/}; if [[ "${index}" != "Framework" ]]; then retval+=" ${index%%.sh}"; fi; done
            retval+=" has"
            COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[1]}")) ;;
        3)  case "${COMP_LINE}" in
                "Framework has "*)  COMPREPLY=($(compgen -W "commands elements instances objects" -- "${COMP_WORDS[2]}")) ;;
                *)                  __skb_${COMP_WORDS[1]}_completions
            esac ;;
        4)  case "${COMP_LINE}" in
                "Framework has "*)  ;;
                *)                  __skb_${COMP_WORDS[1]}_completions
            esac ;;
        *)  __skb_${COMP_WORDS[1]}_completions ;;
    esac
}
complete -F __Framework_component_completions Framework


