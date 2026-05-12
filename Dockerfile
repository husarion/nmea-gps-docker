ARG ROS_DISTRO=humble
ARG PREFIX=
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG ROS_DISTRO
ARG PREFIX

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
        ros-${ROS_DISTRO}-nmea-navsat-driver \
        ros-${ROS_DISTRO}-nav2-common && \
    dpkg -s ros-${ROS_DISTRO}-nmea-navsat-driver | \
        awk -F': ' '/^Version:/ {print $2}' | \
        sed -E 's/-[0-9].*$//' > /version.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY demo/config/ /config
COPY demo/nmea_navsat.launch.py /
