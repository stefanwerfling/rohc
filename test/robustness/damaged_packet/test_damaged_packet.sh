#!/bin/sh
#
# file:        test_damaged_packet.sh
# description: Check that the ROHC library correctly handle damaged packets
# author:      Didier Barvaux <didier@barvaux.org>
#
# This script may be used by creating a link "test_damaged_packet_NUM_CAPTURE.sh"
# where:
#    NUM      is the packet # to damage
#    CAPTURE  is the source capture to use for the test, it must begins with
#             the name of the packet to damage (ie. ir, irdyn, uo0, uo1 or uor2)
#
# Script arguments:
#    test_damaged_packet_NUM_CAPTURE.sh [verbose [verbose]]
# where:
#   verbose          prints the traces of test application
#   verbose verbose  prints the traces of test application and the ones of the
#                    library
#

# parse arguments
SCRIPT="$0"
VERBOSE="$1"
VERY_VERBOSE="$2"
if [ "x$MAKELEVEL" != "x" ] ; then
	BASEDIR="${srcdir}"
	APP="./test_damaged_packet"
else
	BASEDIR=$( dirname "${SCRIPT}" )
	APP="${BASEDIR}/test_damaged_packet"
fi

# extract the packet to damage and source capture from the name of the script
PACKET_TO_DAMAGE=$( echo "${SCRIPT}" | \
                    sed -e 's#^.*/test_damaged_packet_\([0-9]\+\)_.\+\.sh#\1#' )
CAPTURE_NAME=$( echo "${SCRIPT}" | \
                sed -e 's#^.*/test_damaged_packet_[0-9]\+_\(.\+\)\.sh#\1#' )
EXPECTED_PACKET=$( echo "${SCRIPT}" | \
                   sed -e 's#^.*/test_damaged_packet_[0-9]\+_\([^_.]\+\)\(_.\+\)\?\.sh#\1#' )
CAPTURE_SOURCE="${BASEDIR}/inputs/${CAPTURE_NAME}.pcap"

# check that capture exists
if [ ! -r "${CAPTURE_SOURCE}" ] ; then
	echo "source capture not found or not readable, please do not run ${APP}.sh directly!"
	exit 1
fi

# check that the expected packet and packet to damage are not empty
if [ -z "${PACKET_TO_DAMAGE}" ] || [ -z "${EXPECTED_PACKET}" ] ; then
	echo "failed to parse packet infos, please do not run ${APP}.sh directly!"
	exit 1
fi

CMD="${APP} ${CAPTURE_SOURCE} ${PACKET_TO_DAMAGE} ${EXPECTED_PACKET}"

# run in verbose mode or quiet mode
if [ "${VERBOSE}" = "verbose" ] ; then
	if [ "${VERY_VERBOSE}" = "verbose" ] ; then
		${CMD} || exit $?
	else
		${CMD} > /dev/null || exit $?
	fi
else
	${CMD} > /dev/null 2>&1 || exit $?
fi

