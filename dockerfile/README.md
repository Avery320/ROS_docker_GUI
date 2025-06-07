# ROS Docker 映像檔建立說明

本目錄包含建立 ROS 相關 Docker 映像檔的配置文件。主要分為兩個階段建立。
- `ros_desktop_base/`：ROS 桌面環境映像檔
- `ros_core/`：ROS 核心映像檔

## 建立順序
1. 首先建立 ROS 桌面環境映像檔：
   ```bash
   cd dockerfile/ros_desktop/
   ./build.sh
   ```
2. 首先建立 ROS 核心映像檔：
   ```bash
   cd ..
   cd dockerfile/ros_core/
   ./build.sh
   ```