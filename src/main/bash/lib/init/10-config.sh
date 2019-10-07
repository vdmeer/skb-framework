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
## Initialize configuration
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


declare -r -x -g SF_VERSION="$(cat ${SF_HOME}/lib/version.skb)"
SF_FILE_STRING="$(date +"%Y-%m-%d--%H-%M")--$$"

Add Object Configuration    RUNTIME_CONFIG_FAST     "/tmp/skb-${SF_FILE_STRING}-fast"           "runtime configuration file for fast changing settings"
Add Object Configuration    RUNTIME_CONFIG_MEDIUM   "/tmp/skb-${SF_FILE_STRING}-medium"         "runtime configuration file for medium changing settings"
Add Object Configuration    RUNTIME_CONFIG_SLOW     "/tmp/skb-${SF_FILE_STRING}-slow"           "runtime configuration file for slow chaning settings"
Add Object Configuration    RUNTIME_CONFIG_LOAD     "/tmp/skb-${SF_FILE_STRING}-load"           "runtime configuration file only written during load"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
declare -r -x -g FW_RUNTIME_CONFIG_FAST="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"

Add Object Configuration    HOME                    "${SF_HOME}"                                    "the framework's home directory"
Add Object Configuration    PID                     "$$"                                            "process ID of the load part, for log messages"
Add Object Configuration    FILE_STRING             "${SF_FILE_STRING}"                             "unique string for files, e.g. temporary and log files"
Add Object Configuration    VERSION                 "${SF_VERSION}"                                 "the framework's version, semantic string with major.minor.path"
Add Object Configuration    USER_CONFIG             "${HOME}/.skbrc"                                "file with user settings"
Add Object Configuration    PATTERN_REMOVE_ANSI     "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"   "SED pattern to remove ANSI escape codes from text"
Add Object Configuration    CACHE_DIR               "/var/cache/skb-framework/${SF_VERSION}"        "directory for cached data"
Add Object Configuration    DEFAULT_THEME           "Default"                                       "file with the default theme definitions"
Add Object Configuration    PAR_PARA                "j1s0f1"                                        "options for the 'par' command to format paragraphs"
Add Object Configuration    PAR_LIST                "P=*"                                           "options for the 'par' command to format lists"
Add Object Configuration    PRIMAY_MODULE_PATH      "${SF_HOME}/share/modules"                      "list of directories to scan for loadable modules"

system="$(uname -a)"
case ${system} in
    *CYGWIN*)       system=CYGWIN ;;
    *Microsoft*)    system=WSL ;;
    *Linux*)        system=Linux ;;
    *)              system="$(uname -s)" ;;
esac
Add Object Configuration    SYSTEM                  "${system}"                                     "identifier for the underlying operating system"