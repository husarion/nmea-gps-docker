# nmea-gps-docker
Building a Docker image for a GPS module

### GPS API 

GPS data in [NMEA](https://en.wikipedia.org/wiki/NMEA_0183) format is forwarded to RPi IP address at port 5000, typically it is `10.15.20.2:5000`. 
You can make sure the address is correct by typing (http://10.15.20.1/#/services/gps/nmea)[http://10.15.20.1/#/services/gps/nmea] into your browser (NMEA forwarding -> Hostname and Port). Remember that you must be connected to the robot's WIFi network. If changes were needed, finish the connfiguration by pressing `save & apply` at the bottom of the screen.

Data frequency is 1Hz and can be interacted ether with GPSD daemon (`gpsd -N udp://10.15.20.2:5000`) or directly with [ROS package](https://github.com/ros-drivers/nmea_navsat_driver/tree/decode-udp-line) redirecting signal to ROS topic. 

It is recommended to use docker image. To start the container type:

```bash
git clone https://github.com/husarion/nmea-gps-docker.git
cd nmea-gps-docker

docker compose up
```

You should be able to see data on `/panther/fix` topic (`rostopic echo /panther/fix`). 