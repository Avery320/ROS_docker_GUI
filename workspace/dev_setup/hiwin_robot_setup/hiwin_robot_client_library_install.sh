#!/usr/bin/env bash
set -euo pipefail

# =============================================
# HIWIN Robot Client Library 安裝腳本
# 版本：1.0.0
# 最後更新：2025-05-24
# 來源：https://github.com/HIWINCorporation/hiwin_robot_client_library
# 作者：Cheng-En Tsai
# =============================================
# 使用說明：
# 1. 確保系統為 Ubuntu 20.04
# 2. 執行權限：chmod +x hiwin_robot_client_library_install.sh
# 3. 執行腳本：./hiwin_robot_client_library_install.sh
# =============================================
# 說明：
# - 此腳本用於安裝 HIWIN Robot Client Library
# - 安裝位置：
#   - 源碼：${WORKSPACE_PATH}/hiwin_robot_client_library
#   - 編譯後檔案：${WORKSPACE_PATH}/devel
# - 此腳本位於 dev_setup 目錄，但不會影響 ROS 工作空間結構
# =============================================

#--------------------------------------------------
# 變數設定
REPO_URL="https://github.com/HIWINCorporation/hiwin_robot_client_library.git"
WORKSPACE_PATH="/home/ROS/workspace"  # ROS 工作空間根目錄
CLONE_DIR="${WORKSPACE_PATH}/hiwin_robot_client_library"  # 源碼安裝目錄
BUILD_DIR="build"
INSTALL_PREFIX="${WORKSPACE_PATH}/devel"  # 編譯後檔案安裝目錄
#--------------------------------------------------

echo "🔄 更新套件清單並安裝必要套件..."
sudo apt update
sudo apt install -y git cmake build-essential || {
    echo "❌ 套件安裝失敗"
    exit 1
}

# 檢查 ROS 工作空間是否存在
if [ ! -d "$WORKSPACE_PATH" ]; then
    echo "❌ ROS 工作空間 ${WORKSPACE_PATH} 不存在"
    exit 1
fi

echo "📥 正在 clone 專案到 ROS 工作空間：$REPO_URL ..."
git clone "$REPO_URL" "$CLONE_DIR" || {
    echo "❌ 克隆專案失敗"
    exit 1
}
cd "$CLONE_DIR"

echo "🏗️ 建立並進入建置目錄：$BUILD_DIR"
mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

echo "⚙️ 執行 cmake 與 make ..."
cmake -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" .. || {
    echo "❌ cmake 配置失敗"
    exit 1
}

make -j"$(nproc)" || {
    echo "❌ 編譯失敗"
    exit 1
}

echo "🚀 安裝到 ROS 工作空間：$INSTALL_PREFIX"
make install || {
    echo "❌ 安裝失敗"
    exit 1
}

# 更新環境變數
echo "🔄 更新環境變數..."
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${INSTALL_PREFIX}/lib" >> ~/.bashrc
echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:${INSTALL_PREFIX}/lib/pkgconfig" >> ~/.bashrc

echo "✅ 安裝完成！"
echo "請重新開啟終端機或執行 'source ~/.bashrc' 來更新環境變數"
