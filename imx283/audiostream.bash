#!/bin/bash

device=/dev/sda1

while sleep 1
do
	arecord -f dat -t raw -D hw:CARD=H2n,DEV=0 - | ./datstreamer 56787:24000
	if [ -f /tmp/shutdown ]
	then
		break;
	fi
	sleep 1
done

