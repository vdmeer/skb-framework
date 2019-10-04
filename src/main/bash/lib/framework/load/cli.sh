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
## Init/cli - parse and processes CLI option
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##

Set current phase CLI

##
## Parse automatically takes care of all "Terminate framework 0" options, plus setting format (which will exit with errors if any)
##
Parse cli arguments "" $*

##
## Test dependencies if not deactivated, terminates with 7/8 on errors
##
if [[ ${FW_PARSED_ARG_MAP[N]:-${FW_PARSED_ARG_MAP[no-runtime-tests]:-no}} == no ]]; then Test framework dependencies; fi
if [[ ${FW_PARSED_ARG_MAP[N]:-${FW_PARSED_ARG_MAP[no-runtime-tests]:-no}} == yes ]]; then FW_ELEMENT_OPT_VAL[no-runtime-tests]="yes"; fi


##
## Continue with runtiem options, simply set, no errors
##
if [[ ${FW_PARSED_ARG_MAP[C]:-${FW_PARSED_ARG_MAP[config-file]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[config-file]="${FW_PARSED_VAL_MAP[C]:-${FW_PARSED_VAL_MAP[config-file]}}"
    Set config file "${FW_PARSED_VAL_MAP[C]:-${FW_PARSED_VAL_MAP[config-file]}}"
fi

if [[ ${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[strict-mode]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[strict-mode]="yes"
    Set strict mode on
fi

if [[ ${FW_PARSED_ARG_MAP[A]:-${FW_PARSED_ARG_MAP[all-mode]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[all-mode]="yes"
    Set current mode all
elif [[ ${FW_PARSED_ARG_MAP[D]:-${FW_PARSED_ARG_MAP[dev-mode]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[dev-mode]="yes"
    Set current mode dev
elif [[ ${FW_PARSED_ARG_MAP[B]:-${FW_PARSED_ARG_MAP[build-mode]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[build-mode]="yes"
    Set current mode build
elif [[ ${FW_PARSED_ARG_MAP[U]:-${FW_PARSED_ARG_MAP[user-mode]:-no}} == yes ]]; then
    FW_ELEMENT_OPT_VAL[user-mode]="yes"
    Set current mode use
fi

if [[ ${FW_PARSED_ARG_MAP[t]:-${FW_PARSED_ARG_MAP[execute-task]:-no}} == yes ]]; then
    export FW_CLI_EXEC_TASK="${FW_PARSED_VAL_MAP[t]:-${FW_PARSED_VAL_MAP[execute-task]}}"
    export FW_CLI_EXEC_ARGS="${FW_PARSED_EXTRA}"
    FW_ELEMENT_OPT_VAL[execute-task]="${FW_PARSED_VAL_MAP[t]:-${FW_PARSED_VAL_MAP[execute-task]}} ${FW_PARSED_EXTRA}"
fi
if [[ ${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[execute-scenario]:-no}} == yes ]]; then
    export FW_CLI_EXEC_SCENARIO="${FW_PARSED_VAL_MAP[s]:-${FW_PARSED_VAL_MAP[execute-scenario]}}"
    export FW_CLI_EXEC_ARGS="${FW_PARSED_EXTRA}"
    FW_ELEMENT_OPT_VAL[execute-scenario]="${FW_PARSED_VAL_MAP[s]:-${FW_PARSED_VAL_MAP[execute-scenario]}} ${FW_PARSED_EXTRA}"
fi
if [[ ${FW_PARSED_ARG_MAP[c]:-${FW_PARSED_ARG_MAP[execute-command]:-no}} == yes ]]; then
    export FW_CLI_EXEC_COMMAND="${FW_PARSED_VAL_MAP[c]:-${FW_PARSED_VAL_MAP[execute-command]}}"
    export FW_CLI_EXEC_ARGS="${FW_PARSED_EXTRA}"
    FW_ELEMENT_OPT_VAL[execute-command]="${FW_PARSED_VAL_MAP[c]:-${FW_PARSED_VAL_MAP[execute-command]}} ${FW_PARSED_EXTRA}"
fi
