<h1 align="center">
  Docker Images for a GPS module
</h1>


The repository includes a GitHub Actions workflow that automatically deploys built Docker images to the [husarion/nmea-gps-docker](https://hub.docker.com/r/husarion/nmea-gps) Docker Hub repositories. This process is based on the [ros-drivers/nmea_navsat_driver](https://github.com/ros-drivers/nmea_navsat_driver/tree/ros2) repository.

[![.github/workflows/build-docker-image.yaml](https://github.com/husarion/nmea-gps-docker/actions/workflows/build-docker-image.yaml/badge.svg?branch=ros2)](https://github.com/husarion/nmea-gps-docker/actions/workflows/build-docker-image.yaml)
### GPS API

GPS data in [NMEA](https://en.wikipedia.org/wiki/NMEA_0183) format is forwarded to RPi IP address at port 5000, typically it is `10.15.20.2:5000`.
You can make sure the address is correct by typing [http://10.15.20.1](http://10.15.20.1) into your browser (Username: `admin`, Password: `Husarion1`). Navigate to `Services -> GPS -> NMEA -> NMEA forwarding -> Hostname and Port`. Remember that you must be connected to the robot's WIFi network. If changes were needed, finish the connfiguration by pressing `save & apply` at the bottom of the screen.

Data frequency is 1Hz and can be interacted ether with GPSD daemon (`gpsd -N udp://10.15.20.2:5000`) or directly with [ROS package](https://github.com/ros-drivers/nmea_navsat_driver/tree/ros2) redirecting signal to ROS 2 topic.

## Demo

It is recommended to use docker image. To start the container type:

```bash
git clone https://github.com/husarion/nmea-gps-docker.git
cd nmea-gps-docker/demo

docker compose up
```

You should be able to see data on `/panther/fix` topic (`ros2 topic echo /panther/fix`).
