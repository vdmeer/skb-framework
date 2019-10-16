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


## this should be first
Add object setting CURRENT_PHASE    with    Load                        "current execution phase"

Add object setting PRINT_LEVEL      with    " fatalerror error warning "                "level for printing messages"
Add object setting LOG_LEVEL        with    " fatalerror error message text warning "   "level for printing lines to the log"

Add object setting PRINT_FORMAT     with    ansi                        "standard format for text output"
Add object setting PRINT_FORMAT2    with    ""                          "secondary format, overwrites the standard format"
Add object setting LOG_FORMAT       with    ansi                        "standard format for log output"
Add object setting CURRENT_MODE     with    use                         "creates views on tasks and other elements"
Add object setting APP_NAME         with    sf                          "application name for messages"
Add object setting APP_NAME2        with    ""                          "secondary application name, overwrites the primary name"
Add object setting LOG_DATE_ARG     with    "--iso-8601=seconds"        "format for the date in logs, defaults to '--iso-8601=seconds'"
Add object setting STRICT_MODE      with    off                         "determines how strict-warnings are treated"
Add object setting ERROR_COUNT      with    0                           "number of errors found for current phase"
Add object setting MESSAGE_CODES    with    ""                          "collected message codes (message IDs) for current phase"
Add object setting WARNING_COUNT    with    0                           "number of warnings found for current phase"
Add object setting CURRENT_THEME    with    Default                     "the current theme with settings for configurable output"
Add object setting CURRENT_TASK     with    ""                          "in execution, the task currently executed"
Add object setting LAST_TASK        with    ""                          "the last task that was executed"
Add object setting CURRENT_PROJECT  with    ""                          "in execution, the project currently executed"
Add object setting LAST_PROJECT     with    ""                          "the last project that was executed"
Add object setting CURRENT_SCRIPT   with    ""                          "in execution, the script currently executed"
Add object setting LAST_SCRIPT      with    ""                          "the last script that was executed"
Add object setting CURRENT_SCENARIO with    ""                          "in execution, the scenario currently executed"
Add object setting LAST_SCENARIO    with    ""                          "the last scenario that was executed"
Add object setting CURRENT_SITE     with    ""                          "in execution, the site currently executed"
Add object setting LAST_SITE        with    ""                          "the last site that was executed"

Add object setting CONFIG_FILE      with    ""                          "configuration file read during initialization"
Add object setting MODULE_PATH      with    " "                         "list of directories to scan for loadable modules"
Add object setting AUTO_WRITE       with    false                       "settings write runtime file automatically (true) or manually (false)"
Add object setting AUTO_VERIFY      with    false                       "settings verify elements automatically (true) or manually (false)"

Add object setting LOG_DIR          with    /var/log/skb-framework/${SF_VERSION}    "directory for log files"
Add object setting LOG_FILE         with    ${SF_FILE_STRING}.log                   "file for log output"

Add object setting SHOW_EXECUTION   with    on      "standard show execution details, on or off"
Add object setting SHOW_EXECUTION2  with    on      "secondary show execution details, overwrites the standard"

Set current theme to "${FW_OBJECT_CFG_VAL["DEFAULT_THEME"]}"
file="${FW_OBJECT_SET_VAL["LOG_DIR"]}/${FW_OBJECT_SET_VAL["LOG_FILE"]}"
if [[ ! -w ${file} ]]; then mkdir -p ${file%/*}; touch ${file}; fi

