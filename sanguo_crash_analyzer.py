#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
三国游戏特定闪退问题深度诊断工具
针对已知兼容性问题的专门分析
"""

import os
import zipfile
import xml.etree.ElementTree as ET
from tempfile import TemporaryDirectory
import shutil

def analyze_manifest_compatibility(apk_path):
    """分析AndroidManifest.xml的兼容性问题"""
    print("=== AndroidManifest.xml 兼容性分析 ===")
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            # 提取AndroidManifest.xml
            manifest_data = zf.read('AndroidManifest.xml')
            
            # 注意：这是二进制格式的manifest，需要特殊解析
            print("📋 检测到AndroidManifest.xml (二进制格式)")
            
            # 检查是否有AndroidManifest.xml的其他版本
            files = zf.namelist()
            manifest_files = [f for f in files if 'AndroidManifest' in f]
            print(f"📁 发现的manifest文件: {manifest_files}")
            
    except Exception as e:
        print(f"❌ 分析manifest失败: {e}")

def check_native_lib_compatibility(apk_path):
    """深度检查native库兼容性"""
    print("\n=== Native库兼容性深度分析 ===")
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            lib_files = [f for f in zf.namelist() if f.startswith('lib/') and f.endswith('.so')]
            
            if not lib_files:
                print("❌ 未找到native库文件")
                return
            
            # 按架构分组
            libs_by_arch = {}
            for lib_file in lib_files:
                parts = lib_file.split('/')
                if len(parts) >= 3:
                    arch = parts[1]
                    lib_name = parts[2]
                    
                    if arch not in libs_by_arch:
                        libs_by_arch[arch] = []
                    libs_by_arch[arch].append(lib_name)
            
            # 分析每个架构
            for arch, libs in libs_by_arch.items():
                print(f"🏗️  {arch} 架构:")
                for lib in libs:
                    lib_size = 0
                    try:
                        lib_info = zf.getinfo(lib_file)
                        lib_size = lib_info.file_size
                    except:
                        pass
                    
                    print(f"   📚 {lib} ({lib_size:,} bytes)")
                    
                    # 检查关键库
                    if 'game' in lib.lower():
                        print(f"      🎮 游戏核心库")
                    elif 'megjb' in lib.lower():
                        print(f"      🔧 Bangcle保护库")
            
            # 兼容性建议
            print("\n🎯 兼容性分析:")
            if 'armeabi-v7a' in libs_by_arch:
                print("✅ 包含armeabi-v7a库 - 兼容Android 10+")
            else:
                print("❌ 缺少armeabi-v7a库 - 可能导致Android 10+闪退")
            
            if 'arm64-v8a' in libs_by_arch:
                print("✅ 包含arm64-v8a库 - 支持现代64位设备")
            
            if 'armeabi' in libs_by_arch:
                print("⚠️  包含armeabi库 - Android 10+不支持，但保留用于兼容性")
                
    except Exception as e:
        print(f"❌ 分析native库失败: {e}")

def check_bangcle_protection_issues(apk_path):
    """检查Bangcle保护相关问题"""
    print("\n=== Bangcle保护机制分析 ===")
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            files = zf.namelist()
            
            # 检查Bangcle相关文件
            bangcle_files = [f for f in files if 'bangcle' in f.lower()]
            if bangcle_files:
                print(f"🛡️  检测到Bangcle保护文件:")
                for f in bangcle_files:
                    print(f"   - {f}")
            
            # 检查可能的保护库
            protection_libs = [f for f in files if 'lib/' in f and ('protect' in f.lower() or 'sec' in f.lower())]
            if protection_libs:
                print(f"🔒 检测到保护相关库:")
                for f in protection_libs:
                    print(f"   - {f}")
            
            # 检查assets中的保护文件
            assets_files = [f for f in files if f.startswith('assets/')]
            suspicious_assets = [f for f in assets_files if any(keyword in f.lower() for keyword in ['protect', 'sec', 'encrypt', 'bangcle'])]
            if suspicious_assets:
                print(f"📦 Assets中的可疑文件:")
                for f in suspicious_assets:
                    print(f"   - {f}")
                    
    except Exception as e:
        print(f"❌ 分析Bangcle保护失败: {e}")

def generate_specific_fixes():
    """生成针对三国游戏的特定修复建议"""
    print("\n=== 三国游戏特定修复建议 ===")
    
    fixes = """
