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
## Functions: system
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## function: PathToSystemPath()
## - converts a path to Cygwin
## $1: path to convert
## return: converted path, original if not on a cygwin OS
## use: VARIABLE=$(PathToSystemPath "path")
##
PathToSystemPath() {
    if [[ ${CONFIG_MAP["SYSTEM"]} == "CYGWIN" ]]; then
        echo "`cygpath -m $1`"
    else
        echo $1
    fi
}



##
## function: TestDirectoryExists()
## - tests if a directory exists and is readable, throws an error if not
## $1: the directory name, with path if required
## $2: some string for the error message, for instance the calling task
##
TestDirectoryExists() {
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestDirectoryExists: no directory name given"
        return
    fi
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestDirectoryExists: no error text given"
        return
    fi

    if [[ ! -d "$1" ]]; then
        ConsoleError "  ->" "$2: directory does not exist: $1"
    fi
    if [[ ! -r "$1" ]]; then
        ConsoleError "  ->" "$2: directory not readable: $1"
    fi
}



##
## function: TestFileExists()
## - tests if a file exists and is readable, throws an error if not
## $1: the file name, with path if required
## $2: some string for the error message, for instance the calling task
##
TestFileExists() {
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestFileExists: no file name given"
        return
    fi
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestFileExists: no error text given"
        return
    fi

    if [[ ! -f "$1" ]]; then
        ConsoleError "  ->" "$2: file does not exist: $1"
    fi
    if [[ ! -r "$1" ]]; then
        ConsoleError "  ->" "$2: file not readable: $1"
    fi
}



##
## function: TestDirectoryWritable()
## - tests if a directory exists and is writable, throws an error if not
## $1: the directory name, with path if required
## $2: some string for the error message, for instance the calling task
##
TestDirectoryWritable() {
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestDirectoryWritable: no directory name given"
        return
    fi
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestDirectoryWritable: no error text given"
        return
    fi

    if [[ ! -d "$1" ]]; then
        ConsoleError "  ->" "$2: directory does not exist: $1"
    fi
    if [[ ! -w "$1" ]]; then
        ConsoleError "  ->" "$2: directory not writable: $1"
    fi
}



##
## function: TestFileWritable()
## - tests if a file exists and is writable, throws an error if not
## $1: the file name, with path if required
## $2: some string for the error message, for instance the calling task
##
TestFileWritable() {
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestFileWritable: no file name given"
        return
    fi
    if [[ -z ${1:-} ]]; then
        ConsoleError "  ->" "TestFileWritable: no error text given"
        return
    fi

    if [[ ! -f "$1" ]]; then
        ConsoleError "  ->" "$2: file does not exist: $1"
    fi
    if [[ ! -w "$1" ]]; then
        ConsoleError "  ->" "$2: file not writable: $1"
    fi
}
