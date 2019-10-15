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
## Object Maps - declare the framework's (data) object maps
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


##
## CONFIGURATION Maps - CFG
##
declare -A FW_OBJECT_CFG_LONG       ## [long]="description"
declare -A FW_OBJECT_CFG_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_CFG_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_CFG_VAL        ## [long]="value"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_CFG_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_CFG_LONG FW_OBJECT_CFG_DECMDS FW_OBJECT_CFG_DECPHA"



##
## FORMATS Maps - FMT
##
declare -A FW_OBJECT_FMT_LONG       ## [long]="description"
declare -A FW_OBJECT_FMT_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_FMT_DECPHA     ## [long]="declared in phase"

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_FMT_LONG FW_OBJECT_FMT_DECMDS FW_OBJECT_FMT_DECPHA"



##
## LEVELS Maps - LVL
##
declare -A FW_OBJECT_LVL_LONG       ## [long]="description"
declare -A FW_OBJECT_LVL_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_LVL_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_LVL_CHAR_ABBR  ## [long]="char for abbbreviating level, e.g. in tables"
declare -A FW_OBJECT_LVL_STRING_THM ## [long]="theme string"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_LVL_LONG FW_OBJECT_LVL_CHAR_ABBR FW_OBJECT_LVL_STRING_THM FW_OBJECT_LVL_DECMDS FW_OBJECT_LVL_DECPHA"



##
## MESSAGES Maps - MSG
##
declare -A FW_OBJECT_MSG_LONG       ## [long]="description"
declare -A FW_OBJECT_MSG_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_MSG_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_MSG_TYPE       ## [long]="error | warning"]
declare -A FW_OBJECT_MSG_CAT        ## [long]="category
declare -A FW_OBJECT_MSG_ARGS       ## [long]="number of arguments"
declare -A FW_OBJECT_MSG_TEXT       ## [long]="text with arg replacement string"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_MSG_LONG FW_OBJECT_MSG_TYPE FW_OBJECT_MSG_CAT FW_OBJECT_MSG_ARGS FW_OBJECT_MSG_TEXT FW_OBJECT_MSG_DECMDS FW_OBJECT_MSG_DECPHA"



##
## MODES Maps - MOD
##
declare -A FW_OBJECT_MOD_LONG       ## [long]="description"
declare -A FW_OBJECT_MOD_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_MOD_DECPHA     ## [long]="declared in phase"

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_MOD_LONG FW_OBJECT_MOD_DECMDS FW_OBJECT_MOD_DECPHA"



##
## PHASES Maps - PHA
##
declare -A FW_OBJECT_PHA_LONG       ## [long]="description"
declare -A FW_OBJECT_PHA_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_PHA_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_PHA_PRT_LVL    ## [long]=" print levels "
declare -A FW_OBJECT_PHA_LOG_LVL    ## [long]=" log levels "
declare -A FW_OBJECT_PHA_ERRCNT     ## [long]="error count, integer"
declare -A FW_OBJECT_PHA_WRNCNT     ## [long]="warning count, integer"
declare -A FW_OBJECT_PHA_MSGCOD     ## [long]="list of recorded messages codes"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_PHA_PRT_LVL FW_OBJECT_PHA_LOG_LVL FW_OBJECT_PHA_ERRCNT FW_OBJECT_PHA_WRNCNT FW_OBJECT_PHA_MSGCOD"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_PHA_LONG FW_OBJECT_PHA_DECMDS FW_OBJECT_PHA_DECPHA"



##
## SETTINGS Maps - SET
##
declare -A FW_OBJECT_SET_LONG       ## [long]="description"
declare -A FW_OBJECT_SET_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_SET_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_SET_PHASET     ## [long]="phase that did set the value"
declare -A FW_OBJECT_SET_VAL        ## [long]="the value"

FW_RUNTIME_MAPS_FAST+=" FW_OBJECT_SET_PHASET FW_OBJECT_SET_VAL"
FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_SET_LONG FW_OBJECT_SET_DECMDS FW_OBJECT_SET_DECPHA"



##
## THEME Maps - THM
##
declare -A FW_OBJECT_THM_LONG       ## [long]=description
declare -A FW_OBJECT_THM_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_THM_DECPHA     ## [long]="declared in phase"

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_THM_LONG FW_OBJECT_THM_DECMDS FW_OBJECT_THM_DECPHA"



##
## THEMEITEM Maps - TIM
##
declare -A FW_OBJECT_TIM_LONG       ## [long]=description
declare -A FW_OBJECT_TIM_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_TIM_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_TIM_SOURCE     ## [long]=source of setting, theme long
declare -A FW_OBJECT_TIM_VAL        ## [long]=value, item settings

FW_RUNTIME_MAPS_SLOW+=" FW_OBJECT_TIM_SOURCE FW_OBJECT_TIM_VAL"
FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_TIM_LONG FW_OBJECT_TIM_DECMDS FW_OBJECT_TIM_DECPHA"



##
## VARIABLE Maps - VAR
##
declare -A FW_OBJECT_VAR_LONG       ## [long]=description
declare -A FW_OBJECT_VAR_DECMDS     ## [long]="declared in module"
declare -A FW_OBJECT_VAR_DECPHA     ## [long]="declared in phase"
declare -A FW_OBJECT_VAR_CAT        ## [long]=category

FW_RUNTIME_MAPS_LOAD+=" FW_OBJECT_VAR_LONG FW_OBJECT_VAR_DECMDS FW_OBJECT_VAR_DECPHA"

