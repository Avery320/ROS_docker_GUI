# docker compose setting

## 新增 volume

### 將外部的 [volume] 卷掛載到容器的 /home/ROS/workspace 目錄

```
    volumes:
      - [volume_name]:/home/ROS/workspace 
```