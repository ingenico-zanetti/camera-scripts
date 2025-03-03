#!/bin/bash
gain=" --gain 4 "

if [ "${UHD}" == "1" ]
then
	echo "4K UHD"
	mode=" --mode 4056:3040:12 "
	width=" --width 3840 "
	height=" --height 2160 "
	roi=" --roi 0.045,0,0.9468,1 "
	fps=" --framerate 10 "
while sleep 1
do
	/usr/local/bin/libcamera-vid --verbose \
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
		--rotation 180 \
		--libav-format h264 -o -  2>>./h264.log | ./h264streamer
done
elif [ "${UHD}" == "0" ]
then
	# thanks to a kernel patch by 6by9 we have 4056:2160 12bpp at 32.39fps
	echo "4K -> 1080p"
	mode=" --mode 4056:2160:12 "
	width=" --width 1920 "
	height=" --height 1080 "
	fps=" --framerate 30 "
	roi=" --roi=0.0450,0.1447,0.9468,1 "
while sleep 1
do
	/usr/local/bin/libcamera-vid --verbose \
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
		--codec h264 \
		--rotation 180 \
		--libav-format h264 -o -  2>>./h264.log | ./h264streamer
done
else
	echo "FHD 1080p"
	mode=" --mode 2028:1080:12 "
	roi=" --roi 0.045,0,0.9468,1 "
	width=" --width 1920 "
	height=" --height 1080 "
	fps=" --framerate 30 "
while sleep 1
do
	/usr/local/bin/libcamera-vid --verbose \
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
		--codec h264 \
		--rotation 180 \
		--libav-format h264 -o -  2>>./h264.log | ./h264streamer
done
fi


