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

Add object setting PRINT_FORMAT     ansi                    "standard format for text output"
Add object setting PRINT_FORMAT2    ""                      "secondary format, overwrites the standard format"
Add object setting LOG_FORMAT       ansi                    "standard format for log output"
Add object setting CURRENT_MODE     use                     "creates views on tasks and other elements"
Add object setting APP_NAME         sf                      "application name for messages"
Add object setting APP_NAME2        ""                      "secondary application name, overwrites the primary name"
Add object setting LOG_DATE_ARG     "--iso-8601=seconds"    "format for the date in logs, defaults to '--iso-8601=seconds'"
Add object setting STRICT_MODE      off                     "determines how strict-warnings are treated"
Add object setting ERROR_COUNT      0                       "number of errors found for current phase"
Add object setting ERROR_CODES      ""                      "collected error codes (message IDs) for current phase"
Add object setting WARNING_COUNT    0                       "number of warnings found for current phase"
Add object setting CURRENT_THEME    Default                 "the current theme with settings for configurable output"

Add object setting PRINT_LEVEL      " fatalerror error warning "                "level for printing messages"
Add object setting LOG_LEVEL        " fatalerror error message text warning "   "level for printing lines to the log"

Add object setting CURRENT_TASK     ""                          "in execution, the task currently executed"
Add object setting LAST_TASK        ""                          "the last task that was executed"
Add object setting CURRENT_PROJECT  ""                          "in execution, the project currently executed"
Add object setting LAST_PROJECT     ""                          "the last project that was executed"
Add object setting CURRENT_SCENARIO ""                          "in execution, the scenario currently executed"
Add object setting LAST_SCENARIO    ""                          "the last scenario that was executed"
Add object setting CURRENT_SITE     ""                          "in execution, the site currently executed"
Add object setting LAST_SITE        ""                          "the last site that was executed"

Add object setting CONFIG_FILE      ""                          "configuration file read during initialization"
Add object setting MODULE_PATH      " "                         "list of directories to scan for loadable modules"
Add object setting AUTO_WRITE       false                       "settings write runtime file automatically (true) or manually (false)"
Add object setting AUTO_VERIFY      false                       "settings verify elements automatically (true) or manually (false)"

Add object setting LOG_DIR          /var/log/skb-framework/${SF_VERSION}    "directory for log files"
Add object setting LOG_FILE         ${SF_FILE_STRING}.log                   "file for log output"

Add object setting SHOW_EXECUTION   on      "standard show execution details, on or off"
Add object setting SHOW_EXECUTION2  on      "secondary show execution details, overwrites the standard"

Set current theme to "${FW_OBJECT_CFG_VAL["DEFAULT_THEME"]}"
file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
if [[ ! -w ${file} ]]; then mkdir -p ${file%/*}; touch ${file}; fi
