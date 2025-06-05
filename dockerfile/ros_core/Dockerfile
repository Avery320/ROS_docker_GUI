FROM ros_desktop_base:latest

# 設定預設的映像名稱
LABEL maintainer="n76124052@gs.ncku.edu.tw"
LABEL org.opencontainers.image.title="ros_core"
LABEL org.opencontainers.image.description="ROS Development Image"
LABEL org.opencontainers.image.version="1.0"

# 使用 ARG 來接收參數，並設定預設值
ARG ROS_DISTRO=noetic
ARG INSTALL_PACKAGE=desktop

# 將 ARG 轉換為 ENV
ENV ROS_DISTRO=${ROS_DISTRO}
ENV INSTALL_PACKAGE=${INSTALL_PACKAGE}

# 安裝 ROS
RUN apt-get update -qq && \
    # 添加必要的套件
    apt-get install -y --no-install-recommends curl gnupg2 lsb-release ca-certificates && \
    # 移除已存在的 ROS 金鑰
    rm -f /etc/apt/trusted.gpg.d/ros* /etc/apt/trusted.gpg.d/openrobotics* /etc/apt/trusted.gpg && \
    # 添加 ROS 金鑰
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | gpg --dearmor -o /etc/apt/keyrings/ros.gpg && \
    # 添加 ROS 源
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ros.gpg] http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros.list && \
    # 更新套件列表
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
      python3-vcstool && \
    rosdep init && \
    rosdep update && \
    rm -rf /var/lib/apt/lists/*

# 安裝 Gazebo
RUN apt-get update -q && \
    apt-get install -y \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-gazebo-plugins \
    ros-${ROS_DISTRO}-gazebo-msgs \
    ros-${ROS_DISTRO}-gazebo-dev \
    ros-${ROS_DISTRO}-gazebo-ros && \
    rm -rf /var/lib/apt/lists/*

# 建立 ROS 工作空間
RUN mkdir -p /home/${USER}/workspace/src && \
    mkdir -p /home/${USER}/workspace/dev_setup && \
    chown -R ${USER}:${USER} /home/${USER}/workspace

# 複製工作空間檔案
COPY workspace/src/ /home/${USER}/workspace/src/
COPY workspace/dev_setup/ /home/${USER}/workspace/dev_setup/
RUN chown -R ${USER}:${USER} /home/${USER}/workspace && \
    cd /home/${USER}/workspace && \
    /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
    catkin_make && \
    echo 'source /home/${USER}/workspace/devel/setup.bash' >> /home/${USER}/.bashrc"

# 啟用 apt-get 自動完成功能
RUN rm /etc/apt/apt.conf.d/docker-clean

COPY dockerfile/ros_core/entrypoint.sh /
ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ] 