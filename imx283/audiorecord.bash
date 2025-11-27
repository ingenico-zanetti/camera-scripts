#!/bin/bash

device=/dev/sda1

while sleep 1
do
	filename=/media/sda1/$(date +%Y%m%d-%H%M%S.wav)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		arecord -f dat -t raw -D hw:CARD=H2n,DEV=0 - | ./datstreamer stdout 56787:24000 > ${filename}
		size=$(du -hs ${filename}| cut -f 1)
		if [ "${size}" == "0" ]
		then
			echo "${filename} is empty, removing"
			rm -vf ${filename}
		fi
	fi
	if [ -f /tmp/shutdown ]
	then
		break;
	fi
	sleep 1
done

