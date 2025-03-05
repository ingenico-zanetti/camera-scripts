#!/bin/bash
if [ "$UHD" == "0" ]
then
	mode=" --mode 5568:3094:10 "
	# perfectly centered roi would be roi=" --roi 0.1491,0.1491,0.7018,0.7018 "
	# but the sensor is *not* exactly centered on the optical axis
	#
	# x=0.1382 => crop (main) (756, yyy) on est au plus proche de la perfection
	#
	# y=0.2560 => crop (main) (xxx,1072) on est au plus proche de la perfection
	#
	roi=" --roi 0.1382,0.2560,0.7018,0.7018 "
	resolution=" --width 1920 --height 1080 "
	gain=" --gain 4 "
	logfile="UHD=0.log"
	fps=" --framerate 30 "
elif [ "$UHD" == "1" ]
then
	mode=" --mode 5568:3094:10 "
	roi=" --roi 0.1382,0.2560,0.7018,0.7018 "
	resolution=" --width 3840 --height 2160 "
	gain=" --gain 4 "
	logfile="UHD=1.log"
	fps=" --framerate 3 "
else
	mode=" --mode 2784:1828:12 "
	# perfectly centered roi would be roi=" --roi 0.1491,0.1491,0.7018,0.7018 "
	# but the sensor is *not* exactly centered on the optical axis
	#
	# y=0.2166 => crop (main) (xxx, 790) on est au plus proche de la perfection
	#
	# x=0.1382 => crop (main) (756, yyy) on est au plus proche de la perfection
	#
	roi=" --roi 0.1382,0.2166,0.7018,0.5923 "
	resolution=" --width 1920 --height 1080 "
	gain=" --gain 4 "
	logfile="2K.log"
	fps=" --framerate 30 "
fi
shutter=" --shutter 16000 "
bitrate=" --bitrate 18000000 "

#/ while true ; do
	/usr/local/bin/libcamera-vid ${shutter} --verbose --info-text "frame %frame (%fps fps) exp %exp ag %ag dg %dg rg %rg bg %bg" ${mode} ${roi} ${bitrate} ${gain} ${fps}  -t 0 ${resolution} --codec h264 -o - --libav-format h264 2>>${logfile} | ./h264streamer 
	sleep 1
#/ done

