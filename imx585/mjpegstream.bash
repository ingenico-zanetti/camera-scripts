#!/bin/bash
PATH="/usr/local/bin:$PATH"
if [ "" = "$UHD" ]
then
	echo "Binning 2x2"
	configuration="UHD=no.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=no.log)"
elif [ 1 -eq "$UHD" ]
then
	echo "Actual 4K"
	configuration="UHD=1.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=1.log)"
else
	echo "1080p from 4K sensor"
	configuration="UHD=0.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=0.log)"
fi


while sleep 1
do
	# Check pour CFB
	device=/dev/nvme0n1p1
	mounted=$(mount|grep ${device})
	if [ "" != "${mounted}" ]
	then
		filename="--file /media/CFB/$(date +%Y%m%d-%H%M%S)"
		libcamera-vid --config ${configuration} 2>>${log} | ./mjpegstreamer3 ${filename} --tcp 56789 --tcp 56782:2 --tcp 56786:6 --tcp 56780:60
	else
		libcamera-vid --config ${configuration} 2>>${log} | ./mjpegstreamer3 --tcp 56789 --tcp 56782:2 --tcp 56786:6 --tcp 56780:60
	fi
done
