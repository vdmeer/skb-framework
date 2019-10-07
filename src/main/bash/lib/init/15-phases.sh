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


    Add Object Phase Load           "${SF_HOME}/lib/text/phases" "load, from start to final settings"
    Add Object Phase CLI            "${SF_HOME}/lib/text/phases" "phase loading CLI options"
    Add Object Phase Default        "${SF_HOME}/lib/text/phases" "phase loading default values"
    Add Object Phase Env            "${SF_HOME}/lib/text/phases" "phase loading values from the environment"
    Add Object Phase File           "${SF_HOME}/lib/text/phases" "phase loading values from a file"
    Add Object Phase Project        "${SF_HOME}/lib/text/phases" "phase running targets on a project"
    Add Object Phase Scenario       "${SF_HOME}/lib/text/phases" "phase running tasks from a scenario"
    Add Object Phase Shell          "${SF_HOME}/lib/text/phases" "phase executing commands in the shell"
    Add Object Phase Task           "${SF_HOME}/lib/text/phases" "phase executing tasks"
    Add Object Phase Site           "${SF_HOME}/lib/text/phases" "phase running functions for a (Maven) site"
