#!/bin/bash

device=/dev/sda

while sleep 1
do
	filename=/media/sda/$(date +%Y%m%d-%H%M%S.mp4)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		ffmpeg -y -f h264 -r 30 -i tcp://localhost:56789/ -an -codec copy ${filename}
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

