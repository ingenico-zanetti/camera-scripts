#!/bin/bash

while sleep 1
do
	# Look for USB-Audio - MOVO X1 MINI Microphone (JIAYZ MOVO X1 MINI)
	# camera@Pi5Cam1:~ $ cat /proc/asound/cards
	# 0 [Device         ]: USB-Audio - USB PnP Sound Device
	#                      C-Media Electronics Inc. USB PnP Sound Device at usb-xhci-hcd.1-1, full speed
	# 1 [MINI           ]: USB-Audio - MOVO X1 MINI
	#                      JIAYZ MOVO X1 MINI at usb-xhci-hcd.1-2, full speed
	# 2 [vc4hdmi0       ]: vc4-hdmi - vc4-hdmi-0
	#                      vc4-hdmi-0
	# 3 [vc4hdmi1       ]: vc4-hdmi - vc4-hdmi-1
	#                      vc4-hdmi-1
	# 4 [H2n            ]: USB-Audio - H2n
	#                      ZOOM Corporation H2n at usb-xhci-hcd.0-2, full speed
	# hw:CARD=MINI,DEV=0
	mic=$(grep "\[MINI" < /proc/asound/cards| cut -d '[' -f 1| tr -d ' ')
	card=$(grep "\[vc4hdmi0" < /proc/asound/cards| cut -d '[' -f 1| tr -d ' ')
	if [ "" != "$mic" ]
	then
		device="hw:CARD=MINI,DEV=0"
		format=" -f S16_LE -c1 -r48000 "
		option=" -c1 "
		echo "Using device ${device} with format ${format} and option ${option}"
		echo "Output to plughw:${card},0"
		amixer -c${mic} sset Mic,0 8 unmute cap
		arecord ${format} -t raw -D ${device} - | ./datstreamer ${option} 41075:36000 41000 stdout | aplay -D plughw:${card},0 -
	else
		echo "No USB-Audio - MOVO X1 MINI Microphone found"
	fi
	if [ -f /tmp/shutdown ]
	then
		break;
	fi
	sleep 1
done

