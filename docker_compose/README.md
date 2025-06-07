# ROS Docker 開發環境

這個`docker-compose`會透過資料夾名稱建立 `Continers`，在建立之前需在 `docker` 中預先設置 `Volumes` 與在 `.env` 文件中配置相關參數。

## Containers 設定說明
容器名稱設定將會與資料夾名稱相同，預設為`docker_compose/<name>`。

## Volume 設置說明
1. Docker Volume 命名規則：
   - Volume 名稱必須與環境變數 `NAME` 相同
   - 例如：如果 `NAME=sample`，則 volume 名稱也必須是 `sample`
2. 創建 Volume：
   ```bash
   docker volume create 'sample'
   ```
3. 修改 docker-compose.ymal 文件中 `volumes` 的配置
```yaml
  volumes:
    sample: # 手動修正 volumes 名稱與設置名稱相同
      external: true
```

## `.env`環境變數設定

在運行容器之前，請在`.env`設定以下環境變數：

```bash
# 容器名稱
NAME=sample
# 連接埠設定
export VNC_PORT=5901           # VNC 連接埠
export WEB_PORT=8080           # 網頁介面連接埠
export VNC_PASSWORD=your_password  # VNC 密碼
```

## 網頁介面

- 瀏覽器訪問：http://localhost:${WEB_PORT}
