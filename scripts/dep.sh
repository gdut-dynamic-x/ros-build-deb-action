#!/bin/bash
ros_distro=$1

echo "Install packaging tool..."
sudo apt update && sudo apt-get install -y \
    python3-bloom \
    fakeroot \
    dh-make \
    devscripts \
    python3-catkin-pkg \
    python3-rosdep \
    > /dev/null
pip install shyaml > /dev/null