#!/bin/bash

device=/dev/nvme0n1p1

while sleep 1
do
	filename=/media/CFB/$(date +%Y%m%d-%H%M%S_device.wav)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		# Select "Device" mic stream, with 0 delay
		nc -w 2 localhost 41200 > ${filename}
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

