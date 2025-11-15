#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Bangcle保护兼容性修复工具
专门解决三国游戏Bangcle保护在Android 10+上的兼容性问题
"""

import os
import zipfile
import tempfile
import shutil
import subprocess

def create_bangcle_compatibility_fix():
    """创建Bangcle兼容性修复方案"""
    print("🛡️ Bangcle保护兼容性修复工具")
    print("=" * 50)
    
    print("\n📋 Bangcle保护问题分析:")
    print("1. Bangcle是2015年流行的应用保护方案")
    print("2. 在Android 10+上存在兼容性问题")
    print("3. 主要问题：")
    print("   - 动态库加载失败")
    print("   - 存储权限限制")
    print("   - 网络验证超时")
    print("   - 加密算法不兼容")

def create_permission_fix_script():
    """创建权限修复脚本"""
    script_content = """#!/bin/bash
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
"""
    
    with open('fix_permissions.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('fix_permissions.sh', 0o755)
    print("📜 权限修复脚本已创建: fix_permissions.sh")

def create_storage_fix():
    """创建存储修复方案"""
    print("\n💾 创建Android 10+存储兼容性修复...")
    
    fix_instructions = """
# Android 10+ 存储兼容性修复指南

## 问题说明
Android 10+引入了分区存储(Scoped Storage)，限制了应用对外部存储的访问。
三国游戏可能需要写入特定目录来保存配置和游戏数据。

## 手动修复步骤

### 1. 授予所有文件访问权限
- 设置 -> 应用 -> 三国游戏 -> 权限
- 找到"存储权限"或"文件和媒体"
- 选择"所有文件访问权限"

### 2. 创建必要目录
如果需要手动创建目录（需要root）：
```
mkdir -p /sdcard/Android/data/com.bangcle.protect/files
mkdir -p /sdcard/Android/data/com.bangcle.protect/cache
chmod -R 777 /sdcard/Android/data/com.bangcle.protect
```

### 3. 检查存储空间
- 确保设备有足够的存储空间
- 清理不必要的文件
- 检查SD卡状态

### 4. 检查文件系统
- 确保SD卡格式正确
- 尝试使用内部存储而非SD卡
- 检查文件权限

## 自动化脚本
运行 storage_fix.sh 自动修复存储问题（需要root）
"""
    
    with open('storage_fix_instructions.txt', 'w', encoding='utf-8') as f:
        f.write(fix_instructions)
    
    print("📄 存储修复指南已创建: storage_fix_instructions.txt")

def create_storage_fix_script():
    """创建存储修复脚本"""
    script_content = """#!/bin/bash
# Android 10+ 存储修复脚本

echo "💾 Android 10+ 存储修复"
echo "====================="

PACKAGE="com.bangcle.protect"
DATA_DIR="/sdcard/Android/data/$PACKAGE"
CACHE_DIR="/sdcard/Android/data/$PACKAGE/cache"

echo "📁 检查应用数据目录..."

if [ -d "$DATA_DIR" ]; then
    echo "✅ 应用数据目录已存在: $DATA_DIR"
else
    echo "🔧 创建应用数据目录..."
    mkdir -p "$DATA_DIR"
    mkdir -p "$CACHE_DIR"
fi

echo "🔧 设置目录权限..."
chmod -R 755 "$DATA_DIR"
chown -R system:system "$DATA_DIR" 2>/dev/null

echo "🔧 创建游戏需要的子目录..."
mkdir -p "$DATA_DIR/files"
mkdir -p "$DATA_DIR/cache"
mkdir -p "$DATA_DIR/databases"
mkdir -p "$DATA_DIR/shared_prefs"

chmod -R 777 "$DATA_DIR/files"

echo "📊 目录结构:"
ls -la "$DATA_DIR"

echo ""
echo "💾 存储修复完成"
echo "💡 如果问题仍然存在，可能需要："
echo "1. 重启设备"
echo "2. 清空应用数据后重新设置"
echo "3. 检查SD卡状态"
"""
    
    with open('storage_fix.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('storage_fix.sh', 0o755)
    print("📜 存储修复脚本已创建: storage_fix.sh")

def create_compatibility_launcher():
    """创建兼容性启动器"""
    print("\n🚀 创建兼容性启动器...")
    
    launcher_instructions = """
# 三国游戏兼容性启动器使用指南

## 问题
Bangcle保护在Android 10+上可能因为权限或兼容性问题导致启动失败。

## 解决方案

### 方案1: 权限预设启动
1. 在启动游戏前，确保所有权限已授予
2. 关闭所有后台应用
3. 在网络连接良好的环境下启动

### 方案2: 兼容模式启动
某些设备支持兼容模式：
- 设置 -> 应用 -> 三国游戏 -> 高级设置
- 查找"兼容模式"或"Android版本兼容性"
- 选择"Android 9"或更低版本

### 方案3: 环境预设启动
1. 重启设备
2. 不要打开其他应用
3. 确保存储空间充足
4. 连接WiFi网络
5. 启动游戏

