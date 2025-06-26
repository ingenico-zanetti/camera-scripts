#!/bin/bash
if [ "$UHD" == "0" ]
then
	mode=" --mode 3856:2180:12 "
	roi=" --roi 0,0,1,1 "
	resolution=" --width 1920 --height 1080 "
	gain=" --gain 1 "
	logfile="UHD=0.log"
	fps=" --framerate 30 "
elif [ "$UHD" == "1" ]
then
	mode=" --mode 3856:2180:12 "
	roi=" --roi 0,0,1,1 "
	resolution=" --width 3840 --height 2160 "
	gain=" --gain 1 "
	logfile="UHD=1.log"
	fps=" --framerate 3 "
else
	mode=" --mode 1928:1090:12 "
	roi=" --roi 0,0,1,1 "
	resolution=" --width 1920 --height 1080 "
	gain=" --gain 1 "
	logfile="2K.log"
	fps=" --framerate 30 "
fi
# shutter=" --shutter 4000 "
# wb="  --awbgains 1.56,2.15 "
bitrate=" --bitrate 18000000 "
# preview=" --nopreview "
while true ; do
	/usr/local/bin/libcamera-vid ${preview} ${shutter} ${wb} --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" ${mode} ${roi} ${bitrate} ${gain} ${fps}  -t 0 ${resolution} --codec h264 -o - --libav-format h264 2>>${logfile} | ./h264streamer 
	sleep 1
done

