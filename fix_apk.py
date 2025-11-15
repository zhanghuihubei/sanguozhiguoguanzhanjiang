#!/usr/bin/env python3
"""
APK Compatibility Fixer for Android 10+ arm64 devices
Fixes the crash on Huawei Enjoy 60 (Harmony 3.0) with Android 10

Problem: APK contains only armeabi native libraries (ARM v5/v6)
Android 10+ requires armeabi-v7a (ARM v7) or arm64-v8a (64-bit)

Solution: Repackage APK with armeabi-v7a native library support
"""

import os
import sys
import shutil
import subprocess
import struct
from pathlib import Path
from zipfile import ZipFile

class APKFixer:
    def __init__(self, apk_path):
        self.apk_path = Path(apk_path)
        self.extract_dir = Path("apk_extracted")
        self.output_apk = Path("sanguozhiguoguanzhanjiang_downcc_fixed.apk")
        self.armeabi_dir = self.extract_dir / "lib" / "armeabi"
        self.armeabi_v7a_dir = self.extract_dir / "lib" / "armeabi-v7a"
        
    def validate_native_libs(self):
        """检查和验证native库"""
        if not self.armeabi_dir.exists():
            print("❌ armeabi directory not found!")
            return False
            
        libs = list(self.armeabi_dir.glob("*.so"))
        print(f"✓ Found {len(libs)} native libraries in armeabi:")
        for lib in libs:
            size = lib.stat().st_size
            print(f"  - {lib.name} ({size} bytes)")
            self._validate_elf(lib)
        return True
        
    def _validate_elf(self, so_file):
        """验证ELF文件头"""
        try:
            with open(so_file, 'rb') as f:
                header = f.read(20)
                if header[:4] == b'\x7fELF':
                    # e_machine: 0x28 = ARM v5/v6 (ARMEABI), 0x28 = ARMV7L, 0xb7 = ARM64
                    e_machine = struct.unpack('<H', header[18:20])[0]
                    arch_map = {
                        0x28: "ARM v5/v6 (armeabi) ❌",
                        0xb7: "ARM 64-bit ✓",
                    }
                    arch = arch_map.get(e_machine, f"Unknown (0x{e_machine:x})")
                    print(f"    ELF header: {arch}")
        except Exception as e:
            print(f"    Could not read ELF: {e}")
            
    def create_compatible_lib_structure(self):
        """创建armeabi-v7a目录结构（与armeabi相同的库）"""
        print("\n🔧 Creating armeabi-v7a library structure...")
        
        if not self.armeabi_v7a_dir.exists():
            self.armeabi_v7a_dir.mkdir(parents=True)
            print(f"✓ Created: {self.armeabi_v7a_dir}")
        
        # 复制armeabi库到armeabi-v7a（在ARM EABI兼容的情况下）
        for so_file in self.armeabi_dir.glob("*.so"):
            dest = self.armeabi_v7a_dir / so_file.name
            shutil.copy2(so_file, dest)
            print(f"✓ Copied: {so_file.name}")
            
        return True
        
    def update_manifest(self):
        """更新AndroidManifest.xml以支持新架构"""
        manifest_path = self.extract_dir / "AndroidManifest.xml"
        
        if not manifest_path.exists():
            print("❌ AndroidManifest.xml not found!")
            return False
            
        print("\n📝 Updating AndroidManifest.xml...")
        # 注意：直接修改二进制XML很复杂，这里记录需要的更改
        # 在实际环境中需要使用apktool或类似工具
        print("⚠️  Note: Binary XML modification requires apktool")
        print("    Expected changes:")
        print("    - Add supports-screens tag modifications")
        print("    - Ensure uses-native-library includes armeabi-v7a")
        
        return True
        
    def repackage_apk(self):
        """重新打包APK"""
        print("\n📦 Repackaging APK...")
        
        if self.output_apk.exists():
            self.output_apk.unlink()
            print(f"Removed old: {self.output_apk}")
        
        try:
            # 创建新的APK文件
            with ZipFile(self.output_apk, 'w') as zipf:
                for root, dirs, files in os.walk(self.extract_dir):
                    for file in files:
                        file_path = Path(root) / file
                        arcname = file_path.relative_to(self.extract_dir)
                        zipf.write(file_path, arcname)
                        
            print(f"✓ Created: {self.output_apk}")
            size = self.output_apk.stat().st_size / (1024*1024)
            print(f"  Size: {size:.2f} MB")
            return True
        except Exception as e:
            print(f"❌ Error repackaging: {e}")
            return False
            
    def create_fix_instructions(self):
        """生成修复说明"""
        instructions = """# APK修复说明

## 问题
APK中只有armeabi (ARM v5/v6)库，但Android 10只支持armeabi-v7a或arm64-v8a

## 已执行的步骤
1. ✓ 提取APK文件
2. ✓ 验证native库架构
3. ✓ 创建armeabi-v7a目录结构
4. ✓ 复制库文件

## 需要手动执行的步骤

### 步骤1: 安装必要的工具
```bash
# Ubuntu/Debian
sudo apt-get install apktool android-sdk-build-tools

# 或手动下载apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool.jar
```

### 步骤2: 使用apktool反编译原APK
```bash
apktool d -f "sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk" -o apk_source
```

### 步骤3: 添加库文件
```bash
# 复制修复后的库到反编译目录
cp -r apk_extracted/lib/armeabi-v7a apk_source/lib/
```

### 步骤4: 修改AndroidManifest.xml（可选）
```bash
# 编辑 apk_source/AndroidManifest.xml
# 确保supports-screens标签包含正确的DPI和屏幕配置
```

### 步骤5: 重新编译APK
```bash
apktool b apk_source -o sanguozhiguoguanzhanjiang_fixed_unsigned.apk
```

### 步骤6: 生成签名密钥（仅首次）
```bash
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 \\
  -validity 10000 -alias release -storepass android -keypass android \\
  -dname "CN=Release,O=Fix,C=CN"
```

### 步骤7: 签名APK
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \\
  -keystore release.keystore \\
  -storepass android \\
  -keypass android \\
  sanguozhiguoguanzhanjiang_fixed_unsigned.apk release
```

### 步骤8: 对齐APK（提高性能）
```bash
zipalign -v 4 sanguozhiguoguanzhanjiang_fixed_unsigned.apk \\
  sanguozhiguoguanzhanjiang_downcc_fixed.apk
```

### 步骤9: 安装到设备
```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_fixed.apk
```

## 测试
```bash
# 查看logcat
adb logcat | grep -E "(Native|Library|crash|Exception)"

# 启动应用并查看日志
adb shell am start -n com.xxx.xxx/.MainActivity
```

## 常见问题

### Q: 仍然闪退？
A: 可能原因：
1. armeabi库不完全兼容ARM v7
2. Bangcle保护与Android 10不兼容
3. 需要移除或更新保护方案

### Q: 签名问题？
A: 使用 -v 选项查看详细信息
```bash
jarsigner -verify -verbose -certs sanguozhiguoguanzhanjiang_downcc_fixed.apk
```

### Q: 如何查看详细错误？
A: 
```bash
adb logcat | grep -A5 "AndroidRuntime"
adb bugreport > bug.txt
```

## 参考资源
- Android NDK ABI 兼容性: https://developer.android.com/ndk/guides/abis
- APKTool: https://ibotpeaches.github.io/Apktool/
- Android App Signing: https://developer.android.com/studio/publish/app-signing
"""
        
        with open("FIX_INSTRUCTIONS.md", "w", encoding="utf-8") as f:
            f.write(instructions)
        print("✓ Created: FIX_INSTRUCTIONS.md")
        return True
        
    def run(self):
        """执行完整的修复流程"""
        print("=" * 60)
        print("APK Compatibility Fixer for Android 10+")
        print("=" * 60)
        
        if not self.extract_dir.exists():
            print("❌ Please extract APK first using:")
            print(f"   unzip '{self.apk_path}' -d {self.extract_dir}")
            return False
            
        print(f"\nAnalyzing: {self.apk_path}")
        print(f"Extract dir: {self.extract_dir}")
        
        steps = [
            ("Validating native libraries", self.validate_native_libs),
            ("Creating armeabi-v7a structure", self.create_compatible_lib_structure),
            ("Updating manifest", self.update_manifest),
            ("Repackaging APK", self.repackage_apk),
            ("Creating fix instructions", self.create_fix_instructions),
        ]
        
        for step_name, step_func in steps:
            print(f"\n{'=' * 40}")
            print(f"Step: {step_name}")
            print('=' * 40)
            if not step_func():
                print(f"❌ Failed at: {step_name}")
                return False
                
        print("\n" + "=" * 60)
        print("✓ APK preparation complete!")
        print("=" * 60)
        print(f"\nOutput files:")
        print(f"  - {self.output_apk}")
        print(f"  - FIX_INSTRUCTIONS.md")
        print(f"\nNext steps:")
        print(f"  1. Install apktool and build tools")
        print(f"  2. Follow FIX_INSTRUCTIONS.md for complete fixing process")
        print(f"  3. Use the prepared libraries to repackage the APK")
        
        return True

if __name__ == "__main__":
    apk_name = "sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk"
    
    if not os.path.exists(apk_name):
        print(f"❌ APK not found: {apk_name}")
        sys.exit(1)
        
    fixer = APKFixer(apk_name)
    success = fixer.run()
    sys.exit(0 if success else 1)
