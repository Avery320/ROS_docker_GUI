#!/bin/bash

# 在腳本開頭添加清理舊VNC進程的代碼
vncserver -kill :1 &> /dev/null || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# 创建用户和组如果不存在
if ! id ${USER} &>/dev/null; then
    groupadd ${USER}  # 确保组存在
    useradd -m -s /bin/bash -g ${USER} ${USER}  # 创建用户并指定组
    echo "${USER}:${VNC_PASSWORD}" | chpasswd
    adduser ${USER} sudo
fi

# 确保目录权限正确
mkdir -p /home/${USER}/.vnc
echo "${VNC_PASSWORD}" | vncpasswd -f > /home/${USER}/.vnc/passwd
chmod 600 /home/${USER}/.vnc/passwd
chown -R ${USER}:${USER} /home/${USER}

# 設置ROS環境
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USER}/.bashrc
echo "source /home/${USER}/workspace/devel/setup.bash" >> /home/${USER}/.bashrc
echo "cd /home/${USER}/workspace" >> /home/${USER}/.bashrc

# 添加VSCodium别名
echo 'alias code="/usr/bin/codium --no-sandbox --unity-launch"' >> /home/${USER}/.bashrc

# 重新编译工作空间
su - ${USER} -c "cd /home/${USER}/workspace && source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make"

# 启动VNC服务器，使用密码
su - ${USER} -c "vncserver :1 -geometry 1280x800 -depth 24 -localhost no"

# 启动noVNC，使用环境变量中的端口
websockify -D --web=/usr/lib/novnc ${NOVNC_PORT} localhost:${VNC_PORT}

# 输出访问信息
echo "========================================================"
echo "VNC服务器已启动，端口: ${VNC_PORT}"
echo "noVNC服务已启动，访问: http://localhost:${NOVNC_PORT}/vnc.html"
echo "用户名: ${USER}"
echo "密碼: ${VNC_PASSWORD}"
echo "ROS版本: ${ROS_DISTRO}"
echo "========================================================"

# 保持容器运行
tail -f /dev/null