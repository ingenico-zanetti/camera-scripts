#!/bin/bash
PATH="/usr/local/bin:$PATH"
if [ "" = "$UHD" ]
then
	echo "Binning 2x2"
	configuration="UHD=no.cfg"
	log="$(date +%Y%m%d-%H%M%S.UHD=no.log)"
elif [ 1 -eq "$UHD" ]
then
	echo "Actual 4K"
	configuration="UHD=1.cfg"
	log="$(date +%Y%m%d-%H%M%S.UHD=1.log)"
else
	echo "1080p from 4K sensor"
	configuration="UHD=0.cfg"
	log="$(date +%Y%m%d-%H%M%S.UHD=0.log)"
fi

while sleep 1
do
	libcamera-vid --config ${configuration} 2>>${log} | ./h264streamer 
done

