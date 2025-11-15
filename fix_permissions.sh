#!/bin/bash
# 三国游戏权限修复脚本

echo "🔧 三国游戏权限修复"
echo "==================="

# 检查是否root
if [ "$(id -u)" != "0" ]; then
    echo "⚠️  需要root权限来执行完整修复"
    echo "💡 建议在已root的设备上运行，或手动授予权限"
fi

# 包名（需要根据实际情况调整）
PACKAGE="com.bangcle.protect"

echo "📱 检查应用安装状态..."
pm list packages | grep $PACKAGE

if [ $? -eq 0 ]; then
    echo "✅ 找到应用: $PACKAGE"
    
    echo ""
    echo "🔧 授予存储权限..."
    pm grant $PACKAGE android.permission.WRITE_EXTERNAL_STORAGE
    pm grant $PACKAGE android.permission.READ_EXTERNAL_STORAGE
    
    echo "🔧 授予网络权限..."
    pm grant $PACKAGE android.permission.INTERNET
    pm grant $PACKAGE android.permission.ACCESS_NETWORK_STATE
    
    echo "🔧 授予其他权限..."
    pm grant $PACKAGE android.permission.WAKE_LOCK
    pm grant $PACKAGE android.permission.VIBRATE
    
    # Android 10+ 特殊权限
    echo "🔧 授予Android 10+特殊权限..."
    
    # 检查是否可以授予所有文件访问权限
    if [ "$(id -u)" = "0" ]; then
        echo "尝试授予所有文件访问权限..."
        appops set $PACKAGE MANAGE_EXTERNAL_STORAGE allow
    fi
    
    echo ""
    echo "✅ 权限修复完成"
    echo "💡 请重启应用后测试"
else
    echo "❌ 未找到应用，请先安装APK"
fi

echo ""
echo "🎯 手动权限设置（如果脚本无法自动设置）："
echo "1. 设置 -> 应用 -> 找到三国游戏"
echo "2. 权限 -> 存储权限 -> 允许"
echo "3. 权限 -> 电话权限 -> 允许（如需要）"
echo "4. 权限 -> 其他权限 -> 全部允许"
echo "5. 高级权限 -> 所有文件访问权限 -> 允许（Android 10+）"
