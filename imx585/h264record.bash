#!/bin/bash
# Check pour CFB 
#
while sleep 1
do
		grep -q nvme0n1p1 /proc/partitions
		present=$?
		echo ${present}
		if [ ${present} == "0" ]
		then
			break;
		fi
done

mount /media/CFB

while sleep 1
do
	filename=/media/CFB/$(date +%Y%m%d-%H%M%S.mp4)
	ffmpeg -y -f h264 -r 30 -i tcp://localhost:56789 -an -codec copy ${filename} 2>&1 | tee -a h264record.log
	size=$(du -hs ${filename}| cut -f 1)
	if [ "${size}" == "0" ]
	then
		echo "${filename} is empty, removing"
		rm -vf ${filename}
	fi
	sleep 1
done

