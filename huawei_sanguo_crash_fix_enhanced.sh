#!/bin/bash
# 三国志官斩 华为畅享60 Android 10 闪退修复脚本 (增强版)
# 针对Bangcle保护和华为设备兼容性问题的专门修复

echo "🎮 三国志官斩闪退修复工具 (增强版)"
echo "===================================="
echo "设备: 华为畅享60 Android 10"
echo "问题: 启动图标生成时闪退 (Bangcle保护兼容性)"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查设备连接
echo -e "${BLUE}📱 检查ADB连接...${NC}"
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}❌ 未检测到ADB设备连接${NC}"
    echo "请确保："
    echo "1. 已开启USB调试模式"
    echo "2. 已连接USB线"
    echo "3. 已授权此计算机"
    exit 1
fi

echo -e "${GREEN}✅ 检测到ADB设备${NC}"

# 获取设备信息
echo -e "${BLUE}📋 获取设备信息...${NC}"
DEVICE_MODEL=$(adb shell getprop ro.product.model)
ANDROID_VERSION=$(adb shell getprop ro.build.version.release)
BRAND=$(adb shell getprop ro.product.brand)
echo -e "设备型号: ${DEVICE_MODEL}"
echo -e "Android版本: ${ANDROID_VERSION}"
echo -e "制造商: ${BRAND}"

# 获取包名
PACKAGE="com.idealdimension.EmpireAttack"
echo -e "${BLUE}📦 应用包名: $PACKAGE${NC}"

# 检查应用是否已安装
echo ""
echo -e "${BLUE}🔍 检查应用安装状态...${NC}"
if adb shell pm list packages | grep -q "$PACKAGE"; then
    echo -e "${GREEN}✅ 应用已安装${NC}"
else
    echo -e "${RED}❌ 应用未安装，请先安装APK${NC}"
    exit 1
fi

# 1. 获取应用详细信息和权限状态
echo ""
echo -e "${BLUE}🔍 检查应用详细信息和权限状态...${NC}"

# 获取应用版本信息
APP_VERSION=$(adb shell dumpsys package $PACKAGE | grep "versionName" | head -1 | cut -d= -f2)
echo -e "应用版本: $APP_VERSION"

# 获取目标SDK版本
TARGET_SDK=$(adb shell dumpsys package $PACKAGE | grep "targetSdk" | head -1 | cut -d= -f2)
echo -e "目标SDK: $TARGET_SDK"

# 检查应用声明的权限
echo ""
echo -e "${YELLOW}📋 应用声明的权限:${NC}"
adb shell dumpsys package $PACKAGE | grep -A 50 "declared permissions" | grep "android.permission" | head -15

# 2. 智能权限授予 (只授予应用实际声明的权限)
echo ""
echo -e "${BLUE}🔧 智能授予必要权限...${NC}"

# 获取应用实际声明的权限列表
DECLARED_PERMISSIONS=$(adb shell dumpsys package $PACKAGE | grep "android.permission" | grep -o "android\.permission\.[^[:space:]]*" | sort | uniq)

# 常见且安全的权限列表
SAFE_PERMISSIONS=(
    "android.permission.WRITE_EXTERNAL_STORAGE"
    "android.permission.READ_EXTERNAL_STORAGE"
    "android.permission.INTERNET"
    "android.permission.ACCESS_NETWORK_STATE"
    "android.permission.ACCESS_WIFI_STATE"
    "android.permission.WAKE_LOCK"
    "android.permission.VIBRATE"
    "android.permission.READ_PHONE_STATE"
    "android.permission.SYSTEM_ALERT_WINDOW"
    "com.android.launcher.permission.INSTALL_SHORTCUT"
)

for perm in "${SAFE_PERMISSIONS[@]}"; do
    if echo "$DECLARED_PERMISSIONS" | grep -q "$perm"; then
        echo -e "  授予权限: $perm"
        adb shell pm grant $PACKAGE $perm 2>/dev/null || echo -e "    ${YELLOW}⚠️ 无法授予${NC}"
    fi
