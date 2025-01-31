#!/bin/bash
. ~/bin/roi.bash
if true
then
while sleep 1 ; do
	libcamera-vid --exposure sport --metering average --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" --mode 2784:1828:12 ${roi}  --bitrate 48000000 --gain 1 --framerate 30 -t 0 --width 1920 --height 1080 --codec h264 -o - --libav-format h264 2>>2K.err  | ./h264streamer | tee $(date +h264streamer_%Y%m%d-%H%M%S.log)  
done
else
	while sleep 1 
	do
		libcamera-vid --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" \
			--mode 5568:3664:12 --roi 0.1552,0.2046,0.6896,0.5908 \
			--bitrate 48000000 --gain 1 --framerate 15 -t 0 --width 3840 --height 2160 \
			--codec h264 --quality 85 --metering spot \
			--listen -o tcp://0.0.0.0:56789/ 2>&1 | tee $(date +%Y%m%d-%H%M%S.txt) 
	done
fi

