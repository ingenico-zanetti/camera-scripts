#!/bin/bash

device=/dev/sda1

while sleep 1
do
	# filename=/media/sda1/$(date +%Y%m%d-%H%M%S.mp4)
	filename=/media/sda1/$(date +%Y%m%d-%H%M%S.mp4)
	mounted=$(mount|grep ${device})
	if [ "" == "${mounted}" ]
	then
		echo ${device} not mounted yet
	else
		# nc -w 2 localhost 56789 | ffmpeg -y -f h264 -r 30 -i - -an -codec copy ${filename}
		nc -w 2 localhost 56789 | dd of=${filename} status=progress
		size=$(du -hs ${filename}| cut -f 1)
		if [ "${size}" == "0" ]
		then
			echo "${filename} is empty, removing"
			rm -vf ${filename}
		fi
	fi
	sleep 1
done

