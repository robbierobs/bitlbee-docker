#!/bin/sh

USER_ID=${LOCAL_USER_ID:-1000}
GROUP_ID=${LOCAL_GROUP_ID:-1000}

addgroup -g "$GROUP_ID" -S bitlbee
adduser -u "$USER_ID" -S bitlbee -G bitlbee

touch /var/run/bitlbee.pid

chown -R bitlbee:bitlbee /bitlbee-data
chown bitlbee:bitlbee /var/run/bitlbee.pid

export HOME=/home/bitlbee

exec su-exec bitlbee "$@"
