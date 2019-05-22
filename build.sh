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
##

set -o errexit -o pipefail -o noclobber -o nounset
shopt -s globstar

export SF_MVN_SITES=$PWD
export SF_MAKE_TARGET_SETS=$PWD

mkdir -p src/main/bash/man/man1 2> /dev/null
mkdir -p src/main/bash/doc/manual 2> /dev/null

src/main/bash/bin/skb-framework --all-mode --snp --task-level debug --install -e make-target-sets -- --all -t $1
