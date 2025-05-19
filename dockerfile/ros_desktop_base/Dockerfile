FROM ubuntu:focal-20241011

# 設定預設的映像名稱
LABEL maintainer="n76124052@gs.ncku.edu.tw"
LABEL org.opencontainers.image.title="ros_desktop_base"
LABEL org.opencontainers.image.description="ROS Desktop Base Image"
LABEL org.opencontainers.image.version="1.0"

# 使用 ARG 來接收參數，並設定預設值
ARG CONTAINER_NAME=hiwinros_dev
ARG VNC_PASSWORD=ros000
ARG USER=ROS
ARG VNC_PORT=5901
ARG NOVNC_PORT=8080

# 將 ARG 轉換為 ENV
ENV CONTAINER_NAME=${CONTAINER_NAME}
ENV VNC_PASSWORD=${VNC_PASSWORD}
ENV USER=${USER}
ENV VNC_PORT=${VNC_PORT}
ENV NOVNC_PORT=${NOVNC_PORT}
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

# 建立使用者
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:${VNC_PASSWORD}" | chpasswd && \
    adduser ${USER} sudo

# 更新系統並安裝所有必要的套件
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        # 桌面環境
        ubuntu-mate-desktop \
        # VNC 相關套件
        tigervnc-standalone-server tigervnc-common \
        supervisor wget curl python3-pip \
        # 開發工具
        gosu git sudo python3-pip tini \
        build-essential vim sudo lsb-release locales \
        bash-completion tzdata terminator && \
    # 清理
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# noVNC 和 Websockify
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc && \
    pip3 install --no-cache-dir git+https://github.com/novnc/websockify.git@v0.10.0 && \
    ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html && \
    sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/lib/novnc/app/ui.js

# 安裝和設定 VSCodium
RUN wget https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    -O /usr/share/keyrings/vscodium-archive-keyring.asc && \
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.asc ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list && \
    apt-get update -q && \
    apt-get install -y codium libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libasound2 && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/applications && \
    echo -e "[Desktop Entry]\nVersion=1.0\nName=VSCodium\nComment=Code Editing\nExec=/usr/bin/codium --no-sandbox --unity-launch %F\nIcon=vscodium\nType=Application\nTerminal=false\nCategories=Development;TextEditor;" > /usr/share/applications/codium.desktop && \
    mkdir -p /home/${USER}/Desktop && \
    cp /usr/share/applications/codium.desktop /home/${USER}/Desktop/ && \
    chmod +x /home/${USER}/Desktop/codium.desktop && \
    chown ${USER}:${USER} /home/${USER}/Desktop/codium.desktop && \
    echo 'alias code="/usr/bin/codium --no-sandbox --unity-launch"' >> /home/${USER}/.bashrc

# 停用自動更新和錯誤報告
RUN sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades && \
    sed -i 's/enabled=1/enabled=0/g' /etc/default/apport