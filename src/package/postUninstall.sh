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
## postUninstall - called by the installer after package software is removed.
##
## @author     Sven van der Meer <vdmeer.sven@mykolab.com>
## @version    0.0.5
##

echo  "********************postrm*******************"
echo "arguments $*"
echo  "*********************************************"

# Check for debian upgrade case which calls postrm, in which we do nothing
if [ "$1" = "upgrade" ]; then
    exit 0
fi

# Check if a soft link for Framework exists, if so remove it
echo " ==> removing symlinks"
if [ -L "/usr/local/bin/skb-framework" ]; then
    rm /usr/local/bin/skb-framework
fi
if [ -L "/usr/local/share/man/man1/skb-framework.1" ]; then
    rm /usr/local/share/man/man1/skb-framework.1
fi

echo " ==> removing /opt/skb-framework"
rm -fr /opt/skb/skb-framework

echo " ==> removing /var/cache/skb-framework"
rm -fr /var/cache/skb-framework

if [ -d "/opt/skb" ]; then
    echo " ==> found /opt/skb"

    if [ "`ls /opt/skb | wc -l`" != "0" ]; then
        echo " ==> none empty /opt/skb - leaving directory/group/user"
    else
        echo " ==> empty /opt/skb - removing directory/group/user"

        echo " ==> removing /opt/skb"
        rmdir /opt/skb/

        if [ -e "/home/skbuser" ]; then
            echo " ==> removing /home/skbuser"
            rm -fr /home/skbuser
        fi

        if getent passwd "skbuser" >/dev/null 2>&1
        then
            echo " ==> deleting user skbuser"
            userdel skbuser
        fi

        if getent group "skbuser" >/dev/null 2>&1
        then
            echo " ==> deleting group skbuser"
            groupdel skbuser
        fi

        echo " ==> done"
    fi
fi
