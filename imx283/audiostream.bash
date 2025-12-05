#!/bin/bash

while sleep 1
do
	# Find which microphone is available
	# Look for H2n, USB MINI Microphone and MOVO X1 MINI
	# camera@Pi5Cam1:~/src/datstreamer $ arecord -L | egrep "^hw"
	# hw:CARD=Device,DEV=0
	# hw:CARD=H2n,DEV=0
	# hw:CARD=MINI,DEV=0
	# Trick: we prefer MINI over H2n over Device, so sorting the ouput is a working solution
	# camera@Pi5Cam1:~/src/datstreamer $ arecord -L | egrep "^hw"| sort -r
	# hw:CARD=MINI,DEV=0
	# hw:CARD=H2n,DEV=0
	# hw:CARD=Device,DEV=0
	device=$(arecord -L | egrep "^hw"|sort -r|head -n 1)
	case ${device} in
		"hw:CARD=MINI,DEV=0")
			format=" -f S16_LE -c1 -r48000 "
			option=" -c1 "
		;;
		"hw:CARD=H2n,DEV=0")
			format=" -f dat "
			option=""
		;;
		"hw:CARD=Device,DEV=0")
			format=" -f S16_LE -c1 -r48000 "
			option=" -c1 "
		;;

	esac
	if [ "" != "$device" ]
	then
		echo "Using device ${device} with format ${format} and option ${option}"
		arecord ${format} -t raw -D ${device} - | ./datstreamer ${option} 56787:24000 
	else
		echo "No suitable USB microphone found"
	fi
	if [ -f /tmp/shutdown ]
	then
		break;
	fi
	sleep 1
done

