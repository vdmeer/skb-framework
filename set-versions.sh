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
## make script for the SKB-Framework
## - runs the SKB-Framework with task make-target-sets
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v1.0.0
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

if [[ -f tool/src/main/resources/tool-version.txt ]]; then
    rm tool/src/main/resources/tool-version.txt
fi

RELEASE_VERSION="$(cat src/main/bash/etc/version.txt)"
cp src/main/bash/etc/version.txt tool/src/main/resources/tool-version.txt
ant -f ant/build.xml -DmoduleVersion=${RELEASE_VERSION} -DmoduleDir=../
chmod 644 src/main/bash/**/*.id src/main/bash/**/*.scn tool/src/**/*.java
