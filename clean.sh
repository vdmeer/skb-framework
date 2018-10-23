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
## Clean script for the SKB Framework
## - cleans artifacts
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##

if [[ ! $(command -v gradle) ]]; then
    printf "%s\n\n" "requires gradle"
    exit 1
fi
if [[ "$(gradle --version | grep "Gradle 4" | wc -l)" != "1" ]]; then
    printf "%s\n\n" "requires gradle version 4"
    exit 1
fi

gradle -c distribution.settings clean

if [[ -d src/main/bash/bin/java ]]; then
    rm src/main/bash/bin/java/*
    rmdir src/main/bash/bin/java
fi

if [[ -d src/main/bash/doc/manual ]]; then
    rm src/main/bash/doc/manual/*
    rmdir src/main/bash/doc/manual
    rmdir src/main/bash/doc
fi

if [[ -d src/main/bash/man/man1 ]]; then
    rm src/main/bash/man/man1/*
    rmdir src/main/bash/man/man1
    rmdir src/main/bash/man
fi

if [[ $(command -v mvn) ]]; then
    mvn clean
else
    printf "\n%s\n\n" "did not find maven, could not clean sitse"
fi
