#!/bin/bash

if [ "" = "$UHD" ]
then
	mode=" --mode 1928:1090:12 "
	resolution=" --width 1920 --height 1080 "
	DEFAULT_FRAME_RATE=60
	log="UHD=no.log"
elif [ 1 -eq "$UHD" ]
then
	mode=" --mode 3856:2180:12 "
	resolution=" --width 3840 --height 2160 "
	DEFAULT_FRAME_RATE=15
	log="UHD=1.log"
else
	mode=" --mode 3856:2180:12 "
	resolution=" --width 1920 --height 1080 "
	DEFAULT_FRAME_RATE=30
	log="UHD=0.log"
fi
if [ "$D" = "" ]
then
	duration=" -t 0 "
else
	duration=" -t ${D}000 "
fi

if [ "" = "$G" ]
then
	gain=" --gain 1 "
else
	gain=" --gain ${G} "
fi

if [ "" = "$F" ]
then
	fps=" --framerate ${DEFAULT_FRAME_RATE} "
else
	fps=" --framerate ${F} "
fi

if [ "" = "$S" ]
then
	shutter=" --shutter 16000 "
else
	shutter=" --shutter ${S} "
fi

if [ "$B" = "" ]
then
	bitrate=" --bitrate 48000000 "
else
	bitrate=" --bitrate ${B} "
fi

echo "Using ${duration} ; ${gain} ; ${fps} ; ${shutter} ; ${mode} ; ${resolution} ; ${bitrate} and logging to ${log}"

while sleep 1
do
	# echo "libcamera-vid --verbose --info-text \"frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg\"  ${mode}  ${shutter}  ${gain}  ${fps}  ${duration}  ${resolution}  --metering average --exposure sport  ${bitrate} --codec h264 -o - --libav-format h264 2>>${log} | ./h264streamer"

	libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
		${mode} \
		${shutter} \
		${gain} \
		${fps} \
	       	${duration} \
		${resolution} \
		--metering average --exposure sport \
		${bitrate} --codec h264 -o - --libav-format h264 2>>${log} | ./h264streamer 
	if [ "$D" != "" ]
	then
		exit 0
	fi
done

