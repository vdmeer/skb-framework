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
## Print - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Print_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Print)          retval="categorized framework test"
                        retval+=" exitcode clioption"
                        retval+=" configuration format level message mode phase setting theme themeitem variable "
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario script site task"
                        retval+=" action element instance object operation" ;;

        categorized)    retval="message option" ;;
        framework)      retval="help version" ;;
        test)           retval="colors effects characters terminal" ;;

        application)    retval="table descriptions list" ;;
        clioption)      retval="table list" ;;
        configuration)  retval="table list" ;;
        dependency)     retval="table descriptions list" ;;
        dirlist)        retval="table descriptions list" ;;
        dir)            retval="table descriptions list" ;;
        exitcode)       retval="table descriptions list" ;;
        filelist)       retval="table descriptions list" ;;
        file)           retval="table descriptions list" ;;
        format)         retval="table descriptions list" ;;
        level)          retval="table descriptions list" ;;
        message)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "categorized" ]]; then retval="table"; else retval="table descriptions list"; fi ;;
        mode)           retval="table descriptions list" ;;
        module)         retval="table descriptions list" ;;
        option)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "categorized" ]]; then retval="table"; else retval="table descriptions list"; fi ;;
        parameter)      retval="table descriptions list" ;;
        phase)          retval="table descriptions list" ;;
        project)        retval="table descriptions list" ;;
        scenario)       retval="table descriptions list" ;;
        setting)        retval="list table" ;;
        script)         retval="table descriptions list" ;;
        site)           retval="table descriptions list" ;;
        task)           retval="table descriptions list" ;;
        theme)          retval="table descriptions list" ;;
        themeitem)      retval="table descriptions list" ;;
        variable)       retval="table descriptions list" ;;

        action)         retval="table descriptions list" ;;
        element)        retval="table descriptions list" ;;
        instance)       retval="table descriptions list" ;;
        object)         retval="table descriptions list" ;;
        operation)      retval="table list" ;;

        table)          if [[ "${COMP_WORDS[COMP_CWORD-3]}" == "categorized" ]]; then retval="Exit+Options Runtime+Options"; else
                            retval="show-values with-legend without-status without-extras"
                            case "$COMP_LINE" in
                                "Print exitcode table "* )  retval="without-status" ;;
                                "Print action table "* )    retval="without-status" ;;
                                "Print element table "* )   retval="without-status" ;;
                                "Print instance table "* )  retval="without-status" ;;
                                "Print object table "* )    retval="without-status" ;;
                                "Print operation table "* ) retval="without-status" ;;
                                "Print parameter table "* ) retval+=" show-defvalues" ;;
                            esac
                        fi ;;

        *)  case "$COMP_LINE" in
                "Print application table "* | "Print configuration table "* | "Print dependency table "* | "Print dir table "* | "Print dirlist table "* | "Print file table "* | "Print filelist table "* | \
                "Print format table "* | "Print level table "* | "Print message table "* | "Print mode table "* | "Print module table "* | "Print option table "* | "Print parameter table "* | "Print phase table "* | "Print project table "* | \
                "Print scenario table "* | "Print setting table "* | "Print script table "* | "Print site table "* | "Print task table "* | "Print theme table "* | "Print themeitem table "* | "Print variable table "* | \
                "Print clioption table "* | "Print exitcode table "*)
                    retval="show-values with-legend without-status without-extras"
                    case "$COMP_LINE" in
                        "Print parameter table "* ) retval+=" show-defvalues" ;;
                    esac
                    case "$COMP_LINE" in
                        *"show-values"*)    retval="${retval//"show-values"/}"; retval="${retval//"show-defvalues"/}" ;;&
                        *"with-legend"*)    retval="${retval//"with-legend"/}" ;;&
                        *"without-status"*) retval="${retval//"without-status"/}" ;;&
                        *"without-extras"*) retval="${retval//"without-extras"/}"; retval="${retval//"with-legend"/}" ;;&
                        *"show-defvalues"*) retval="${retval//"show-defvalues"/}"; retval="${retval//"show-values"/}" ;;&
                    esac ;;
                "Print application list "* | "Print configuration list "* | "Print dependency list "* | "Print dir list "* | "Print dirlist list "* | "Print file list "* | "Print filelist list "* | \
                "Print format list "* | "Print level list "* | "Print message list "* | "Print mode list "* | "Print module list "* | "Print option list "* | "Print parameter list "* | "Print phase list "* | "Print project list "* | \
                "Print scenario list "* | "Print setting list "* | "Print script list "* | "Print site list "* | "Print task list "* | "Print theme list "* | "Print themeitem list "* | "Print variable list "* | \
                "Print clioption list "*)
                    retval="show-values"
                    case "$COMP_LINE" in
                        "Print parameter list "* ) retval+=" show-defvalues" ;;
                    esac
                    case "$COMP_LINE" in
                        *"show-values"*)    retval="" ;;&
                        *"show-defvalues"*) retval="" ;;&
                    esac ;;
            esac ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Print_completions Print
