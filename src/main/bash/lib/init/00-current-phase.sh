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
## Current Phase - preset current phase, required to load caches
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


declare -A FW_OBJECT_SET_LONG       ## [long]="description"
declare -A FW_OBJECT_SET_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_SET_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_SET_PHASET     ## [long]="phase that did set the value"
declare -A FW_OBJECT_SET_VAL        ## [long]="the value"


FW_OBJECT_SET_LONG["CURRENT_PHASE"]="current execution phase"
FW_OBJECT_SET_DECMDS["CURRENT_PHASE"]="⫷Framework⫸"
FW_OBJECT_SET_DECPHA["CURRENT_PHASE"]="Load"
FW_OBJECT_SET_PHASET["CURRENT_PHASE"]="Load"
FW_OBJECT_SET_VAL["CURRENT_PHASE"]="Load"

