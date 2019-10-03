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
## Get - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Get_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Get)            retval="pid system version"
                        retval+=" app cache config current default error file home last log module option print status strict theme user warning"
                        retval+=" auto element object"
                        ;;

        auto)           retval="verify write" ;;
        default)        retval="theme" ;;

        element)        retval="dependency module parameter project scenario site task"
                        retval+=" file filelist dir dirlist" ;;
        object)         retval="configuration format level message mode phase setting theme themeitem" ;;

        configuration)  retval="$(Configuration has)" ;;
        format)         retval="$(Formats has)" ;;
        level)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Levels has)"; fi ;;
        message)        retval="$(Messages has)" ;;
        mode)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Modes has)"; fi ;;
        phase)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Phases has)"; fi ;;
        setting)        retval="$(Settings has)" ;;
        theme)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Themes has long)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]]; then retval="id"; fi ;;
        themeitem)      retval="$(Themeitems has)" ;;

        dependency)     retval="$(Dependencies has)" ;;
        module)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Modules has long)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]]; then retval="path id"; fi ;;
        option)         retval="id" ;;
        parameter)      retval="$(Parameters has)" ;;
        project)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Projects has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        scenario)       if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Scenarios has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        site)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Sites has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        task)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Tasks has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        file)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Files has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]]; then retval="string"; fi ;;
        filelist)       retval="$(Filelists has)" ;;
        dir)            retval="$(Dirs has)" ;;
        dirlist)        retval="$(Dirlists has)" ;;

        app)            retval="name name2" ;;
        cache)          retval="dir" ;;
        config)         retval="file" ;;
        current)        retval="mode phase theme project scenario site task" ;;
        home)           retval="dir" ;;

        error)          retval="count codes" ;;
        last)           retval="project scenario site task" ;;
        log)            if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then retval="level"; else retval="dir file format level date-arg"; fi ;;
        print)          if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then retval="level"; else retval="format format2 level"; fi ;;
        status)         retval="char" ;;
        strict)         retval="mode" ;;
        user)           retval="config" ;;
        warning)        retval="count" ;;

        *)              if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "configuration" ]]; then
                            retval="description value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "format" ]]; then
                           retval="description"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "level" ]]; then
                           retval="description"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "message" ]]; then
                           retval="arguments description text type"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "mode" ]]; then
                           retval="description"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then
                           retval="print description error log warning"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "setting" ]]; then
                           retval="description phase value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "theme" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="short description path"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "dependency" ]]; then
                           retval="description origin command requirements"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "module" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="description short path requirements"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "parameter" ]]; then
                           retval="description origin type default-value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "project" ]]; then
                           retval="description origin modes path targets"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "scenario" ]]; then
                           retval="description origin modes path"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "site" ]]; then
                           retval="description origin path"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "task" ]]; then
                           retval="description origin modes path"


                        fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Get_completions Get
