#!/bin/bash
ros_distro=$1
ignore_packages=$2
ros_workspace='/tmp/catkin_build'

source /opt/ros/$ros_distro/setup.bash

mkdir -p $ros_workspace/src/
cp -r ./ $ros_workspace/src/
echo 'Installing dependence..'
rosdep update > /dev/null
rosdep install --from-paths $ros_workspace/src --ignore-packages-from-source --rosdistro $ros_distro -y > /dev/null
catkin_make_isolated -C $ros_workspace --use-ninja --build $ros_workspace --install --merge --cmake-args -DCMAKE_BUILD_TYPE=Release
rosdep update > /dev/null
echo "::set-output name=catkin-ws-directory::$(echo $ros_workspace)"
