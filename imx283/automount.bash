#!/bin/bash
# Look for /dev/sda1, if it is accessible, mount it (to /media/sda1)
# This requires the user to be in group disk
# and /media/sda1 to be accessible RW to the user
# (/etc/fstab must have this entry with the user and noauto option)

while true
do
	device=/dev/sda1
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

