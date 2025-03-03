#!/bin/bash
libcamera-still --raw --rotation 180 --encoding png --mode 4056:2160:12 --width 4056 --height 2160 -o mode_4056x2160x12.png
libcamera-still --raw --rotation 180 --encoding png --mode 4056:2160:12 --width 2028 --height 1080 -o mode_4056x2160x12_2028x1080.png
libcamera-still --raw --rotation 180 --encoding png --mode 2028:1080:12 --width 2028 --height 1080 -o mode_2028x1080x12_2028x1080.png

