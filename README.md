# ROS Docker Version2.0
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Docker](https://img.shields.io/badge/Docker-greenlogo=docker)](https://www.docker.com)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-orange?logo=ubuntu)](https://releases.ubuntu.com/20.04/)
[![ROS](https://img.shields.io/badge/ROS-Noetic-blueviolet?logo=ros)](http://wiki.ros.org/noetic)
[![VNC](https://img.shields.io/badge/VNC-Enabled-green?logo=vnc)](https://www.tigervnc.org/)

## 專案簡介
這是一個基於 Docker 的 ROS（Robot Operating System）開發環境，專為機器人開發者設計。本專案整合了 ROS Noetic、Ubuntu 20.04 和完整的桌面環境，提供了一個即用型的開發平台。主要特點包括：

- 🐳 基於 Docker 的容器化環境，確保開發環境的一致性和可移植性
- 🖥️ 整合 VNC/noVNC 服務，支援圖形化介面操作
- 🔧 預裝完整的 ROS 開發工具和 Hiwin 機器人相關依賴套件
- 🛠️ 支援 VSCode 遠端開發
- 🔄 使用 Docker Compose 進行容器管理

## 建立容器
### Git clone 
```bash
git clone https://github.com/Avery320/ROS_docker_GUI.git
```
### Docker Build
參考：[Docker Build](./dockerfile/README.md)
### Dokcer Compose
參考：[Docker Compose](./docker_compose/README.md)

## VSCode 遠端開發
在 `docker_compose/sample/` 中以設置 `.devcontariner` 允許開發者可以透過 VSCode 的 `reopen to container` 的方式進入容器。
```bash
cd docker_compose/sample/
code .
```
## VNC/noVNC
- VNC客戶端：localhost:5901 (密碼：ros000)
- 瀏覽器：http://localhost:8080/vnc.html
---
## 系統套件 
### ros_desktop_base
這是一個基於 Ubuntu 20.04 的桌面環境映像檔，提供完整的圖形化介面支援：
#### 桌面環境
- `ubuntu-mate-desktop` - Ubuntu MATE 桌面環境
- `tigervnc-standalone-server` - VNC 伺服器
- `noVNC` - 網頁版 VNC 客戶端
- `supervisor` - 進程管理工具

#### 開發工具
- `vscodium` - 開源版 VS Code
- `build-essential` - 編譯工具
- `vim`, `git`, `sudo` - 基本工具
- `python3-pip` - Python 套件管理
- `tini`, `gosu` - 容器管理工具
- `wget`, `curl` - 網路工具
- `terminator` - 終端機

### ros_core
基於 ros_desktop_base 的 ROS 開發環境映像檔，提供完整的 ROS 開發工具：

#### ROS 核心
- `ros-noetic-desktop` - ROS 桌面版本，包含基本開發工具
- `python3-ros*` - ROS 開發工具集（安裝、依賴管理、工作空間工具等）
- `rosdep` - ROS 套件依賴管理工具

#### Gazebo 模擬器
- `ros-noetic-gazebo-ros-pkgs` - Gazebo ROS 整合套件
- `ros-noetic-gazebo-ros-control` - Gazebo 控制介面
- `ros-noetic-gazebo-plugins` - Gazebo 插件集
- `ros-noetic-gazebo-msgs` - Gazebo 訊息定義
- `ros-noetic-gazebo-dev` - Gazebo 開發工具
- `ros-noetic-gazebo-ros` - Gazebo ROS 介面

## Workspace
- 容器內已預先配置好ROS工作空間，會將`workspace`資料夾中的內容映射至容器中`/home/ROS/workspace/`。
- 目前添加作者所需的開發腳本 Hiwin robot dependencies 於`workspace/dev_setup/hiwin_robot_setup`。


## 編譯要使用
```
catkin_make_isolated

source devel_isolated/setup.bash

```
您可以添加自己的ROS包於`/home/ROS/workspace/`。

## 授權條款

本專案採用 GNU General Public License v3.0 授權條款。詳情請參閱 [LICENSE](LICENSE) 檔案。

