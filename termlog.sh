#!/bin/bash
SCRIPTLOGDIR="${HOME}/.terminal-logs"

export PATH="/opt/homebrew/bin:$PATH"

if [ ! -d "${SCRIPTLOGDIR}" ] ; then
    mkdir -p "${SCRIPTLOGDIR}"
fi
export PTZ='[%D{%Y/%m/%d %H:%M}] '
export PTB='[\D{%Y/%m/%d %H:%M}] '

if type gawk &>/dev/null ; then
    if type ansifilter &>/dev/null ; then
        exec script -F -q >( ansifilter | exec gawk '{print strftime("[%Y-%m-%d %H:%M:%S] ") $0;fflush()}' > "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") ) \
                          $SHELL -l
    else
        exec script -F -q >( sed -uE "s/\x1B\[[0-9;?]*[a-zA-Z]//g" | col -bx | \
                             gawk '{print strftime("[ %Y-%m-%d %H:%M:%S ] ") $0;fflush()}' > "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") ) \
                          $SHELL -l
    fi
else
    exec script -F -q "${SCRIPTLOGDIR}"/$(date "+%Y-%m-%d_%H-%M-%S") $SHELL -l
fi
