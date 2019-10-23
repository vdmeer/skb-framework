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
## Stores - data object representing the framework's stores
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.6
## @since      0.0.6
##


function Stores() {
    if [[ -z "${1:-}" ]]; then Explain component "${FUNCNAME[0]}"; return; fi

    local format id keys
    if [[ -n "${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]:-}" ]]; then format="${FW_OBJECT_SET_VAL["PRINT_FORMAT2"]}"; else format="${FW_OBJECT_SET_VAL["PRINT_FORMAT"]}"; fi

    local cmd1="${1,,}" cmd2 cmd3 cmdString1="${1,,}" cmdString2 cmdString3
    shift; case "${cmd1}" in

        has)
            echo " characters legends settings templates " ;;

        count)
            printf "${FW_OBJECT_STO_COUNT}" ;;

        build | clear | show)
            if [[ "${#}" -lt 1 ]]; then Report process error "${FUNCNAME[0]}" "${cmdString1} cmd2" E802 1 "$#"; return; fi
            cmd2=${1,,}; shift; cmdString2="${cmd1} ${cmd2}"
            case "${cmd1}-${cmd2}" in

                build-all)
                    __skb_internal_store_build_characters ${format}
                    __skb_internal_store_build_legends ${format}
                    __skb_internal_store_build_settings ${format}
                    __skb_internal_store_build_templates ${format} ;;

                build-characters)
                    __skb_internal_store_build_characters ${format} ;;

                build-legends)
                    __skb_internal_store_build_characters ${format}
                    __skb_internal_store_build_legends ${format} ;;

                build-settings)
                    __skb_internal_store_build_settings ${format} ;;

                build-templates)
                    __skb_internal_store_build_templates ${format} ;;

                clear-all)
                    declare -A -g FW_OBJECT_STO__CHARS FW_OBJECT_STO__SET FW_OBJECT_STO__LEGENDS FW_OBJECT_STO_TEMPLATES
                    FW_OBJECT_STO_STORED=" " ;;

                clear-format)   __skb_internal_store_clear_format ${format} ;;

                show-all)
                    __skb_internal_store_show_characters
                    __skb_internal_store_show_legends
                    __skb_internal_store_show_settings
                    __skb_internal_store_show_templates ;;

                show-characters)
                    __skb_internal_store_show_characters ;;

                show-legends)
                    __skb_internal_store_show_legends ;;

                show-settings)
                    __skb_internal_store_show_settings ;;

                show-templates)
                    __skb_internal_store_show_templates ;;

                *)  Report process error "${FUNCNAME[0]}" "cmd2" E803 "${cmdString2}"; return ;;
            esac ;;
        *)  Report process error "${FUNCNAME[0]}" E803 "${cmdString1}"; return ;;
    esac
}
