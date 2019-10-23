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
        Format)     retval="4d ansi available defval element exec execution has-value help is-set list phase paragraph status table tagline text themed" ;;

        4d)             retval="number" ;;
        ansi)           retval="end file start" ;;
        element)        retval="status" ;;
        execution)      retval="line" ;;
        help)           retval="indentation" ;;
        level)          retval="$(Levels has)" ;;
        list)           retval="from" ;;
        mode)           retval="$(Modes has)" ;;
        paragraph)      retval="from" ;;
        tagline)        retval="for" ;;
        table)          retval="toprule midrule bottomrule legendrule statusrule extras legend" ;;
        themed)         retval="text" ;;

        extras)         retval="for" ;;
        legend)         retval="for" ;;

        phase)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Format" ]]; then retval="char"
                        else retval="$(Phases has)"
                        fi ;;
        available)      retval="char" ;;
        defval)         retval="char" ;;
        exec)           retval="char" ;;
        has-value)      retval="char" ;;
        is-set)         retval="char" ;;
        status)         retval="char" ;;

        for)            retval="clioption exitcode"
                        retval+=" configuration format level message mode setting phase theme themeitem variable"
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario script site task"
                        retval+=" action element instance object operation"
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "tagline" ]]; then retval+=" framework"; fi ;;
        from)           retval="file" ;;

        *)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "for" ]]; then
                        case ${COMP_WORDS[COMP_CWORD-1]} in
                            application)    retval="$(Applications has)" ;;
                            clioption)      retval="$(Clioptions has)" ;;
                            configuration)  retval="$(Configurations has)" ;;
                            dependency)     retval="$(Dependencies has)" ;;
                            dirlist)        retval="$(Dirlists has)" ;;
                            dir)            retval="$(Dirs has)" ;;
                            exitcode)       retval="$(Exitcodes has)" ;;
                            filelist)       retval="$(Filelists has)" ;;
                            file)           retval="$(Files has)" ;;
                            format)         retval="$(Formats has)" ;;
                            message)        retval="$(Messages has)" ;;
                            modules)        retval="$(Modules has)" ;;
                            option)         retval="$(Options has)" ;;
                            phase)          retval="$(Phases has)" ;;
                            parameter)      retval="$(Parameters has)" ;;
                            project)        retval="$(Projects has)" ;;
                            scenario)       retval="$(Scenarios has)" ;;
                            setting)        retval="$(Settings has)" ;;
                            script)         retval="$(Scripts has)" ;;
                            site)           retval="$(Sites has)" ;;
                            task)           retval="$(Tasks has)" ;;
                            theme)          retval="$(Themes has)" ;;
                            themeitem)      retval="$(Themeitems has)" ;;
                            variable)       retval="$(Variables has)" ;;

                            action)         retval="$(Framework has actions)" ;;
                            element)        retval="$(Framework has elements)" ;;
                            instance)       retval="$(Framework has instances)" ;;
                            object)         retval="$(Framework has objects)" ;;
                            operation)      retval="${!SF_OPERATIONS[@]}" ;;
                        esac
                    elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "for" ]]; then retval="list table"

                    elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "4d" ]]; then
                        retval="$(Themeitems has)"
                    elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "4d" ]]; then
                        retval="$(Themeitems has)"
                    elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "4d" ]]; then
                        retval="$(Themeitems has)"
                    elif [[ "${COMP_WORDS[COMP_CWORD-5]}" == "4d" ]]; then
                        retval="$(Themeitems has)"

                    fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Format_completions Format
