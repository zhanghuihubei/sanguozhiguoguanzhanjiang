#!/usr/bin/env python3
"""
修复Bangcle库文件损坏问题
从原始APK中提取assets/中的保护库文件，
重新打包修改后的APK以恢复其完整性
"""

import os
import sys
import zipfile
import shutil
from pathlib import Path

def extract_protected_libs_from_original(original_apk, target_dir):
    """从原始APK中提取Bangcle保护库"""
    print(f"\n📦 从原始APK中提取Bangcle保护库...")
    
    # assets目录中的保护库列表（来自诊断结果）
    protected_libs = [
        'libmegbpp_02.02.09_01.so',
        'libsecexe.so',
        'libsecexe.x86.so',
        'libsecmain.so',
        'libsecmain.x86.so',
    ]
    
    try:
        with zipfile.ZipFile(original_apk, 'r') as zip_file:
            # 创建临时提取目录
            os.makedirs(target_dir, exist_ok=True)
            
            for lib_name in protected_libs:
                src_path = f'assets/{lib_name}'
                
                if src_path in zip_file.namelist():
                    # 读取库文件
                    lib_data = zip_file.read(src_path)
                    
                    # 保存到临时目录
                    output_file = os.path.join(target_dir, lib_name)
                    with open(output_file, 'wb') as f:
                        f.write(lib_data)
                    
                    print(f"  ✓ {lib_name} ({len(lib_data)} 字节)")
                else:
                    print(f"  ⚠️  {lib_name} 未在原始APK中找到")
    
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False
    
    return True

def verify_libs_integrity(lib_dir):
    """验证提取的库文件完整性"""
    print(f"\n🔍 验证库文件完整性...")
    
    import struct
    
    all_valid = True
    for lib_file in os.listdir(lib_dir):
        lib_path = os.path.join(lib_dir, lib_file)
        
        try:
            with open(lib_path, 'rb') as f:
                content = f.read()
            
            # 检查ELF头
            if len(content) < 48:
                print(f"  ❌ {lib_file}: 文件过小")
                all_valid = False
                continue
            
            if content[:4] != b'\x7fELF':
                print(f"  ❌ {lib_file}: 不是ELF文件")
                all_valid = False
                continue
            
            # 检查e_shentsize
            e_shentsize = struct.unpack('<H', content[46:48])[0]
            if e_shentsize == 0:
                print(f"  ❌ {lib_file}: e_shentsize为0（已损坏）")
                all_valid = False
            else:
                print(f"  ✓ {lib_file}: e_shentsize=0x{e_shentsize:02x} (完整)")
        
        except Exception as e:
            print(f"  ❌ {lib_file}: {e}")
            all_valid = False
    
    return all_valid

def rebuild_apk_with_fixed_libs(broken_apk, lib_source_dir, output_apk):
    """重新打包APK，替换损坏的Bangcle库"""
    print(f"\n📦 重新打包APK（替换Bangcle库）...")
    
    try:
        # 创建临时目录用于APK内容
        temp_extract = Path("temp_apk_rebuild")
        if temp_extract.exists():
            shutil.rmtree(temp_extract)
        temp_extract.mkdir()
        
        # 提取broken APK
        print(f"  提取: {broken_apk}")
        with zipfile.ZipFile(broken_apk, 'r') as zip_file:
            zip_file.extractall(temp_extract)
        
        # 替换assets中的Bangcle库
        assets_dir = temp_extract / "assets"
        if assets_dir.exists():
            for lib_file in os.listdir(lib_source_dir):
                src = os.path.join(lib_source_dir, lib_file)
                dst = assets_dir / lib_file
                
                print(f"  替换: {lib_file}")
                shutil.copy2(src, dst)
        else:
            print(f"  ❌ assets目录不存在")
            return False
        
        # 删除META-INF（需要重新签名）
        meta_inf = temp_extract / "META-INF"
        if meta_inf.exists():
            shutil.rmtree(meta_inf)
            print(f"  删除了META-INF（需重新签名）")
        
        # 重新打包为APK
        print(f"  创建新APK: {output_apk}")
        with zipfile.ZipFile(output_apk, 'w', zipfile.ZIP_DEFLATED) as zip_out:
            for root, dirs, files in os.walk(temp_extract):
                for file in files:
                    file_path = Path(root) / file
                    arcname = file_path.relative_to(temp_extract)
                    zip_out.write(file_path, arcname)
        
        # 清理临时目录
        shutil.rmtree(temp_extract)
        
        size_mb = os.path.getsize(output_apk) / (1024*1024)
        print(f"  ✓ APK大小: {size_mb:.2f} MB")
        
        return True
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False

