#!/bin/bash

device=/dev/sda

while sleep 1
do
	filename=/media/sda/$(date +%Y%m%d-%H%M%S.wav)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		nc -w 2 localhost 56787 > ${filename}
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

