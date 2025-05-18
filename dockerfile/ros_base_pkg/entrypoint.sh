#!/bin/bash

# 檢查必要的環境變數
if [ -z "${USER}" ] || [ -z "${VNC_PASSWORD}" ] || [ -z "${VNC_PORT}" ] || [ -z "${NOVNC_PORT}" ]; then
    echo "錯誤：缺少必要的環境變數"
    echo "請確保以下環境變數已設定："
    echo "- USER"
    echo "- VNC_PASSWORD"
    echo "- VNC_PORT"
    echo "- NOVNC_PORT"
    exit 1
fi

# 清理舊的 VNC 程序
vncserver -kill :1 &> /dev/null || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 確保 VNC 密碼設定正確
mkdir -p /home/${USER}/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > /home/${USER}/.vnc/passwd
chmod 600 /home/${USER}/.vnc/passwd
chown -R ${USER}:${USER} /home/${USER}

# 啟動 VNC 伺服器
su - ${USER} -c "vncserver :1 -geometry 1280x800 -depth 24 -localhost no"

# 啟動 noVNC
websockify -D --web=/usr/lib/novnc ${NOVNC_PORT} localhost:${VNC_PORT}

# 輸出存取資訊
echo "========================================================"
echo "容器名稱: ${CONTAINER_NAME}"
echo "VNC 伺服器已啟動，連接埠: ${VNC_PORT}"
echo "noVNC 服務已啟動，存取: http://localhost:${NOVNC_PORT}/vnc.html"
echo "使用者名稱: ${USER}"
echo "密碼: ${VNC_PASSWORD}"
echo "ROS 版本: ${ROS_DISTRO}"
echo "========================================================"

# 保持容器執行
tail -f /dev/null 