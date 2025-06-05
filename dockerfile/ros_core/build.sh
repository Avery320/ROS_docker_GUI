#!/bin/bash

# 設定顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 顯示進度函數
print_step() {
    echo -e "${GREEN}[步驟 $1]${NC} $2"
}

print_error() {
    echo -e "${RED}[錯誤]${NC} $1"
    exit 1
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

# 主程式
main() {
    # 切換到專案根目錄
    cd "$(dirname "$0")/../.."
    
    # 從 Dockerfile 中讀取容器名稱
    DOCKERFILE_PATH="dockerfile/ros_core/Dockerfile"
    CONTAINER_NAME=$(grep "LABEL org.opencontainers.image.title" "${DOCKERFILE_PATH}" | cut -d'"' -f2)
    
    if [ -z "$CONTAINER_NAME" ]; then
        print_error "無法從 Dockerfile 中讀取容器名稱"
    fi
    
    print_step "1" "開始建立 Docker 映像 ${CONTAINER_NAME}..."
    
    # 建立映像
    docker build -t ${CONTAINER_NAME}:latest -f ${DOCKERFILE_PATH} .
    
    if [ $? -eq 0 ]; then
        print_step "2" "映像建立完成！"
        echo "映像資訊："
        docker images | grep ${CONTAINER_NAME}
    else
        print_error "映像建立失敗"
    fi
}

# 執行主程式
main 