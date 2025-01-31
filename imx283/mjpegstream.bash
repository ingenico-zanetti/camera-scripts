#!/bin/bash
. ./roi.bash
if [ "" = "$UHD" ]
then
	while sleep 1 
	do
		echo 1080p
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--exposure sport --metering average --mode 5568:3664:12 ${roi} \
			--gain 4 --framerate 30 -t 0 --width 1920 --height 1080 --codec mjpeg --quality 95 \
		       	-o - --libav-format mjpeg | ./mjpegstreamer
	done
elif [ 1 -eq "$UHD" ]
then
	while sleep 1 
	do
		echo 2160p
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 5568:3664:12 ${roi} \
			--gain 1 --framerate 30 -t 0 --width 3840 --height 2160 \
			--codec mjpeg --quality 85 --metering average --exposure sport \
			-o - --libav-format mjpeg 2>>4K.err | ./mjpegstreamer  | tee $(date +%Y%m%d-%H%M%S.txt) 
	done
else
	while sleep 1 
	do
		echo 3648p
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 5568:3664:12 \
			--gain 1 --framerate 3 -t 0 --width 5472 --height 3648 \
			--codec mjpeg --quality 100 --metering spot \
		       	-o - --libav-format mjpeg | ./mjpegstreamer
	done
fi

