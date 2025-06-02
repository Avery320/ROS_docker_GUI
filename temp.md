
---

## 2. 桌面環境

- Ubuntu MATE Desktop：完整的桌面環境套件

---



---

## 4. 遠端桌面工具

- noVNC：
  - 網頁版 VNC 客戶端
  - 支援剪貼簿同步
- websockify：VNC-to-WebSocket 代理

---

## 5. 開發工具

- VSCodium (開源版 VS Code)
- 相關依賴：
  - `libx11-xcb1`, `libxcb-dri3-0`, `libdrm2`, `libgbm1`, `libasound2`

---


---

## 8. 工作空間設定

- ROS 工作區：
  - 路徑：`/home/${USER}/workspace`
  - 包含 `src` 目錄
- 自動編譯：
  - 執行 `catkin_make`
- 環境變數：
  - 自動 source 相應的 setup 檔案

---

## 9. 使用者設定

- 建立使用者：創建 `ROS` 帳號
- VNC 密碼：設定預設密碼
- 快捷捷徑：配置 VSCodium 桌面圖示
- Shell 別名：設置常用命令別名
