# Copyright 2020-2024 Tiryoh<tiryoh@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This Dockerfile is based on https://github.com/AtsushiSaito/docker-ubuntu-sweb
# which is released under the Apache-2.0 license.

FROM ubuntu:focal-20241011

# 設置環境變量
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=noetic
ENV USER=ROS
ENV VNC_PORT=5901
ENV NOVNC_PORT=8080
ENV CONTAINER_NAME=LocalROS

# 使用ARG而不是ENV来设置密码
ARG VNC_PASSWORD="ros000"
# 在构建完成后设置环境变量
ENV VNC_PASSWORD=${VNC_PASSWORD}

ARG TARGETPLATFORM
ARG INSTALL_PACKAGE=desktop
# 移除密码参数
# ARG PASSWD=ros000

LABEL maintainer="Tiryoh<tiryoh@gmail.com>"

SHELL ["/bin/bash", "-c"]

# Upgrade OS
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Install Ubuntu Mate desktop
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ubuntu-mate-desktop && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Add Package
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server tigervnc-common \
        supervisor wget curl gosu git sudo python3-pip tini \
        build-essential vim sudo lsb-release locales \
        bash-completion tzdata terminator && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# noVNC and Websockify
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc && \
    pip install --no-cache-dir git+https://github.com/novnc/websockify.git@v0.10.0 && \
    ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html && \
    sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/lib/novnc/app/ui.js

# Disable auto update and crash report
RUN sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades && \
    sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

# Install VSCodium
RUN wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    -O /usr/share/keyrings/vscodium-archive-keyring.asc && \
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list && \
    apt-get update -q && \
    apt-get install -y codium && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 安裝 ROS
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros.list && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      ros-${ROS_DISTRO}-${INSTALL_PACKAGE} \
      python3-rosinstall \
      python3-rosinstall-generator \
      python3-wstool \
      python3-catkin-tools \
      python3-osrf-pycommon \
      python3-argcomplete \
      python3-rosdep \
      python3-vcstool \
      ros-${ROS_DISTRO}-industrial-robot-client \
      ros-${ROS_DISTRO}-industrial-robot-simulator \
      ros-${ROS_DISTRO}-controller-manager \
      ros-${ROS_DISTRO}-joint-state-controller \
      ros-${ROS_DISTRO}-robot-state-publisher \
      ros-${ROS_DISTRO}-joint-trajectory-controller \
      ros-${ROS_DISTRO}-moveit \
      ros-${ROS_DISTRO}-rviz && \
    rosdep init && \
    rosdep update && \
    rm -rf /var/lib/apt/lists/*


# 安裝 Gazebo (僅適用於 amd64)
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    apt-get update -q && \
    apt-get install -y \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-ros-ign-gazebo && \
    rm -rf /var/lib/apt/lists/*; \
    fi

# 創建用戶
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:${VNC_PASSWORD}" | chpasswd && \
    adduser ${USER} sudo

# 創建ROS工作空間
RUN mkdir -p /home/${USER}/workspace/src && \
    chown -R ${USER}:${USER} /home/${USER}/workspace && \
    cd /home/${USER}/workspace && \
    /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
    catkin_make && \
    echo 'source /home/${USER}/workspace/devel/setup.bash' >> /home/${USER}/.bashrc"

# 複製本地工作空間文件到容器
COPY ./workspace/ /home/${USER}/workspace/src/
RUN chown -R ${USER}:${USER} /home/${USER}/workspace

# Enable apt-get completion after running `apt-get update` in the container
RUN rm /etc/apt/apt.conf.d/docker-clean

COPY ./entrypoint.sh /

# 在entrypoint.sh中使用環境變量
ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]
