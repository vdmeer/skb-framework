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
## Terminate - action to terminate the framework with cleanup and extra prints
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Terminate() {
    if [[ -z "${1:-}" ]]; then
        printf "\n"; Format help indentation 1; Format themed text explainTitleFmt "Available Commands"; printf "\n\n"
        Format help indentation 2; Format themed text explainComponentFmt "${FUNCNAME[0]}"; printf " "; Format themed text explainOperationFmt "framework"; printf " "; Format themed text explainArgFmt "[INTEGER]"; printf "\n"
            Format help indentation 3; Format themed text explainTextFmt "does cleanup and terminates framework using exit code 0 or given INTEGER"; printf "\n"
        printf "\n"; return
    fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        framework)
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"; fi
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"; fi
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"; fi
            \exit ${1:-0} ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
