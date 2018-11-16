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
## Loader: commands to run on CLI --configuration
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.2
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


CONFIG_MAP["LOADER_QUIET"]=on
CONFIG_MAP["SHELL_QUIET"]=on
OPT_CLI_MAP["execute-task"]="list-configuration "$CLI_EXTRA_ARGS
DO_EXIT_2=true
