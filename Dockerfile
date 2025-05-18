FROM ubuntu:focal-20241011

# 使用 ARG 來設定參數
ARG CONTAINER_NAME=hiwinros_dev
ARG VNC_PASSWORD=ros000
ARG ROS_DISTRO=noetic
ARG USER=ROS
ARG VNC_PORT=5901
ARG NOVNC_PORT=8080
ARG INSTALL_PACKAGE=desktop

# 將 ARG 轉換為 ENV
ENV CONTAINER_NAME=${CONTAINER_NAME}
ENV VNC_PASSWORD=${VNC_PASSWORD}
ENV ROS_DISTRO=${ROS_DISTRO}
ENV USER=${USER}
ENV VNC_PORT=${VNC_PORT}
ENV NOVNC_PORT=${NOVNC_PORT}
ENV INSTALL_PACKAGE=${INSTALL_PACKAGE}

# 設定環境變數
ENV DEBIAN_FRONTEND=noninteractive

LABEL maintainer="n76124052@gs.ncku.edu.tw"

SHELL ["/bin/bash", "-c"]

# 升級作業系統
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 安裝 Ubuntu Mate 桌面環境
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        ubuntu-mate-desktop && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*ㄌ

# 新增套件
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tigervnc-standalone-server tigervnc-common \
        supervisor wget curl gosu git sudo python3-pip tini \
        build-essential vim sudo lsb-release locales \
        bash-completion tzdata terminator && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# noVNC 和 Websockify
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc && \
    pip install --no-cache-dir git+https://github.com/novnc/websockify.git@v0.10.0 && \
    ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html && \
    sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/lib/novnc/app/ui.js

# 停用自動更新和錯誤報告
RUN sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades && \
    sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

# 安裝 VSCodium
RUN wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    -O /usr/share/keyrings/vscodium-archive-keyring.asc && \
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list && \
    apt-get update -q && \
    apt-get install -y codium libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libasound2 && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    # 建立桌面捷徑
    mkdir -p /usr/share/applications && \
    echo -e "[Desktop Entry]\nVersion=1.0\nName=VSCodium\nComment=Code Editing\nExec=/usr/bin/codium --no-sandbox --unity-launch %F\nIcon=vscodium\nType=Application\nTerminal=false\nCategories=Development;TextEditor;" > /usr/share/applications/codium.desktop

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
      python3-vcstool && \
    rosdep init && \
    rosdep update && \
    rm -rf /var/lib/apt/lists/*

# 安裝 Gazebo（使用模擬器）
RUN apt-get update -q && \
    apt-get install -y \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-gazebo-plugins \
    ros-${ROS_DISTRO}-gazebo-msgs \
    ros-${ROS_DISTRO}-gazebo-dev \
    ros-${ROS_DISTRO}-gazebo-ros \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-gazebo-plugins \
    ros-${ROS_DISTRO}-gazebo-msgs \
    ros-${ROS_DISTRO}-gazebo-dev \
    ros-${ROS_DISTRO}-gazebo-ros && \
    rm -rf /var/lib/apt/lists/*

# 建立使用者
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:${VNC_PASSWORD}" | chpasswd && \
    adduser ${USER} sudo && \
    # 確保 VSCodium 設定目錄存在
    mkdir -p /home/${USER}/.config/VSCodium && \
    chown -R ${USER}:${USER} /home/${USER}/.config && \
    # 建立桌面捷徑
    mkdir -p /home/${USER}/Desktop && \
    cp /usr/share/applications/codium.desktop /home/${USER}/Desktop/ && \
    chmod +x /home/${USER}/Desktop/codium.desktop && \
    chown ${USER}:${USER} /home/${USER}/Desktop/codium.desktop && \
    # 新增 VSCodium 別名到 bashrc
    echo 'alias code="/usr/bin/codium --no-sandbox --unity-launch"' >> /home/${USER}/.bashrc

# 建立 ROS 工作空間
RUN mkdir -p /home/${USER}/workspace/src && \
    chown -R ${USER}:${USER} /home/${USER}/workspace && \
    cd /home/${USER}/workspace && \
    /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
    catkin_make && \
    echo 'source /home/${USER}/workspace/devel/setup.bash' >> /home/${USER}/.bashrc"

# 複製本地工作空間檔案到容器
COPY ./workspace/ /home/${USER}/workspace/src/
RUN chown -R ${USER}:${USER} /home/${USER}/workspace

# 啟用 apt-get 自動完成功能
RUN rm /etc/apt/apt.conf.d/docker-clean

COPY ./entrypoint.sh /

# 在 entrypoint.sh 中使用環境變數
ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]
