#!/bin/bash

function apt_dependencies(){
<<"###comment"
    Function: Install application through apt
###comment
sudo apt install terminator \
                 byobu \
                 libuvc-dev \
                 liborocos-bfl-dev
}

function ros_dependencies(){
<<"###comment"
    Function: Install ROS dependencies.
    Args:  
      $1: ROS version
###comment
    sudo apt install ros-$1-uuid-msgs \
                     ros-$1-map-server \
                     ros-$1-navigation \
                     ros-$1-serial \
                     ros-$1-tf2-sensor-msgs \
                     ros-$1-costmap-converter \
                     ros-$1-teb-local-planner \
                     ros-$1-async-web-server-cpp \
                     ros-$1-joy \
                     ros-$1-ackermann-msgs
}

function lidar_configuration(){
<<"###comment"
    Function: add udev rules for lidar
    Args: 
      $1: idVendor
      $2: idProduct
      $3: symlink
###comment

    rule='KERNEL=="ttyUSB*", ATTRS{idVendor}=="'$1'", ATTRS{idProduct}=="'$2'", MODE:="0666", GROUP:="dialout",  SYMLINK+="'$3'"' 
    echo $rule | sudo tee --append /etc/udev/rules.d/$3.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger


}

# Install
#apt_dependencies
#ros_dependencies $ROS_DISTRO
lidar_configuration "10c4" "ea60" "rplidar_laser"