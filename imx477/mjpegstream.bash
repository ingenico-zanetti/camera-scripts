#!/bin/bash
# imx477: 1.55µm pixels, 4056x3040 native resolution 
# 3840x2160 ROI with offsets to balance optical misalignement
# # centered
# roi=" --roi 0.0266,0.1447,0.9468,0.7106 "
# # corrected
# roi=" --roi 0.0450,0.2125,0.9468,0.7106 "
. ~/bin/roi.bash

if [ "${UHD}" == "1" ]
then
	echo "4K UHD"
	mode=" --mode 4056:3040:12 "
	width=" --width 3840 "
	height=" --height 2160 "
	fps=" --framerate 10 "
	shutter=" --exposure normal --metering spot --nopreview "
	gain=" --gain 1 "
	# shutter=" --shutter 96000 "
	# gain=" --gain 1 "
elif ([ ${UHD} == "0" ]
	echo "FHD 1080p"
	mode=" --mode 2028:1520:12 "
	width=" --width 1920 "
	height=" --height 1080 "
	fps=" --framerate 30 "
	# shutter=" --shutter 32000 "
	# gain=" --gain 3 "
	shutter=" --exposure sport --metering spot"
	gain=" --gain 4 "
else
	libcamera-vid --nopreview --rotation 180 --gain 4 --shutter 4000 --mode 1332:990:10 --width 1280 --height 720 --codec mjpeg --framerate 240 --roi 0.0188,0.1364,0.9624,0.7273  --awbgains 1.5,1.6 --quality 95  -o - -t 60000 | mjpegsplitter
	exit
fi

while sleep 1
do
	libcamera-vid --verbose \
		--info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
		${mode} \
		${roi} \
		--bitrate 18000000 \
		${gain} \
		${shutter} \
		${fps} \
		-t 0 \
		${width} \
		${height} \
		--codec mjpeg \
		--quality 95 \
		--rotation 180 \
		--listen -o tcp://0.0.0.0:56789/ 2>&1 | tee $(date +%Y%m%d-%H%M%S.txt)
done

