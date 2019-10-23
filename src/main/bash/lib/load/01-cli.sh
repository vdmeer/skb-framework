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

Set current phase to CLI


##
## Parse automatically takes care of all "Terminate framework 0" options, plus setting format (which will exit with errors if any)
##
Parse cli "" ${FW_START_CLI}


##
## Continue with runtime options, simply set, no errors
##
if [[ "${FW_ELEMENT_OPT_SET["config-file"]}" == yes ]]; then Set config file to "${FW_ELEMENT_OPT_VAL["config-file"]}"; fi
if [[ "${FW_ELEMENT_OPT_SET["strict-mode"]}" == yes ]]; then Activate strict mode; fi

if [[ "${FW_ELEMENT_OPT_SET["test-mode"]}" == yes ]]; then
    Set current mode to test
elif [[ "${FW_ELEMENT_OPT_SET["dev-mode"]}" == yes ]]; then
    Set current mode to dev
elif [[ "${FW_ELEMENT_OPT_SET["build-mode"]}" == yes ]]; then
    Set current mode to build
elif [[ "${FW_ELEMENT_OPT_SET["use-mode"]}" == yes ]]; then
    Set current mode to use
fi
