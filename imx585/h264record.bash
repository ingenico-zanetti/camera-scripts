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
	filename=/media/CFB/$(date +%Y%m%d-%H%M%S.h264)
	nc -w 2 localhost 56789 | dd of=${filename} status=progress
	size=$(du -hs ${filename}| cut -f 1)
	if [ "${size}" == "0" ]
	then
		echo "${filename} is empty, removing"
		rm -vf ${filename}
	fi
	sleep 1
done

