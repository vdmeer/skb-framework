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
## Convert - command to convert something
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_TAGS_COMMANDS["Convert"]="command to convert something"

function Convert() {
    if [[ -z "${1:-}" ]]; then Report process error "${FUNCNAME[0]}" E802 1 "$#"; return; fi
    local path
    local i id errno dir file fileText modid modpath fsMode list element
    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        path)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1}" E801 1 "$#"; return; fi
            path="${1}"
            if [[ "${FW_OBJECT_CFG_VAL["SYSTEM"]}" == "CYGWIN" ]]; then printf "%s" "$(cygpath -m "${path}")"; else echo "${path}"; fi ;;

        *)
            Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