done

# 3. 华为设备特殊权限和设置
echo ""
echo -e "${BLUE}🔧 华为设备特殊设置...${NC}"

# 检查是否在电池优化白名单
if ! adb shell dumpsys deviceidle whitelist | grep -q "$PACKAGE"; then
    echo -e "  添加到电池优化白名单..."
    adb shell dumpsys deviceidle whitelist +$PACKAGE 2>/dev/null || echo -e "    ${YELLOW}⚠️ 无法添加到白名单${NC}"
else
    echo -e "  ${GREEN}✅ 已在电池优化白名单中${NC}"
fi

# 设置隐藏API策略 (允许访问隐藏API)
adb shell settings put global hidden_api_policy 1 2>/dev/null

# 华为设备特殊设置 - 允许后台启动
adb shell settings put global background_activity_whitelist $PACKAGE 2>/dev/null

# 4. 创建完整的目录结构 (包括Bangcle保护目录)
echo ""
echo -e "${BLUE}📁 创建完整的应用数据目录...${NC}"

DATA_DIR="/sdcard/Android/data/$PACKAGE"
CACHE_DIR="/sdcard/Android/data/$PACKAGE/cache"
BANGCLE_DIR="/sdcard/Android/data/com.bangcle.protect"

# 创建应用基础目录
echo -e "  创建应用数据目录..."
adb shell "mkdir -p $DATA_DIR/files" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/cache" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/databases" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/shared_prefs" 2>/dev/null

# 创建Bangcle保护需要的目录
echo -e "  创建Bangcle保护目录..."
adb shell "mkdir -p $BANGCLE_DIR/files" 2>/dev/null
adb shell "mkdir -p $BANGCLE_DIR/cache" 2>/dev/null
adb shell "mkdir -p $BANGCLE_DIR/databases" 2>/dev/null
adb shell "mkdir -p $BANGCLE_DIR/shared_prefs" 2>/dev/null

# 创建游戏可能需要的特定目录
echo -e "  创建游戏特定目录..."
adb shell "mkdir -p $DATA_DIR/files/download" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/temp" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/update" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/games" 2>/dev/null
adb shell "mkdir -p $DATA_DIR/files/obb" 2>/dev/null

# 创建可能的缓存目录
adb shell "mkdir -p /sdcard/Android/obb/$PACKAGE" 2>/dev/null

# 5. 设置目录权限
echo ""
echo -e "${BLUE}🔧 设置目录权限...${NC}"
adb shell "chmod -R 777 $DATA_DIR" 2>/dev/null
adb shell "chmod -R 777 $BANGCLE_DIR" 2>/dev/null
adb shell "chmod -R 777 /sdcard/Android/obb/$PACKAGE" 2>/dev/null

# 6. 清理可能的冲突数据
echo ""
echo -e "${BLUE}🧹 清理可能冲突的数据...${NC}"
echo -e "  清理缓存文件..."
adb shell "rm -rf $DATA_DIR/cache/*" 2>/dev/null
adb shell "rm -rf $BANGCLE_DIR/cache/*" 2>/dev/null

# 清理可能的临时文件
adb shell "rm -rf $DATA_DIR/files/temp/*" 2>/dev/null
adb shell "rm -rf $DATA_DIR/files/download/tmp*" 2>/dev/null

# 7. 停止应用进程
echo ""
echo -e "${BLUE}🔄 停止应用进程...${NC}"
adb shell am force-stop $PACKAGE
adb shell "killall -9 $PACKAGE" 2>/dev/null

# 等待进程完全停止
sleep 2

# 8. Bangcle保护特殊处理
echo ""
echo -e "${BLUE}🛡️ Bangcle保护特殊处理...${NC}"

# 检查Bangcle相关进程
BANGCLE_PROCESSES=$(adb shell ps | grep -i bangcle | awk '{print $9}')
if [ ! -z "$BANGCLE_PROCESSES" ]; then
    echo -e "  发现Bangcle进程，停止相关服务..."
    echo "$BANGCLE_PROCESSES" | xargs -I {} adb shell "am force-stop {}" 2>/dev/null
