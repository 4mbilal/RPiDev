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

# Initialize rosdep
echo "4. Initialize and update rosdep"
sudo rosdep init
rosdep update

# ROS installation
echo "5. Installing ROS..."
mkdir -p ~/catkin_ws
cd ~/catkin_ws
rosinstall_generator ros_comm --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall
wstool init src kinetic-ros_comm-wet.rosinstall

# if the above init wstool fails, 
# wstool update -j4 -t src


mkdir -p ~/catkin_ws/external_src
cd ~/catkin_ws/external_src
wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
cmake .
make
sudo make install

cd ~/catkin_ws
rosdep install -y --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:buster

sudo apt remove -y libboost1.67-dev
sudo apt autoremove -y
sudo apt install -y libboost1.58-dev libboost1.58-all-dev
sudo apt install -y g++-5 gcc-5
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 20
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++
sudo apt install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake
sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic

source /opt/ros/kinetic/setup.bash
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# Add new ROS packages
rosinstall_generator ros_comm ros_control joystick_drivers --rosdistro kinetic --deps --wet-only --tar > kinetic-custom_ros.rosinstall
wstool merge -t src kinetic-custom_ros.rosinstall
wstool update -t src

# Install ROSARIA
mkdir -p ~/Aria
cd ~/Aria
git clone https://github.com/cinvesrob/Aria.git
make -j4
sudo make install
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/Aria
sudo ldconfig


cd src
sudo git clone https://github.com/amor-ros-pkg/rosaria.git
sudo git clone  https://github.com/Slamtec/rplidar_ros.git
cd ..

# install dependencies

rosinstall_generator ros_comm dynamic_reconfigure geometry_msgs message_generation nav_msgs roscpp sensor_msgs std_msgs std_srvs tf --rosdistro kinetic --deps --wet-only --tar > kinetic-custom_ros.rosinstall
wstool merge -t src kinetic-custom_ros.rosinstall
wstool update -t src

# Run rosdep to install remaining dependencies. Don't use -y option and say no when it again tries to install libboost1.67.
echo "Press No when asked to install libbost1.67"
rosdep install --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:buster

#Rebuild again
#This error might come up during building: "src/geometry2/tf2/src/buffer_core.cpp:126:34: error: ‘logWarn’ was not declared in this scope"
#Solution is to append "logWarn" and "logError" with "CONSOLE_BRIDGE_" in whole file.

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic

#An alternative to above build command is this. This builds in build folder while the above builds in build_isolated. The above works fine now.
#catkin_make

