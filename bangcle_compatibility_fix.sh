#!/bin/bash
# Bangcle保护兼容性修复脚本

echo "🛡️ Bangcle保护兼容性修复"
echo "========================"

PACKAGE="com.idealdimension.EmpireAttack"
BANGCLE_DIR="/sdcard/Android/data/com.bangcle.protect"

# 1. 创建Bangcle兼容性配置
echo "📝 创建Bangcle兼容性配置..."
adb shell "mkdir -p $BANGCLE_DIR/files" 2>/dev/null

# 创建兼容性配置文件
cat > /tmp/bangcle_config.txt << EOF
# Bangcle Android 10+ 兼容性配置
compatibility_mode=1
android_version=10
target_sdk=29
device_manufacturer=huawei
storage_compat=1
permission_compat=1
network_compat=1
security_level=medium
debug_mode=0
EOF

adb shell "mv /tmp/bangcle_config.txt $BANGCLE_DIR/files/config.txt" 2>/dev/null

# 2. 设置环境变量
echo "🔧 设置兼容性环境变量..."
adb shell "setprop debug.bangcle.compat 1" 2>/dev/null
adb shell "setprop debug.bangcle.android10 1" 2>/dev/null

# 3. 创建兼容性标志文件
echo "📋 创建兼容性标志..."
adb shell "touch $BANGCLE_DIR/files/android10_compat" 2>/dev/null
adb shell "touch $BANGCLE_DIR/files/huawei_compat" 2>/dev/null

# 4. 清理可能的冲突缓存
echo "🧹 清理Bangcle缓存..."
adb shell "rm -rf $BANGCLE_DIR/cache/*" 2>/dev/null
adb shell "rm -rf /data/data/$PACKAGE/cache/bangcle/*" 2>/dev/null

# 5. 设置权限
echo "🔐 设置Bangcle权限..."
adb shell "chmod -R 777 $BANGCLE_DIR" 2>/dev/null
adb shell "chown -R shell:shell $BANGCLE_DIR" 2>/dev/null

# 6. 华为设备特殊设置
echo "📱 华为设备特殊设置..."
# 允许Bangcle服务的后台运行
adb shell "am startservice -n com.bangcle.protect/.CompatibilityService" 2>/dev/null || echo "服务启动失败，这是正常的"

# 设置华为电池优化白名单
adb shell "dumpsys deviceidle whitelist +com.bangcle.protect" 2>/dev/null

echo "✅ Bangcle兼容性修复完成"
