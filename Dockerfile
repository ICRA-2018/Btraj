FROM roslab/roslab:kinetic-nvidia

USER root

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    libarmadillo-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/HKUST-Aerial-Robotics/plan_utils.git /plan_utils \
 && cd /plan_utils \
 && mkdir -p ${HOME}/catkin_ws/src \
 && cp -R /plan_utils ${HOME}/catkin_ws/src/. \
 && cd ${HOME}/catkin_ws \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make" \
 && rm -fr /plan_utils

RUN mkdir -p ${HOME}/catkin_ws/src/btraj
COPY . ${HOME}/catkin_ws/src/btraj/.
RUN cd ${HOME}/catkin_ws \
 && mv src/btraj/README.ipynb .. \
 && apt-get update \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && rosdep update && rosdep install --as-root apt:false --from-paths src --ignore-src -r -y" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ${HOME}/.bashrc

RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}
