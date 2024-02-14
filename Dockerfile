ARG ROS_DISTRO=humble
ARG PREFIX=
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG ROS_DISTRO
ARG PREFIX

SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

RUN apt-get update && apt-get install -y \
        ros-dev-tools python3-transforms3d && \
    git clone -b ros2 https://github.com/ros-drivers/nmea_navsat_driver.git src/nmea_navsat_driver && \
    rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --cmake-args -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release && \
    echo $(cat /ros2_ws/src/nmea_navsat_driver/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') >> /version.txt && \
    # Size optimalization
    apt-get remove -y \
        ros-dev-tools && \
    apt-get clean && \
    rm -rf src build && \
    rm -rf /var/lib/apt/lists/*
