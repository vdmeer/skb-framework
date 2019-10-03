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
## describe-elements - task that describes elements in general
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option target-all

Cli add general option  applications    a ""  "general description of applications"     "Targets"
Cli add general option  dependencies    d ""  "general description of dependencies"     "Targets"
Cli add general option  dirlists        "" "" "general description of directory lists"  "Targets"
Cli add general option  dirs            "" "" "general description of directories"      "Targets"
Cli add general option  filelists       "" "" "general description of file lists"       "Targets"
Cli add general option  files           "" "" "general description of files"            "Targets"
Cli add general option  modules         m ""  "general description of modules"          "Targets"
Cli add general option  options         o ""  "general description of options"          "Targets"
Cli add general option  parameters      p ""  "general description of parameters"       "Targets"
Cli add general option  projects        P ""  "general description of projects"         "Targets"
Cli add general option  scenarios       s ""  "general description of scenarios"        "Targets"
Cli add general option  sites           S ""  "general description of sites"            "Targets"
Cli add general option  tasks           t ""  "general description of tasks"            "Targets"

#Cli add general option  exit-options    e ""  "general description of exit options"     "Targets"
#Cli add general option  runtime-options r ""  "general description of runtime options"  "Targets"

Parse cli arguments "Options Targets" $*


############################################################################################
##
## set targets
##
############################################################################################
targets="$(Framework has elements)"

#exit-options
#runtime-options


if [[ "${FW_PARSED_ARG_MAP[A]:-${FW_PARSED_ARG_MAP[all]:-no}}" == no ]]; then
    if [[ "${FW_PARSED_ARG_MAP[a]:-${FW_PARSED_ARG_MAP[applications]:-no}}" == no ]]; then targets=${targets/Applications/}; fi
    if [[ "${FW_PARSED_ARG_MAP[d]:-${FW_PARSED_ARG_MAP[dependencies]:-no}}" == no ]]; then targets=${targets/Dependencies/}; fi
    if [[ "${FW_PARSED_ARG_MAP[dirlists]:-no}" == no ]]; then targets=${targets/Dirlists/}; fi
    if [[ "${FW_PARSED_ARG_MAP[dirs]:-no}" == no ]]; then targets=${targets/Dirs/}; fi
    if [[ "${FW_PARSED_ARG_MAP[filelists]:-no}" == no ]]; then targets=${targets/Filelists/}; fi
    if [[ "${FW_PARSED_ARG_MAP[files]:-no}" == no ]]; then targets=${targets/Files/}; fi
    if [[ "${FW_PARSED_ARG_MAP[m]:-${FW_PARSED_ARG_MAP[modules]:-no}}" == no ]]; then targets=${targets/Modules/}; fi
    if [[ "${FW_PARSED_ARG_MAP[o]:-${FW_PARSED_ARG_MAP[options]:-no}}" == no ]]; then targets=${targets/Options/}; fi
    if [[ "${FW_PARSED_ARG_MAP[p]:-${FW_PARSED_ARG_MAP[parameters]:-no}}" == no ]]; then targets=${targets/Parameters/}; fi
    if [[ "${FW_PARSED_ARG_MAP[P]:-${FW_PARSED_ARG_MAP[projects]:-no}}" == no ]]; then targets=${targets/Projects/}; fi
    if [[ "${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[scenarios]:-no}}" == no ]]; then targets=${targets/Scenarios/}; fi
    if [[ "${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[sites]:-no}}" == no ]]; then targets=${targets/Sites/}; fi
    if [[ "${FW_PARSED_ARG_MAP[t]:-${FW_PARSED_ARG_MAP[tasks]:-no}}" == no ]]; then targets=${targets/Tasks/}; fi

#    if [[ "${FW_PARSED_ARG_MAP[e]:-${FW_PARSED_ARG_MAP[exit-options]:-no}}" == no ]]; then targets=${targets/exit-options/}; fi
#    if [[ "${FW_PARSED_ARG_MAP[r]:-${FW_PARSED_ARG_MAP[runtime-options]:-no}}" == no ]]; then targets=${targets/runtime-options/}; fi
fi



############################################################################################
##
## print application text
##
############################################################################################
for target in $targets; do
    printf "\n"; Describe element ${target}
    if (( ${FW_OBJECT_SET_VAL["ERROR_COUNT"]} > 0 )); then exit ${FW_OBJECT_SET_VAL["ERROR_COUNT"]}; fi
done
