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
## Functions for applications
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##



##
## DescribeApplication()
## - prints application descriptions for various topics
## $1: topic, one of authors, bugs, copying, description, resources, security
## $2: optional print-mode, default setting from CONFIG_MAP used otherwise
##
DescribeApplication() {
    local PRINT_MODE=${CONFIG_MAP["PRINT_MODE"]}
    if [[ ! -z ${2:-} ]]; then
        case $2 in
            ansi | text* | adoc)
                PRINT_MODE=$2
                ;;
            *)
                ConsolePrint error "describe-application: unknown print mode $2"
                return
                ;;
        esac
    fi

    case $1 in
        authors)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== AUTHORS\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/authors.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "AUTHORS" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/authors.txt
                    printf "\n"
                    ;;
            esac
            ;;
        bugs)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== BUGS\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/bugs.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "BUGS" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/bugs.txt
                    printf "\n"
                    ;;
            esac
            ;;
        copying)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== COPYING\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/copying.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "COPYING" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/copying.txt
                    printf "\n"
                    ;;
            esac
            ;;
        description)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== DESCRIPTION\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/description.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "DESCRIPTION" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/description.txt
                    printf "\n"
                    ;;
            esac
            ;;
        resources)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== RESOURCES\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/resources.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "RESOURCES" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/resources.txt
                    printf "\n"
                    ;;
            esac
            ;;
        security)
            case $PRINT_MODE in
                adoc)
                    printf "\n\n== SECURITY CONCERNS\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/security.adoc
                    printf "\n\n"
                    ;;
                ansi | text*)
                    printf "  "
                    PrintEffect bold "SECURITY CONCERNS" $PRINT_MODE
                    printf "\n"
                    cat ${CONFIG_MAP["MANUAL_SRC"]}/application/security.txt
                    printf "\n"
                ;;
            esac
            ;;
        *)
            ConsolePrint error "describe-application: unknown topic $1"
            ;;
    esac
}