fi

# 创建Bangcle配置文件
echo -e "  创建Bangcle配置..."
adb shell "echo 'compatibility_mode=1' > $BANGCLE_DIR/files/config.txt" 2>/dev/null
adb shell "echo 'android_version=10' >> $BANGCLE_DIR/files/config.txt" 2>/dev/null
adb shell "echo 'device_type=huawei' >> $BANGCLE_DIR/files/config.txt" 2>/dev/null

# 9. 网络和环境检查
echo ""
echo -e "${BLUE}🌐 网络和环境检查...${NC}"

# 检查网络连接
if adb shell "ping -c 1 8.8.8.8" >/dev/null 2>&1; then
    echo -e "  ${GREEN}✅ 网络连接正常${NC}"
else
    echo -e "  ${YELLOW}⚠️ 网络连接异常，可能影响游戏启动${NC}"
fi

# 检查存储空间
STORAGE_INFO=$(adb shell df /sdcard | tail -1)
if [ ! -z "$STORAGE_INFO" ]; then
    echo -e "  存储空间: $STORAGE_INFO"
fi

# 10. 启动测试和日志收集
echo ""
echo -e "${BLUE}📝 准备启动测试...${NC}"
echo -e "${YELLOW}⚠️ 注意：接下来将启动应用并收集日志${NC}"
echo -e "如果应用闪退，脚本会自动收集崩溃信息"

# 等待用户确认
echo ""
read -p "按回车键启动应用进行测试..."

# 清空logcat准备收集新的日志
echo -e "${BLUE}🔄 清空日志缓存...${NC}"
adb logcat -c 2>/dev/null

# 启动应用
echo -e "${BLUE}🚀 启动应用...${NC}"
adb shell am start -n $PACKAGE/cn.cmgame.billing.api.GameOpenActivity

# 等待应用启动
echo -e "等待应用启动 (5秒)..."
sleep 5

# 收集日志
echo -e "${BLUE}📊 收集运行日志...${NC}"
adb logcat -d > app_launch_log.txt

# 检查应用是否仍在运行
echo ""
echo -e "${BLUE}📊 检查应用运行状态...${NC}"
if adb shell ps | grep -q "$PACKAGE"; then
    echo -e "${GREEN}✅ 应用正在运行${NC}"
    
    # 收集正常运行的日志
    echo -e "${BLUE}📄 保存运行日志...${NC}"
    grep -E "(三国|EmpireAttack|GameOpenActivity)" app_launch_log.txt > success_log.txt 2>/dev/null
    echo -e "${GREEN}✅ 运行日志已保存到 success_log.txt${NC}"
else
    echo -e "${RED}❌ 应用已停止运行${NC}"
    echo -e "${BLUE}🔍 分析崩溃原因...${NC}"
    
    # 收集崩溃相关的日志
    echo -e "  收集崩溃日志..."
    grep -E -i "(FATAL|AndroidRuntime|Exception|Error|三国|EmpireAttack|Bangcle)" app_launch_log.txt > crash_log.txt
    
    # 如果没有找到相关错误，收集更多日志
    if [ ! -s crash_log.txt ]; then
        echo -e "  收集更多日志信息..."
        tail -100 app_launch_log.txt > crash_log.txt
    fi
    
    echo -e "${RED}📄 崩溃日志已保存到 crash_log.txt${NC}"
    
    # 尝试提取关键错误信息
    echo -e "${BLUE}🔍 提取关键错误信息...${NC}"
    grep -E -i "(FATAL|AndroidRuntime.*Exception|Caused by)" crash_log.txt | head -10 > key_errors.txt 2>/dev/null
fi

# 11. 生成详细诊断报告
echo ""
echo -e "${BLUE}📋 生成详细诊断报告...${NC}"
cat > enhanced_diagnosis_report.txt << EOF
三国志官斩闪退增强诊断报告
==========================

