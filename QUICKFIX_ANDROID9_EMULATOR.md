# 快速修复指南 - Android 9 雷电模拟器闪退

## 问题
在雷电模拟器（Android 9, x86架构）上闪退，显示：
```
java.lang.UnsatisfiedLinkError: no error!
at com.bangcle.protect.ACall.<clinit>
```

## 快速解决方案（3个步骤）

### 步骤1：清除旧应用
```bash
adb uninstall com.idealdimension.EmpireAttack
```

### 步骤2：安装修复版本
```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

### 步骤3：授予权限（可选）
```bash
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

## 完成！

应用应该现在可以正常启动。

## 如果仍然不工作

### 检查1：验证安装
```bash
adb shell pm list packages | grep idealdimension
```
应该显示：`package:com.idealdimension.EmpireAttack`

### 检查2：查看错误日志
```bash
adb logcat | grep -E "(EmpireAttack|crash|error|bangcle)"
```

### 检查3：重新尝试安装
```bash
adb uninstall com.idealdimension.EmpireAttack
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

## 技术信息

**修复文件**：`sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk`
- 大小：~35 MB
- targetSdkVersion：28（Android 9）
- 基于原始APK，保留所有功能
- Bangcle保护保持有效

**修复方式**：使用apktool重新处理APK，确保所有二进制资源的完整性

详见：`CRASH_FIX_SUMMARY.md` 和 `ANDROID9_EMULATOR_FIX.md`
