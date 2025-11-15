#!/bin/bash
# Android 10+ 存储修复脚本

echo "💾 Android 10+ 存储修复"
echo "====================="

PACKAGE="com.bangcle.protect"
DATA_DIR="/sdcard/Android/data/$PACKAGE"
CACHE_DIR="/sdcard/Android/data/$PACKAGE/cache"

echo "📁 检查应用数据目录..."

if [ -d "$DATA_DIR" ]; then
    echo "✅ 应用数据目录已存在: $DATA_DIR"
else
    echo "🔧 创建应用数据目录..."
    mkdir -p "$DATA_DIR"
    mkdir -p "$CACHE_DIR"
fi

echo "🔧 设置目录权限..."
chmod -R 755 "$DATA_DIR"
chown -R system:system "$DATA_DIR" 2>/dev/null

echo "🔧 创建游戏需要的子目录..."
mkdir -p "$DATA_DIR/files"
mkdir -p "$DATA_DIR/cache"
mkdir -p "$DATA_DIR/databases"
mkdir -p "$DATA_DIR/shared_prefs"

chmod -R 777 "$DATA_DIR/files"

echo "📊 目录结构:"
ls -la "$DATA_DIR"

echo ""
echo "💾 存储修复完成"
echo "💡 如果问题仍然存在，可能需要："
echo "1. 重启设备"
echo "2. 清空应用数据后重新设置"
echo "3. 检查SD卡状态"
