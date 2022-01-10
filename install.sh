#!/bin/bash

# Tested with Raspbian Bullseye (2022-01-05 or later), but other versions may work.
#

# -- SCRIPT --

# Update apt
echo "Updating APT"
sudo apt update

# Install all dependencies
echo "Installing dependencies"
sudo apt install -y libboost-all-dev libusb-1.0-0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev

# Install raspbian dependencies
echo "Installing Raspbian dependencies"
sudo apt install -y libraspberrypi-doc libraspberrypi-dev

# Clone AASDK
echo "Cloning AASDK"
git clone https://github.com/mgrotaers/aasdk

# Build AASDK
echo "Building AASDK"
mkdir aasdk_build
cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j2

# Install ilclient dependencies
echo "Setup ilclient"
sudo apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
git clone https://github.com/raspberrypi/userland
../userland/buildme

# Build ilclient
echo "Building ilclient"
cd /opt/vc/src/hello_pi/libs/ilclient
make -j2 

cd

# Clone OpenAuto
echo "Cloning OpenAuto"
git clone -b development https://github.com/f1xpl/openauto.git

# Build OpenAuto
echo "Building OpenAuto"
mkdir openauto_build
cd openauto_build
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" ~/openauto
make -j2

# Finish up & start
echo "Done!"
echo "To start OpenAuto in the future, run \e[1msudo ~/openauto/bin/autoapp"
echo "If nothing happens when you plug in your phone, please try restarting your pi."

echo "Enable OpenAuto autostart"
# echo "sudo /home/pi/openauto/bin/autoapp" >> /home/pi/.config/lxsession/LXDE-pi/autostart

echo "Starting OpenAuto..."
sudo /home/pi/openauto/bin/autoapp
