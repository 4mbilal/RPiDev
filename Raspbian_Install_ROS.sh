# !/bin/bash
username="pi"
echo "Installing ROS..."

# Update&Upgrade the package repository.
echo "1. Update&Upgrade package repository..."
sudo apt-get -y update
sudo apt-get -y upgrade

# Add ROS repo
echo "2. Adding ROS repo..."
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install dependencies
echo "3. Installing dependencies..."
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo rosdep init
rosdep update
mkdir -p ~/catkin_ws
cd ~/catkin_ws
rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall
wstool init src kinetic-ros_comm-wet.rosinstall

