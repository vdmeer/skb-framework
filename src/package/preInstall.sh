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
## preInstall - called by the installer before package software is installed.
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##

echo  "********************preinst*******************"
echo "arguments $*"
echo  "**********************************************"

# Check if Framework is running
if [ -d /tmp/skb-framework ]; then
    if [ "`ls /tmp/skb-framework | wc -l`" != "0" ]; then
        echo "==> SKB Framework processes are running, stop prior to package upgrade"
        echo "==> alternatively: remove /tmp/skb-framework"
        exit 1
    fi
fi

mkdir -p /usr/local/share/man/man1/

if ! getent group "skbuser" >/dev/null 2>&1
then
    echo "creating group skbuser . . ."
    groupadd skbuser
fi

if ! getent passwd "skbuser" >/dev/null 2>&1
then
    echo "creating user skbuser . . ."
    useradd -g skbuser skbuser
    usermod -a -G skbuser skbuser
fi

# Create the skbuser home directory
mkdir -p /home/skbuser
chown -R skbuser:skbuser /home/skbuser
