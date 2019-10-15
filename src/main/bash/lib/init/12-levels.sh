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
## Add levels
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


Add object level fatalerror     with    "F"  "Fatal"    "a fatal problem that should lead to exit"
Add object level error          with    "E"  "Error"    "a serious problem, recovery might be possible"
Add object level text           with    "X"  "Text"     "simple text"
Add object level message        with    "M"  "Message"  "a formatted messsage"
Add object level warning        with    "W"  "Warning"  "a warning that should not impede further processing"
Add object level info           with    "I"  "Info"     "information about a flow or process"
Add object level debug          with    "D"  "Debug"    "detailed information about a flow of process"
Add object level trace          with    "T"  "Trace"    "very detailed information about a flow or process"

