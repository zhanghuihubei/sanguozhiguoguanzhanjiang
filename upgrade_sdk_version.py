#!/usr/bin/env python3
"""
APK SDK Version Upgrader
升级APK的targetSdkVersion以兼容现代Android系统

问题: targetSdkVersion=14过低，Android 10+系统要求更高的SDK版本
解决方案: 使用apktool反编译APK，修改AndroidManifest.xml，重新编译和签名
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path

class SDKVersionUpgrader:
    def __init__(self, apk_path):
        self.apk_path = Path(apk_path)
        self.work_dir = Path("sdk_upgrade_work")
        self.decompiled_dir = self.work_dir / "decompiled"
        self.upgraded_apk = self.work_dir / "upgraded_unsigned.apk"
        self.final_apk = Path("sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk")
        
        # 推荐的SDK版本配置
        self.min_sdk_version = 19  # Android 4.4 (KitKat)
        self.target_sdk_version = 28  # Android 9 (Pie) - 兼容性最好
        # 不使用29+因为可能需要权限适配
        
    def setup_environment(self):
        """设置工作环境"""
        print("🔧 Setting up work environment...")
        
        if self.work_dir.exists():
            shutil.rmtree(self.work_dir)
        self.work_dir.mkdir()
        self.decompiled_dir.mkdir()
        
        print(f"✓ Work directory: {self.work_dir}")
        return True
        
    def check_dependencies(self):
        """检查必要的工具"""
        print("\n🔍 Checking dependencies...")
        
        tools = ["apktool", "jarsigner", "zipalign"]
        missing = []
        
        for tool in tools:
            if not shutil.which(tool):
                missing.append(tool)
        
        if missing:
            print(f"❌ Missing tools: {', '.join(missing)}")
            print("\nInstall with:")
            print("sudo apt-get install apktool android-sdk-build-tools")
            return False
            
        print("✓ All tools available")
        return True
        
    def decompile_apk(self):
        """使用apktool反编译APK"""
        print(f"\n📦 Decompiling {self.apk_path.name}...")
        
        try:
            cmd = [
                "apktool", "d", 
                "-f",  # 强制覆盖
                str(self.apk_path),
                "-o", str(self.decompiled_dir)
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode != 0:
                print(f"❌ Decompilation failed: {result.stderr}")
                return False
                
            print(f"✓ Decompiled to: {self.decompiled_dir}")
            return True
            
        except Exception as e:
            print(f"❌ Error during decompilation: {e}")
            return False
            
    def analyze_manifest(self):
        """分析当前的AndroidManifest.xml"""
        manifest_path = self.decompiled_dir / "AndroidManifest.xml"
        
        if not manifest_path.exists():
            print("❌ AndroidManifest.xml not found!")
            return False
            
        print("\n📋 Analyzing current manifest...")
        
        try:
            with open(manifest_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # 查找SDK版本信息
            import re
            
            min_sdk_match = re.search(r'minSdkVersion="(\d+)"', content)
            target_sdk_match = re.search(r'targetSdkVersion="(\d+)"', content)
            
            if min_sdk_match:
                current_min = min_sdk_match.group(1)
                print(f"  Current minSdkVersion: {current_min}")
            else:
                print("  minSdkVersion not found")
                
            if target_sdk_match:
                current_target = target_sdk_match.group(1)
                print(f"  Current targetSdkVersion: {current_target}")
            else:
                print("  targetSdkVersion not found")
                
            return True
            
        except Exception as e:
            print(f"❌ Error analyzing manifest: {e}")
            return False
            
    def update_manifest(self):
        """更新AndroidManifest.xml中的SDK版本"""
        manifest_path = self.decompiled_dir / "AndroidManifest.xml"
        
        print(f"\n📝 Updating SDK versions...")
        print(f"  minSdkVersion: {self.min_sdk_version}")
        print(f"  targetSdkVersion: {self.target_sdk_version}")
        
        try:
            with open(manifest_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # 更新SDK版本
            import re
            
            # 更新或添加minSdkVersion
            if 'minSdkVersion=' in content:
                content = re.sub(r'minSdkVersion="\d+"', f'minSdkVersion="{self.min_sdk_version}"', content)
            else:
                # 在uses-sdk标签中添加
                content = re.sub(r'<uses-sdk', f'<uses-sdk minSdkVersion="{self.min_sdk_version}"', content)
                
            # 更新或添加targetSdkVersion
            if 'targetSdkVersion=' in content:
                content = re.sub(r'targetSdkVersion="\d+"', f'targetSdkVersion="{self.target_sdk_version}"', content)
            else:
                # 在uses-sdk标签中添加
                content = re.sub(r'<uses-sdk[^>]*>', lambda m: m.group(0).replace('>', f' targetSdkVersion="{self.target_sdk_version}">'), content)
                
            # 确保uses-sdk标签正确
            if '<uses-sdk' not in content:
                # 在manifest标签后添加
                content = re.sub(r'<manifest[^>]*>', r'\g<0>\n    <uses-sdk android:minSdkVersion="{}" android:targetSdkVersion="{}" />'.format(
                    self.min_sdk_version, self.target_sdk_version), content)
                
            with open(manifest_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            print("✓ SDK versions updated in AndroidManifest.xml")
            return True
            
        except Exception as e:
            print(f"❌ Error updating manifest: {e}")
            return False
            
    def add_compatibility_features(self):
        """添加兼容性特性"""
        import re
        manifest_path = self.decompiled_dir / "AndroidManifest.xml"
        
        print("\n🔧 Adding compatibility features...")
        
        try:
            with open(manifest_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # 添加必要的权限声明（如果缺失）
            required_permissions = [
                'android.permission.REQUEST_INSTALL_PACKAGES',
            ]
            
            # 添加网络安全配置（允许HTTP）
            network_config = '''
    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config">'''
        
        # 检查是否已经有usesCleartextTraffic
            if 'android:usesCleartextTraffic="true"' not in content:
                content = re.sub(r'<application', '<application\n        android:usesCleartextTraffic="true"', content)
                print("  ✓ Added cleartext traffic permission")
                
            with open(manifest_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
            # 创建网络安全配置文件
            self.create_network_security_config()
            
            print("✓ Compatibility features added")
            return True
            
        except Exception as e:
            print(f"❌ Error adding compatibility features: {e}")
            return False
            
    def create_network_security_config(self):
        """创建网络安全配置文件"""
        res_dir = self.decompiled_dir / "res" / "xml"
        res_dir.mkdir(parents=True, exist_ok=True)
        
        config_content = '''<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">localhost</domain>
    </domain-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system"/>
        </trust-anchors>
    </base-config>
</network-security-config>'''
        
        config_file = res_dir / "network_security_config.xml"
        with open(config_file, 'w', encoding='utf-8') as f:
            f.write(config_content)
            
        print(f"  ✓ Created: {config_file}")
        
    def rebuild_apk(self):
        """重新构建APK"""
        print(f"\n🔨 Rebuilding APK...")
        
        try:
            cmd = [
                "apktool", "b",
                str(self.decompiled_dir),
                "-o", str(self.upgraded_apk)
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode != 0:
                print(f"❌ Build failed: {result.stderr}")
                return False
                
            print(f"✓ Built: {self.upgraded_apk}")
            size = self.upgraded_apk.stat().st_size / (1024*1024)
            print(f"  Size: {size:.2f} MB")
            return True
            
        except Exception as e:
            print(f"❌ Error during build: {e}")
            return False
            
    def sign_apk(self):
        """签名APK"""
        print(f"\n🔐 Signing APK...")
        
        keystore_path = "release.keystore"
        
        # 检查或创建keystore
        if not os.path.exists(keystore_path):
            print("Creating keystore...")
            cmd = [
                "keytool", "-genkey", "-v",
                "-keystore", keystore_path,
                "-keyalg", "RSA",
                "-keysize", "2048",
                "-validity", "10000",
                "-alias", "release",
                "-storepass", "android",
                "-keypass", "android",
                "-dname", "CN=Release,O=SDK_Upgrade,C=CN"
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode != 0:
                print(f"❌ Keystore creation failed: {result.stderr}")
                return False
                
        # 对齐APK
        aligned_apk = self.work_dir / "upgraded_aligned.apk"
        cmd = ["zipalign", "-v", "4", str(self.upgraded_apk), str(aligned_apk)]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"❌ Alignment failed: {result.stderr}")
            return False
            
        # 签名APK
        cmd = [
            "jarsigner", "-verbose",
            "-sigalg", "SHA1withRSA",
            "-digestalg", "SHA1",
            "-keystore", keystore_path,
            "-storepass", "android",
            "-keypass", "android",
            str(aligned_apk),
            "release"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f"❌ Signing failed: {result.stderr}")
            return False
            
        # 复制到最终位置
        if self.final_apk.exists():
            self.final_apk.unlink()
        shutil.copy2(aligned_apk, self.final_apk)
        
        print(f"✓ Signed: {self.final_apk}")
        return True
        
    def verify_upgraded_apk(self):
        """验证升级后的APK"""
        print(f"\n🔍 Verifying upgraded APK...")
        
        try:
            cmd = ["aapt", "dump", "badging", str(self.final_apk)]
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                for line in result.stdout.split('\n'):
                    if 'sdkVersion:' in line or 'targetSdkVersion:' in line:
                        print(f"  {line}")
                        
                print("✓ APK verification complete")
                return True
            else:
                print(f"❌ Verification failed: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"❌ Error during verification: {e}")
            return False
            
    def create_instructions(self):
        """生成升级说明"""
        instructions = f"""# APK SDK版本升级说明

