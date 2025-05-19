# ROS Docker Version2.0
開發中~
---
## 執行
### Git clone 
```bash
git clone https://github.com/Avery320/ROS_docker_GUI.git
```
### Docker Build
```bash
docker build -t hiwinros_dev .
```
### Docker Compose
本專案使用`docker compose`的方式管理容器。
```bash
cd docker_compose/dev # 進入 docker_compose 目錄中的 dev 資料夾
```
```bash
docker-compose -f docker-compose.yml up -d # 啟動容器
```
- 透過`.env`管理容器的設定檔。
- 使用`.devcontariner`允許開發者可以透過 IDE 的 `reopen to container` 的方式進入容器。

## VNC/noVNC
- 通過VNC客戶端：連接到 localhost:5901 ，默認密碼： ros000
- 通過瀏覽器：訪問 http://localhost:8080/vnc.html
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


## Workspace
容器內已預先配置好ROS工作空間，位於`/home/ROS/workspace/`。
目前添加作者所需的開發腳本 Hiwin robot dependencies 於`workspace/dev_setup/hiwin_robot_setup`。
您可以添加自己的ROS包於`/home/ROS/workspace/`。

