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
## Functions for printing settings, values, etc
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.4
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##


##
## function: PrintAppMode
## - prints the application mode
##
PrintAppMode() {
    case "${CONFIG_MAP["APP_MODE"]}" in
        all)    PrintColor red              "${CONFIG_MAP["APP_MODE"]}" ;; 
        dev)    PrintColor yellow           "${CONFIG_MAP["APP_MODE"]}" ;;
        build)  PrintColor light-blue       "${CONFIG_MAP["APP_MODE"]}" ;;
        use)    PrintColor green            "${CONFIG_MAP["APP_MODE"]}" ;;
    esac
}



##
## function: PrintAppModeFlavor
## - prints the application mode flavor
##
PrintAppModeFlavor() {
    case "${CONFIG_MAP["APP_MODE_FLAVOR"]}" in
        std)        PrintColor cyan             "${CONFIG_MAP["APP_MODE_FLAVOR"]}" ;; 
        install)    PrintColor purple           "${CONFIG_MAP["APP_MODE_FLAVOR"]}" ;;
    esac
}



##
## function: PrintConsoleLevel
## - prints the level (loader, shell, task) in color
## $1: level
##
PrintConsoleLevel() {
    local LEVEL=$1
    case "$LEVEL" in
        all)            PrintColor light-cyan      $LEVEL;;
        fatal)          PrintColor red             $LEVEL;;
        error)          PrintColor light-red       $LEVEL;;
        warn-strict)    PrintColor yellow "warn"; printf "-"; PrintColor light-red "strict";;
        warn)           PrintColor yellow          $LEVEL;;
        info)           PrintColor green           $LEVEL;;
        debug | trace)  PrintColor light-blue      $LEVEL;;
        off)            PrintColor light-purple    $LEVEL;;
        *)              PrintColor light-purple    $LEVEL;;
    esac
}



##
## function: PrintStrict
## - prints the strict setting
##
PrintStrict() {
    case "${CONFIG_MAP["STRICT"]}" in
        on)     PrintColor light-red "on" ;;
        off)    PrintColor light-green "off" ;;
    esac
}



##
## function: PrintQuiet
## - prints the quiet setting
## $1: setting
##
PrintQuiet() {
    local QUIET=$1
    case "$QUIET" in
        on)     PrintColor light-red        $QUIET;;
        off)    PrintColor light-green      $QUIET;;
        *)      PrintColor light-purple     $QUIET;;
    esac
}



##
## function: PrintShellSNP
## - prints the shell no-prompt- setting
##
PrintShellSNP() {
    case "${CONFIG_MAP["SHELL_SNP"]}" in
        on)     PrintColor light-red "on" ;;
        off)    PrintColor light-green "off" ;;
    esac
}
