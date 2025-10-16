#!/bin/bash

if [ "" = "$Q" ]
then
	quality=" --quality 75 "
else
	quality=" --quality ${Q} "
fi

if [ "" = "$UHD" ]
then
	while sleep 1 
	do
		echo 1080pbin2x2
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 1928:1090:12  \
			--gain 1 --framerate 60 -t 0 --width 1920 --height 1080 \
			--codec mjpeg ${quality} --metering average --exposure sport \
		       	-o - --libav-format mjpeg  2>>2x2.err | ./mjpegstreamer
	done
elif [ 1 -eq "$UHD" ]
then
	while sleep 1 
	do
		echo 2160p
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 3856:2180:12  \
			--gain 1 --framerate 30 -t 0 --width 3840 --height 2160 \
			--codec mjpeg ${quality} --metering average --exposure sport \
			-o - --libav-format mjpeg 2>>4K.err | ./mjpegstreamer
	done
else
	while sleep 1 
	do
		echo 1080p
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 3856:2180:12 \
			--gain 1 --framerate 30 -t 0 --width 1920 --height 1080 \
			--codec mjpeg ${quality} --metering average --exposure sport \
		       	-o - --libav-format mjpeg 2>>2K.err | ./mjpegstreamer 56789
	done
fi

