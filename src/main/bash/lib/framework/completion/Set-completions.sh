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
        Set)            retval="value phase themeitem file filelist dir dirlist parameter"
                        retval+=" application app config current error last log module print strict warning"
                        retval+=" auto"
                        ;;

        file)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then retval="$(Files has)"; fi ;;
        filelist)       if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then retval="$(Filelists has)"; fi ;;
        dir)            if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then retval="$(Dirs has)"; fi ;;
        dirlist)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then retval="$(Dirlists has)"; fi ;;
        parameter)      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then retval="$(Parameters has)"; fi ;;

        value)          retval="for" ;;
        phase)          retval="$(Phases has)" ;;

        application)    retval="$(Applications has)" ;;

        app)            retval="name name2" ;;
        config)         retval="file" ;;
        current)        retval="mode phase theme project scenario site task" ;;
        error)          retval="count codes" ;;
        last)           retval="project scenario site task" ;;
        log)            if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then
                            retval="dir file format level date-arg"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then
                            retval="level"
                        fi ;;
        module)         retval="path" ;;
        print)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Set" ]]; then
                            retval="format format2 level"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "phase" ]]; then
                            retval="level"
                        fi ;;
        strict)         retval="mode" ;;
        theme)          retval="$(Themes has long)" ;;
        themeitem)      retval="$(Themeitems has)" ;;
        warning)        retval="count" ;;

        auto)           retval="verify write" ;;

        codes)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "error" ]]; then retval="$(Messages has)"; fi ;;

        *)              if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "phase" ]]; then
                            retval="print error log warning"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "value" && "${COMP_WORDS[COMP_CWORD-1]}" == "for" ]]; then
                            retval="$(Settings has)"
                        elif [[ "${COMP_WORDS[COMP_CWORD-3]}" == "value" && "${COMP_WORDS[COMP_CWORD-2]}" == "for" ]]; then
                            retval="to"
                        elif [[ "${COMP_WORDS[COMP_CWORD-4]}" == "value" && "${COMP_WORDS[COMP_CWORD-3]}" == "for" && "${COMP_WORDS[COMP_CWORD-1]}" == "to" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-2]} in
                                CURRENT_MODE)                               retval="$(Modes has)" ;;
                                CURRENT_PHASE)                              retval="$(Phases has)" ;;
                                CURRENT_THEME)                              retval="$(Themes has long)" ;;
                                CURRENT_PROJECT | LAST_PROJECT)             retval="$(Projects has long)" ;;
                                CURRENT_SCENARIO | LAST_SCENARIO)           retval="$(Scenarios has long)" ;;
                                CURRENT_SITE | LAST_SITE)                   retval="$(Sites has long)" ;;
                                CURRENT_TASK | LAST_TASK)                   retval="$(Tasks has long)" ;;
                                LOG_LEVEL | PRINT_LEVEL)                    retval="$(Levels has) all none" ;;
                                LOG_FORMAT | PRINT_FORMAT | PRINT_FORMAT2)  retval="$(Formats has)" ;;
                                STRICT_MODE)                                retval="on off" ;;
                                ERROR_COUNT | WARNING_COUNT)                retval="-2 -1 0 +1 +2 1 2 3 4 5" ;;
                            esac

                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "current" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-1]} in
                                mode)       retval="$(Modes has)" ;;
                                phase)      retval="$(Phases has)" ;;
                                theme)      retval="$(Themes has)" ;;
                                project)    retval="$(Projects has)" ;;
                                scenario)   retval="$(Scenarios has)" ;;
                                site)       retval="$(Sites has)" ;;
                                task)       retval="$(Tasks has)" ;;
                            esac
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "last" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-1]} in
                                project)    retval="$(Projects has)" ;;
                                scenario)   retval="$(Scenarios has)" ;;
                                site)       retval="$(Sites has)" ;;
                                task)       retval="$(Tasks has)" ;;
                            esac
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "log" || "${COMP_WORDS[COMP_CWORD-2]}" == "print" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-1]} in
                                format)     retval="$(Formats has)" ;;
                                format2)    retval="$(Formats has)" ;;
                                level)      retval="$(Levels has) all none" ;;
                            esac
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "strict" ]]; then
                            case ${COMP_WORDS[COMP_CWORD-1]} in
                                mode)       retval="on off" ;;
                            esac

                        fi ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Set_completions Set