🎮 针对三国过关斩将的已知问题修复：

1. **Bangcle保护兼容性问题**：
   - 问题：Bangcle保护在Android 10+可能不兼容
   - 症状：启动后立即闪退，无错误提示
   - 尝试：在设置中给应用所有权限，特别是存储权限

2. **网络权限问题**：
   - 问题：游戏可能需要网络验证
   - 症状：启动时检查网络后闪退
   - 解决：确保网络连接良好，授予网络权限

3. **存储权限问题**：
   - 问题：游戏需要写入外部存储
   - 症状：加载资源时闪退
   - 解决：设置 -> 应用 -> 权限 -> 存储权限

4. **Android 10+存储限制**：
   - 问题：Android 10+分区存储限制
   - 症状：无法保存游戏进度或配置
   - 解决：在应用信息中授予"所有文件访问权限"

5. **目标存储位置**：
   - 检查游戏是否尝试写入特定目录
   - 可能需要创建特定目录结构
   - /Android/data/com.bangcle.protect/files/

6. **兼容模式尝试**：
   - 在Android设置中查找兼容模式选项
   - 某些手机有"应用兼容性"设置
   - 尝试以"Android 9"兼容模式运行

7. **重新安装顺序**：
   - 完全卸载应用
   - 重启手机
   - 重新安装APK
   - 首次启动时授予所有权限
"""
    
    print(fixes)
    
    # 保存到文件
    with open('sanguo_specific_fixes.txt', 'w', encoding='utf-8') as f:
        f.write(fixes)
    print("📄 特定修复建议已保存到: sanguo_specific_fixes.txt")

def check_permissions_config(apk_path):
    """检查权限配置"""
    print("\n=== 权限配置分析 ===")
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            # 查找可能的权限相关文件
            files = zf.namelist()
            
            # 检查是否有权限声明文件
            perm_files = [f for f in files if 'permission' in f.lower() or 'manifest' in f.lower()]
            
            print("🔍 权限相关文件:")
            for f in perm_files:
                print(f"   - {f}")
            
            # 常见游戏需要的权限
            common_permissions = [
                "android.permission.INTERNET",
                "android.permission.WRITE_EXTERNAL_STORAGE", 
                "android.permission.READ_EXTERNAL_STORAGE",
                "android.permission.ACCESS_NETWORK_STATE",
                "android.permission.WAKE_LOCK",
                "android.permission.VIBRATE"
            ]
            
            print("\n📋 游戏可能需要的权限:")
            for perm in common_permissions:
                print(f"   - {perm}")
                
    except Exception as e:
        print(f"❌ 分析权限配置失败: {e}")

def create_advanced_troubleshooting_script():
    """创建高级故障排除脚本"""
    script_content = """#!/bin/bash
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
"""
    
    with open('advanced_troubleshooting.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('advanced_troubleshooting.sh', 0o755)
    print("📜 高级故障排除脚本已创建: advanced_troubleshooting.sh")

def main():
    """主函数"""
    print("🎮 三国游戏闪退深度诊断工具")
    print("=" * 60)
    
    apk_path = "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk"
    
    if not os.path.exists(apk_path):
        print(f"❌ APK文件不存在: {apk_path}")
        return
    
    # 深度分析
    analyze_manifest_compatibility(apk_path)
    check_native_lib_compatibility(apk_path)
    check_bangcle_protection_issues(apk_path)
    check_permissions_config(apk_path)
    
    # 生成特定修复建议
    generate_specific_fixes()
    
    # 创建高级脚本
    create_advanced_troubleshooting_script()
    
    print("\n" + "=" * 60)
    print("🎯 深度诊断完成！")
    print("\n📋 重要发现和建议：")
    print("1. 查看 sanguo_specific_fixes.txt 获取针对性解决方案")
    print("2. Bangcle保护可能是闪退的主要原因")
    print("3. 权限问题（特别是存储权限）很常见")
    print("4. Android 10+的存储限制可能影响游戏运行")
    print("5. 如果有adb权限，运行 ./advanced_troubleshooting.sh")

if __name__ == "__main__":
    main()