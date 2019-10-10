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
## Test - auto completion
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function __skb_Test_completions(){
    local retval=""
    case ${COMP_WORDS[COMP_CWORD-1]} in
        Test)           retval="command"
                        retval+=" existing used"
                        retval+=" dir element file fs integer known log print yesno" ;;

        existing)       retval="exitcode"
                        retval+=" action element instance object component"
                        retval+=" clioption configuration format level message mode phase setting theme themeitem"
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario site task" ;;
        used)           retval="clioption configuration format level message mode phase setting theme themeitem"
                        retval+=" application dependency dirlist dir filelist file module option parameter project scenario site task" ;;

        exitcode)       retval="id" ;;

        instance)       retval="id" ;;
        object)         retval="id" ;;
        element)        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id"; else retval="status"; fi ;;
        action)         retval="id" ;;
        component)      retval="id" ;;

        clioption)      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="long-id short-id"; fi ;;
        configuration)  if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        format)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        level)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        message)        retval="id" ;;
        mode)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        phase)          retval="id" ;;
        setting)        retval="id" ;;
        theme)          if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        themeitem)      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id identifiers";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        application)    retval="id" ;;
        dependency)     retval="id" ;;
        module)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"; fi ;;
        option)         if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id";
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="long-id short-id"; fi ;;
        parameter)      retval="id" ;;
        project)        retval="id" ;;
        scenario)       retval="id" ;;
        site)           retval="id" ;;
        task)           retval="id" ;;

        fs)             retval="mode" ;;
        file)           if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Test" ]]; then retval="exists can"; fi ;;
        filelist)       iretval="id" ;;
        dir)            if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "existing" ]]; then retval="id"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "used" ]]; then retval="id"
                        elif [[ "${COMP_WORDS[COMP_CWORD-2]}" == "Test" ]]; then retval="exists can"; fi ;;
        dirlist)        retval="id" ;;

        can)            retval="read write create delete"
                        if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "file" ]]; then retval+=" execute"; fi ;;

        known)          retval="module" ;;
        log)            retval="format level" ;;
        print)          retval="format level" ;;
    esac
    if [[ -n "${retval}" ]]; then COMPREPLY=($(compgen -W "${retval}" -- "${COMP_WORDS[COMP_CWORD]}")); fi
}
complete -F __skb_Test_completions Test
