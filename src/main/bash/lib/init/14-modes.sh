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
## Add modes
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


Add Object Mode all             "${SF_HOME}/lib/text/modes" "all modes are active"
Add Object Mode test            "${SF_HOME}/lib/text/modes" "mode for testing framework and modules"
Add Object Mode dev             "${SF_HOME}/lib/text/modes" "mode for development tasks"
Add Object Mode build           "${SF_HOME}/lib/text/modes" "mode for build tasks"
Add Object Mode use             "${SF_HOME}/lib/text/modes" "mode for use tasks"
