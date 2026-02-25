#!/bin/sh

XTRAIL=~/misc/blade/bin/xtrail

if [ -z "${DBUS_SESSION_BUS_ADDRESS}" ] || [ "${FORCE_NEW_DBUS_SESSION}" = 1 ]; then
  exec dbus-run-session -- "${XTRAIL}"
else
  "${XTRAIL}"
fi
