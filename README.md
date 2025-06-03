# ROS Docker Version1.0
![Docker](https://img.shields.io/badge/Docker-blue?logo=docker)
![ROS](https://img.shields.io/badge/ROS-Noetic-blueviolet?logo=ros)

這是一個基於Ubuntu 20.04的ROS Noetic桌面環境，包含VNC支持，可以通過瀏覽器訪問。
---
## 執行
### git clone 
```bash
git clone https://github.com/Avery320/ROS_docker_GUI.git
```
### 構建映像
```bash
docker build -t ros-desktop .
```
### Docker Compose
```bash
cd docker_compose/[folder] # 進入 docker_compose 目錄下的特定環境目錄
```
```bash
docker-compose -f docker-compose.yml up -d # 啟動容器
```
---
## 核心工具套件
- 系統工具：
  - `tigervnc-standalone-server`
  - `tigervnc-common`
  - `supervisor`
  - `wget`, `curl`
  - `gosu`, `git`, `sudo`
  - `python3-pip`, `tini`
  - `build-essential`, `vim`, `lsb-release`
  - `locales`, `bash-completion`, `tzdata`
  - `terminator`
---
## ROS 相關套件
- 核心套件：
  - `ros-${ROS_DISTRO}-desktop`
  - `python3-rosinstall`, `python3-rosinstall-generator`
  - `python3-wstool`, `python3-catkin-tools`
  - `python3-osrf-pycommon`, `python3-argcomplete`
  - `python3-rosdep`, `python3-vcstool`
- 工業機器人：
  - `ros-${ROS_DISTRO}-industrial-robot-client`
  - `ros-${ROS_DISTRO}-industrial-robot-simulator`
  - `ros-${ROS_DISTRO}-controller-manager`
  - `ros-${ROS_DISTRO}-joint-state-controller`
  - `ros-${ROS_DISTRO}-robot-state-publisher`
  - `ros-${ROS_DISTRO}-joint-trajectory-controller`
  - `ros-${ROS_DISTRO}-moveit`
  - `ros-${ROS_DISTRO}-rviz`
  - `ros-${ROS_DISTRO}-gazebo-ros-pkgs`
  - `ros-${ROS_DISTRO}-ros-ign-gazebo`


## 支援
- ✅ VSCodium代碼編輯器
- ✅ noVNC 網頁客戶端        
- ✅ reopen in container

### 訪問桌面環境
- 通過VNC客戶端：連接到 localhost:5901 ，默認密碼： ros000
- 通過瀏覽器：訪問 http://localhost:8080/vnc.html

## 工作空間
容器內已預先配置好ROS工作空間，位於 /home/ROS/workspace/ 。
您可以通過以下方式添加自己的ROS包：
1. 在本地 ./workspace/ 目錄中添加文件，這些文件會被複製到容器的工作空間中
2. 直接在容器內的工作空間中創建或修改文件。

## 預設配置
- ROS_DISTRO=noetic
- USER=ROS 
- PASSWORD=ROS000
- VNC_PORT=5901
- NOVNC_PORT=8080
- CONTAINER_NAME=LocalROS
