#!/bin/bash
set -o nounset
set -o errexit

_DETECT_RESULT="OK"
# Detect network using netcat, i.e. : nc -w 10 -zv docker-host 58080
delectWithNetcat(){
	local CMD="nc -w 10 -zv $1 $2"
	set +o errexit
	${CMD}
	local EXITCODE=$?
	if [ $EXITCODE -eq 0 ]; then
		_DETECT_RESULT=0
	else
		echo ">>> Network detection error: [${CMD}]=$EXITCODE"
		_DETECT_RESULT=$EXITCODE
	fi
	set -o errexit
}
# Detect network using wget, i.e. : wget -t 3 -T 10 -q -O - http://docker-host:58080
detectWithWget(){
	local HTTP_ADDR=$1
	
	shift 1
	local MORE_ARGS=$*

	local CMD="wget ${MORE_ARGS} -t 3 -T 10 -q -O - ${HTTP_ADDR}"
	set +o errexit
	echo "*** [ ${CMD} ] ***"
	${CMD}
	local EXITCODE=$?
	# exit codes for wget:
	#	0       No problems occurred
	#	1       Generic error code
	#	2       Parse error — for instance, when parsing command-line options, the .wgetrc or .netrc…
	#	3       File I/O error
	#	4       Network failure
	#	5       SSL verification failure
	#	6       Username/password authentication failure
	#	7       Protocol errors
	#	8       Server issued an error response
	if [ $EXITCODE -eq 0 ]; then
		_DETECT_RESULT=0
	elif [ $EXITCODE -eq 8 ]; then
		#404 500 etc...
		_DETECT_RESULT=0
	else
		echo ">>> Network detection error: [${CMD}]=$EXITCODE"
		_DETECT_RESULT=$EXITCODE
	fi
	set -o errexit
}

_sleep(){
	echo "> [$1] after $2 seconds ..."
	sleep $2
}

doSSHConnect() {
	rm -f ~u01/.ssh/known_hosts
	
	set +o errexit
	pkill ssh
	pkill sshpass
	set -o errexit
	
	sshpass -v -p "${U01_SSH_PWD}" ${SSH_CMD}
}

networkDetect() {
	${NET_DETECT_CMD}
	if [ ${_DETECT_RESULT} -ne 0 ]; then
		echo -e "********\n>>> ${NET_DETECT_CMD} : connection broken, try reconnecting ...\n********"
		doSSHConnect &
		_sleep "Confirm network connection" ${NET_CONFIRM_SEC}
	else
		echo -e "\n> ${NET_DETECT_CMD} : connection keep ready.\n"
		_sleep "Detect network connection" ${NET_DETECT_SEC}
	fi
	networkDetect
}

SSH_CMD="ssh -4 -C -v ${U01_SSH_ARGS}"
echo ">>> Starting SSH Tunnel: ${SSH_CMD} ..."

doSSHConnect &

_sleep "Confirm first network connection" ${NET_CONFIRM_SEC}
networkDetect
