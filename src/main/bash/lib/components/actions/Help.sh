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
## Help - provides help for actions, elements, instances, and objects
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Help() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local cmd="${1}" type=""
    if [[ "${cmd}" == "Framework" ]]; then
        printf "\n"
        Describe framework ${cmd}
        Explain  framework ${cmd}
    fi

    local actions=" $(Framework has actions) "
    local elements=" $(Framework has elements) "
    local objects=" $(Framework has objects) "
    local instances=" $(Framework has instances) "

    case ${actions} in *" ${cmd} "*)   type="action"   ;; esac
    case ${elements} in *" ${cmd} "*)  type="element"  ;; esac
    case ${objects} in *" ${cmd} "*)   type="object"   ;; esac
    case ${instances} in *" ${cmd} "*) type="instance" ;; esac

    if [[ -n "${type}" ]]; then
        printf "\n"
        Describe ${type} ${cmd}
        Explain  ${type} ${cmd}
    else
        Report process error "${FUNCNAME[0]}" E803 "${cmd}"
    fi
}
