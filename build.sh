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
## Build script for the SKB Framework
## - builds all artifacts for distributions
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##

gradle -c java.settings clean
gradle -c java.settings

mkdir -p src/main/bash/doc/manual
mkdir -p src/main/bash/man/man1
mkdir -p src/main/bash/cache

mkdir -p src/main/bash/bin/java
cp build/libs/skb-framework-tool-0.0.0-all.jar src/main/bash/bin/java

#TOOL_DIR=`(cd build/libs;pwd)`
export SF_SKB_FW_TOOL=$TOOL_DIR/skb-framework-tool-0.0.0-all.jar
src/main/bash/bin/skb-framework -c
src/main/bash/bin/skb-framework -D -e bdh -S off
src/main/bash/bin/skb-framework -h

gradle -c distribution.settings