### 方案4: 调试模式启动
如果设备支持开发者选项：
- 开启USB调试
- 使用adb启动应用
- 监控启动过程
- 捕获详细错误信息

## 启动脚本
运行 compatibility_launcher.sh 进行兼容性启动
"""
    
    with open('compatibility_launcher_guide.txt', 'w', encoding='utf-8') as f:
        f.write(launcher_instructions)
    
    print("📄 兼容性启动指南已创建: compatibility_launcher_guide.txt")

def create_compatibility_script():
    """创建兼容性启动脚本"""
    script_content = """#!/bin/bash
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
"""
    
    with open('compatibility_launcher.sh', 'w') as f:
        f.write(script_content)
    
    os.chmod('compatibility_launcher.sh', 0o755)
    print("📜 兼容性启动脚本已创建: compatibility_launcher.sh")

def create_complete_fix_guide():
    """创建完整修复指南"""
    print("\n📚 创建完整修复指南...")
    
    complete_guide = """
# 三国游戏Bangcle保护完整修复指南

## 🎯 问题诊断
您遇到的问题是：安装了 sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk 后无法运行，闪退。

经过分析，主要原因是：
1. Bangcle保护机制在Android 10+上的兼容性问题
2. 存储权限限制
3. 可能的网络验证问题

## 🔧 分步修复方案

### 第1步：基础权限修复
```bash
# 如果有adb权限，运行：
./fix_permissions.sh

# 手动设置：
设置 -> 应用 -> 三国游戏 -> 权限 -> 全部允许
```

### 第2步：存储兼容性修复
```bash
# 如果有root权限，运行：
./storage_fix.sh

# 手动设置：
设置 -> 应用 -> 三国游戏 -> 权限 -> 存储权限 -> 所有文件访问权限
```

### 第3步：兼容性启动
```bash
# 运行兼容性启动器：
./compatibility_launcher.sh
```

### 第4步：环境优化
1. 重启设备
2. 确保WiFi连接稳定
3. 关闭不必要的后台应用
4. 确保存储空间充足（至少1GB）

### 第5步：高级修复（如果上述方法无效）
1. 完全卸载应用
2. 重启设备
3. 重新安装APK
4. 首次启动时立即授予所有权限
5. 不要跳过任何权限请求

## 🚨 常见问题解决

### 问题1：启动后立即闪退
- 原因：Bangcle保护初始化失败
- 解决：确保所有权限已授予，特别是存储权限

### 问题2：加载时闪退
- 原因：资源文件加载失败
- 解决：检查存储空间，确保网络连接

### 问题3：检查权限后闪退
- 原因：Android 10+权限模型变更
- 解决：授予"所有文件访问权限"

### 问题4：网络验证失败
- 原因：防火墙或网络设置问题
- 解决：确保网络畅通，尝试切换网络

## 📞 获取更多帮助

如果问题仍然存在：
1. 运行诊断工具收集更多信息
2. 提供设备型号和Android版本
3. 描述具体的闪退时机和现象
4. 提供崩溃日志（如果可能）

## 🔍 调试信息收集

使用以下命令收集调试信息：
```bash
# 收集应用信息
dumpsys package com.bangcle.protect > app_info.txt

# 收集崩溃日志
adb logcat | grep -E "(FATAL|AndroidRuntime|Bangcle|三国)"

# 检查权限状态
dumpsys package com.bangcle.protect | grep permission
```
"""
    
    with open('complete_fix_guide.md', 'w', encoding='utf-8') as f:
        f.write(complete_guide)
    
    print("📄 完整修复指南已创建: complete_fix_guide.md")

def main():
    """主函数"""
    print("🛡️ Bangcle保护兼容性修复工具")
    print("=" * 60)
    print("专门解决三国游戏在Android 10+上的闪退问题")
    
    create_bangcle_compatibility_fix()
    create_permission_fix_script()
    create_storage_fix()
    create_storage_fix_script()
    create_compatibility_launcher()
    create_compatibility_script()
    create_complete_fix_guide()
    
    print("\n" + "=" * 60)
    print("🎯 Bangcle修复工具创建完成！")
    print("\n📋 生成的文件：")
    print("🔧 fix_permissions.sh - 权限修复脚本")
    print("💾 storage_fix.sh - 存储修复脚本")
    print("🚀 compatibility_launcher.sh - 兼容性启动器")
    print("📚 storage_fix_instructions.txt - 存储修复指南")
    print("📖 compatibility_launcher_guide.txt - 启动指南")
    print("📄 complete_fix_guide.md - 完整修复指南")
    
    print("\n🎯 使用建议：")
    print("1. 首先阅读 complete_fix_guide.md")
    print("2. 按步骤执行修复脚本")
    print("3. 如果有adb权限，优先使用脚本自动修复")
    print("4. 如果没有adb权限，按指南手动设置")
    print("5. 问题解决后，建议保存这些工具以备后用")

if __name__ == "__main__":
    main()