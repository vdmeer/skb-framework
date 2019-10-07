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
#shopt -s globstar


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] source components\n"; fi
source ${SF_HOME}/lib/components/Framework.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] source rt maps\n"; fi
source ${SF_HOME}/lib/init/01-rt-maps.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] source object maps\n"; fi
source ${SF_HOME}/lib/init/02-object-maps.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] source element maps\n"; fi
source ${SF_HOME}/lib/init/03-element-maps.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] initialize configuration\n"; fi
source ${SF_HOME}/lib/init/10-config.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load formats\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/formats.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/formats.cache"
else
    source ${SF_HOME}/lib/init/11-formats.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load levels\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/levels.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/levels.cache"
else
    source ${SF_HOME}/lib/init/12-levels.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load messages\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/messages.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/messages.cache"
else
    source ${SF_HOME}/lib/init/13-messages.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load modes\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache"
else
    source ${SF_HOME}/lib/init/14-modes.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load phases\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/modes.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/phases.cache"
else
    source ${SF_HOME}/lib/init/15-phases.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load themeitems\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themeitems.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themeitems.cache"
else
    source ${SF_HOME}/lib/init/16-themeitems.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load temes\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/themes.cache"
else
    source ${SF_HOME}/lib/init/17-themes.sh
fi

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load settings\n"; fi
source ${SF_HOME}/lib/init/18-settings.sh

if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] load options\n"; fi
if [[ -r "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/options.cache" ]]; then
    source "${FW_OBJECT_CFG_VAL["CACHE_DIR"]}/options.cache"
else
    source ${SF_HOME}/lib/init/19-options.sh
fi


Report process message "framework initialized"
printf "\n"


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] parse cli\n"; fi
if [[ -z "${FW_START_CLI:-}" ]]; then declare -x FW_START_CLI="$*"; fi
source ${SF_HOME}/lib/load/01-cli.sh
if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then printf "\n"; Terminate framework 1; fi


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] set env, aliases, traps\n"; fi
source ${SF_HOME}/lib/load/02-settings.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] change to phase mode\n"; fi
Set current phase Load


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] load modules: API, Core\n"; fi
source ${SF_HOME}/lib/load/03-modules.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] read config file\n"; fi
source ${SF_HOME}/lib/load/04-file.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] read environment\n"; fi
source ${SF_HOME}/lib/load/05-env.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] verify\n"; fi
Verify everything
Set current phase Load


Report process message "framework loaded"
export FW_LOADED=yes

IFS="." read -r -a SF_VERSINFO <<< "${SF_VERSION}"
source ${SF_HOME}/lib/completions/*.bash
if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] writing runtime config files\n"; fi
Write load config; Write fast config; Write medium config; Write slow config


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] cli exit options\n"; fi
source ${SF_HOME}/lib/load/10-cli2.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] runtime maps\n"; fi
source ${SF_HOME}/lib/runtime.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-load] last settings\n"; fi
Report process message "framework started, ready to go"
Set current phase Shell
FW_OBJECT_SET_VAL["AUTO_VERIFY"]=true
Set auto write true
