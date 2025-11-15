#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
三国志官斩 华为畅享60 闪退快速诊断工具
"""

import os
import subprocess
import sys

def check_adb_connection():
    """检查ADB连接"""
    print("🔍 检查ADB连接...")
    try:
        result = subprocess.run(['adb', 'devices'], capture_output=True, text=True)
        if 'device' in result.stdout and len(result.stdout.strip().split('\n')) > 1:
            print("✅ ADB设备已连接")
            return True
        else:
            print("❌ 未检测到ADB设备")
            print("请确保：")
            print("1. 已开启USB调试模式")
            print("2. 已连接USB线") 
            print("3. 已授权此计算机")
            return False
    except FileNotFoundError:
        print("❌ ADB未安装或不在PATH中")
        return False

def check_app_installed():
    """检查应用是否已安装"""
    print("\n📦 检查应用安装状态...")
    package = "com.idealdimension.EmpireAttack"
    
    try:
        result = subprocess.run(['adb', 'shell', 'pm', 'list', 'packages'], 
                              capture_output=True, text=True)
        if package in result.stdout:
            print("✅ 三国志官斩已安装")
            return package
        else:
            print("❌ 三国志官斩未安装")
            return None
    except Exception as e:
        print(f"❌ 检查失败: {e}")
        return None

def check_permissions(package):
    """检查应用权限状态"""
    print(f"\n🔋 检查应用权限状态...")
    
    permissions = [
        "android.permission.WRITE_EXTERNAL_STORAGE",
        "android.permission.READ_EXTERNAL_STORAGE", 
        "android.permission.INTERNET",
        "android.permission.ACCESS_NETWORK_STATE",
        "android.permission.WAKE_LOCK"
    ]
    
    for perm in permissions:
        try:
            result = subprocess.run(['adb', 'shell', 'pm', 'list', 'permissions', package], 
                                  capture_output=True, text=True)
            if perm in result.stdout:
                print(f"✅ {perm}")
            else:
                print(f"❌ {perm}")
        except:
            print(f"⚠️  无法检查 {perm}")

def check_storage_directories():
    """检查存储目录"""
    print("\n📁 检查存储目录...")
    
    directories = [
        "/sdcard/Android/data/com.idealdimension.EmpireAttack",
        "/sdcard/Android/data/com.bangcle.protect"
    ]
    
    for directory in directories:
        try:
            result = subprocess.run(['adb', 'shell', 'ls', directory], 
                                  capture_output=True, text=True)
            if result.returncode == 0:
                print(f"✅ {directory}")
            else:
                print(f"❌ {directory} (不存在)")
        except:
            print(f"⚠️  无法检查 {directory}")

def get_device_info():
    """获取设备信息"""
    print("\n📱 设备信息:")
    
    try:
        # 获取设备型号
        model = subprocess.run(['adb', 'shell', 'getprop', 'ro.product.model'], 
                            capture_output=True, text=True).stdout.strip()
        print(f"型号: {model}")
        
        # 获取Android版本
        version = subprocess.run(['adb', 'shell', 'getprop', 'ro.build.version.release'], 
                               capture_output=True, text=True).stdout.strip()
        print(f"Android版本: {version}")
        
        # 获取CPU架构
        abi = subprocess.run(['adb', 'shell', 'getprop', 'ro.product.cpu.abi'], 
                           capture_output=True, text=True).stdout.strip()
        print(f"CPU架构: {abi}")
        
    except Exception as e:
        print(f"❌ 获取设备信息失败: {e}")

def check_recent_crashes():
    """检查最近的崩溃日志"""
    print("\n💥 检查最近的崩溃日志...")
    
    try:
        # 获取最近的应用相关日志
        result = subprocess.run([
            'adb', 'shell', 'logcat', '-d', '-t', '100'
        ], capture_output=True, text=True)
        
        lines = result.stdout.split('\n')
        crash_lines = []
        
        for line in lines:
            if any(keyword in line for keyword in [
                'com.idealdimension.EmpireAttack',
                'FATAL', 
                'AndroidRuntime',
                'ActivityManager.*died',
                'Process.*crashed'
            ]):
                crash_lines.append(line)
        
        if crash_lines:
            print("发现可能的崩溃日志:")
            for line in crash_lines[-10:]:  # 显示最后10条相关日志
                print(f"  {line}")
        else:
            print("未发现明显的崩溃日志")
            
    except Exception as e:
        print(f"❌ 检查崩溃日志失败: {e}")

def generate_solutions():
    """生成解决方案建议"""
    print("\n🎯 解决方案建议:")
    
    solutions = [
        "1. 🔧 运行自动化修复脚本: ./huawei_sanguo_crash_fix.sh",
        "2. 🔋 手动授予所有权限（特别是存储权限）",
        "3. 📁 创建应用数据目录结构",
        "4. 🔄 重启设备后重新启动应用",
        "5. ⚙️  在华为设置中关闭应用启动管理",
        "6. 🌐 确保网络连接稳定",
        "7. 💾 确保存储空间充足（至少2GB可用空间）"
    ]
    
    for solution in solutions:
        print(f"   {solution}")

def main():
    """主函数"""
    print("🎮 三国志官斩 华为畅享60 闪退快速诊断")
    print("=" * 50)
    
    # 检查ADB连接
    if not check_adb_connection():
        sys.exit(1)
    
    # 获取设备信息
    get_device_info()
    
    # 检查应用安装
    package = check_app_installed()
    if not package:
        print("\n请先安装APK文件后再运行此诊断工具")
        sys.exit(1)
    
    # 检查权限
    check_permissions(package)
    
    # 检查存储目录
    check_storage_directories()
    
    # 检查崩溃日志
    check_recent_crashes()
    
    # 生成解决方案
    generate_solutions()
    
    print("\n" + "=" * 50)
    print("🎯 诊断完成！")
    print("\n💡 下一步操作:")
    print("1. 运行 ./huawei_sanguo_crash_fix.sh 进行自动修复")
    print("2. 查看 华为畅享60_闪退解决方案.md 获取详细说明")
    print("3. 如果问题持续，收集更多日志信息进行分析")

if __name__ == "__main__":
    main()