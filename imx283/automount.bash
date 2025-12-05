#!/bin/bash
# Look for /dev/sda, if it is accessible, mount it (to /media/sda)
# This requires the user to be in group disk
# and /media/sda to be accessible RW to the user
# (/etc/fstab must have this entry with the user and noauto option)

while true
do
	device=/dev/sda
	if [ -w ${device} ]
	then
		echo Write access to ${device} : OK
		mounted=$(mount|grep ${device})
		if [ "" == "${mounted}" ]
		then
			echo ${device} not mounted yet
			mount ${device}
		fi
	fi
	sleep 1
done

