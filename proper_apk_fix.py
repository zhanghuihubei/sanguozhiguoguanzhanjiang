#!/usr/bin/env python3
"""
正确的APK修复流程
使用apktool进行反编译和重新编译，确保所有文件完整性
重点：直接从原始APK中复制，仅修改必要的部分
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def run_cmd(cmd, description=""):
    """运行命令并检查返回值"""
    print(f"\n  执行: {' '.join(cmd) if isinstance(cmd, list) else cmd}")
    
    result = subprocess.run(cmd, capture_output=True, text=True, shell=isinstance(cmd, str))
    if result.returncode != 0:
        print(f"  ❌ 失败")
        if result.stderr:
            print(f"     错误: {result.stderr[:200]}")
        return False
    
    print(f"  ✓ 成功")
    return True

def main():
    print("=" * 70)
    print("正确的APK修复工具（使用apktool）")
    print("=" * 70)
    
    # 文件路径
    original_apk = "sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk"
    output_apk = "sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk"
    
    # 工作目录
    work_dir = Path("apk_fix_work")
    decompile_dir = work_dir / "decompiled"
    
    if not os.path.exists(original_apk):
        print(f"❌ 原始APK不存在: {original_apk}")
        return False
    
    try:
        # 清理之前的工作目录
        if work_dir.exists():
            print(f"\n🧹 清理旧的工作目录...")
            shutil.rmtree(work_dir)
        work_dir.mkdir()
        
        # 第一步：反编译APK
        print(f"\n📦 第一步：反编译原始APK...")
        cmd = ["apktool", "d", "-f", original_apk, "-o", str(decompile_dir)]
        if not run_cmd(cmd):
            print(f"❌ 反编译失败")
            return False
        
        # 第二步：检查并分析manifest
        print(f"\n📋 第二步：分析AndroidManifest.xml...")
        manifest_path = decompile_dir / "AndroidManifest.xml"
        if not manifest_path.exists():
            print(f"❌ 找不到AndroidManifest.xml")
            return False
        
        # 第三步：更新SDK版本（可选）
        print(f"\n🔄 第三步：更新SDK版本...")
        with open(manifest_path, 'r', encoding='utf-8') as f:
            manifest_content = f.read()
        
        import re
        
        # 检查当前的SDK版本
        min_sdk = re.search(r'minSdkVersion="(\d+)"', manifest_content)
        target_sdk = re.search(r'targetSdkVersion="(\d+)"', manifest_content)
        
        print(f"  当前 minSdkVersion: {min_sdk.group(1) if min_sdk else '未指定'}")
        print(f"  当前 targetSdkVersion: {target_sdk.group(1) if target_sdk else '未指定'}")
        
        # 将targetSdkVersion升级到28（Android 9）以支持Android 9
        if 'targetSdkVersion=' in manifest_content:
            manifest_content = re.sub(r'targetSdkVersion="\d+"', 'targetSdkVersion="28"', manifest_content)
            print(f"  ✓ 更新 targetSdkVersion 为 28")
        
        with open(manifest_path, 'w', encoding='utf-8') as f:
            f.write(manifest_content)
        
        # 第四步：检查lib目录
        print(f"\n📚 第四步：检查native库...")
        lib_dir = decompile_dir / "lib"
        if lib_dir.exists():
            for arch_dir in lib_dir.iterdir():
                if arch_dir.is_dir():
                    libs = list(arch_dir.glob("*.so"))
                    print(f"  {arch_dir.name}: {len(libs)} 个库文件")
        else:
            print(f"  ⚠️  lib目录不存在")
        
        # 第五步：重新编译APK
        print(f"\n🔨 第五步：重新编译APK...")
        unsigned_apk = work_dir / "unsigned.apk"
        cmd = ["apktool", "b", str(decompile_dir), "-o", str(unsigned_apk)]
        if not run_cmd(cmd):
            print(f"❌ 重新编译失败")
            return False
        
        unsigned_size_mb = unsigned_apk.stat().st_size / (1024*1024)
        print(f"  APK大小: {unsigned_size_mb:.2f} MB")
        
        # 第六步：签名APK
        print(f"\n🔐 第六步：签名APK...")
        
        keystore = "release.keystore"
        
        # 创建keystore（如果不存在）
        if not os.path.exists(keystore):
            print(f"  生成签名密钥...")
            cmd = [
                "keytool", "-genkey", "-v",
                "-keystore", keystore,
                "-keyalg", "RSA",
                "-keysize", "2048",
                "-validity", "10000",
                "-alias", "release",
                "-storepass", "android",
                "-keypass", "android",
                "-dname", "CN=Release,O=APKFix,C=CN"
            ]
            if not run_cmd(cmd):
                print(f"❌ 密钥生成失败")
                return False
        
        # 对齐APK
        aligned_apk = work_dir / "aligned.apk"
        cmd = ["zipalign", "-v", "4", str(unsigned_apk), str(aligned_apk)]
        if not run_cmd(cmd):
            print(f"❌ APK对齐失败")
            return False
        
        # 签名APK
        cmd = [
            "jarsigner", "-verbose",
            "-sigalg", "SHA1withRSA",
            "-digestalg", "SHA1",
            "-keystore", keystore,
            "-storepass", "android",
            "-keypass", "android",
            str(aligned_apk),
            "release"
        ]
        if not run_cmd(cmd):
            print(f"❌ APK签名失败")
            return False
        
        # 移动到最终位置
        print(f"\n📋 第七步：完成...")
        shutil.copy2(aligned_apk, output_apk)
        
        final_size_mb = os.path.getsize(output_apk) / (1024*1024)
        print(f"  ✓ 输出APK: {output_apk} ({final_size_mb:.2f} MB)")
        
        # 清理工作目录
        print(f"\n🧹 清理工作目录...")
        shutil.rmtree(work_dir)
        
        print("\n" + "=" * 70)
        print("✓ APK修复完成！")
        print("=" * 70)
        print(f"\n安装命令:")
        print(f"  adb install -r {output_apk}")
        print(f"\n注意事项:")
        print(f"  1. 该APK已升级到targetSdkVersion=28（Android 9）")
        print(f"  2. 保留了所有原始库文件和资源")
        print(f"  3. 仅修改了AndroidManifest.xml中的SDK版本")
        
        return True
        
    except Exception as e:
        print(f"❌ 发生错误: {e}")
        if work_dir.exists():
            shutil.rmtree(work_dir)
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
