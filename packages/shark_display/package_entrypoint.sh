#!/bin/bash

set +e
echo "ROS_DISCOVERY_SERVER: $ROS_DISCOVERY_SERVER"
IFS=':' read -ra ADDR <<<"$ROS_DISCOVERY_SERVER"

export IP_ROS_DISCOVERY_SERVER="${ADDR[0]}"
export PORT_ROS_DISCOVERY_SERVER="${ADDR[1]}"

if [ -z "$ROS_DISCOVERY_SERVER" ]; then
	echo "WARNING: ROS_DISCOVERY_SERVER ENV VARIABLE NOT SET"
fi

echo "CONFIGURING ROS2 DISCOVERY SUPER CLIENT: $IP_ROS_DISCOVERY_SERVER:$PORT_ROS_DISCOVERY_SERVER"
sed -i "s|<address>[^<]*</address>|<address>$IP_ROS_DISCOVERY_SERVER</address>|g" /ran/config/super_client_configuration.xml
sed -i "s|<port>[^<]*</port>|<port>$PORT_ROS_DISCOVERY_SERVER</port>|g" /ran/config/super_client_configuration.xml

# setup ros2 environment
source "/ran/install/setup.bash" --

exec "$@"
