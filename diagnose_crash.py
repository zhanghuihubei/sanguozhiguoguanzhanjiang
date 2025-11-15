#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
三国游戏闪退诊断工具
用于分析APK安装后的运行时崩溃问题
"""

import os
import sys
import subprocess
import tempfile
import shutil
from datetime import datetime

def check_apk_info(apk_path):
    """检查APK基本信息"""
    print("=== APK信息检查 ===")
    
    if not os.path.exists(apk_path):
        print(f"❌ APK文件不存在: {apk_path}")
        return False
    
    file_size = os.path.getsize(apk_path) / (1024 * 1024)  # MB
    print(f"📦 APK文件: {apk_path}")
    print(f"📏 文件大小: {file_size:.1f} MB")
    
    # 尝试使用aapt检查APK信息（如果可用）
    try:
        result = subprocess.run(['aapt', 'dump', 'badging', apk_path], 
                              capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            lines = result.stdout.split('\n')
            for line in lines:
                if 'package:' in line:
                    print(f"📱 包信息: {line}")
                elif 'sdkVersion:' in line or 'targetSdkVersion:' in line:
                    print(f"🔧 SDK版本: {line}")
                elif 'native-code:' in line:
                    print(f"🏗️  支持架构: {line}")
        else:
            print("⚠️  aapt工具不可用，无法详细分析APK")
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("⚠️  aapt工具不可用，跳过详细分析")
    
    return True

def check_system_info():
    """检查系统环境"""
    print("\n=== 系统环境检查 ===")
    
    # 检查操作系统
    print(f"💻 操作系统: {os.name}")
    
    # 检查Python版本
    print(f"🐍 Python版本: {sys.version}")
    
    # 检查可用工具
    tools = ['adb', 'aapt', 'java', 'keytool']
    for tool in tools:
        try:
            result = subprocess.run([tool, '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print(f"✅ {tool}: 已安装")
            else:
                print(f"❌ {tool}: 未正确安装")
        except (subprocess.TimeoutExpired, FileNotFoundError):
            print(f"❌ {tool}: 未找到")

def generate_crash_analysis_guide():
    """生成崩溃分析指南"""
    print("\n=== 闪退问题分析指南 ===")
    
    guide = """
🔍 闪退问题诊断步骤：

1. **获取崩溃日志** (最重要)：
   - 如果有adb访问权限：
     adb logcat > crash_log.txt
     然后启动游戏，等待闪退，停止logcat
     搜索关键词：FATAL、AndroidRuntime、三国、包名
   
   - 如果没有adb：
     在手机上安装"Logcat Reader"等应用
     或在开发者选项中开启USB调试

2. **常见闪退原因**：
   - 权限问题：存储、网络等权限被拒绝
   - 兼容性问题：Android 10+新限制
   - 资源加载失败：assets文件损坏
   - 网络连接问题：需要网络验证
   - 加载保护：Bangcle保护机制冲突

3. **立即尝试的解决方案**：
   - 重启手机后再次尝试
   - 清空应用数据和缓存
   - 检查是否授予了所有必要权限
   - 在网络连接良好的环境下尝试

4. **信息收集**：
   - 闪退时的具体时间
   - 闪退前是否有错误提示
   - 手机型号和Android版本
   - 是否root或安装了Xposed等框架
"""
    
    print(guide)
    
    # 保存指南到文件
    with open('crash_diagnosis_guide.txt', 'w', encoding='utf-8') as f:
        f.write(guide)
    print("📄 详细指南已保存到: crash_diagnosis_guide.txt")

def create_logcat_script():
    """创建logcat收集脚本"""
    script_content = """#!/bin/bash
# 崩溃日志收集脚本

echo "开始收集崩溃日志..."
echo "请确保手机已连接并开启USB调试"

# 检查设备连接
adb devices

echo "按回车键开始记录日志，然后启动游戏等待闪退..."
read

# 清空现有日志
adb logcat -c

# 开始记录日志
echo "正在记录日志... 闪退后按Ctrl+C停止"
adb logcat > game_crash_log.txt

echo "日志已保存到 game_crash_log.txt"

# 分析关键错误
echo "分析关键错误..."
grep -E "(FATAL|AndroidRuntime|Exception|Error|三国)" game_crash_log.txt > crash_errors.txt

echo "错误信息已提取到 crash_errors.txt"
"""
    
    with open('collect_crash_log.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('collect_crash_log.sh', 0o755)
    print("📜 日志收集脚本已创建: collect_crash_log.sh")

def check_apk_integrity(apk_path):
    """检查APK完整性"""
    print("\n=== APK完整性检查 ===")
    
    try:
        # 检查ZIP文件结构
        import zipfile
        with zipfile.ZipFile(apk_path, 'r') as zf:
            files = zf.namelist()
            
            # 检查关键文件
            required_files = [
                'AndroidManifest.xml',
                'classes.dex',
                'resources.arsc'
            ]
            
            missing_files = []
            for req_file in required_files:
                if not any(req_file in f for f in files):
                    missing_files.append(req_file)
            
            if missing_files:
                print(f"❌ 缺少关键文件: {missing_files}")
            else:
                print("✅ 关键文件完整")
            
            # 检查native库
            lib_files = [f for f in files if f.startswith('lib/')]
            if lib_files:
                print(f"📚 Native库文件:")
                for lib in sorted(set(f.split('/')[1] for f in lib_files if '/' in f)):
                    print(f"   - {lib}")
            else:
                print("⚠️  未找到native库文件")
                
    except zipfile.BadZipFile:
        print("❌ APK文件损坏或不是有效的ZIP文件")
        return False
    except Exception as e:
        print(f"❌ 检查APK时出错: {e}")
        return False
    
    return True

def main():
    """主函数"""
    print("🎮 三国游戏闪退诊断工具")
    print("=" * 50)
    
    # APK文件路径
    apk_path = "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk"
    
    # 检查APK信息
    if not check_apk_info(apk_path):
        return
    
    # 检查系统环境
    check_system_info()
    
    # 检查APK完整性
    check_apk_integrity(apk_path)
    
    # 生成分析指南
    generate_crash_analysis_guide()
    
    # 创建日志收集脚本
    create_logcat_script()
    
    print("\n" + "=" * 50)
    print("📋 诊断完成！")
    print("\n🎯 下一步建议：")
    print("1. 查看 crash_diagnosis_guide.txt 获取详细分析步骤")
    print("2. 如果有adb，运行 ./collect_crash_log.sh 收集崩溃日志")
    print("3. 将崩溃日志发送给开发者进一步分析")
    print("4. 尝试基本的故障排除步骤（重启、权限检查等）")

if __name__ == "__main__":
    main()