#!/bin/bash
gain=" --gain 1 "
# perfectly centered roi wouldbe roi=" --roi 0.1491,0.1491,0.7018,0.7018 "
# but the sensor is *not* exactly centered on the optical axis
mode=" --mode 5568:3094:10 "
roi=" --roi 0.1422,0.2500,0.7018,0.7018 "
# resolution=" --width 3840 --height 2160 "
# fps=" --framerate 3 "
resolution=" --width 1920 --height 1080 "
fps=" --framerate 30 "
bitrate=" --bitrate 18000000 "
while true ; do
	/usr/local/bin/libcamera-vid --exposure sport --metering centre --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" ${mode} ${roi} ${bitrate} ${gain} ${framerate}  -t 0 ${resolution} --codec h264 -o - --libav-format h264 2>>./h264.err | ./h264streamer | tee $(date +h264streamer_%Y%m%d-%H%M%S.log)  
	sleep 1
done

