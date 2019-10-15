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
## CLI2 - second level exit options
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ "${FW_ELEMENT_OPT_SET["execute-task"]}" == "yes" ]]; then
    Execute task "${FW_ELEMENT_OPT_VAL["execute-task"]}" ${FW_ELEMENT_OPT_EXTRA}
    if (( $(Get object phase Task error-count) > 0 )); then printf "\n"; Terminate framework 14; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-scenario"]}" == "yes" ]]; then
    Execute scenario "${FW_ELEMENT_OPT_VAL["execute-scenario"]}"
    if (( $(Get object phase Scenario error-count) > 0 )); then printf "\n"; Terminate framework 15; else Terminate framework 0; fi
fi

if [[ "${FW_ELEMENT_OPT_SET["execute-command"]}" == "yes" ]]; then
    cmd="${FW_ELEMENT_OPT_VAL["execute-command"]}"
    case "$(Framework has actions) $(Framework has elements) $(Framework has instances) $(Framework has objects)" in
        *" ${cmd} "*)   ${cmd} ${FW_ELEMENT_OPT_EXTRA}
                        if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 17; else Terminate framework 0; fi ;;
        *)              Report application fatalerror E803 "${cmd}"; Terminate framework 16 ;;
    esac
fi
