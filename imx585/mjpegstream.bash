#!/bin/bash
PATH="/usr/local/bin:$PATH"

if [ "1" = "$UHD" ]
then
	echo "Actual 4K"
	configuration="UHD=1.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=1.log)"

elif [ "HDR1" = "$UHD" ]
then
	echo "Actual 4K HDR"
	configuration="UHD=1.MJPEG.HDR.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=1.log)"

elif [ "0" = "$UHD" ]
then
	echo "1080p from 4K sensor"
	configuration="UHD=0.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=0.log)"

elif [ "HDR0" = "$UHD" ]
then
	echo "1080p from 4K HDR sensor"
	configuration="UHD=0.MJPEG.HDR.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=0.log)"

else
	echo "Binning 2x2"
	configuration="UHD=no.MJPEG.CFG"
	log="$(date +%Y%m%d-%H%M%S.UHD=no.log)"
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
