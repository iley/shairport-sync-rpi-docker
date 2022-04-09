#!/bin/sh
service dbus start
service avahi-daemon start
echo "Starting nqptp..."
nqptp &
echo "Starting shairport-sync..."
shairport-sync -v -u -m avahi -a "$AIRPLAY_NAME" "$@"
