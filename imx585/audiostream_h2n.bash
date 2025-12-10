#!/bin/bash

while sleep 1
do
	# Look for USB-Audio - H2n Microphone (JIAYZ MOVO X1 MINI)
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
	# hw:CARD=H2n,DEV=0
	card=$(grep "\[H2n" < /proc/asound/cards| cut -d '[' -f 1| tr -d ' ')
	if [ "" != "$card" ]
	then
		device="hw:CARD=H2n,DEV=0"
		format=" -f S16_LE -c2 -r48000 "
		option=""
		echo "Using device ${device} with format ${format} and option ${option}"
		arecord ${format} -t raw -D ${device} - | ./datstreamer ${option} 41175:36000 41100
	else
		echo "No USB-Audio - H2n Microphone found"
	fi
	if [ -f /tmp/shutdown ]
	then
		break;
	fi
	sleep 1
done

