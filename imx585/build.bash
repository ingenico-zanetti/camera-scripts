#!/bin/bash

SOURCE=$(pwd)
echo "Script run from ${SOURCE}"

TEMP=$(mktemp -d)
echo "Build folder: ${TEMP}"
cd ${TEMP}

sudo apt-get remove --purge -y rpicam-apps-lite rpicam-apps libcamera
sudo apt-get remove --purge -y libcamera-dev libepoxy-dev libopencv-dev
sudo apt-get autoremove
sudo apt-get install -y linux-headers-$(uname -r) dkms libjpeg-dev libtiff5-dev libpng-dev libavcodec-dev libavdevice-dev libavformat-dev libswresample-dev python3-pip python3-jinja2 libboost-dev libgnutls28-dev openssl libtiff5-dev pybind11-dev meson cmake ninja-build python3-yaml python3-ply cmake libboost-program-options-dev libdrm-dev libexif-dev

# IMX585 kernel module
#
git clone https://github.com/Kurokesu/imx585-rpi-driver.git
cd imx585-rpi-driver/
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
git clone https://github.com/Kurokesu/libcamera.git
cd libcamera
# Apply patch to get .minPixelProcessingTime = 1.0us / 580 instead of 1.0us / 380
git apply "${SOURCE}/libcamera.patch"
meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=enabled -Dgstreamer=disabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=disabled
ninja -C build -j 2
sudo ninja -C build install
cd ..

# rpicam-apps
#
git clone https://github.com/Kurokesu/rpicam-apps.git
cd rpicam-apps/
meson setup build -Denable_libav=enabled -Denable_drm=enabled -Denable_egl=disabled -Denable_wayland=disabled -Denable_qt=disabled -Denable_opencv=disabled -Denable_tflite=disabled -Denable_hailo=disabled
meson compile -C build -j 2
sudo meson install -C build
cd ..

sudo ldconfig
rpicam-hello --version
rpicam-hello --list-cameras

