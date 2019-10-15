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
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        framework)
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"; fi
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"; fi
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"; fi
            if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"; fi
            \exit ${1:-0} ;;

        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
