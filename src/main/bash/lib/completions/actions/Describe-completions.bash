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
## Describe - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Describe_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Describe)       retval="component framework"
                        retval+=" exitcode"
                        retval+=" format level message mode phase theme themeitem variable"
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario script site task"
                        retval+=" exit-options runtime-options"
                        retval+=" action element instance object" ;;

        component)      retval="actions elements instances objects" ;;
        framework)      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Describe" ]]; then retval="authors bugs copying exit-status description resources security framework"; fi ;;

        application)    retval="$(Applications has)" ;;
        dependency)     retval="$(Dependencies has)" ;;
        dirlist)        retval="$(Dirlists has)" ;;
        dir)            retval="$(Dirs has)" ;;
        exitcode)       retval="$(Exitcodes has)" ;;
        filelist)       retval="$(Filelists has)" ;;
        file)           retval="$(Files has)" ;;
        format)         retval="$(Formats has)" ;;
        level)          retval="$(Levels has)" ;;
        message)        retval="$(Messages has)" ;;
        mode)           retval="$(Modes has)" ;;
        module)         retval="$(Modules has)" ;;
        option)         retval="$(Options has)" ;;
        parameter)      retval="$(Parameters has)" ;;
        phase)          retval="$(Phases has)" ;;
        project)        retval="$(Projects has)" ;;
        scenario)       retval="$(Scenarios has)" ;;
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
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Describe_completions Describe
