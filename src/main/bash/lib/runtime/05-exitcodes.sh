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
## Runtime / Exitcodes - fill runtime information for exit codes
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


declare -A FW_INSTANCE_EXC_LONG     ## [long]="description"


FW_INSTANCE_EXC_LONG["00"]="normal exit"
FW_INSTANCE_EXC_LONG["01"]="general error during initialization, load, or option processing" ## e.g. unknown print format set in CLI
FW_INSTANCE_EXC_LONG["02"]="command 'realpath' not found"
FW_INSTANCE_EXC_LONG["03"]="\$SF_HOME does not exist or is not a directory"
FW_INSTANCE_EXC_LONG["04"]="\$SF_HOME not set"
FW_INSTANCE_EXC_LONG["05"]="wrong bash major version, requires minimum 4"
FW_INSTANCE_EXC_LONG["06"]="wrong bash minor version, requires minimum 2"
FW_INSTANCE_EXC_LONG["07"]="did not find GNU (Extended) getopt"
FW_INSTANCE_EXC_LONG["08"]="missing core dependency core-utils"
FW_INSTANCE_EXC_LONG["09"]="missing important dependency"
FW_INSTANCE_EXC_LONG["10"]="framework not loaded"
FW_INSTANCE_EXC_LONG["11"]="error while reading the set configuration file"
FW_INSTANCE_EXC_LONG["12"]="error while reading the default configuration file"
FW_INSTANCE_EXC_LONG["13"]="error loading settings from the environment"
FW_INSTANCE_EXC_LONG["14"]="error(s) executing task"
FW_INSTANCE_EXC_LONG["15"]="error(s) executing scenario"
FW_INSTANCE_EXC_LONG["16"]="requested command for execution not found"
FW_INSTANCE_EXC_LONG["17"]="error(s) executing command"
