# ROS Docker Version2.0
[![Docker](https://img.shields.io/badge/Docker-blue?logo=docker)](https://www.docker.com)
[![ROS](https://img.shields.io/badge/ROS-Noetic-blueviolet?logo=ros)](http://wiki.ros.org/noetic)

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
- VNC客戶端：localhost:5901 (密碼：ros000)
- 瀏覽器：http://localhost:8080/vnc.html
---
## 系統套件 (ros_desktop_base)
### 桌面環境
- `ubuntu-mate-desktop` - Ubuntu MATE 桌面環境
- `tigervnc-standalone-server` - VNC 伺服器
- `noVNC` - 網頁版 VNC 客戶端
- `supervisor` - 進程管理工具

### 開發工具
- `vscodium` - 開源版 VS Code
- `build-essential` - 編譯工具
- `vim`, `git`, `sudo` - 基本工具
- `python3-pip` - Python 套件管理
- `tini`, `gosu` - 容器管理工具
- `wget`, `curl` - 網路工具
- `terminator` - 終端機

## ROS 套件 (ros_core)
### ROS 核心
- `ros-noetic-desktop` - ROS 桌面版本，包含基本開發工具
- `python3-ros*` - ROS 開發工具集（安裝、依賴管理、工作空間工具等）
- `rosdep` - ROS 套件依賴管理工具

### Gazebo 模擬器
- `ros-noetic-gazebo-ros-pkgs` - Gazebo ROS 整合套件
- `ros-noetic-gazebo-ros-control` - Gazebo 控制介面
- `ros-noetic-gazebo-plugins` - Gazebo 插件集
- `ros-noetic-gazebo-msgs` - Gazebo 訊息定義
- `ros-noetic-gazebo-dev` - Gazebo 開發工具
- `ros-noetic-gazebo-ros` - Gazebo ROS 介面

## Workspace
容器內已預先配置好ROS工作空間，位於`/home/ROS/workspace/`。
目前添加作者所需的開發腳本 Hiwin robot dependencies 於`workspace/dev_setup/hiwin_robot_setup`。
您可以添加自己的ROS包於`/home/ROS/workspace/`。

