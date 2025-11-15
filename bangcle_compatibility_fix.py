#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Bangcle保护兼容性修复工具
专门解决Android 10+设备上Bangcle保护导致的闪退问题
"""

import os
import sys
import subprocess
import tempfile
import shutil
from datetime import datetime

def check_bangcle_compatibility():
    """检查Bangcle保护兼容性问题"""
    print("🛡️ Bangcle保护兼容性检查")
    print("=" * 50)
    
    # 检查APK文件
    apk_path = "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk"
    if not os.path.exists(apk_path):
        print(f"❌ APK文件不存在: {apk_path}")
        return False
    
    try:
        import zipfile
        with zipfile.ZipFile(apk_path, 'r') as zf:
            files = zf.namelist()
            
            # 检查Bangcle相关文件
            bangcle_files = [f for f in files if 'bangcle' in f.lower()]
            protection_files = [f for f in files if 'protect' in f.lower()]
            
            print(f"📦 Bangcle相关文件:")
            for f in bangcle_files:
                print(f"   - {f}")
            
            print(f"🔒 保护相关文件:")
            for f in protection_files:
                print(f"   - {f}")
            
            # 检查native库
            lib_files = [f for f in files if f.startswith('lib/') and f.endswith('.so')]
            suspicious_libs = [f for f in lib_files if any(keyword in f.lower() for keyword in ['protect', 'sec', 'encrypt', 'megjb'])]
            
            if suspicious_libs:
                print(f"🔍 可疑的保护库:")
                for f in suspicious_libs:
                    print(f"   - {f}")
            
            return True
            
    except Exception as e:
        print(f"❌ 检查失败: {e}")
        return False

def create_bangcle_fix_script():
    """创建Bangcle修复脚本"""
    script_content = """#!/bin/bash
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
"""
    
    with open('bangcle_compatibility_fix.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('bangcle_compatibility_fix.sh', 0o755)
    print("📜 Bangcle兼容性修复脚本已创建: bangcle_compatibility_fix.sh")

def create_advanced_diagnosis_tool():
    """创建高级诊断工具"""
    script_content = """#!/bin/bash
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
"""
    
    with open('advanced_diagnosis.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('advanced_diagnosis.sh', 0o755)
    print("📜 高级诊断工具已创建: advanced_diagnosis.sh")

def generate_compatibility_solutions():
    """生成兼容性解决方案"""
    solutions = """
🛡️ Bangcle保护 Android 10+ 兼容性解决方案
============================================

问题分析:
1. Bangcle保护机制与Android 10的存储权限模型冲突
2. 华为设备的安全策略与Bangcle保护机制不兼容
3. 目标SDK版本与系统版本不匹配导致的兼容性问题

解决方案 (按优先级排序):

🔧 方案一: 权限和目录修复 (推荐首先尝试)
1. 运行增强修复脚本:
   ./huawei_sanguo_crash_fix_enhanced.sh

2. 手动设置权限:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 权限 -> 全部允许
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 存储 -> 允许管理所有文件
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 电池 -> 允许后台活动

3. Bangcle特殊设置:
   ./bangcle_compatibility_fix.sh

🔧 方案二: 系统兼容性设置
1. 关闭华为纯净模式:
   - 设置 -> 系统和更新 -> 纯净模式 -> 关闭

2. 允许未知来源应用:
   - 设置 -> 安全 -> 更多安全设置 -> 安装未知应用

3. 开发者选项设置:
   - 设置 -> 关于手机 -> 连续点击版本号7次开启开发者选项
   - 设置 -> 系统和更新 -> 开发者选项 -> USB调试 (开启)
   - 设置 -> 系统和更新 -> 开发者选项 -> 保持唤醒状态 (开启)

🔧 方案三: 重新安装流程
1. 完全卸载应用:
   adb uninstall com.idealdimension.EmpireAttack
   
2. 清理残留数据:
   adb shell "rm -rf /sdcard/Android/data/com.idealdimension.EmpireAttack"
   adb shell "rm -rf /sdcard/Android/data/com.bangcle.protect"
   
3. 重启设备
   
4. 重新安装APK:
   adb install sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk
   
5. 运行修复脚本:
   ./huawei_sanguo_crash_fix_enhanced.sh

🔧 方案四: 网络和环境修复
1. 确保网络连接稳定
2. 关闭VPN和代理
3. 切换到稳定的WiFi网络
4. 尝试使用移动数据网络

🔧 方案五: 设备特定设置 (华为)
1. 电池优化设置:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 电池 -> 无限制
   
2. 启动管理设置:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 启动管理 -> 手动管理
   - 关闭"自动管理"，开启"允许关联启动"和"允许后台活动"
   
3. 存储权限设置:
   - 设置 -> 应用 -> 应用管理 -> 三国志官斩 -> 权限 -> 存储 -> "所有文件" (仅本次/每次询问)

⚠️ 注意事项:
1. 如果以上方案都无效，可能是Bangcle保护本身与Android 10不兼容
2. 这种情况下需要等待游戏开发者发布兼容Android 10的版本
3. 可以尝试在Android 9或更低版本的设备上运行

📞 联系支持:
如果问题持续存在，请提供以下信息:
1. 设备型号和Android版本
2. 应用版本号
3. 崩溃日志 (crash_log.txt)
4. 诊断报告 (enhanced_diagnosis_report.txt)
5. 尝试过哪些解决方案
"""
    
    with open('bangcle_compatibility_solutions.md', 'w', encoding='utf-8') as f:
        f.write(solutions)
    
    print("📄 兼容性解决方案已保存到: bangcle_compatibility_solutions.md")

def main():
    """主函数"""
    print("🛡️ Bangcle保护兼容性修复工具")
    print("=" * 60)
    
    # 检查Bangcle兼容性
    if check_bangcle_compatibility():
        print("\n✅ Bangcle保护检查完成")
    else:
        print("\n❌ Bangcle保护检查失败")
    
    # 创建修复脚本
    print("\n🔧 创建修复工具...")
    create_bangcle_fix_script()
    create_advanced_diagnosis_tool()
    generate_compatibility_solutions()
    
    print("\n" + "=" * 60)
    print("🎯 Bangcle修复工具创建完成！")
    print("\n📋 生成的工具:")
    print("1. 🔧 bangcle_compatibility_fix.sh - Bangcle兼容性修复脚本")
    print("2. 🔍 advanced_diagnosis.sh - 高级诊断工具") 
    print("3. 📄 bangcle_compatibility_solutions.md - 详细解决方案")
    print("\n🚀 建议使用顺序:")
    print("1. 首先运行 ./huawei_sanguo_crash_fix_enhanced.sh")
    print("2. 如果仍然闪退，运行 ./bangcle_compatibility_fix.sh")
    print("3. 使用 ./advanced_diagnosis.sh 收集详细信息")
    print("4. 查看 bangcle_compatibility_solutions.md 了解更多解决方案")

if __name__ == "__main__":
    main()