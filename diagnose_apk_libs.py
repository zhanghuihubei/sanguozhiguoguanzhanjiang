#!/usr/bin/env python3
"""
诊断APK中的库文件完整性
检查原始APK和修改后APK中的so文件是否正常
"""

import os
import sys
import struct
import tempfile
import zipfile
from pathlib import Path

def check_elf_header(so_file_content, lib_name):
    """检查ELF文件头的有效性"""
    print(f"\n检查: {lib_name}")
    print(f"  文件大小: {len(so_file_content)} 字节")
    
    if len(so_file_content) < 52:
        print(f"  ❌ 文件过小（少于52字节，无法完整解析ELF头）")
        return False
    
    # 检查ELF魔数
    if so_file_content[:4] != b'\x7fELF':
        print(f"  ❌ 不是有效的ELF文件（魔数错误）")
        return False
    
    print(f"  ✓ ELF魔数正确")
    
    try:
        # 解析ELF头
        ei_class = so_file_content[4]  # 32/64位
        ei_data = so_file_content[5]   # 字节序
        ei_version = so_file_content[6]  # ELF版本
        ei_osabi = so_file_content[7]  # OS/ABI
        
        # 根据字节序解析
        is_le = (ei_data == 1)
        endian = '<' if is_le else '>'
        
        # e_machine (字节16-17)
        e_machine = struct.unpack(endian + 'H', so_file_content[18:20])[0]
        
        # e_entry (字节32-35 或 32-39)
        if ei_class == 1:  # 32-bit
            e_entry = struct.unpack(endian + 'I', so_file_content[28:32])[0]
            e_phoff = struct.unpack(endian + 'I', so_file_content[32:36])[0]
            e_shoff = struct.unpack(endian + 'I', so_file_content[36:40])[0]
            e_shentsize = struct.unpack(endian + 'H', so_file_content[46:48])[0]
        else:  # 64-bit
            e_entry = struct.unpack(endian + 'Q', so_file_content[32:40])[0]
            e_phoff = struct.unpack(endian + 'Q', so_file_content[32:40])[0]
            e_shoff = struct.unpack(endian + 'Q', so_file_content[40:48])[0]
            e_shentsize = struct.unpack(endian + 'H', so_file_content[58:60])[0]
        
        arch_names = {
            0x03: "Intel 80386 (x86)",
            0x28: "ARM v5/v6 (armeabi)",
            0x97: "ARM v7 (armeabi-v7a)",
            0xb7: "ARM 64-bit (arm64-v8a)",
            0x3e: "x86-64",
            0xf7: "ARM AARCH64",
        }
        
        arch = arch_names.get(e_machine, f"Unknown (0x{e_machine:x})")
        
        print(f"  ✓ ELF类: {'32-bit' if ei_class == 1 else '64-bit'}")
        print(f"  ✓ 字节序: {'Little Endian' if is_le else 'Big Endian'}")
        print(f"  ✓ 架构: {arch}")
        print(f"  ✓ e_entry: 0x{e_entry:08x}")
        print(f"  ✓ e_shoff: 0x{e_shoff:08x}")
        print(f"  ✓ e_shentsize: 0x{e_shentsize:02x}")
        
        if e_shentsize == 0:
            print(f"  ❌ e_shentsize为0（已损坏！应该是0x28或0x40）")
            return False
        
        return True
        
    except Exception as e:
        print(f"  ❌ 解析错误: {e}")
        return False

def analyze_apk_libs(apk_path):
    """分析APK中的库文件"""
    print("\n" + "=" * 70)
    print(f"分析APK: {apk_path}")
    print("=" * 70)
    
    if not os.path.exists(apk_path):
        print(f"❌ APK文件不存在: {apk_path}")
        return
    
    try:
        with zipfile.ZipFile(apk_path, 'r') as zip_file:
            # 列出所有so文件
            so_files = [f for f in zip_file.namelist() if f.endswith('.so')]
            print(f"\n找到 {len(so_files)} 个so库文件")
            
            # 按目录分组
            lib_by_dir = {}
            for so in so_files:
                dir_name = os.path.dirname(so)
                if dir_name not in lib_by_dir:
                    lib_by_dir[dir_name] = []
                lib_by_dir[dir_name].append(so)
            
            # 显示库文件结构
            for lib_dir in sorted(lib_by_dir.keys()):
                print(f"\n📁 {lib_dir}/ ({len(lib_by_dir[lib_dir])} 个文件)")
                
                for so_file in sorted(lib_by_dir[lib_dir]):
                    so_data = zip_file.read(so_file)
                    lib_name = os.path.basename(so_file)
                    
                    # 检查文件完整性
                    check_elf_header(so_data, lib_name)
                    
    except zipfile.BadZipFile:
        print(f"❌ 无效的ZIP文件: {apk_path}")
    except Exception as e:
        print(f"❌ 错误: {e}")

def main():
    apks = [
        "sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk",
        "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk"
    ]
    
    for apk in apks:
        if os.path.exists(apk):
            analyze_apk_libs(apk)
        else:
            print(f"⚠️  APK文件不存在: {apk}")

if __name__ == "__main__":
    main()
