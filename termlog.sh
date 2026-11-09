#!/bin/zsh
SCRIPTLOGDIR="${HOME}/.terminal-logs"

#eval `/opt/homebrew/bin/brew shellenv`
export PATH="/opt/homebrew/bin:$PATH"

if [ ! -d "${SCRIPTLOGDIR}" ] ; then
    mkdir -p "${SCRIPTLOGDIR}"
fi
export PTZ='[%D{%Y/%m/%d %H:%M}] '
export PTB='[\D{%Y/%m/%d %H:%M}] '

if type gawk &>/dev/null ; then
    exec script -F -q >( sed -E "s/\x1B\[[0-9;?]*[a-zA-Z]//g" | col -bx | \
                         gawk '{print "[ " strftime("%Y-%m-%d %H:%M:%S", systime()) " ] " $0}' > "${SCRIPTLOGDIR}"/`date "+%Y-%m-%d_%H%M%S"` )
else
    exec script "${SCRIPTLOGDIR}"/`date "+%Y-%m-%d_%H%M%S"`
fi
