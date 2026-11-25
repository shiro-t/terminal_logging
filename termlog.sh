#!/bin/bash
SCRIPTLOGDIR="${HOME}/Documents/terminal_logs"
TTL="${HOME}/Applications/libexec/ttl"
BSDSCRIPT="${HOME}/Applications/bin/script"

if [ ! -d "${SCRIPTLOGDIR}" ] ; then
    mkdir -p "${SCRIPTLOGDIR}"
fi
export PTZ='[%D{%Y/%m/%d %H:%M}] '
export PTB='[\D{%Y/%m/%d %H:%M}] '

SCRIPT="$(which script)"
WFLAG=""
if [ -e "${BSDSCRIPT}" ]; then
   SCRIPT="${BSDSCRIPT}"
   WFLAG="-w"
fi

if [ -e "${TTL}" ] ; then
    exec "${SCRIPT}" "${WFLAG}" -F -q >( "${TTL}"> "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") ) $SHELL -l
else
    exec "${SCRIPT}" "${WFLAG}" -F -q "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") $SHELL -l
fi
