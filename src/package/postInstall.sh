#! /bin/sh
#
# This script is called after package software is installed
#

echo  "********************postinst****************"
echo "arguments $*"
echo  "***********************************************"

# Check for debian abort-remove case which calls postinst, in which we do nothing
if [ "$1" = "abort-remove" ]; then
    exit 0
fi

# Ensure everything has the correct permissions
find /opt/skb/skb-framework -type d -perm 755
find /opt/skb/skb-framework/bin -type f -perm 555
find /opt/skb/skb-framework/etc -type f -perm 664
#find /opt/skb/skb-framework/lib -type f -perm 644
find /opt/skb/skb-framework/man -type f -perm 644
find /opt/skb/skb-framework/scenarios -type f -perm 644

chown -R skbuser:skbuser /opt/skb/skb-framework

mkdir -p /var/cache/skb-framework
chown -R skbuser:skbuser /var/cache/skb-framework

mkdir -p /opt/skb/skb-framework/lib/java
chown -R skbuser:skbuser /opt/skb/skb-framework/lib
chmod 775 /opt/skb/skb-framework/lib
chmod 775 /opt/skb/skb-framework/lib/java
