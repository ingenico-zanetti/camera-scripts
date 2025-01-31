#!/bin/bash
. ./roi.bash
gain=" --gain 4 "
shutter=" --shutter 32000 "

if [ "${UHD}" != "" ]
then
	echo "4K UHD"
	mode=" --mode 4056:3040:12 "
	width=" --width 3840 "
	height=" --height 2160 "
	fps=" --framerate 10 "
else
	echo "FHD 1080p"
	mode=" --mode 2028:1080:12 "
	roi=" --roi 0.045,0,0.9468,1 "
	width=" --width 1920 "
	height=" --height 1080 "
	fps=" --framerate 30 "
fi

while sleep 1
do
	libcamera-vid --verbose \
		--info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
		${mode} \
		${roi} \
		--bitrate 48000000 \
		${gain} \
		${shutter} \
		${fps} \
		-t 0 \
		${width} \
		${height} \
		--codec h264 \
		--quality 95 \
		--rotation 180 \
		--listen -o tcp://0.0.0.0:56789/ 2>&1 | tee $(date +%Y%m%d-%H%M%S.txt)
done

