#!/bin/bash

if [ "$D" = "" ]
then
	duration=" -t 0 "
else
	duration=" -t ${D}000 "
fi
echo "Using ${duration}"

if [ "" = "$G" ]
then
	gain=" --gain 1 "
else
	gain=" --gain ${G} "
fi
echo "Using ${gain}"

if [ "" = "$F" ]
then
	fps=" --framerate 30 "
else
	fps=" --framerate ${F} "
fi
echo "Using ${fps}"

if [ "" = "$S" ]
then
	shutter=" --shutter 16000 "
else
	shutter=" --shutter ${S} "
fi
echo "Using ${shutter}"

if [ "" = "$Q" ]
then
	quality=" --quality 75 "
else
	quality=" --quality ${Q} "
fi
echo "Using ${quality}"

if [ "" = "$UHD" ]
then
	mode=" --mode 1928:1090:12 "
	resolution=" --width 1920 --height 1080 "
	log="UHD=no.log"
elif [ 1 -eq "$UHD" ]
then
	mode=" --mode 3856:2180:12 "
	resolution=" --width 3840 --height 2160 "
	log="UHD=1.log"
else
	mode=" --mode 3856:2180:12 "
	resolution=" --width 1920 --height 1080 "
	log="UHD=0.log"
fi

echo "Using ${duration} ; ${gain} ; ${fps} ; ${shutter} ; ${mode} ; ${resolution} ; ${quality} and logging to ${log}"

while sleep 1
do
	libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
		${mode} \
		${shutter} \
		${gain}  ${fps}  ${duration} ${resolution} \
		--codec mjpeg ${quality} --metering average --exposure sport \
		-o - --libav-format mjpeg  2>>${log} | ./mjpegstreamer 56789
	if [ "$D" != "" ]
	then
		exit 0
	fi
done
