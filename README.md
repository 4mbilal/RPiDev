# RPi_ROS
ROS projects on Raspberry Pi

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/kinetic
rosdep install --from-paths src --ignore-src --rosdistro kinetic -r --os=debian:buster
