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
## validate-installation - task that validates the framework's installation
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" ]]; then printf " $(basename $0): please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/task-runtime.sh

Clioptions add option target-all

Clioptions add general option  dependencies  d   ""  "validate dependencies"    "Targets"
Clioptions add general option  options       o   ""  "validate options"         "Targets"
Clioptions add general option  tasks         t   ""  "validate tasks"           "Targets"

Parse cli "Options Targets" $*


############################################################################################
##
## test CLI
##
############################################################################################
targets="dependencies options tasks"

if [[ "${FW_INSTANCE_CLI_SET["all"]}" == "no" ]]; then
    if [[ "${FW_INSTANCE_CLI_SET["dependencies"]}" == "no" ]]; then targets=${targets/dependencies/}; fi
    if [[ "${FW_INSTANCE_CLI_SET["options"]}" == "no" ]]; then targets=${targets/options/}; fi
    if [[ "${FW_INSTANCE_CLI_SET["tasks"]}" == "no" ]]; then targets=${targets/tasks/}; fi
fi



############################################################################################
##
## validate targets
##
############################################################################################
IFS=" " read -a keys <<< "${targets}"; IFS=$'\n' keys=($(sort <<<"${keys[*]}")); unset IFS
for target in "${keys[@]}"; do
    Validate ${target}
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi
done
