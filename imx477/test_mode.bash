#!/bin/bash
libcamera-still --raw --rotation 180 --encoding png --mode 4056:3040:12 --width 4056 --height 3040 -o mode_4056x3040x12.png
libcamera-still --raw --rotation 180 --encoding png --mode 4056:3040:12 --width 2028 --height 1520 -o mode_4056x3040x12_2028x1520.png
libcamera-still --raw --rotation 180 --encoding png --mode 2028:1520:12 --width 2028 --height 1520 -o mode_2028x1520x12_2028x1520.png
libcamera-still --raw --rotation 180 --encoding png --mode 2028:1080:12 --width 2028 --height 1080 -o mode_2028x1080x12_2028x1080.png

