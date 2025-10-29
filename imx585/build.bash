#!/bin/bash

SOURCE=$(pwd)
echo "Script run from ${SOURCE}"

TEMP=$(mktemp -d)
echo "Build folder: ${TEMP}"
cd ${TEMP}

sudo apt remove --purge rpicam-apps
sudo apt remove --purge libcamera-dev libepoxy-dev

sudo apt install -y linux-headers dkms git

sudo apt install -y libjpeg-dev libtiff5-dev libpng-dev libopencv-dev
sudo apt install -y libavcodec-dev libavdevice-dev libavformat-dev libswresample-dev

sudo apt install -y python3-pip python3-jinja2
sudo apt install -y libboost-dev
sudo apt install -y libgnutls28-dev openssl libtiff5-dev pybind11-dev
sudo apt install -y meson cmake ninja-build
sudo apt install -y python3-yaml python3-ply

sudo apt install -y cmake libboost-program-options-dev libdrm-dev libexif-dev
sudo apt install -y

# IMX585 kernel module
#
git clone https://github.com/will127534/imx585-v4l2-driver.git
cd imx585-v4l2-driver/
sudo ./setup.sh
cd ..

# overclock RP1 from 200MHz to 333MHz
#
mkdir overclock
cd overclock
cp "${SOURCE}/rp1-300mhz.dtso" .
cp "${SOURCE}/install-rp1-overclock.sh" .
sudo bash ./install-rp1-overclock.sh
cat /sys/kernel/debug/clk/clk_summary
cd ..

# libcamera
#
git clone https://github.com/will127534/libcamera.git
cd libcamera
# Apply patch to get .minPixelProcessingTime = 1.0us / 580 instead of 1.0us / 380
git apply "${SOURCE}/libcamera.patch"
meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=enabled -Dgstreamer=disabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=disabled
ninja -C build install -j 1
sudo ninja -C build install
cd ..

# rpicam-apps
#
git clone https://github.com/will127534/rpicam-apps.git
cd rpicam-apps/
meson setup build -Denable_libav=enabled -Denable_drm=enabled -Denable_egl=disabled -Denable_qt=disabled -Denable_opencv=disabled -Denable_tflite=disabled -Denable_hailo=disabled
meson compile -C build -j 1
sudo meson install -C build
cd ..

rpicam-hello --version
rpicam-hello --list-cameras

