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
                        retval+=" app cache config current default error file home message last log module option primary print retest show start status strict user warning"
                        retval+=" auto element object"
                        ;;

        auto)           retval="verify write" ;;
        default)        retval="theme" ;;
        primary)        retval="module" ;;

        element)        retval="application dependency dirlist dir filelist file module option parameter project scenario script site task" ;;
        object)         retval="configuration format level message mode phase setting theme themeitem variable" ;;

        configuration)  retval="$(Configurations has)" ;;
        format)         retval="$(Formats has)" ;;
        level)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Levels has)"; fi ;;
        message)        if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" ]]; then retval="description path character theme-string"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]]; then retval="codes"
                        else retval="$(Messages has)"
                        fi ;;
        codes)          retval="" ;;
        mode)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Modes has)"; fi ;;
        phase)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "object" ]]; then retval="$(Phases has)"; fi ;;
        setting)        retval="$(Settings has)" ;;
        theme)          retval="$(Themes has)" ;;
        themeitem)      retval="$(Themeitems has)" ;;
        variable)       retval="$(Variables has)" ;;

        application)    retval="$(Applications has)" ;;
        dependency)     retval="$(Dependencies has)" ;;
        module)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Modules has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "primary" ]]; then retval="path"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]];     then retval="path"; fi ;;
        option)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Options has)"
                        else retval="id"
                        fi ;;
        parameter)      retval="$(Parameters has)" ;;
        project)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Projects has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        scenario)       if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Scenarios has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        script)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Scripts has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        site)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Sites has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        task)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Tasks has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then  retval="print description error log warning"; fi ;;
        file)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Files has)"; fi
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Get" ]]; then retval="string"; fi ;;
        filelist)       retval="$(Filelists has)" ;;
        dir)            if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "element" ]]; then retval="$(Dirs has)"; fi ;;
        dirlist)        retval="$(Dirlists has)" ;;

        app)            retval="name name2" ;;
        cache)          retval="dir" ;;
        config)         retval="file" ;;
        current)        retval="mode phase theme project script scenario site task" ;;
        home)           retval="dir" ;;

        retest)         retval="commands fs" ;;

        error)          if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" ]]; then retval="description path character theme-string"
                        else retval="count"
                        fi ;;
        last)           retval="project script scenario site task" ;;
        log)            if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then retval="level"; else retval="dir file format level date-arg"; fi ;;
        print)          if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then retval="level"; else retval="format format2 level"; fi ;;
        show)           retval="execution execution2" ;;
        start)          retval="time" ;;
        status)         retval="char" ;;
        strict)         retval="mode" ;;
        user)           retval="config" ;;
        warning)        if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "object" ]]; then retval="description path character theme-string"
                        else retval="count"
                        fi ;;

        *)              if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "configuration" ]]; then
                            retval="description value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "format" ]]; then
                           retval="description"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "level" ]]; then
                           retval="description character theme-string"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "message" ]]; then
                           retval="arguments description text type category"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "mode" ]]; then
                           retval="description"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then
                           retval="print-level description error-count message-codes message-count log-level warning-count"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "setting" ]]; then
                           retval="description phase value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "theme" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="description"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "themeitem" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="description value source"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "variable" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="description"

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "application" ]]; then
                           retval="description origin phase command argnum arguments status status-comments requested"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "dependency" ]]; then
                           retval="description origin command requirements status status-comments requested"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "dirlist" || "${COMP_WORDS[COMP_CWORD-2]}" == "dir" || "${COMP_WORDS[COMP_CWORD-2]}" == "filelist" || "${COMP_WORDS[COMP_CWORD-2]}" == "file" ]]; then
                            retval="description origin phase value mode status status-comments requested"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "module" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" && "${COMP_WORDS[COMP_CWORD-3]}" != "primary" ]]; then
                           retval="description acronym path phase requirements status status-comments requested"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "option" && "${COMP_WORDS[COMP_CWORD-3]}" != "Get" ]]; then
                           retval="description short argument category length set value"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "parameter" ]]; then
                           retval="description origin default-value phase value status status-comments requested"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "project" ]]; then
                           retval="description origin modes path path-text root-dir targets status status-comments required-applications required-dependencies required-parameters required-projects required-scenarios required-sites required-tasks required-files required-filelists required-directories required-dirlists"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "script" ]]; then
                           retval="description origin modes path path-text root-dir targets status status-comments required-applications required-dependencies required-parameters required-projects required-scripts required-scenarios required-sites required-tasks required-files required-filelists required-directories required-dirlists"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "scenario" ]]; then
                           retval="description origin modes path path-text status status-comments required-applications required-scenarios required-tasks"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "site" ]]; then
                           retval="description origin path path-text file status status-comments required-applications required-dependencies required-parameters required-scenarios required-tasks required-files required-filelists required-directories required-dirlists"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "task" ]]; then
                           retval="description origin modes path path-text status status-comments required-applications required-dependencies required-parameters required-tasks required-files required-filelists required-directories required-dirlists"

                        fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Get_completions Get
