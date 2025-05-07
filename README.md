# ROS Docker 桌面環境
這是一個基於Ubuntu 20.04的ROS Noetic桌面環境，包含VNC支持，可以通過瀏覽器訪問。

## 功能特性
### 版本
- Ubuntu Mate桌面環境
- ROS Noetic完整桌面版
### 功能 
✅ VSCodium代碼編輯器
✅ noVNC網頁客戶端｜TigerVNC伺服器
✅ reopen in container
✅ 預配置的ROS工作空間
### 開法與測試中
🛠️Gazebo模擬器（僅支持amd64架構）

## 執行
### 構建映像
```bash
docker build -t ros-desktop .
```
### Docker Compose
```bash
# 進入 docker_compose 目錄下的特定環境目錄
cd docker_compose/[folder]
# 啟動容器
docker-compose -f docker-compose.yml up -d
```
### 訪問桌面環境
- 通過VNC客戶端：連接到 localhost:5901 ，默認密碼： ros000
- 通過瀏覽器：訪問 http://localhost:8080/vnc.html

## 工作空間
容器內已預先配置好ROS工作空間，位於 /home/ROS/workspace/ 。
您可以通過以下方式添加自己的ROS包：
1. 在本地 ./workspace/ 目錄中添加文件，這些文件會被複製到容器的工作空間中
2. 直接在容器內的工作空間中創建或修改文件

## 預設配置
- 用戶名：ROS
- VNC端口：5901
- noVNC端口：8080
