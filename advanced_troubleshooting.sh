#!/bin/bash
# 三国游戏高级故障排除脚本

echo "🎮 三国游戏闪退高级诊断"
echo "=========================="

# 1. 检查设备信息
echo "📱 设备信息:"
getprop ro.product.model
getprop ro.build.version.release
getprop ro.product.cpu.abi

echo ""
echo "🔧 检查应用安装状态:"
pm list packages | grep -i bangcle

if [ $? -eq 0 ]; then
    echo "✅ 找到Bangcle相关包"
    pkg=$(pm list packages | grep -i bangcle | cut -d: -f2)
    echo "包名: $pkg"
    
    echo ""
    echo "📊 应用详细信息:"
    dumpsys package $pkg | head -20
    
    echo ""
    echo "🔍 权限状态:"
    dumpsys package $pkg | grep -A 20 "declared permissions"
    
    echo ""
    echo "💾 存储使用情况:"
    dumpsys package $pkg | grep -A 10 "storage"
else
    echo "❌ 未找到Bangcle相关包"
fi

echo ""
echo "🎯 建议的故障排除步骤:"
echo "1. 清空应用数据和缓存"
echo "2. 授予所有必要权限"
echo "3. 检查网络连接"
echo "4. 重启设备后重试"
