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
                     ros-$1-ackermann-msgs \
                     ros-$1-ecl-core \
                     ros-$1-teleop-twist-keyboard \
                     ros-$1-gmapping
}

function uart_configuration(){
<<"###comment"
    Function: add udev rules for lidar
    Args: 
      $1: lidar idVendor
      $2: lidar idProduct
      $3: lidar symlink
      $4: STM32 idVendor
      $5: STM32 idProduct
      $6: STM32 symlink
###comment

    rule1='KERNEL=="ttyUSB*", ATTRS{idVendor}=="'$1'", ATTRS{idProduct}=="'$2'",ATTRS{serial}=="0002" ,MODE:="0666", GROUP:="dialout",  SYMLINK+="'$3'"'
    rule2='KERNEL=="ttyUSB*", ATTRS{idVendor}=="'$4'", ATTRS{idProduct}=="'$5'",ATTRS{serial}=="0001" ,MODE:="0666", GROUP:="dialout",  SYMLINK+="'$6'"'  
    echo $rule1 | sudo tee --append /etc/udev/rules.d/wheeltec.rules
    echo $rule2 | sudo tee --append /etc/udev/rules.d/wheeltec.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger


}

function setup_nfs(){
<<"###comment"
	Function: setup NFS server
###comment
    #sudo apt install nfs-kernel-server
	project=$HOME'/'$(pwd | cut -d / -f 4)
	echo $project' *(rw,sync,no_root_squash)' | sudo tee --append /etc/exports 
	sudo chmod -R 777 $project
	#sudo chown -R 777 nobody $project
	sudo /etc/init.d/nfs-kernel-server start
	sudo /etc/init.d/nfs-kernel-server restart
}

# Install
#apt_dependencies
#ros_dependencies $ROS_DISTRO

lidar_idVendor="10c4"
lidar_idProduct="ea60"
lidar_symlink="rplidar_laser"
STM32_idVendor=$lidar_idVendor
STM32_idProduct=$lidar_idProduct
STM32_symlink="wheeltec_controller"

uart_configuration $lidar_idVendor $lidar_idProduct $lidar_symlink $STM32_idVendor $STM32_idProduct $STM32_symlink
#setup_nfs
