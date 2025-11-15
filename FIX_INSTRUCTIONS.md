# APK修复说明

## 问题
APK中只有armeabi (ARM v5/v6)库，但Android 10只支持armeabi-v7a或arm64-v8a

## 已执行的步骤
1. ✓ 提取APK文件
2. ✓ 验证native库架构
3. ✓ 创建armeabi-v7a目录结构
4. ✓ 复制库文件

## 需要手动执行的步骤

### 步骤1: 安装必要的工具

**重要**: 下面的 `sudo apt-get` 命令仅适用于 Linux 环境。
- **Linux 用户**: 直接运行 apt-get 命令
- **macOS 用户**: 使用 Homebrew (brew install apktool)
- **Windows 用户**: 请使用 WSL2 或在 Linux 虚拟机中执行

```bash
# Ubuntu/Debian (Linux 环境)
sudo apt-get install apktool android-sdk-build-tools

# 或手动下载apktool (任何平台都可用)
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
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 \
  -validity 10000 -alias release -storepass android -keypass android \
  -dname "CN=Release,O=Fix,C=CN"
```

### 步骤7: 签名APK
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore release.keystore \
  -storepass android \
  -keypass android \
  sanguozhiguoguanzhanjiang_fixed_unsigned.apk release
```

### 步骤8: 对齐APK（提高性能）
```bash
zipalign -v 4 sanguozhiguoguanzhanjiang_fixed_unsigned.apk \
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
