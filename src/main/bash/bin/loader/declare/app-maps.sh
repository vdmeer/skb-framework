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
## Declare: maps for application data, e.g. standard files and paths
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##



##
## MAP for paths in FW_HOME
##
declare -A FW_PATH_MAP                              # map/export for standard paths in FW_HOME
    FW_PATH_MAP["OPTIONS"]="etc/declarations/options"                   # path for application options
    FW_PATH_MAP["EXITSTATUS"]="etc/declarations/exitstatus"             # path for application exist status files
    FW_PATH_MAP["COMMANDS"]="etc/declarations/commands"                 # path for application shell command files



##
## MAP for paths in APP_HOME
##
declare -A APP_PATH_MAP                             # map/export for standard paths of an application
    APP_PATH_MAP["PARAM_DECL"]="etc/declarations/parameters"            # path for parameter declarations
    APP_PATH_MAP["DEP_DECL"]="etc/declarations/dependencies"            # path for dependency declarations
    APP_PATH_MAP["TASK_DECL"]="etc/declarations/tasks"                  # path for task declarations
    APP_PATH_MAP["TASK_SCRIPT"]="bin/tasks"                             # path for task scripts
    APP_PATH_MAP["SCENARIOS"]="scenarios"                               # path for scenarios
