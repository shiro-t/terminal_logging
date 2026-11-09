#!/bin/sh
SCRIPTLOGDIR="${HOME}/.terminal-logs"

if [ ! -d "${SCRIPTLOGDIR}" ] ; then
    mkdir -p "${SCRIPTLOGDIR}"
fi
export PTZ='[%D{%Y/%m/%d %H:%M}] '
export PTB='[\D{%Y/%m/%d %H:%M}] '
exec script "${SCRIPTLOGDIR}"/`date "+%Y-%m-%d_%H%M%S"`