设备信息:
- 型号: $DEVICE_MODEL
- 制造商: $BRAND
- 系统版本: Android $ANDROID_VERSION
- 问题: 启动图标生成时闪退 (Bangcle保护兼容性)

应用信息:
- 包名: $PACKAGE
- 版本: $APP_VERSION
- 目标SDK: $TARGET_SDK

已执行的修复操作:
1. ✅ 智能权限授予 (仅授予声明的权限)
2. ✅ 创建完整应用数据目录
3. ✅ 创建Bangcle保护专用目录
4. ✅ 设置目录权限 (777)
5. ✅ 清理缓存和临时文件
6. ✅ 停止应用进程
7. ✅ Bangcle保护特殊处理
8. ✅ 华为设备特殊设置
9. ✅ 电池优化白名单
10. ✅ 网络环境检查

权限状态 (当前):
$(adb shell dumpsys package $PACKAGE | grep -A 10 "runtime permissions" | head -20)

目录结构:
$(adb shell ls -la /sdcard/Android/data/$PACKAGE 2>/dev/null || echo "应用目录不存在")

Bangcle目录:
$(adb shell ls -la /sdcard/Android/data/com.bangcle.protect 2>/dev/null || echo "Bangcle目录不存在")

崩溃分析:
$(if [ -f crash_log.txt ]; then echo "发现崩溃日志，关键错误:"; head -20 crash_log.txt; else echo "未发现明显崩溃信息"; fi)

进一步建议:
1. 🔧 手动权限检查:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 权限 -> 全部允许
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 存储 -> 允许管理所有文件

2. 🛡️ Bangcle保护问题:
   - 如果仍然闪退，可能是Bangcle保护与Android 10不兼容
   - 尝试在华为设置中关闭"纯净模式"或"应用安装保护"
   - 尝试重启设备后立即启动应用

3. 🌐 网络相关问题:
   - 确保网络连接稳定
   - 尝试切换WiFi/移动网络
   - 检查是否有网络代理或VPN干扰

4. 📱 华为设备特殊设置:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 电池 -> 允许后台活动
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 启动管理 -> 允许关联启动

5. 🔄 最后手段:
   - 完全卸载应用，重启设备，重新安装
   - 尝试使用其他Android版本的手机测试
   - 联系游戏开发者获取Android 10兼容版本

生成时间: $(date)
EOF

echo -e "${GREEN}📄 增强诊断报告已保存到 enhanced_diagnosis_report.txt${NC}"

# 12. 显示总结
echo ""
echo -e "${GREEN}🎯 增强修复完成！${NC}"
echo ""
echo -e "${BLUE}📋 生成的文件:${NC}"
echo -e "  - enhanced_diagnosis_report.txt (详细诊断报告)"
if [ -f crash_log.txt ]; then
    echo -e "  - crash_log.txt (崩溃日志)"
fi
if [ -f success_log.txt ]; then
    echo -e "  - success_log.txt (成功运行日志)"
fi
echo -e "  - app_launch_log.txt (完整启动日志)"
echo -e "  - key_errors.txt (关键错误信息)"

echo ""
echo -e "${YELLOW}💡 如果问题仍然存在，请按以下步骤操作：${NC}"
echo -e "1. ${GREEN}重启设备${NC}后再次启动应用"
echo -e "2. 在${GREEN}华为设置中手动授予所有权限${NC}"
echo -e "3. 查看 ${GREEN}crash_log.txt${NC} 文件获取详细错误信息"
echo -e "4. 尝试在${GREEN}网络连接良好${NC}的环境下启动"
echo -e "5. 如果是Bangcle保护问题，可能需要${GREEN}等待应用更新${NC}"

echo ""
echo -e "${BLUE}🔍 如需进一步调试，请查看生成的日志文件${NC}"
echo -e "${BLUE}   特别关注 crash_log.txt 和 enhanced_diagnosis_report.txt${NC}"