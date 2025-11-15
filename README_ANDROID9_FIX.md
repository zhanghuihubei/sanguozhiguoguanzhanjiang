# Android 9 雷电模拟器闪退修复 - 使用说明

## 🚀 快速开始

如果您只想快速安装修复版本，只需3个命令：

```bash
# 1. 卸载旧版本
adb uninstall com.idealdimension.EmpireAttack

# 2. 安装修复版本
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk

# 3. 授予权限
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

## ✅ 验证修复成功

启动应用应该不再闪退。检查方式：

```bash
# 查看日志
adb logcat | grep -E "(EmpireAttack|error|crash)"

# 启动应用
adb shell am start -n com.idealdimension.EmpireAttack/cn.cmgame.billing.api.GameOpenActivity
```

应该不再看到：
```
java.lang.UnsatisfiedLinkError: no error!
```

---

## 📚 文档指南

### 想快速了解？
👉 **阅读**: `QUICKFIX_ANDROID9_EMULATOR.md`
- 3个步骤的快速指南
- 基本故障排查

### 想理解问题和解决方案？
👉 **阅读**: `CRASH_FIX_SUMMARY.md`
- 问题诊断分析
- 为什么会闪退
- 如何修复的

### 需要技术细节？
👉 **阅读**: `ANDROID9_EMULATOR_FIX.md`
- 技术深入分析
- 进阶故障排查

### 想看完整解决方案？
👉 **阅读**: `SOLUTION_ANDROID9_FINAL.md`
- 完整的项目文档
- 诊断过程
- 实施步骤

### 需要找文件？
👉 **阅读**: `ANDROID9_CRASH_FIX_INDEX.md`
- 所有文件的索引
- 文件说明
- 工作流程图

---

## 🔧 如需重新修复APK

如果您想从头创建修复后的APK：

```bash
# 1. 安装必要的工具
sudo apt-get install apktool android-sdk-build-tools openjdk-11-jdk

# 2. 运行修复脚本
python3 proper_apk_fix.py

# 这会生成新的 sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

## 🔍 诊断问题

如果需要诊断APK库文件状态：

```bash
python3 diagnose_apk_libs.py
```

这会显示APK中所有库文件的ELF头信息和完整性状态。

---

## 📦 可用的APK文件

| 文件 | 推荐 | 说明 |
|------|------|------|
| `sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk` | ✅ | 推荐使用，最可靠 |
| `sanguozhiguoguanzhanjiang_downcc_sdk_upgraded_bangcle_fixed.apk` | ⚠️ | 备选方案 |

---

## 💾 脚本文件

| 脚本 | 功能 | 何时使用 |
|------|------|----------|
| `proper_apk_fix.py` | ⭐ 主要修复脚本 | 需要重新创建APK |
| `diagnose_apk_libs.py` | 诊断工具 | 检查库文件完整性 |
| `fix_bangcle_libs.py` | 备选修复脚本 | 主要脚本失败时尝试 |

---

## ❓ 常见问题

### Q: 修复后仍然闪退怎么办？
**A**: 
1. 试试备选APK: `sanguozhiguoguanzhanjiang_downcc_sdk_upgraded_bangcle_fixed.apk`
2. 清除应用数据: `adb shell pm clear com.idealdimension.EmpireAttack`
3. 查看日志: `adb logcat | grep empire`

### Q: 权限提示错误怎么办？
**A**: 手动授予权限：
```bash
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

### Q: 在真实Huawei设备上会工作吗？
**A**: 是的。这个APK支持targetSdkVersion=28，应该在Huawei Enjoy 60（Android 10）上也能工作。

### Q: 可以在其他模拟器上使用吗？
**A**: 是的，只要支持Android 9及以上版本。

### Q: 修复会改变游戏功能吗？
**A**: 不会。修复只是：
- 更新SDK版本以支持Android 9
- 保留了所有原始功能和库文件

---

## 📖 问题诊断信息

### 原始问题症状
- 设备：雷电模拟器
- Android版本：9
- CPU架构：x86_64
- 错误：`java.lang.UnsatisfiedLinkError: no error!`
- 发生位置：Bangcle保护库加载时

### 诊断发现
- Bangcle库文件在修改过程中被破坏
- 简单的ZIP操作损坏了二进制资源
- DEX文件完整性检查失败

### 解决方案
- 使用apktool正确处理APK
- 保留所有原始资源完整性
- 只修改必要的SDK版本

---

## 🛠️ 工具要求

### 仅使用APK（推荐）
- 需要：Android SDK Platform Tools (adb)
- 不需要：任何编译工具

### 运行修复脚本
- 需要：
  - Python 3.6+
  - apktool
  - Android SDK Build Tools
  - Java (openjdk-11-jdk)

### 在Ubuntu/Debian上安装
```bash
sudo apt-get install apktool android-sdk-build-tools openjdk-11-jdk python3
```

---

## 📞 需要帮助？

1. **问题快速解决**：阅读 `QUICKFIX_ANDROID9_EMULATOR.md`
2. **理解问题**：阅读 `CRASH_FIX_SUMMARY.md`
3. **技术支持**：阅读 `ANDROID9_EMULATOR_FIX.md`
4. **完整文档**：阅读 `SOLUTION_ANDROID9_FINAL.md`

---

## ✨ 总结

| 项目 | 说明 |
|------|------|
| **问题** | Android 9模拟器闪退 |
| **原因** | APK修改方式不当 |
| **解决** | 使用apktool正确处理 |
| **结果** | ✅ `sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk` |
| **使用** | `adb install -r [APK]` |

**立即开始**：
```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

祝您使用愉快！🎮
