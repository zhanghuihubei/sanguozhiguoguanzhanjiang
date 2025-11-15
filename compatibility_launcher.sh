#!/bin/bash
# 三国游戏兼容性启动器

echo "🎮 三国游戏兼容性启动器"
echo "====================="

PACKAGE="com.bangcle.protect"

echo "📱 检查应用状态..."
if ! pm list packages | grep -q $PACKAGE; then
    echo "❌ 应用未安装，请先安装APK"
    exit 1
fi

echo "🔧 预设环境..."

# 1. 清理可能的冲突进程
echo "🔄 停止可能冲突的应用..."
am force-stop $PACKAGE

# 2. 预设权限
echo "🔐 检查并预设权限..."
pm grant $PACKAGE android.permission.WRITE_EXTERNAL_STORAGE 2>/dev/null
pm grant $PACKAGE android.permission.READ_EXTERNAL_STORAGE 2>/dev/null
pm grant $PACKAGE android.permission.INTERNET 2>/dev/null
pm grant $PACKAGE android.permission.ACCESS_NETWORK_STATE 2>/dev/null

# 3. 检查存储状态
echo "💾 检查存储状态..."
DATA_DIR="/sdcard/Android/data/$PACKAGE"
if [ ! -d "$DATA_DIR" ]; then
    echo "🔧 创建应用数据目录..."
    mkdir -p "$DATA_DIR/files"
    mkdir -p "$DATA_DIR/cache"
fi

# 4. 等待系统稳定
echo "⏳ 等待系统稳定..."
sleep 2

# 5. 启动应用
echo "🚀 启动三国游戏..."
am start -n $PACKAGE/.MainActivity 2>/dev/null || am start -n $PACKAGE/.StartActivity 2>/dev/null || am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER $PACKAGE

echo ""
echo "✅ 启动命令已执行"
echo "💡 如果应用仍然闪退，请："
echo "1. 检查权限设置"
echo "2. 确保网络连接正常"
echo "3. 重启设备后重试"
echo "4. 查看详细日志获取更多信息"
