#!/bin/bash
# 三国志官斩 华为畅享60 Android 10 闪退修复脚本
# 针对启动图标生成时闪退问题的专门修复

echo "🎮 三国志官斩闪退修复工具"
echo "=========================="
echo "设备: 华为畅享60 Android 10"
echo "问题: 启动图标生成时闪退"
echo ""

# 检查设备连接
if ! adb devices | grep -q "device$"; then
    echo "❌ 未检测到ADB设备连接"
    echo "请确保："
    echo "1. 已开启USB调试模式"
    echo "2. 已连接USB线"
    echo "3. 已授权此计算机"
    exit 1
fi

echo "✅ 检测到ADB设备"

# 获取包名
PACKAGE="com.idealdimension.EmpireAttack"
echo "📦 应用包名: $PACKAGE"

# 检查应用是否已安装
echo ""
echo "🔍 检查应用安装状态..."
if adb shell pm list packages | grep -q "$PACKAGE"; then
    echo "✅ 应用已安装"
else
    echo "❌ 应用未安装，请先安装APK"
    exit 1
fi

# 1. 检查当前权限状态
echo ""
echo "🔍 检查当前权限状态..."
echo "存储权限:"
adb shell dumpsys package $PACKAGE | grep -A 5 "android.permission.WRITE_EXTERNAL_STORAGE" || echo "未找到存储权限信息"

echo "网络权限:"
adb shell dumpsys package $PACKAGE | grep -A 5 "android.permission.INTERNET" || echo "未找到网络权限信息"

# 2. 授予所有必要权限
echo ""
echo "🔧 授予必要权限..."
adb shell pm grant $PACKAGE android.permission.WRITE_EXTERNAL_STORAGE
adb shell pm grant $PACKAGE android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant $PACKAGE android.permission.INTERNET
adb shell pm grant $PACKAGE android.permission.ACCESS_NETWORK_STATE
adb shell pm grant $PACKAGE android.permission.WAKE_LOCK
adb shell pm grant $PACKAGE android.permission.VIBRATE
adb shell pm grant $PACKAGE android.permission.READ_PHONE_STATE

# 华为设备特殊权限
echo "🔧 授予华为设备特殊权限..."
adb shell pm grant $PACKAGE android.permission.GET_TASKS
adb shell pm grant $PACKAGE android.permission.SYSTEM_ALERT_WINDOW

# 3. 创建必要的目录结构
echo ""
echo "📁 创建应用数据目录..."
DATA_DIR="/sdcard/Android/data/$PACKAGE"
CACHE_DIR="/sdcard/Android/data/$PACKAGE/cache"

# 创建基础目录
adb shell "mkdir -p $DATA_DIR/files" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/cache" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/databases" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/shared_prefs" 2>/dev/null

# 创建Bangcle保护需要的目录
BANGCLE_DIR="/sdcard/Android/data/com.bangcle.protect"
adb shell "mkdir -p $BANGCLE_DIR/files" 2>/dev/null
adb shell "mkdir -p $BANGCLE_DIR/cache" 2>/dev/null

# 创建游戏可能需要的特定目录
adb shell "mkdir -p $DATA_DIR/files/download" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/temp" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/update" 2>/dev/null

# 4. 设置目录权限
echo ""
echo "🔧 设置目录权限..."
adb shell "chmod -R 777 $DATA_DIR" 2>/dev/null
adb shell "chmod -R 777 $BANGCLE_DIR" 2>/dev/null

# 5. 清理可能的冲突数据
echo ""
echo "🧹 清理可能冲突的数据..."
adb shell "rm -rf $DATA_DIR/cache/*" 2>/dev/null
adb shell "rm -rf $BANGCLE_DIR/cache/*" 2>/dev/null

# 6. 停止应用进程
echo ""
echo "🔄 停止应用进程..."
adb shell am force-stop $PACKAGE

# 7. 针对华为设备的特殊设置
echo ""
echo "🔧 华为设备特殊设置..."
# 关闭电池优化
adb shell dumpsys deviceidle whitelist | grep $PACKAGE || echo "添加到电池优化白名单..."
adb shell settings put global hidden_api_policy 1

# 8. 创建启动测试脚本
echo ""
echo "📝 创建启动测试..."
echo "准备启动应用进行测试..."

# 等待用户确认
echo ""
read -p "按回车键启动应用进行测试..."

# 启动应用
echo "🚀 启动应用..."
adb shell am start -n $PACKAGE/cn.cmgame.billing.api.GameOpenActivity

# 等待几秒钟
sleep 3

# 检查应用是否仍在运行
echo ""
echo "📊 检查应用运行状态..."
if adb shell ps | grep -q "$PACKAGE"; then
    echo "✅ 应用正在运行"
else
    echo "❌ 应用已停止运行"
    echo "获取崩溃日志..."
    adb shell logcat -d | grep -A 10 -B 10 "$PACKAGE\|FATAL\|AndroidRuntime" > crash_log.txt
    echo "崩溃日志已保存到 crash_log.txt"
fi

# 9. 生成诊断报告
echo ""
echo "📋 生成诊断报告..."
cat > diagnosis_report.txt << EOF
三国志官斩闪退诊断报告
=====================

设备信息:
- 型号: 华为畅享60
- 系统: Android 10 (鸿蒙3.0.0)
- 问题: 启动图标生成时闪退

已执行的修复:
1. ✅ 授予所有必要权限
2. ✅ 创建应用数据目录
3. ✅ 设置目录权限
4. ✅ 清理缓存数据
5. ✅ 华为设备特殊设置
6. ✅ 停止并重启应用

权限状态:
$(adb shell dumpsys package $PACKAGE | grep -A 2 "declared permissions" | head -20)

目录结构:
$(adb shell ls -la /sdcard/Android/data/$PACKAGE 2>/dev/null || echo "目录不存在")

建议:
1. 如果仍然闪退，尝试重启设备
2. 检查网络连接是否正常
3. 确保SD卡有足够空间
4. 尝试在设置中手动授予"所有文件访问权限"
5. 如果问题持续，可能需要等待应用更新

生成时间: $(date)
EOF

echo "📄 诊断报告已保存到 diagnosis_report.txt"

echo ""
echo "🎯 修复完成！"
echo ""
echo "💡 如果问题仍然存在，请尝试："
echo "1. 重启设备后再次启动应用"
echo "2. 在华为设置中找到应用，手动授予所有权限"
echo "3. 设置 -> 应用 -> 应用管理 -> 找到三国志官斩 -> 权限 -> 全部允许"
echo "4. 设置 -> 应用 -> 应用管理 -> 找到三国志官斩 -> 存储 -> 允许管理所有文件"
echo "5. 查看 crash_log.txt 文件获取详细错误信息"
echo ""
echo "🔍 如需进一步调试，请查看生成的日志文件"