#!/bin/bash
# 三国游戏高级诊断工具

echo "🔍 三国游戏高级诊断工具"
echo "======================="

PACKAGE="com.idealdimension.EmpireAttack"
BANGCLE_PACKAGE="com.bangcle.protect"

# 1. 系统信息
echo "📱 系统信息:"
echo "设备型号: $(getprop ro.product.model)"
echo "Android版本: $(getprop ro.build.version.release)"
echo "API级别: $(getprop ro.build.version.sdk)"
echo "CPU架构: $(getprop ro.product.cpu.abi)"
echo "制造商: $(getprop ro.product.brand)"

# 2. 应用状态检查
echo ""
echo "📦 应用状态:"
if pm list packages | grep -q "$PACKAGE"; then
    echo "✅ 主应用已安装"
    echo "版本信息: $(dumpsys package $PACKAGE | grep versionName | head -1)"
    echo "目标SDK: $(dumpsys package $PACKAGE | grep targetSdk | head -1)"
else
    echo "❌ 主应用未安装"
fi

if pm list packages | grep -q "$BANGCLE_PACKAGE"; then
    echo "✅ Bangcle组件已安装"
else
    echo "❌ Bangcle组件未安装"
fi

# 3. 权限状态详细检查
echo ""
echo "🔐 权限状态:"
dumpsys package $PACKAGE | grep -A 20 "runtime permissions"

# 4. 存储状态检查
echo ""
echo "💾 存储状态:"
echo "主应用目录:"
ls -la /sdcard/Android/data/$PACKAGE 2>/dev/null || echo "目录不存在"

echo "Bangcle目录:"
ls -la /sdcard/Android/data/$BANGCLE_PACKAGE 2>/dev/null || echo "目录不存在"

# 5. 进程状态检查
echo ""
echo "🔄 进程状态:"
ps | grep -E "$PACKAGE|$BANGCLE_PACKAGE" || echo "未找到相关进程"

# 6. 网络状态检查
echo ""
echo "🌐 网络状态:"
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "✅ 网络连接正常"
else
    echo "❌ 网络连接异常"
fi

# 7. 系统限制检查
echo ""
echo "⚠️ 系统限制检查:"
echo "隐藏API策略: $(settings get global hidden_api_policy)"
echo "应用安装来源: $(settings get secure install_non_market_apps)"

# 8. 华为特殊设置
echo ""
echo "📱 华为特殊设置:"
echo "电池优化白名单:"
dumpsys deviceidle whitelist | grep -E "$PACKAGE|$BANGCLE_PACKAGE" || echo "未在白名单中"

echo "后台活动限制:"
settings get global background_activity_whitelist | grep -E "$PACKAGE|$BANGCLE_PACKAGE" || echo "未在后台活动白名单中"

echo ""
echo "🎯 诊断完成！"
echo "请将此输出保存并发送给开发者进行进一步分析"
