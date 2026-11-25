#!/bin/bash
SCRIPTLOGDIR="${HOME}/Documents/terminal_logs"
TTL="${HOME}/Applications/libexec/ttl"
BSDSCRIPT="${HOME}/Applications/bin/script"

export PATH="/opt/homebrew/bin:$PATH"

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

elif type gawk &>/dev/null ; then

    if type ansifilter &>/dev/null ; then
        exec "${SCRIPT}" "${WFLAG}" -F -q >( ansifilter --ignore-csi | exec gawk '{print strftime("[%Y-%m-%d %H:%M:%S] ") $0;fflush()}' > "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") ) \
                          $SHELL -l
    else
        exec "${SCRIPT}" "${WFLAG}" -F -q >( sed -uE "s/\x1B\[[0-9;?]*[a-zA-Z]//g" | col -bx | \
                             gawk '{print strftime("[ %Y-%m-%d %H:%M:%S ] ") $0;fflush()}' > "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") ) \
                          $SHELL -l
    fi
else
    exec "${SCRIPT}" "${WFLAG}" -F -q "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") $SHELL -l
fi
