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
## start - starts the framework
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##

if [[ -n "${SF_TEST:-}" ]]; then
    ## Exitcode 4
    if [[ ! -n "${SF_HOME:-}" ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: \$SF_HOME not set, cannot initialize\n\n"; exit 4; fi

    ## Exitcode 5
    if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: did not find 'bash' major version 4 or higher\n\n"; exit 5; fi

    ## Exitcode 6
    if [[ "${BASH_VERSINFO[1]}" -lt 2 ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: did not find 'bash' minor version 2 or higher\n\n"; exit 6; fi

    ## Exitcode 7
    ! getopt --test > /dev/null
    if [[ ${PIPESTATUS[0]} -ne 4 ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: did not find GNU (Extended) getopt\n\n"; exit 7; fi

    ## Exitcoe 8
    quit=false
    #pwd basename cut dircolors dirname mktemp split head stat tail tr tsort uniq wc who whoami
    for index in cat cp date ls mkdir mv rm rmdir sleep touch uname sort; do
        if [[ ! $(command -v ${index}) ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: missing core dependency core-utils: ${index}\n"; quit=true; fi
    done
    if [[ ${quit} == true ]]; then printf "\n"; exit 8; fi

    ## Exitcoe 9
    quit=false
    for index in bc less par sed tput; do
        if [[ ! $(command -v ${index}) ]]; then printf "  skb-framework: \e[97mbash\e[0m \e[1m\e[91merror\e[0m in phase \e[3m\e[4minit\e[0m: missing important dependency: ${index}\n"; quit=true; fi
    done
    if [[ ${quit} == true ]]; then printf "\n"; exit 9; fi
    unset quit index
fi


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] source load\n"; fi
#clear -x
declare -x FW_START_CLI="$*"
bash --rcfile ${SF_HOME}/lib/load.sh


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] removing runtime configuration files\n"; fi
if [[ "${FW_OBJECT_CFG_LONG[*]:-}" != "" ]]; then
    if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_FAST"]}"; fi
    if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_MEDIUM"]}"; fi
    if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_SLOW"]}"; fi
    if [[ -f "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}" ]]; then rm "${FW_OBJECT_CFG_VAL["RUNTIME_CONFIG_LOAD"]}"; fi
fi


if [[ -n "${SF_DEBUG:-}" ]]; then printf "[debug-init] finished, exiting\n"; fi
#exit 0
