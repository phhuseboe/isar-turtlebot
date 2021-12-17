FROM osrf/ros:noetic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

WORKDIR /home/

RUN apt-get update &&\
    apt-get install -y\
    gazebo11 \
    build-essential \
    python3-osrf-pycommon \
    python3-catkin-tools \
    python3-rosdep \
    libignition-rendering3 \
    git


RUN mkdir -p catkin_ws/src 

WORKDIR /home/catkin_ws/src/

RUN git clone -b noetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git

COPY ./ros_packages/ /home/catkin_ws/src/
COPY ./docker_scripts/install_dep.sh /home/
RUN /home/install_dep.sh

RUN mkdir -p /usr/share/gazebo-11/models
COPY ./models /usr/share/gazebo-11/models
COPY ./docker_scripts/setup.sh /usr/share/gazebo-11/setup.sh
COPY ./docker_scripts/setup.sh /usr/share/gazebo/setup.sh

COPY ./config /home/config
COPY ./docker_scripts/entrypoint.sh /home/

CMD /home/entrypoint.sh
