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
## Set - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Set_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Set)            retval="app config current error last log module print warning"
                        retval+=" element object" ;;

        app)            retval="name name2" ;;
        config)         retval="file" ;;
        current)        retval="mode phase theme project scenario script site task" ;;
        error)          retval="count" ;;
        last)           retval="project scenario script site task" ;;
        log)            retval="dir file format level date-arg" ;;
        module)         retval="path" ;;
        print)          retval="format format2 level" ;;
        warning)        retval="count" ;;

        object)         retval="phase setting themeitem" ;;
        element)        retval="application" ;;

        phase)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Phases has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "current" ]]; then retval="to"; fi ;;
        setting)        retval="$(Settings has)" ;;
        themeitem)      retval="$(Themeitems has)" ;;
        application)    retval="$(Applications has)" ;;


        count)          retval="to" ;;
        name)           retval="to" ;;
        name2)          retval="to" ;;
        file)           retval="to" ;;
        mode)           retval="to" ;;
        theme)          retval="to" ;;
        project)        retval="to" ;;
        scenario)       retval="to" ;;
        script)         retval="to" ;;
        site)           retval="to" ;;
        task)           retval="to" ;;
        dir)            retval="to" ;;
        format)         retval="to" ;;
        format2)        retval="to" ;;
        level)          retval="to" ;;
        date-arg)       retval="to" ;;
        path)           retval="to" ;;
        site)           retval="to" ;;


        *)              if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "mode" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Modes has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "theme" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Themes has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "phase" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Phases has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "project" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Projects has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "script" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Scripts has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "scenario" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Scenarios has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "site" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Sites has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "current" && "${COMP_WORDS[COMP_CWORD-2]}" == "task" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Tasks has)"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "last" && "${COMP_WORDS[COMP_CWORD-2]}" == "project" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Projects has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "last" && "${COMP_WORDS[COMP_CWORD-2]}" == "script" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Scripts has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "last" && "${COMP_WORDS[COMP_CWORD-2]}" == "scenario" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Scenarios has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "last" && "${COMP_WORDS[COMP_CWORD-2]}" == "site" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Sites has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "last" && "${COMP_WORDS[COMP_CWORD-2]}" == "task" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Tasks has)"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "log" && "${COMP_WORDS[COMP_CWORD-2]}" == "format" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Formats has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "log" && "${COMP_WORDS[COMP_CWORD-2]}" == "level" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Levels has)"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "print" && "${COMP_WORDS[COMP_CWORD-2]}" == "format" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Formats has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "print" && "${COMP_WORDS[COMP_CWORD-2]}" == "format2" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Formats has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "print" && "${COMP_WORDS[COMP_CWORD-2]}" == "level" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            retval="$(Levels has)"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" && "${COMP_WORDS[COMP_CWORD-2]}" == "setting" ]]; then
                            retval="to"
                        elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "object" && "${COMP_WORDS[COMP_CWORD-3]}" == "setting" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-2]} in
                                CURRENT_MODE)                               retval="$(Modes has)" ;;
                                CURRENT_PHASE)                              retval="$(Phases has)" ;;
                                CURRENT_THEME)                              retval="$(Themes has)" ;;
                                CURRENT_PROJECT | LAST_PROJECT)             retval="$(Projects has)" ;;
                                CURRENT_SCRIPT | LAST_SCRIPT)               retval="$(Scripts has)" ;;
                                CURRENT_SCENARIO | LAST_SCENARIO)           retval="$(Scenarios has)" ;;
                                CURRENT_SITE | LAST_SITE)                   retval="$(Sites has)" ;;
                                CURRENT_TASK | LAST_TASK)                   retval="$(Tasks has)" ;;
                                LOG_LEVEL | PRINT_LEVEL)                    retval="$(Levels has) all none" ;;
                                LOG_FORMAT | PRINT_FORMAT | PRINT_FORMAT2)  retval="$(Formats has)" ;;
                            esac

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" && "${COMP_WORDS[COMP_CWORD-2]}" == "themeitem" ]]; then
                            retval="to"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" && "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then
                            retval="print-level log-level error-count warning-count"
                        elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "object" && "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then
                            retval="to"
                        elif [[ "${COMP_WORDS[COMP_CWORD-5]}" == "object" && "${COMP_WORDS[COMP_CWORD-4]}" == "phase" ]]; then
                            retval="all none $(Levels has)"

                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "element" && "${COMP_WORDS[COMP_CWORD-2]}" == "application" ]]; then
                            retval="command to"
                        elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "element" && "${COMP_WORDS[COMP_CWORD-3]}" == "application" && "${COMP_WORDS[COMP_CWORD-1]}" == "command" ]]; then
                            retval="to"

                        fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Set_completions Set
