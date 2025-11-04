#!/bin/bash
# This script is source'd before launching any actual camera script/binary
# It is not meant to be edited directly ; instead, GUI should edit parameters.new
# and when camera scripts start, they should copy parameters.new to parameters.bash before sourcing it.
# It feature every configurable parameters, even those not used for invoking
# the camera binary, depending upon the exact configuration

# COMPRESSION scheme
# Possible values:
# h264 for h264 IPB compression using libavcodec
# mjpeg for MJPEG all-I compression
COMPRESSION=h264

# QUALITY for MJPEG compression
# up-to 100, but below 75 artifacts become visible
# 85 is a good tradeoff between quality and throughput
QUALITY=85

# BITRATE
# Binary bitrate for h264 compression
# Very good quality for 1080p30fps is achieved at 48Mbps, so 48000000
BITRATE=48000000

# Resolution is a consequence of the UHD parameter
# UHD=0 means 1080p from 4K sensor data
# UHD=1 means 4K from 4K sensor
# empty UHD (or not defined) means faster framerate, by binning/subsampling/skipping
# Result depends upon actual sensors and camera script implementation
# imx477 will use its 720p240fps
# imx585 will use 2x2 binning outputting 1080p60fps
UHD=0

# SHUTTER
# Define shutter speed ; if not defined or empty, automatic setting through AuotExposition algorithm inside libcamera
# The value is in microseconds, to 4000 would be 4ms (aka 1/250)
SHUTTER=16000

# GAIN
# Sensor analog gain. The value is linear, so 1 is no gain
# Maximum gain varies from sensor to sensor, but up-to 16 is available on all sensors (IMX283, IMX477, IMX585)
GAIN=4


