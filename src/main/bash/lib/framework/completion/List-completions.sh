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
## List - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_List_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        List)       retval="categorized framework logs"
                    retval+=" exitcodes"
                    retval+=" clioptions configurations formats levels messages modes phases settings themes themeitems"
                    retval+=" applications dependencies dirlists dirs filelists files modules options parameters projects scenarios sites tasks"
                    retval+=" actions elements instances objects" ;;

        configurations | applications | dependencies | dirlists | dirs | filelists | files | formats | levels | modes | modules | parameters | phases | projects | scenarios | settings | sites | tasks | themes | themeitems)
            retval="show-values" ;;

        categorized)    retval="clioptions messages options" ;;
        framework)      retval="cache" ;;

        clioptions)     if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "List" ]]; then retval="show-values"; fi ;;
        messages)       if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "List" ]]; then retval="show-values"; fi ;;
        options)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "categorized" ]]; then retval="Exit+Options Runtime+Options"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "List" ]]; then retval="show-values"
                        fi ;;

        Exit+Options)       case "${COMP_LINE}" in
                                *" Runtime+Options "*) ;;
                                *) retval="Runtime+Options" ;;
                            esac ;;
        Runtime+Options)    case "${COMP_LINE}" in
                                *" Exit+Options "*) ;;
                                *) retval="Exit+Options" ;;
                            esac ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_List_completions List
