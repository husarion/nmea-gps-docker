ARG ROS_DISTRO=humble
ARG PREFIX=

## =========================== ROS builder ===============================
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-base AS ros_builder

ARG ROS_DISTRO
ARG PREFIX
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

RUN apt-get update  && \
    apt-get install -y \
        ros-dev-tools && \
    git clone -b ros2 https://github.com/ros-drivers/nmea_navsat_driver.git src/nmea_navsat_driver && \
    rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src -y -i && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --cmake-args -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release && \
    echo $(cat /ros2_ws/src/nmea_navsat_driver/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') >> /version.txt

## =========================== Final Stage ===============================
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG ROS_DISTRO
ARG PREFIX

SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

COPY --from=ros_builder /ros2_ws /ros2_ws
COPY --from=ros_builder /version.txt /version.txt

RUN apt-get update && apt-get install -y \
        ros-dev-tools python3-transforms3d && \
    rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y && \
    # Size optimalization
    apt-get remove -y \
        ros-dev-tools && \
    apt-get clean && \
    rm -rf src && \
    rm -rf /var/lib/apt/lists/*

