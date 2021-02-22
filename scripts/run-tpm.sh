#!/bin/bash
envconfig="/var/vm/scripts/env.sh"

if [ -f $envconfig ]; then
        source $envconfig
else
        echo "Could not find necessary environment setting."
        exit 1
fi

if [ $# -eq 0 ]
then
        echo "No argument supplied, please pass the tpm subfolder under /var/vm/
tpm"
        exit 1
fi

# check if tpm folder exists
tpmname=${1}
tpmdir=$TPM_BASEDIR/${1}
tpmsock=${tpmdir}/swtpm-sock
if [ ! -d "$tpmdir" ]; then
	echo "TPM folder $tpmname doesn't exists, please create it first"
	exit 1
fi
cmds="/usr/bin/swtpm socket -t --tpmstate dir=${tpmdir} --ctrl type=unixio,path=
${tpmsock} --tpm2 --pid file=/tmp/${tpmname}.pid"
echo $cmds
$cmds &
