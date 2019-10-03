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
## list-settings - task that lists the framework's settings
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME}" || "${FW_LOADED:-no}" != yes ]]; then printf " skb-runtime: please run from skb-framework\n\n"; exit 100; fi
source ${SF_HOME}/lib/framework/Framework.sh

Cli add option table; Cli add option show-values; Cli add option with-legend; Cli add option without-status; Cli add option without-extras

Cli add general option  cli         C ""  "set from CLI option" "Filters"
Cli add general option  default     d ""  "set from default value" "Filters"
Cli add general option  env         e ""  "set from environment" "Filters"
Cli add general option  file        f ""  "set from file" "Filters"
Cli add general option  framework   w ""  "set from framework" "Filters"
Cli add general option  project     p ""  "set from project" "Filters"
Cli add general option  scenario    s ""  "set from scenario" "Filters"
Cli add general option  shell       L ""  "set from shell" "Filters"
Cli add general option  task        t ""  "set from task" "Filters"

Parse cli arguments "Options Table+Options Filters" $*


############################################################################################
##
## get filters from CLI
##
############################################################################################
cli=no;         if [[ "${FW_PARSED_ARG_MAP[C]:-${FW_PARSED_ARG_MAP[cli]:-no}}" == yes ]]; then cli=yes; fi
default=no;     if [[ "${FW_PARSED_ARG_MAP[d]:-${FW_PARSED_ARG_MAP[default]:-no}}" == yes ]]; then default=yes; fi
env=no;         if [[ "${FW_PARSED_ARG_MAP[e]:-${FW_PARSED_ARG_MAP[env]:-no}}" == yes ]]; then env=yes; fi
file=no;        if [[ "${FW_PARSED_ARG_MAP[f]:-${FW_PARSED_ARG_MAP[file]:-no}}" == yes ]]; then file=yes; fi
framework=no;   if [[ "${FW_PARSED_ARG_MAP[w]:-${FW_PARSED_ARG_MAP[framework]:-no}}" == yes ]]; then framework=yes; fi
project=no;     if [[ "${FW_PARSED_ARG_MAP[p]:-${FW_PARSED_ARG_MAP[project]:-no}}" == yes ]]; then project=yes; fi
scenario=no;    if [[ "${FW_PARSED_ARG_MAP[s]:-${FW_PARSED_ARG_MAP[scenario]:-no}}" == yes ]]; then scenario=yes; fi
shell=no;       if [[ "${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[shell]:-no}}" == yes ]]; then shell=yes; fi
task=no;        if [[ "${FW_PARSED_ARG_MAP[t]:-${FW_PARSED_ARG_MAP[task]:-no}}" == yes ]]; then task=yes; fi


showValues=""
if [[ "${FW_PARSED_ARG_MAP[V]:-${FW_PARSED_ARG_MAP[show-values]:-no}}" == "yes" ]]; then showValues="show-values"; fi

withLegend=""
if [[ "${FW_PARSED_ARG_MAP[W]:-${FW_PARSED_ARG_MAP[with-legend]:-no}}" == "yes" ]]; then withLegend="with-legend"; fi

withoutStatus=""
if [[ "${FW_PARSED_ARG_MAP[S]:-${FW_PARSED_ARG_MAP[without-status]:-no}}" == "yes" ]]; then withoutStatus="without-status"; fi

withoutExtras=""
if [[ "${FW_PARSED_ARG_MAP[E]:-${FW_PARSED_ARG_MAP[without-extras]:-no}}" == "yes" ]]; then withoutExtras="without-extras"; fi




############################################################################################
##
## filter settings
##
############################################################################################
arr="$(Settings has)"
remove=""
for id in $arr; do
    if [[ "${cli}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "CLI" ]]; then remove+=" "$id; fi
    if [[ "${default}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Default" ]]; then remove+=" "$id; fi
    if [[ "${env}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Env" ]]; then remove+=" "$id; fi
    if [[ "${file}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "File" ]]; then remove+=" "$id; fi
    if [[ "${framework}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Framework" ]]; then remove+=" "$id; fi
    if [[ "${project}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Project" ]]; then remove+=" "$id; fi
    if [[ "${scenario}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Scenario" ]]; then remove+=" "$id; fi
    if [[ "${shell}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Shell" ]]; then remove+=" "$id; fi
    if [[ "${task}" == yes && "${FW_OBJECT_SET_PHA[${id}]}" != "Task" ]]; then remove+=" "$id; fi
done

for id in $remove; do
    arr=${arr/${id}/}
done



############################################################################################
##
## list settings
##
############################################################################################
if [[ ${FW_PARSED_ARG_MAP[T]:-${FW_PARSED_ARG_MAP[table]:-no}} == no ]]; then
    printf "\n  "
    Format themed text listHeadFmt Settings
    printf "\n"
    Print setting list "${arr}" ${showValues}
else
    Print setting table "${arr}" ${showValues} ${withLegend} ${withoutStatus} ${withoutExtras}
fi
