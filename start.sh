#!/bin/sh
envsubst < /etc/shairport-sync.conf.template > /etc/shairport-sync.conf
service dbus start
service avahi-daemon start
echo "Starting nqptp..."
nqptp &
echo "Starting shairport-sync..."
shairport-sync -v -u -m avahi -a "$AIRPLAY_NAME" "$@"
