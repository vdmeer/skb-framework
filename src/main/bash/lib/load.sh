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
## load - initialize and load everything for the framework
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


set -o pipefail -o noclobber -o nounset
#set -o errexit 
shopt -s globstar


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] source components\n"; fi
source ${SF_HOME}/lib/components/Framework.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] preset current phase\n"; fi
source ${SF_HOME}/lib/init/00-current-phase.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 01-rt-maps\n"; fi
source ${SF_HOME}/lib/init/01-rt-maps.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 02-object-maps\n"; fi
source ${SF_HOME}/lib/init/02-object-maps.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 03-element-maps\n"; fi
source ${SF_HOME}/lib/init/03-element-maps.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 04-fw-modules\n"; fi
source ${SF_HOME}/lib/init/04-fw-modules.sh

FW_CURRENT_MODULE_NAME="⫷Framework⫸"

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 10-config\n"; fi
source ${SF_HOME}/lib/init/10-config.sh

if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/⫷Framework⫸-objects.cache" ]]; then
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] found object cache, load from here\n"; fi
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/⫷Framework⫸-objects.cache"
else
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] no object cache\n"; fi
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     11-formats\n"; fi
    source ${SF_HOME}/lib/init/11-formats.sh

    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     12-levels\n"; fi
    source ${SF_HOME}/lib/init/12-levels.sh

    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     13-messages\n"; fi
    source ${SF_HOME}/lib/init/13-messages.sh

    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     14-modes\n"; fi
    source ${SF_HOME}/lib/init/14-modes.sh

    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     15-phases\n"; fi
    source ${SF_HOME}/lib/init/15-phases.sh

    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     16-themeitems\n"; fi
    source ${SF_HOME}/lib/init/16-themeitems.sh
fi

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 17-themes\n"; fi
source ${SF_HOME}/lib/init/17-themes.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 18-variables\n"; fi
source ${SF_HOME}/lib/init/18-variables.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] 19-settings\n"; fi
source ${SF_HOME}/lib/init/19-settings.sh

declare -A FW_INSTANCE_CLI_LONG FW_INSTANCE_CLI_SHORT FW_INSTANCE_CLI_LS FW_INSTANCE_CLI_SORT FW_INSTANCE_CLI_ARG FW_INSTANCE_CLI_CAT FW_INSTANCE_CLI_LEN FW_INSTANCE_CLI_SET FW_INSTANCE_CLI_VAL
declare -A FW_INSTANCE_CLI_EXTRA
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/⫷Framework⫸-options.cache" ]]; then
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] found option cache, load from here\n"; fi
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modules/⫷Framework⫸-options.cache"
else
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] no option cache\n"; fi
    if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init]     20-options\n"; fi
    source ${SF_HOME}/lib/init/20-options.sh
fi

unset FW_CURRENT_MODULE_NAME

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[init] DONE\n"; fi
Report process message "framework initialized"
printf "\n"


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 01-cli (parse)\n"; fi
if [[ -z "${FW_START_CLI:-}" ]]; then declare -x FW_START_CLI="$*"; fi
source ${SF_HOME}/lib/load/01-cli.sh
if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 1; fi
Set current phase to Load

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 02-settings\n"; fi
source ${SF_HOME}/lib/load/02-settings.sh

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 03-modules\n"; fi
source ${SF_HOME}/lib/load/03-modules.sh


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 04-file (read config file)\n"; fi
source ${SF_HOME}/lib/load/04-file.sh


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 05-env (read environment)\n"; fi
source ${SF_HOME}/lib/load/05-env.sh
Set current phase to Load


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] building stores\n"; fi
Stores build all


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] verify elements\n"; fi
Verify elements


Report process message "framework loaded"
export FW_LOADED=yes


IFS="." read -r -a SF_VERSINFO <<< "${SF_VERSION}"
source ${SF_HOME}/lib/completions/*.bash
if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] writing config files (all)\n"; fi
Write load config; Write medium config; Write slow config; Write fast config


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] 10-cli2 (remaining exit options)\n"; fi
source ${SF_HOME}/lib/load/10-cli2.sh


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] runtime (load maps)\n"; fi
source ${SF_HOME}/lib/runtime.sh


if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] last settings\n"; fi
source ${SF_HOME}/lib/operations/operations.sh
Report process message "framework started, ready to go"
Set current phase to Shell
FW_OBJECT_SET_VAL["AUTO_VERIFY"]=true
Activate auto write

if [[ -n "${SF_DEBUG_LOAD:-}" ]]; then printf "[load] DONE\n"; fi

