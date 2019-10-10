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
## Add phases
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


Add object phase Load           "${SF_HOME}/lib/text/phases" "load, from start to final settings"
Add object phase CLI            "${SF_HOME}/lib/text/phases" "phase loading CLI options"
Add object phase Default        "${SF_HOME}/lib/text/phases" "phase loading default values"
Add object phase Env            "${SF_HOME}/lib/text/phases" "phase loading values from the environment"
Add object phase File           "${SF_HOME}/lib/text/phases" "phase loading values from a file"
Add object phase Project        "${SF_HOME}/lib/text/phases" "phase running targets on a project"
Add object phase Scenario       "${SF_HOME}/lib/text/phases" "phase running tasks from a scenario"
Add object phase Shell          "${SF_HOME}/lib/text/phases" "phase executing commands in the shell"
Add object phase Task           "${SF_HOME}/lib/text/phases" "phase executing tasks"
Add object phase Site           "${SF_HOME}/lib/text/phases" "phase running functions for a (Maven) site"
