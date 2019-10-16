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



dateNow="$(date +%s.%N)"

declare -r -x -g SF_VERSION="$(cat ${SF_HOME}/lib/version.skb)"
SF_FILE_STRING="$(date --date=@${dateNow} +"%Y-%m-%d--%H-%M")--$$"

Add object configuration    RUNTIME_CONFIG_FAST     with    "/tmp/skb-${SF_FILE_STRING}-fast"           "runtime configuration file for fast changing settings"
Add object configuration    RUNTIME_CONFIG_MEDIUM   with    "/tmp/skb-${SF_FILE_STRING}-medium"         "runtime configuration file for medium changing settings"
Add object configuration    RUNTIME_CONFIG_SLOW     with    "/tmp/skb-${SF_FILE_STRING}-slow"           "runtime configuration file for slow chaning settings"
Add object configuration    RUNTIME_CONFIG_LOAD     with    "/tmp/skb-${SF_FILE_STRING}-load"           "runtime configuration file only written during load"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
declare -r -x -g FW_RUNTIME_CONFIG_FAST="${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"
touch "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"

Add object configuration    HOME                    with    "${SF_HOME}"                                    "the framework's home directory"
Add object configuration    PID                     with    "$$"                                            "process ID of the load part, for log messages"
Add object configuration    FILE_STRING             with    "${SF_FILE_STRING}"                             "unique string for files, e.g. temporary and log files"
Add object configuration    VERSION                 with    "${SF_VERSION}"                                 "the framework's version, semantic string with major.minor.path"
Add object configuration    USER_CONFIG             with    "${HOME}/.skbrc"                                "file with user settings"
Add object configuration    PATTERN_REMOVE_ANSI     with    "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"   "SED pattern to remove ANSI escape codes from text"
Add object configuration    CACHE_DIR               with    "/var/cache/skb-framework/${SF_VERSION}"        "directory for cached data"
Add object configuration    DEFAULT_THEME           with    "Default"                                       "file with the default theme definitions"
Add object configuration    PAR_PARA                with    "j1s0f1"                                        "options for the 'par' command to format paragraphs"
Add object configuration    PAR_LIST                with    "P=*"                                           "options for the 'par' command to format lists"
Add object configuration    PRIMAY_MODULE_PATH      with    "${SF_HOME}/share/modules"                      "list of directories to scan for loadable modules"
Add object configuration    START_TIME              with    "${dateNow}"                                    "time stamp when application was started"

system="$(uname -a)"
case ${system} in
    *CYGWIN*)       system=CYGWIN ;;
    *Microsoft*)    system=WSL ;;
    *Linux*)        system=Linux ;;
    *)              system="$(uname -s)" ;;
esac
Add object configuration    SYSTEM                  with    "${system}"                                     "identifier for the underlying operating system"

unset dateNow

