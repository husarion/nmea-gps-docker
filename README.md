# nmea-gps-docker

The repository includes a GitHub Actions workflow that automatically deploys built Docker images to the [husarion/nmea-gps-docker](https://hub.docker.com/r/husarion/nmea-gps) Docker Hub repositories. This process is based on the [ros-drivers/nmea_navsat_driver](https://github.com/ros-drivers/nmea_navsat_driver/tree/ros2) repository.

[![.github/workflows/build-docker-image.yaml](https://github.com/husarion/nmea-gps-docker/actions/workflows/build-docker-image.yaml/badge.svg?branch=ros2)](https://github.com/husarion/nmea-gps-docker/actions/workflows/build-docker-image.yaml)

## ROS Nodes

### nmea_navsat_driver

ROS 2 driver to parse NMEA strings and publish standard ROS 2 NavSatFix message types. Does not require the GPSD daemon to be running.

#### Publishers

- `~/fix` [*sensor_msgs/msg/NavSatFix*]: GPS position fix reported by the device. This will be published with whatever positional and status data was available even if the device doesn't have a valid fix. Invalid fields may contain NaNs.
- `~/heading` [*geometry_msgs/msg/QuaternionStamped*]: stamped orientation of heading.
-  `~/time_reference` [*sensor_msgs/msg/TimeReference*]: The timestamp from the GPS device is used as the `time_ref``.
- `~/vel` [*geometry_msgs/msg/TwistStamped*]: Velocity output from the GPS device. Only published when the device outputs valid velocity information. The driver does not calculate the velocity based on only position fixes.

#### Parameters

Node GPS parameters:
- `~/time_ref_source` [*string*, default: **'gps'**]: The value to use as the source in the `sensor_msgs/msg/TimeReference`.
- `~/useRMC` [*bool*, default: **False**]: Whether to generate position fixes from GGA sentences or RMC sentences. If True, fixes will be generated from RMC. If False, fixes will be generated based on the GGA sentences. Using GGA sentences allows for approximated covariance output while RMC provides velocity information.
- `~/frame_id` [*string*, default: **'gps'**]: The`frame_id` for the header of the `sensor_msgs/msg/NavSatFix` and `geometry_msgs/msg/TwistStamped` output messages. Will be resolved with `tf_prefix` if defined.
- `~/tf_prefix` [*string*, default: **''**]: Adds prefix to the `frame_id`.

`nmea_socket_driver.py` parameters:
- `~/ip` [*string*, default: **'0.0.0.0'**]: The ip of socket server.
- `~/port` [*int*, default: **10110**]: The port of socket server.
- `~/buffer_size` [*int*, default: **4096**]: Communication buffer.
- `~/timeout_sec` [*double*, default: **2**]: Timeout during waiting for packages in the socket.

# Panther Demo

GPS data in [NMEA](https://en.wikipedia.org/wiki/NMEA_0183) format is forwarded to RPi IP address at port 5000, typically it is `10.15.20.2:5000`.
You can make sure the address is correct by typing [http://10.15.20.1](http://10.15.20.1) into your browser (Username: `admin`, Password: `Husarion1`). Navigate to `Services -> GPS -> NMEA -> NMEA forwarding -> Hostname and Port`. Remember that you must be connected to the robot's WIFi network. If changes were needed, finish the configuration by pressing `save & apply` at the bottom of the screen.

Data frequency is 1Hz and can be interacted ether with GPSD daemon (`gpsd -N udp://10.15.20.2:5000`) or directly with [ROS package](https://github.com/ros-drivers/nmea_navsat_driver/tree/ros2) redirecting signal to ROS 2 topic.

It is recommended to use docker image. To start the container type:

```bash
git clone https://github.com/husarion/nmea-gps-docker.git
cd nmea-gps-docker/demo

docker compose up
```

You should be able to see data on `/panther/fix` topic (`ros2 topic echo /panther/fix`).
