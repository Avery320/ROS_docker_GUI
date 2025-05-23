#!/bin/bash

# 在腳本開頭新增清理舊 VNC 程序的程式碼
vncserver -kill :1 &> /dev/null || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 建立使用者和群組（如果不存在）
if ! id ${USER} &>/dev/null; then
    groupadd ${USER}  # 確保群組存在
    useradd -m -s /bin/bash -g ${USER} ${USER}  # 建立使用者並指定群組
    echo "${USER}:${VNC_PASSWORD}" | chpasswd
    adduser ${USER} sudo
fi

# 確保目錄權限正確
mkdir -p /home/${USER}/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > /home/${USER}/.vnc/passwd
chmod 600 /home/${USER}/.vnc/passwd
chown -R ${USER}:${USER} /home/${USER}

# 設定 ROS 環境
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USER}/.bashrc
echo "source /home/${USER}/workspace/devel/setup.bash" >> /home/${USER}/.bashrc
echo "cd /home/${USER}/workspace" >> /home/${USER}/.bashrc

# 新增 VSCodium 別名
echo 'alias code="/usr/bin/codium --no-sandbox --unity-launch"' >> /home/${USER}/.bashrc

# 重新編譯工作空間
su - ${USER} -c "cd /home/${USER}/workspace && source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make"

# 啟動 VNC 伺服器，使用密碼
su - ${USER} -c "vncserver :1 -geometry 1920x1080 -depth 24 -localhost no"

# 啟動 noVNC，使用環境變數中的連接埠
/usr/lib/novnc/utils/novnc_proxy --vnc localhost:${VNC_PORT} --listen ${NOVNC_PORT} &

# 輸出存取資訊
echo "========================================================"
echo "VNC 伺服器已啟動，連接埠: ${VNC_PORT}"
echo "noVNC 服務已啟動，存取: http://localhost:${NOVNC_PORT}/vnc.html"
echo "使用者名稱: ${USER}"
echo "密碼: ${VNC_PASSWORD}"
echo "ROS 版本: ${ROS_DISTRO}"
echo "========================================================"

# 保持容器執行
tail -f /dev/null