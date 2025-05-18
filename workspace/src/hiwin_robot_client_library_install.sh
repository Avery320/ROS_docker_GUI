#!/usr/bin/env bash
set -euo pipefail

# =============================================
# HIWIN Robot Client Library 安裝腳本
# 版本：1.0.0
# 最後更新：2025-05-14
# 來源：https://github.com/HIWINCorporation/hiwin_robot_client_library
# 作者：Cheng-En Tsai
# =============================================
# 使用說明：
# 1. 確保系統為 Ubuntu 20.04
# 2. 執行權限：chmod +x hiwin_robot_client_library_install.sh
# 3. 執行腳本：./hiwin_robot_client_library_install.sh
# =============================================
# 說明：
# - 自動安裝 HIWIN Robot Client Library
# - 編譯並安裝到系統
# =============================================

#--------------------------------------------------
# 變數設定
REPO_URL="https://github.com/HIWINCorporation/hiwin_robot_client_library.git"
CLONE_DIR="hiwin_robot_client_library"
BUILD_DIR="build"
INSTALL_PREFIX="/usr/local"
#--------------------------------------------------

echo "🔄 更新套件清單並安裝必要套件..."
sudo apt update
sudo apt install -y git cmake build-essential || {
    echo "❌ 套件安裝失敗"
    exit 1
}

echo "📥 正在 clone 專案：$REPO_URL ..."
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

echo "🚀 安裝到：$INSTALL_PREFIX"
sudo make install || {
    echo "❌ 安裝失敗"
    exit 1
}

# 更新共享庫快取
echo "🔄 更新共享庫快取..."
sudo ldconfig || {
    echo "❌ 更新共享庫快取失敗"
    exit 1
}

echo "✅ 安裝完成！"
