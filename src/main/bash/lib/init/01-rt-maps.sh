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
## Runtime Maps - declare the framework's core runtime maps
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


declare -x FW_RUNTIME_MAPS_FAST=""    ## fast changing maps, such as settings, phases
declare -x FW_RUNTIME_MAPS_MEDIUM=""  ## medium changing maps, such as status and status comments
declare -x FW_RUNTIME_MAPS_SLOW=""    ## slow chaning maps, such as themes, theme items, messages
declare -x FW_RUNTIME_MAPS_LOAD=""    ## maps written only at load time, such as options and known theme items
