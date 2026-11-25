#!/bin/bash
#

device=/dev/nvme0n1p1

while sleep 1
do
	# Check pour CFB 
	mounted=$(mount|grep ${device})
	if [ "" != "${mounted}" ]
	then

		filename=/media/CFB/$(date +%Y%m%d-%H%M%S.mp4)
		ffmpeg -y -f h264 -r 30 -i tcp://localhost:56789 -an -codec copy ${filename} 2>&1 | tee -a h264record.log
		size=$(du -hs ${filename}| cut -f 1)
		if [ "${size}" == "0" ]
		then
			echo "${filename} is empty, removing"
			rm -vf ${filename}
		fi
	fi
done

