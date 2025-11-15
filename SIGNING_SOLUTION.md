# APK签名问题解决方案

## 问题描述

根据调试信息：
```
安装失败
失败原因 : 该安装包未包含任何证书
```

## 问题分析

1. **旧签名损坏**: APK使用2015年的签名可能已损坏或过期
2. **证书不被信任**: 旧签名可能不被现代Android系统信任
3. **需要重新签名**: 必须使用兼容targetSdkVersion的签名算法

**重要**: 签名算法必须与targetSdkVersion匹配！
- targetSdkVersion < 18: 必须使用 SHA1withRSA
- targetSdkVersion ≥ 18: 可以使用 SHA256withRSA

## 解决方案

### 方法1: 使用重新签名脚本（推荐）

**平台说明**: 下面的 `sudo apt-get` 命令仅适用于 Linux。
- **Linux 用户**: 直接按照下面的步骤执行
- **macOS 用户**: 使用 `brew install openjdk` 替代
- **Windows 用户**: 请使用 WSL2 或 Linux 虚拟机

```bash
# 1. 安装必要工具
# Linux (Ubuntu/Debian):
sudo apt-get install openjdk-11-jdk android-sdk-build-tools

# macOS:
brew install openjdk

# 2. 运行重新签名脚本
python3 resign_apk.py
```

脚本会自动：
- 删除旧的META-INF签名文件
- 生成新的签名密钥
- 使用SHA1withRSA算法重新签名（兼容targetSdkVersion=14）
- 对齐APK优化性能

**注意**: resign_apk.py 已更新为使用SHA1withRSA以兼容原APK的targetSdkVersion=14

### 方法2: 手动重新签名

```bash
# 1. 删除旧签名
mkdir temp_unzip
unzip sanguozhiguoguanzhanjiang_downcc_fixed.apk -d temp_unzip
rm -rf temp_unzip/META-INF

# 2. 重新打包
cd temp_unzip
zip -r ../unsigned.apk *
cd ..

# 3. 生成密钥（首次）
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 \
  -validity 10000 -alias release -storepass android -keypass android \
  -dname "CN=Release,O=Fix,C=CN"

# 4. 签名APK（请注意签名算法与targetSdkVersion对应）
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore release.keystore -storepass android -keypass android \
  unsigned.apk release

# 5. 对齐APK
zipalign -v 4 unsigned.apk sanguozhiguoguanzhanjiang_downcc_resigned.apk

# 6. 验证签名
jarsigner -verify -verbose -certs sanguozhiguoguanzhanjiang_downcc_resigned.apk
```

### 方法3: 使用advanced_fix.sh完整修复

```bash
# 完整的修复脚本包含签名步骤
bash advanced_fix.sh
```

## 验证签名

```bash
# 验证APK签名
jarsigner -verify -verbose -certs sanguozhiguoguanzhanjiang_downcc_resigned.apk

# 检查APK内容
unzip -l sanguozhiguoguanzhanjiang_downcc_resigned.apk | grep META-INF
```

## 安装测试

```bash
# 安装重新签名的APK
adb install -r sanguozhiguoguanzhanjiang_downcc_resigned.apk

# 查看安装日志
adb logcat | grep -i "install\|package"
```

## 预期结果

重新签名后应该能够正常安装，不再出现"未包含任何证书"的错误。

## 故障排除

### 如果仍然无法安装：

1. **检查签名算法**: 确保签名算法与targetSdkVersion匹配
   - targetSdkVersion=14需要SHA1withRSA，不能用SHA256
2. **检查密钥有效性**: 确保密钥库文件正确生成
3. **检查APK完整性**: 确保重新打包过程中没有文件丢失
4. **检查设备设置**: 确保允许安装未知来源应用
5. **SDK版本问题**: 如果安装成功但无法运行，可能需要升级SDK版本（见SDK_UPGRADE_INSTRUCTIONS.md）

### 常见错误：

- `jarsigner: command not found`: 需要安装Java JDK
- `zipalign: command not found`: 需要安装Android Build Tools
- `keytool error`: 检查Java环境配置

## 技术细节

- **原始签名**: SHA1withRSA (2015年，META-INF损坏)
- **推荐签名**: SHA1withRSA（适用于targetSdkVersion=14）
- **替代方案**: 当targetSdkVersion升级到≥18时，可以使用SHA256withRSA
- **密钥长度**: 2048位RSA
- **有效期**: 10000天
- **对齐**: 4字节对齐优化

## 文件输出

- `sanguozhiguoguanzhanjiang_downcc_resigned.apk`: 重新签名后的APK
- `release.keystore`: 签名密钥库文件