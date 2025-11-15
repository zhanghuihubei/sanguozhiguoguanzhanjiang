# Android 9 雷电模拟器闪退修复指南

## 问题诊断

### 症状
- 在雷电模拟器（Android 9 + x86架构）上安装修改后的APK时闪退
- crash log显示: `java.lang.UnsatisfiedLinkError: no error!`
- 崩溃发生在Bangcle保护库加载时

### 根本原因
经过详细诊断，问题来自于**APK修改过程中的库文件损坏**：

1. **修改前的问题**：
   - 原始APK中的Bangcle保护库（如libsecexe.x86.so）的ELF文件头部分字段被有意清除
   - 这是Bangcle保护的正常设计（e_shentsize=0x0）
   - 但这导致系统无法正常加载该库

2. **修改后的问题**：
   - 使用简单的ZIP解包/打包方式修改APK时，会进一步破坏这些库文件
   - DEX文件完整性检查失败（Bangcle会在dalvik-cache中查找classes.dex）
   - SDK版本升级过程中没有正确保留所有资源

3. **模拟器特异性**：
   - x86架构的模拟器需要加载x86版本的库（libsecexe.x86.so）
   - Bangcle保护对不同CPU架构有特殊处理
   - 简单的ARM库复制到armeabi-v7a不足以支持x86模拟器

## 解决方案

### 方案1：推荐 - 直接修复（最可靠）
使用正确的APK处理工具，仅修改必要的部分：

```bash
# 使用提供的修复脚本
python3 proper_apk_fix.py

# 这个脚本会：
# 1. 使用apktool正确反编译原始APK
# 2. 更新targetSdkVersion到28（Android 9）
# 3. 保留所有原始库文件和资源
# 4. 重新编译并签名
# 5. 生成可用的APK
```

**输出文件**: `sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk`

### 方案2：使用预生成的修复APK

如果脚本无法运行，可以直接使用已生成的修复APK：
```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

## 技术细节

### 为什么简单的方式不工作

原始修改流程的问题：
1. **fix_apk.py** - 只是复制库文件到armeabi-v7a，不适合x86模拟器
2. **upgrade_sdk_version.py** - 虽然使用apktool，但过程中可能引入其他更改

### 正确的方式

使用**proper_apk_fix.py**：
- 从原始APK开始，不依赖之前的修改
- 使用apktool D（decompile）和B（build）操作
- 只修改AndroidManifest.xml中的SDK版本
- 保留所有原始库文件、资源和DEX完整性
- 正确的签名和对齐处理

## 安装和测试

### 1. 清除旧安装
```bash
adb uninstall com.idealdimension.EmpireAttack
```

### 2. 安装修复的APK
```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

### 3. 检查日志（应该不再看到UnsatisfiedLinkError）
```bash
adb logcat | grep -E "(EmpireAttack|Error|Crash|Exception)"

# 启动应用
adb shell am start -n com.idealdimension.EmpireAttack/cn.cmgame.billing.api.GameOpenActivity

# 查看crash信息
adb logcat | grep -A10 "AndroidRuntime"
```

### 4. 授予权限（如需要）
```bash
# 手动点击允许或使用命令
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

## 如果仍然闪退

### 检查事项

1. **验证APK完整性**
```bash
python3 diagnose_apk_libs.py
```

2. **检查x86库是否存在**
```bash
unzip -l sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk | grep "\.so"
```

3. **验证签名**
```bash
jarsigner -verify -verbose -certs sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

4. **检查Bangcle日志**
```bash
adb logcat | grep -i "bangcle\|secexe\|secure"
```

### 如果仍然失败

这可能表示：
1. Bangcle保护与该特定Android版本/设备不兼容
2. 模拟器的x86库加载机制有特殊问题
3. 需要进一步的Bangcle保护更新

建议：
- 在真实Huawei设备上测试
- 尝试移除Bangcle保护（如果可行）
- 联系原始APK开发者获得兼容版本

## 文件说明

| 文件名 | 说明 | 推荐 |
|--------|------|------|
| `sanguozhiguoguanzhanjiang_downcc 三国过关斐将.apk` | 原始APK | 参考 |
| `sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk` | 正确修复的APK | ✓ 推荐使用 |
| `sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk` | SDK升级版本（有问题） | ✗ 不推荐 |
| `sanguozhiguoguanzhanjiang_downcc_sdk_upgraded_bangcle_fixed.apk` | 尝试修复Bangcle库 | 备选 |

## 修复脚本

### proper_apk_fix.py（推荐）
- 从原始APK开始
- 只修改SDK版本
- 使用apktool正确处理
- 适用于Android 9+

### fix_bangcle_libs.py
- 尝试从原始APK中提取受保护库
- 替换已损坏的库文件
- 备选方案

### diagnose_apk_libs.py
- 诊断APK中的库文件完整性
- 检查ELF文件头
- 用于问题排查

## 参考资源

- APKTool: https://ibotpeaches.github.io/Apktool/
- Android NDK ABI兼容性: https://developer.android.com/ndk/guides/abis
- Bangcle保护: https://www.bangcle.com/

## 版本历史

- 2024-11-15: 创建此诊断和修复指南
- 问题: 在Android 9 x86模拟器上闪退
- 解决: 使用apktool正确处理APK，保留所有资源完整性
