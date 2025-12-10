#!/bin/bash

device=/dev/sda1

while sleep 1
do
	filename=/media/sda1/$(date +%Y%m%d-%H%M%S_mini.wav)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		# Select "MINI" mic stream, with 0 delay
		nc -w 2 localhost 41000 > ${filename}
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

