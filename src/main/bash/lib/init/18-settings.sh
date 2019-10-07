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
## Initialize settings
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


FW_OBJECT_SET_LONG["CURRENT_PHASE"]="current execution phase"
FW_OBJECT_SET_PHA["CURRENT_PHASE"]=Load
FW_OBJECT_SET_VAL["CURRENT_PHASE"]=Load

Add Object Setting PRINT_FORMAT     ansi                    "standard format for text output"
Add Object Setting PRINT_FORMAT2    ""                      "secondary format, overwrites the standard format"
Add Object Setting LOG_FORMAT       ansi                    "standard format for log output"
Add Object Setting CURRENT_MODE     use                     "creates views on tasks and other elements"
Add Object Setting APP_NAME         sf                      "application name for messages"
Add Object Setting APP_NAME2        ""                      "secondary application name, overwrites the primary name"
Add Object Setting LOG_DATE_ARG     "--iso-8601=seconds"    "format for the date in logs, defaults to '--iso-8601=seconds'"
Add Object Setting STRICT_MODE      off                     "determines how strict-warnings are treated"
Add Object Setting ERROR_COUNT      0                       "number of errors found for current phase"
Add Object Setting WARNING_COUNT    0                       "number of warnings found for current phase"
Add Object Setting CURRENT_THEME    default                 "the current theme with settings for configurable output"

Add Object Setting PRINT_LEVEL      " fatalerror error warning "                "level for printing messages"
Add Object Setting LOG_LEVEL        " fatalerror error message text warning "   "level for printing lines to the log"

Add Object Setting CURRENT_TASK     ""                      "in execution, the task currently executed"
Add Object Setting LAST_TASK        ""                      "the last task that was executed"
Add Object Setting CURRENT_PROJECT  ""                      "in execution, the project currently executed"
Add Object Setting LAST_PROJECT     ""                      "the last project that was executed"
Add Object Setting CURRENT_SCENARIO ""                      "in execution, the scenario currently executed"
Add Object Setting LAST_SCENARIO    ""                      "the last scenario that was executed"
Add Object Setting CURRENT_SITE     ""                      "in execution, the site currently executed"
Add Object Setting LAST_SITE        ""                      "the last site that was executed"

Add Object Setting CONFIG_FILE      ""                      "configuration file read during initialization"
Add Object Setting MODULE_PATH      "${SF_HOME}/share/modules"  "list of directories to scan for loadable modules"
Add Object Setting AUTO_WRITE       false                       "settings write runtime file automatically (true) or manually (false)"
Add Object Setting AUTO_VERIFY      false                       "settings verify elements automatically (true) or manually (false)"

Add Object Setting LOG_DIR          /var/log/skb-framework/${SF_VERSION}    "directory for log files"
Add Object Setting LOG_FILE         ${SF_FILE_STRING}.log                   "file for log output"


Set current theme "${FW_OBJECT_CFG_VAL["DEFAULT_THEME"]}"
file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
if [[ ! -w ${file} ]]; then mkdir -p ${file%/*}; touch ${file}; fi
