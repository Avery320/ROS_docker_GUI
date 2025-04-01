# ROS Docker 桌面環境

這是一個基於Ubuntu 20.04的ROS Noetic桌面環境，包含VNC支持，可以通過瀏覽器訪問。

## 功能特性

### 版本
- Ubuntu Mate桌面環境
- ROS Noetic完整桌面版

### 功能 
✅ VSCodium代碼編輯器
✅ TigerVNC伺服器
✅ 預配置的ROS工作空間

### 開法與測試中
🛠️noVNC網頁客戶端
🛠️Gazebo模擬器（僅支持amd64架構）

## 1_執行

### 構建映像
```bash
docker build -t ros-desktop .
```

### 執行 Docker 容器
```
docker run -d \
  -p 5901:5901 \
  -p 8080:8080 \
  --name LocalROS \
  ros-desktop
```

### 2_使用 Docker Compose
```bash
docker-compose -f .devcontainer/docker-compose.yml up -d

### 3. 訪問桌面環境
- 通過VNC客戶端：連接到 localhost:5901 ，密碼： ros000
- 通過瀏覽器：訪問 http://localhost:8080/vnc.html


## 工作空間
容器內已預先配置好ROS工作空間，位於 /home/ROS/workspace/ 。
您可以通過以下方式添加自己的ROS包：

1. 在本地 ./workspace/ 目錄中添加文件，這些文件會被複製到容器的工作空間中
2. 直接在容器內的工作空間中創建或修改文件
## 自定義配置

### 修改VNC密碼

構建時指定密碼：
```bash
docker build -t ros-desktop --build-arg VNC_PASSWORD=your_password .
 ```

運行時指定密碼：
```bash
docker run -d -p 5901:5901 -p 8080:8080 -e VNC_PASSWORD=your_password --name LocalROS ros-desktop
```

### 持久化工作空間
使用卷掛載保存工作空間：

```bash
docker run -d \
  -p 5901:5901 \
  -p 8080:8080 \
  -v /path/to/local/workspace:/home/ROS/workspace \
  --name LocalROS \
  ros-desktop
 ```

## 預設配置
- 用戶名：ROS
- VNC端口：5901
- noVNC端口：8080
- ROS版本：Noetic
