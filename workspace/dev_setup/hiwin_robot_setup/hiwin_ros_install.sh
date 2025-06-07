#!/bin/bash

# =============================================
# HIWIN ROS 安裝腳本
# 版本：1.0.0
# 最後更新：2025-05-14
# 來源：https://github.com/HIWINCorporation/hiwin_ros
# 作者：Cheng-En Tsai
# =============================================
# 使用說明：
# 1. 確保系統為 Ubuntu 20.04
# 2. 確保已安裝 ROS Noetic
# 3. 執行權限：chmod +x hiwin_ros_install.sh
# 4. 執行腳本：./hiwin_ros_install.sh
# =============================================
# 說明：
# - 自動安裝 HIWIN ROS 套件
# - 移除 
#   - hiwin_ra605_710_moveit_config
#   - hiwin_ra610_1869_moveit_config
# =============================================

# 設定顏色輸出
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}開始安裝 HIWIN ROS 套件...${NC}"

# 檢查是否為 Ubuntu 20.04
if [ "$(lsb_release -rs)" != "20.04" ]; then
    echo -e "${RED}錯誤：此腳本需要 Ubuntu 20.04${NC}"
    exit 1
fi

# 安裝 ROS Noetic 依賴項
echo -e "${GREEN}安裝 ROS Noetic 依賴項...${NC}"
sudo apt-get update
sudo apt-get install -y ros-noetic-industrial-robot-client \
    ros-noetic-industrial-robot-simulator \
    ros-noetic-controller-manager \
    ros-noetic-joint-state-controller

# 設定工作空間路徑
WORKSPACE_PATH="/home/ROS/workspace"
SRC_PATH="${WORKSPACE_PATH}/src"
echo -e "${GREEN}使用工作空間：${WORKSPACE_PATH}${NC}"
echo -e "${GREEN}使用源碼目錄：${SRC_PATH}${NC}"

# 檢查工作空間是否存在
if [ ! -d "$WORKSPACE_PATH" ]; then
    echo -e "${RED}錯誤：工作空間 ${WORKSPACE_PATH} 不存在${NC}"
    exit 1
fi

# 檢查 src 目錄是否存在
if [ ! -d "$SRC_PATH" ]; then
    echo -e "${RED}錯誤：源碼目錄 ${SRC_PATH} 不存在${NC}"
    exit 1
fi

# 進入工作空間根目錄
cd $WORKSPACE_PATH

# 檢查並克隆 HIWIN ROS 專案
echo -e "${GREEN}檢查 HIWIN ROS 專案...${NC}"
if [ ! -d "$SRC_PATH/hiwin_ros" ]; then
    echo -e "${GREEN}克隆 HIWIN ROS 專案...${NC}"
    cd $SRC_PATH
    git clone -b noetic-devel https://github.com/HIWINCorporation/hiwin_ros.git
    if [ $? -ne 0 ]; then
        echo -e "${RED}克隆專案失敗${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}HIWIN ROS 專案已存在，更新中...${NC}"
    cd $SRC_PATH/hiwin_ros
    git pull origin noetic-devel
fi

# 返回工作空間根目錄
cd $WORKSPACE_PATH

# 安裝依賴項
echo -e "${GREEN}安裝專案依賴項...${NC}"
rosdep update
rosdep install --from-paths src/ --ignore-src --rosdistro noetic -y

# 編譯工作空間
echo -e "${GREEN}編譯工作空間...${NC}"
source /opt/ros/noetic/setup.bash
catkin_make

# 設置環境
echo -e "${GREEN}設置環境...${NC}"
echo "source ${WORKSPACE_PATH}/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

# 移除不需要的資料夾
echo -e "${GREEN}移除不需要的資料夾...${NC}"
rm -rf $WORKSPACE_PATH/src/hiwin_ros/hiwin_ra610_1869_moveit_config
rm -rf $WORKSPACE_PATH/src/hiwin_ros/hiwin_ra605_710_moveit_config

echo -e "${GREEN}安裝完成！${NC}"
echo -e "請重新開啟終端機或執行 'source ~/.bashrc' 來更新環境變數"
