#!/bin/bash
ros_distro=$1
ros_workspace=$2
tmp_space="/tmp/catkin_binary_deb"

source /opt/ros/$ros_distro/setup.bash
source $ros_workspace/devel/setup.bash

run_directory=`pwd`

time_stamp=`date +%Y%m%d.%H%M%S`

mkdir $tmp_space
cp -r ./ $tmp_space
package_list=`find $tmp_space -maxdepth 2 -name package.xml | sed 's/package.xml//g'`
CM_PREFIX_PATH=`sed 's/:/;/g' <<< $CMAKE_PREFIX_PATH`

for package_source in $package_list
do
  echo "Trying to package $package_source..."
  cd $package_source
  bloom-generate rosdebian --os-name ubuntu --ros-distro $ros_distro
  if [ ${{ inputs.timestamp }} ]
  then
    debchange -a $time_stamp -p -D -u -m 'Append timestamp when binarydeb was built.'
  fi
  sed -e "s|-DCMAKE_PREFIX_PATH=.*|-DCMAKE_PREFIX_PATH=\""$CM_PREFIX_PATH"\"|g" -i debian/rules
  fakeroot debian/rules binary
  cd $run_directory
done
echo 'Package has been done.'
find $tmp_space -name '*.deb' -o -name '*.ddeb'|xargs -I {} cp {} $run_directory/
