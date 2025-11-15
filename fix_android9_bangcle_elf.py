#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Android 9 Bangcle ELF兼容性修复工具
专门解决libsecexe.x86.so的e_shentsize=0x0问题
"""

import os
import sys
import struct
import zipfile
import shutil
import tempfile
from pathlib import Path

def fix_elf_header_for_android9(lib_file_path):
    """修复ELF头使其兼容Android 9"""
    print(f"🔧 修复ELF头: {lib_file_path}")
    
    try:
        with open(lib_file_path, 'rb') as f:
            data = bytearray(f.read())
        
        # 检查ELF头
        if len(data) < 48 or data[:4] != b'\x7fELF':
            print(f"  ❌ 不是有效的ELF文件")
            return False
        
        # 获取当前e_shentsize
        e_shentsize = struct.unpack('<H', data[46:48])[0]
        print(f"  当前e_shentsize: 0x{e_shentsize:04x}")
        
        if e_shentsize != 0:
            print(f"  ✓ e_shentsize正常，无需修复")
            return True
        
        # 修复e_shentsize为标准值0x28 (40字节)
        struct.pack_into('<H', data, 46, 0x28)
        
        # 备份原文件
        backup_path = lib_file_path + ".backup"
        shutil.copy2(lib_file_path, backup_path)
        
        # 写入修复后的文件
        with open(lib_file_path, 'wb') as f:
            f.write(data)
        
        print(f"  ✓ 已修复e_shentsize为0x28")
        print(f"  ✓ 原文件备份至: {backup_path}")
        
        return True
        
    except Exception as e:
        print(f"  ❌ 修复失败: {e}")
        return False

def extract_and_fix_libs_from_apk(apk_path, output_dir):
    """从APK中提取并修复Bangcle库"""
    print(f"\n📦 从APK中提取Bangcle库: {apk_path}")
    
    # 需要修复的库文件列表
    libs_to_fix = [
        'assets/libsecexe.so',
        'assets/libsecexe.x86.so',
        'assets/libsecmain.so',
        'assets/libsecmain.x86.so',
        'assets/libmegbpp_02.02.09_01.so'
    ]
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zip_file:
            os.makedirs(output_dir, exist_ok=True)
            
            fixed_libs = []
            for lib_path in libs_to_fix:
                if lib_path in zip_file.namelist():
                    # 提取库文件
                    lib_data = zip_file.read(lib_path)
                    lib_name = os.path.basename(lib_path)
                    output_path = os.path.join(output_dir, lib_name)
                    
                    # 保存库文件
                    with open(output_path, 'wb') as f:
                        f.write(lib_data)
                    
                    print(f"  提取: {lib_name}")
                    
                    # 修复ELF头
                    if fix_elf_header_for_android9(output_path):
                        fixed_libs.append(lib_name)
                else:
                    print(f"  ⚠️  未找到: {lib_path}")
            
            return fixed_libs
            
    except Exception as e:
        print(f"❌ 提取失败: {e}")
        return []

def rebuild_apk_with_fixed_libs(original_apk, fixed_libs_dir, output_apk):
    """重新构建APK，使用修复后的库文件"""
    print(f"\n📦 重新构建APK: {output_apk}")
    
    try:
        # 创建临时目录
        temp_dir = tempfile.mkdtemp(prefix="apk_rebuild_")
        
        # 提取原始APK
        with zipfile.ZipFile(original_apk, 'r') as zip_file:
            zip_file.extractall(temp_dir)
        
        # 替换库文件
        assets_dir = os.path.join(temp_dir, "assets")
        if os.path.exists(assets_dir):
            for lib_file in os.listdir(fixed_libs_dir):
                src_path = os.path.join(fixed_libs_dir, lib_file)
                dst_path = os.path.join(assets_dir, lib_file)
                
                shutil.copy2(src_path, dst_path)
                print(f"  替换: {lib_file}")
        
        # 删除META-INF（需要重新签名）
        meta_inf_dir = os.path.join(temp_dir, "META-INF")
        if os.path.exists(meta_inf_dir):
            shutil.rmtree(meta_inf_dir)
            print("  删除META-INF目录")
        
        # 重新打包
        with zipfile.ZipFile(output_apk, 'w', zipfile.ZIP_DEFLATED) as zip_out:
            for root, dirs, files in os.walk(temp_dir):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, temp_dir)
                    zip_out.write(file_path, arcname)
        
        # 清理临时目录
        shutil.rmtree(temp_dir)
        
        size_mb = os.path.getsize(output_apk) / (1024*1024)
        print(f"  ✓ 新APK大小: {size_mb:.2f} MB")
        
        return True
        
    except Exception as e:
        print(f"❌ 重建失败: {e}")
        return False

def sign_apk_simple(apk_path):
    """简单的APK签名（使用debug keystore）"""
    print(f"\n🔐 签名APK: {apk_path}")
    
    try:
        # 检查是否有Android build-tools
        result = os.system("which zipalign > /dev/null 2>&1")
        if result != 0:
            print("  ⚠️  未找到zipalign，跳过对齐")
            aligned_apk = apk_path
        else:
            # 对齐APK
            aligned_apk = apk_path.replace(".apk", "_aligned.apk")
            os.system(f"zipalign -v 4 {apk_path} {aligned_apk}")
            if os.path.exists(aligned_apk):
                os.remove(apk_path)
                os.rename(aligned_apk, apk_path)
                print("  ✓ APK对齐完成")
        
        # 创建debug keystore
        keystore = "debug.keystore"
        if not os.path.exists(keystore):
            os.system(f'keytool -genkey -v -keystore {keystore} -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"')
            print("  ✓ 创建debug keystore")
        
        # 签名
        result = os.system(f'jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore {keystore} -storepass android -keypass android {apk_path} androiddebugkey')
        
        if result == 0:
            print("  ✓ APK签名完成")
            return True
        else:
            print("  ❌ APK签名失败")
            return False
            
    except Exception as e:
        print(f"❌ 签名过程出错: {e}")
        return False

def main():
    print("=" * 70)
    print("Android 9 Bangcle ELF兼容性修复工具")
    print("=" * 70)
    print("解决libsecexe.x86.so的e_shentsize=0x0问题")
    
    # 文件路径配置
    source_apk = "sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk"
    fixed_libs_dir = "temp_fixed_libs"
    output_apk = "sanguozhiguoguanzhanjiang_downcc_android9_elf_fixed.apk"
    
    # 检查源APK
    if not os.path.exists(source_apk):
        print(f"\n❌ 源APK文件不存在: {source_apk}")
        print("\n请确保以下文件存在:")
        print("  - sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk")
        return False
    
    try:
        # 第一步：提取并修复库文件
        print("\n🔧 第一步：提取并修复Bangcle库文件")
        fixed_libs = extract_and_fix_libs_from_apk(source_apk, fixed_libs_dir)
        
        if not fixed_libs:
            print("❌ 没有找到或修复任何库文件")
            return False
        
        print(f"✓ 成功修复 {len(fixed_libs)} 个库文件")
        
        # 第二步：重新构建APK
        print("\n🔧 第二步：重新构建APK")
        temp_apk = output_apk.replace(".apk", "_temp.apk")
        
        if not rebuild_apk_with_fixed_libs(source_apk, fixed_libs_dir, temp_apk):
            print("❌ APK重建失败")
            return False
        
        # 第三步：签名APK
        print("\n🔧 第三步：签名APK")
        if not sign_apk_simple(temp_apk):
            print("❌ APK签名失败")
            return False
        
        # 移动到最终位置
        shutil.move(temp_apk, output_apk)
        
        # 清理临时文件
        if os.path.exists(fixed_libs_dir):
            shutil.rmtree(fixed_libs_dir)
        
        print("\n" + "=" * 70)
        print("✓ Android 9 Bangcle兼容性修复完成！")
        print("=" * 70)
        print(f"\n📱 输出文件: {output_apk}")
        print(f"\n🚀 安装命令:")
        print(f"   adb install -r {output_apk}")
        
        print("\n🎯 修复内容:")
        print("  ✓ 修复libsecexe.x86.so的ELF头")
        print("  ✓ 修复libsecexe.so的ELF头")
        print("  ✓ 修复其他Bangcle保护库")
        print("  ✓ 重新签名APK")
        
        print("\n💡 使用说明:")
        print("  1. 卸载现有版本: adb uninstall com.idealdimension.EmpireAttack")
        print("  2. 安装修复版本: adb install -r " + output_apk)
        print("  3. 启动应用测试")
        print("  4. 如果仍有问题，请检查权限设置")
        
        return True
        
    except Exception as e:
        print(f"\n❌ 修复过程出错: {e}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)