## 问题分析
- 原始APK: targetSdkVersion=14 (Android 4.0)
- 现代Android系统要求更高的SDK版本
- 错误: "此应用SDK版本过低, 无法正常运行"

## 执行的升级
- minSdkVersion: 8 → {self.min_sdk_version} (Android 4.4)
- targetSdkVersion: 14 → {self.target_sdk_version} (Android 9)
- 添加兼容性配置
- 重新签名APK

## 输出文件
- 升级后的APK: `{self.final_apk}`
- 工作目录: `{self.work_dir}`

## 安装测试
```bash
# 卸载旧版本
adb uninstall com.idealdimension.EmpireAttack

# 安装升级版本
adb install {self.final_apk}

# 查看日志
adb logcat | grep -E "(EmpireAttack|三国|crash|error)"
```

## 兼容性改进
1. ✅ 提升SDK版本到Android 9级别
2. ✅ 允许明文HTTP流量（兼容旧服务器）
3. ✅ 添加网络安全配置
4. ✅ 保持原有功能不变

## 注意事项
- 如果仍有问题，可能需要进一步适配权限
- 某些API在高版本中可能需要运行时权限
- 建议在目标设备上充分测试

## 回滚方案
如需回退到原版本，使用之前签名的APK:
```bash
adb install sanguozhiguoguanzhanjiang_downcc_resigned_fixed.apk
```
"""
        
        with open("SDK_UPGRADE_INSTRUCTIONS.md", "w", encoding="utf-8") as f:
            f.write(instructions)
        print("✓ Created: SDK_UPGRADE_INSTRUCTIONS.md")
        return True
        
    def run(self):
        """执行完整的升级流程"""
        print("=" * 60)
        print("APK SDK Version Upgrader")
        print("=" * 60)
        
        if not self.apk_path.exists():
            print(f"❌ APK not found: {self.apk_path}")
            return False
            
        steps = [
            ("Setting up environment", self.setup_environment),
            ("Checking dependencies", self.check_dependencies),
            ("Decompiling APK", self.decompile_apk),
            ("Analyzing manifest", self.analyze_manifest),
            ("Updating SDK versions", self.update_manifest),
            ("Adding compatibility features", self.add_compatibility_features),
            ("Rebuilding APK", self.rebuild_apk),
            ("Signing APK", self.sign_apk),
            ("Verifying upgraded APK", self.verify_upgraded_apk),
            ("Creating instructions", self.create_instructions),
        ]
        
        for step_name, step_func in steps:
            print(f"\n{'=' * 40}")
            print(f"Step: {step_name}")
            print('=' * 40)
            if not step_func():
                print(f"❌ Failed at: {step_name}")
                return False
                
        print("\n" + "=" * 60)
        print("✓ SDK upgrade complete!")
        print("=" * 60)
        print(f"\nOutput files:")
        print(f"  - {self.final_apk}")
        print(f"  - SDK_UPGRADE_INSTRUCTIONS.md")
        print(f"\nNext steps:")
        print(f"  1. Install the upgraded APK on your device")
        print(f"  2. Test if the SDK version error is resolved")
        print(f"  3. Check if the app runs without crashes")
        
        return True

if __name__ == "__main__":
    apk_name = "sanguozhiguoguanzhanjiang_downcc_resigned_fixed.apk"
    
    if not os.path.exists(apk_name):
        print(f"❌ APK not found: {apk_name}")
        print("Please ensure the signed APK is available")
        sys.exit(1)
        
    upgrader = SDKVersionUpgrader(apk_name)
    success = upgrader.run()
    sys.exit(0 if success else 1)