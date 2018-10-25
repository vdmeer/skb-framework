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
## Functions for build-mvn-site (Maven site)
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    v0.0.0
##


##
## DO NOT CHANGE CODE BELOW, unless you know what you are doing
##



##
## function: MvnSiteFixAdoc()
## - fixes HTML files generated from ADOC sources by the Maven site plugin
##   -- add a text to the HTML title of the page (empty otherwise)
##   -- add text to the active bread crumb list item (empty otherwise)
## $1: file name, with leading directory if required
## $2: text to add to title and bread crumbs
##
MvnSiteFixAdoc() {
    sed -i.bak 's,<li class="active "></li>,'"<li class=\"active \">${2}</li>"',g' $1.html
    rm $1.html.bak
    sed -i.bak 's,x2013; </title>,'"x2013; $2</title>"',g' $1.html
    rm $1.html.bak
}
