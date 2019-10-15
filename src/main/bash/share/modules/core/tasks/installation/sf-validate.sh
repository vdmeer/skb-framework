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
## sf-validate - task that validates the framework
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" ]]; then printf " $(basename $0): please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/task-runtime.sh

Clioptions add option target-all

Clioptions add general option  everything    E   ""  "validate everything"              "Targets"
Clioptions add general option  framework     f   ""  "validate framework components"    "Targets"
Clioptions add general option  objects       o   ""  "validate added objects"           "Targets"
Clioptions add general option  elements      e   ""  "validate added elements"          "Targets"
Clioptions add general option  library       l   ""  "validate the library texts"       "Targets"

Parse cli "Options Targets" $*



############################################################################################
##
## test CLI
##
############################################################################################
if [[ "${FW_INSTANCE_CLI_SET["everything"]}" == "yes" ]]; then
    targets="everything"
else
    targets="framework-components added-objects added-elements runtime-settings"
    if [[ "${FW_INSTANCE_CLI_SET["framework"]}" == "no" ]]; then targets=${targets/framework-components/}; fi
    if [[ "${FW_INSTANCE_CLI_SET["objects"]}" == "no" ]]; then targets=${targets/added-objects/}; fi
    if [[ "${FW_INSTANCE_CLI_SET["elements"]}" == "no" ]]; then targets=${targets/added-elements/}; fi
    if [[ "${FW_INSTANCE_CLI_SET["library"]}" == "no" ]]; then targets=${targets/runtime-settings/}; fi
fi



############################################################################################
##
## validate targets
##
############################################################################################
Report application debug "set targets - ${targets}"
for target in ${targets}; do
    Report application debug "validate target - ${target//-/ }"
    Validate ${target//-/ }
done
