#! /bin/sh

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
## postInstall - called by the installer after package software is installed.
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##

echo  "********************postinst****************"
echo "arguments $*"
echo  "***********************************************"

# Check for debian abort-remove case which calls postinst, in which we do nothing
if [ "$1" = "abort-remove" ]; then
    exit 0
fi

# create the lib dir for the Tool
mkdir /opt/skb/skb-framework/lib

# Ensure everything has the correct permissions
find /opt/skb/skb-framework -type d -perm 755
find /opt/skb/skb-framework/bin -type f -perm 555
find /opt/skb/skb-framework/etc -type f -perm 664
#find /opt/skb/skb-framework/lib -type f -perm 644
find /opt/skb/skb-framework/man -type f -perm 644
find /opt/skb/skb-framework/scenarios -type f -perm 644
chown -R skbuser:skbuser /opt/skb/skb-framework

# create the cache dir
mkdir -p /var/cache/skb-framework
chown -R skbuser:skbuser /var/cache/skb-framework

(cd /usr/local/bin; ln -s /opt/skb/skb-framework/bin/skb-framework)
(cd /usr/local/share/man/man1; ln -s /opt/skb/skb-framework/man/man1/skb-framework.1)
