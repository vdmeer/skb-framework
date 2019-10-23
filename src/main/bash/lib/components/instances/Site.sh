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
## Site - instance to manage site requirements
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Site() {
    local writeSlow=false
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    ## Site ID1 requires ... ID2
    if [[ "${#}" -lt 4 ]];         then Report process error "${FUNCNAME[0]}" E801 4 "$#"; return; fi
    if [[ "${2}" != "requires" ]]; then Report process error "${FUNCNAME[0]}" "${1} requires 'component' ${4}" E803 "${2}"; return; fi

    local id1="${1}" id2="${4}"
    Test existing site id "${id1}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi

    case "${3}" in
        application)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_APP["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_APP["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_APP["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_APP["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        dependency)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_DEP["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_DEP["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_DEP["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_DEP["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        parameter)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_PAR["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_PAR["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_PAR["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_PAR["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        scenario)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_SCN["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_SCN["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_SCN["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_SCN["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        directory-list)
            Test existing dirlist id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_DLS["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_DLS["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_DLS["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_DLS["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        directory)
            Test existing dir id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_DIR["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_DIR["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_DIR["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_DIR["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        file-list)
            Test existing filelist id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_FLS["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_FLS["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_FLS["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_FLS["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        file)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_FIL["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_FIL["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_FIL["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_FIL["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        task)
            Test existing ${3} id "${id2}"; errno=$?; if [[ "${errno}" != 0 ]]; then return; fi
            if [[ ! -n "${FW_ELEMENT_SIT_REQOUT_TSK["${id1}"]:-}" ]]; then
                FW_ELEMENT_SIT_REQOUT_TSK["${id1}"]+="${id2} "; writeSlow=true
            else
                case "${FW_ELEMENT_SIT_REQOUT_TSK["${id1}"]}" in
                    *"${id2} "*)    Report application error "${FUNCNAME[0]}" "${1} requires ${3} ${4}" E904 "${id2}" "${3} ${id1}"; return ;;
                    *)              FW_ELEMENT_SIT_REQOUT_TSK["${id1}"]+="${id2} "; writeSlow=true ;;
                esac
            fi ;;
        *)
            Report process error "${FUNCNAME[0]}" "${1} requires 'component' ${4}" E803 "${3}"; return ;;
    esac

    if [[ "${writeSlow}" ]]; then FW_ELEMENT_SIT_REQOUT_COUNT[${id1}]=$(( FW_ELEMENT_SIT_REQOUT_COUNT[${id1}] + 1 )); fi
    if [[ "${writeSlow}" == true && "${FW_OBJECT_SET_VAL["AUTO_WRITE"]:-false}" != false ]]; then Write slow config; fi
}