def sign_apk(apk_path):
    """使用系统工具签名APK"""
    import subprocess
    
    print(f"\n🔐 签名APK...")
    
    keystore = "release.keystore"
    
    # 检查或创建keystore
    if not os.path.exists(keystore):
        print("  生成签名密钥...")
        cmd = [
            "keytool", "-genkey", "-v",
            "-keystore", keystore,
            "-keyalg", "RSA",
            "-keysize", "2048",
            "-validity", "10000",
            "-alias", "release",
            "-storepass", "android",
            "-keypass", "android",
            "-dname", "CN=Release,O=BangcleFix,C=CN"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"  ❌ 密钥生成失败: {result.stderr}")
            return False
    
    # 对齐APK
    aligned_apk = apk_path.replace(".apk", "_aligned.apk")
    cmd = ["zipalign", "-v", "4", apk_path, aligned_apk]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  ❌ 对齐失败: {result.stderr}")
        return False
    
    # 签名APK
    cmd = [
        "jarsigner", "-verbose",
        "-sigalg", "SHA1withRSA",
        "-digestalg", "SHA1",
        "-keystore", keystore,
        "-storepass", "android",
        "-keypass", "android",
        aligned_apk,
        "release"
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  ❌ 签名失败: {result.stderr}")
        return False
    
    # 移动已签名的APK到最终位置
    shutil.move(aligned_apk, apk_path)
    print(f"  ✓ APK已签名")
    
    return True

def main():
    print("=" * 70)
    print("Bangcle库文件修复工具")
    print("=" * 70)
    
    # 文件路径
    original_apk = "sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk"
    broken_apk = "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk"
    lib_temp_dir = "temp_bangcle_libs"
    final_apk = "sanguozhiguoguanzhanjiang_downcc_sdk_upgraded_bangcle_fixed.apk"
    
    # 检查文件
    if not os.path.exists(original_apk):
        print(f"❌ 原始APK未找到: {original_apk}")
        return False
    
    if not os.path.exists(broken_apk):
        print(f"❌ 修改后的APK未找到: {broken_apk}")
        return False
    
    try:
        # 第一步：从原始APK中提取保护库
        if not extract_protected_libs_from_original(original_apk, lib_temp_dir):
            print("❌ 库文件提取失败")
            return False
        
        # 第二步：验证提取的库
        if not verify_libs_integrity(lib_temp_dir):
            print("⚠️  部分库文件有问题，但继续修复...")
        
        # 第三步：重新打包APK
        temp_unsigned_apk = broken_apk.replace(".apk", "_unsigned_temp.apk")
        if not rebuild_apk_with_fixed_libs(broken_apk, lib_temp_dir, temp_unsigned_apk):
            print("❌ APK重新打包失败")
            return False
        
        # 第四步：签名APK
        if not sign_apk(temp_unsigned_apk):
            print("❌ APK签名失败")
            return False
        
        # 第五步：移动到最终位置
        shutil.move(temp_unsigned_apk, final_apk)
        
        print("\n" + "=" * 70)
        print("✓ Bangcle库文件修复完成！")
        print("=" * 70)
        print(f"\n输出文件: {final_apk}")
        print(f"\n安装命令:")
        print(f"  adb install -r {final_apk}")
        
        # 清理临时目录
        if os.path.exists(lib_temp_dir):
            shutil.rmtree(lib_temp_dir)
        
        return True
        
    except Exception as e:
        print(f"❌ 发生错误: {e}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
