#!/usr/bin/env python3
"""
APK重新签名工具
解决"安装包未包含任何证书"的问题

问题：APK使用2015年的SHA1签名，Android 10+不支持
解决：删除旧签名，使用现代算法重新签名
"""

import os
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path
from zipfile import ZipFile
import hashlib

class APKResigner:
    def __init__(self, input_apk):
        self.input_apk = Path(input_apk)
        self.temp_dir = Path("temp_resign")
        self.unsigned_apk = self.temp_dir / "unsigned.apk"
        self.signed_apk = Path("sanguozhiguoguanzhanjiang_downcc_resigned.apk")
        self.keystore = Path("release.keystore")
        
    def check_dependencies(self):
        """检查必要的工具"""
        required = ["keytool", "jarsigner", "zipalign"]
        missing = []
        
        for tool in required:
            if not shutil.which(tool):
                missing.append(tool)
        
        if missing:
            print(f"❌ 缺少必要工具: {', '.join(missing)}")
            print("\n安装方法:")
            print("Ubuntu/Debian:")
            print("  sudo apt-get install openjdk-11-jdk android-sdk-build-tools")
            print("\nmacOS:")
            print("  brew install openjdk android-sdk-build-tools")
            return False
        
        print("✓ 所有必要工具已安装")
        return True
    
    def prepare_unsigned_apk(self):
        """准备未签名的APK（删除META-INF）"""
        print("\n🔧 准备未签名APK...")
        
        # 创建临时目录
        if self.temp_dir.exists():
            shutil.rmtree(self.temp_dir)
        self.temp_dir.mkdir()
        
        # 解压APK
        print(f"解压: {self.input_apk}")
        with ZipFile(self.input_apk, 'r') as zipf:
            zipf.extractall(self.temp_dir)
        
        # 删除META-INF签名文件
        meta_inf = self.temp_dir / "META-INF"
        if meta_inf.exists():
            print("删除旧签名文件...")
            shutil.rmtree(meta_inf)
        
        # 重新打包为未签名APK
        print("重新打包...")
        with ZipFile(self.unsigned_apk, 'w') as zipf:
            for root, dirs, files in os.walk(self.temp_dir):
                for file in files:
                    file_path = Path(root) / file
                    if file_path != self.unsigned_apk:  # 不包含自己
                        arcname = file_path.relative_to(self.temp_dir)
                        zipf.write(file_path, arcname)
        
        print(f"✓ 未签名APK: {self.unsigned_apk}")
        return True
    
    def generate_keystore(self):
        """生成签名密钥"""
        if self.keystore.exists():
            print(f"✓ 密钥库已存在: {self.keystore}")
            return True
        
        print("\n🔑 生成签名密钥...")
        cmd = [
            "keytool", "-genkey", "-v",
            "-keystore", str(self.keystore),
            "-keyalg", "RSA",
            "-keysize", "2048",
            "-validity", "10000",
            "-alias", "release",
            "-storepass", "android",
            "-keypass", "android",
            "-dname", "CN=Release,O=APKResign,C=CN"
        ]
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            print(f"✓ 密钥库生成: {self.keystore}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 密钥库生成失败: {e}")
            return False
    
    def sign_apk(self):
        """签名APK"""
        print("\n✍️  签名APK...")
        
        cmd = [
            "jarsigner", "-verbose",
            "-sigalg", "SHA1withRSA",   # 使用兼容旧版本的签名算法
            "-digestalg", "SHA1",        # targetSdkVersion=14需要SHA1
            "-keystore", str(self.keystore),
            "-storepass", "android",
            "-keypass", "android",
            str(self.unsigned_apk),
            "release"
        ]
        
        try:
            result = subprocess.run(cmd, check=True, capture_output=True, text=True)
            print("✓ APK签名成功")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 签名失败: {e}")
            print(f"错误输出: {e.stderr}")
            return False
    
    def align_apk(self):
        """对齐APK"""
        print("\n📐 对齐APK...")
        
        cmd = [
            "zipalign", "-v", "4",
            str(self.unsigned_apk),
            str(self.signed_apk)
        ]
        
        try:
            subprocess.run(cmd, check=True, capture_output=True)
            print(f"✓ APK对齐完成: {self.signed_apk}")
            
            # 显示文件大小
            size_mb = self.signed_apk.stat().st_size / (1024*1024)
            print(f"  文件大小: {size_mb:.2f} MB")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 对齐失败: {e}")
            return False
    
    def verify_signature(self):
        """验证签名"""
        print("\n🔍 验证签名...")
        
        cmd = ["jarsigner", "-verify", "-verbose", "-certs", str(self.signed_apk)]
        
        try:
            result = subprocess.run(cmd, check=True, capture_output=True, text=True)
            print("✓ 签名验证通过")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ 签名验证失败: {e}")
            return False
    
    def cleanup(self):
        """清理临时文件"""
        if self.temp_dir.exists():
            shutil.rmtree(self.temp_dir)
    
    def run(self):
        """执行重新签名流程"""
        print("=" * 60)
        print("APK重新签名工具")
        print("解决: 安装包未包含任何证书")
        print("=" * 60)
        
        if not self.input_apk.exists():
            print(f"❌ APK文件不存在: {self.input_apk}")
            return False
        
        # 检查依赖
        if not self.check_dependencies():
            return False
        
        try:
            steps = [
                ("准备未签名APK", self.prepare_unsigned_apk),
                ("生成签名密钥", self.generate_keystore),
                ("签名APK", self.sign_apk),
                ("对齐APK", self.align_apk),
                ("验证签名", self.verify_signature),
            ]
            
            for step_name, step_func in steps:
                print(f"\n{'=' * 40}")
                print(f"步骤: {step_name}")
                print('=' * 40)
                if not step_func():
                    print(f"❌ 失败: {step_name}")
                    return False
            
            # 清理临时文件
            self.cleanup()
            
            print("\n" + "=" * 60)
            print("✓ APK重新签名完成!")
            print("=" * 60)
            print(f"输出文件: {self.signed_apk}")
            print(f"\n安装命令:")
            print(f"  adb install -r {self.signed_apk}")
            
            return True
            
        except Exception as e:
            print(f"❌ 发生错误: {e}")
            self.cleanup()
            return False

def main():
    apk_name = "sanguozhiguoguanzhanjiang_downcc_fixed.apk"
    
    if not os.path.exists(apk_name):
        print(f"❌ APK文件不存在: {apk_name}")
        print("请确保已运行fix_apk.py生成修复后的APK")
        sys.exit(1)
    
    resigner = APKResigner(apk_name)
    success = resigner.run()
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()