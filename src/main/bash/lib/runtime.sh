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
## task-runtime - configures runtime for tasks and other elements
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


if [[ ! -n "${SF_HOME:-}" || "${FW_LOADED:-no}" != yes ]]; then printf " task-runtime: please run from skb-framework\n\n"; exit 10; fi
source ${SF_HOME}/lib/runtime/01-rt-maps.sh
source ${SF_HOME}/lib/runtime/02-object-maps.sh
source ${SF_HOME}/lib/runtime/03-element-maps.sh
source ${SF_HOME}/lib/runtime/04-instance-maps.sh
source ${SF_HOME}/lib/runtime/05-exitcodes.sh
source ${SF_HOME}/lib/runtime/06-actions.sh