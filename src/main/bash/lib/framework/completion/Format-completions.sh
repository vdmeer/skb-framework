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
## Format - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Format_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Format)     retval="current element tagline table text themed" ;;

        current)        retval="mode" ;;
        element)        retval="status" ;;
        tagline)        retval="for" ;;
        table)          retval="topline midline bottomline" ;;
        themed)         retval="text" ;;

        for)            retval="clioption configuration format level mode setting theme themeitem"
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario site task"
                        retval+=" command element instance object" ;;

        *)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "for" ]]; then
                        case ${COMP_WORDS[COMP_CWORD-1]} in
                            application)    retval="$(Applications has)" ;;
                            clioption)      retval="$(Cli has long)" ;;
                            configuration)  retval="$(Configuration has)" ;;
                            dependency)     retval="$(Dependencies has)" ;;
                            dirlist)        retval="$(Dirlists has)" ;;
                            dir)            retval="$(Dirs has)" ;;
                            filelist)       retval="$(Filelists has)" ;;
                            file)           retval="$(Files has)" ;;
                            format)         retval="$(Formats has)" ;;
                            level)          retval="$(Levels has)" ;;
                            message)        retval="$(Messages has)" ;;
                            mode)           retval="$(Modes has)" ;;
                            modules)        retval="$(Modules has long)" ;;
                            option)         retval="$(Options has long)" ;;
                            phase)          retval="$(Phases has)" ;;
                            parameter)      retval="$(Parameters has)" ;;
                            project)        retval="$(Projects has)" ;;
                            scenario)       retval="$(Scenarios has)" ;;
                            setting)        retval="$(Settings has)" ;;
                            site)           retval="$(Sites has)" ;;
                            task)           retval="$(Tasks has)" ;;
                            theme)          retval="$(Themes has long)" ;;
                            themeitem)      retval="$(Themeitems has)" ;;

                            command)        retval="$(Framework has commands)" ;;
                            element)        retval="$(Framework has elements)" ;;
                            instance)       retval="$(Framework has instances)" ;;
                            object)         retval="$(Framework has objects)" ;;
                        esac
                    elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "for" ]]; then retval="list table"

                    fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Format_completions Format
