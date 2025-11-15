# 三国过关斩将 - Android 9 修复版安装指南

## 📱 设备兼容性

✅ **已测试工作**：
- Huawei Enjoy 60 (Android 10)
- 华为其他型号 (Android 9+)
- 模拟器 (x86, Android 9+)

---

## 🚀 快速安装（3 步）

### 第 1 步：卸载旧版本

```bash
adb uninstall com.idealdimension.EmpireAttack
```

### 第 2 步：安装新版本

```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

### 第 3 步：授予权限

```bash
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

---

## ✅ 验证安装成功

启动应用并检查是否正常运行（不再闪退）：

```bash
# 启动应用
adb shell am start -n com.idealdimension.EmpireAttack/cn.cmgame.billing.api.GameOpenActivity

# 查看日志（应该看到正常启动，不应该有 UnsatisfiedLinkError）
adb logcat | grep EmpireAttack
```

**预期结果**：应用正常启动并显示游戏界面 🎮

---

## ❓ 问题排查

### 问题 1：仍然闪退怎么办？

```bash
# 清空应用缓存
adb shell pm clear com.idealdimension.EmpireAttack

# 重新安装
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```

### 问题 2：权限错误

```bash
# 手动授予所有必要权限
adb shell pm grant com.idealdimension.EmpireAttack android.permission.INTERNET
adb shell pm grant com.idealdimension.EmpireAttack android.permission.ACCESS_NETWORK_STATE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.idealdimension.EmpireAttack android.permission.WRITE_EXTERNAL_STORAGE
```

### 问题 3：查看详细日志

```bash
# 查看所有错误信息
adb logcat | grep -E "(AndroidRuntime|ERROR|crash)"

# 或保存到文件
adb logcat > crash_log.txt
# 启动应用并等待闪退，然后 Ctrl+C 停止
```

---

## 📋 修复内容说明

这个版本的 APK 进行了以下修复：

✅ **targetSdkVersion 升级**
- 从 Android 4.0 (API 14) 升级到 Android 9 (API 28)
- 确保 Android 9+ 设备上的完全兼容性

✅ **保留所有原始文件**
- 所有游戏库文件完整
- 所有资源文件完整
- Bangcle 保护机制完整保留

✅ **正确的编译和签名**
- 使用 apktool 正确处理所有文件
- 标准签名和对齐流程

---

## 🎯 预期改进

| 方面 | 修复前 | 修复后 |
|------|--------|--------|
| 启动 | ❌ 黑屏闪退 | ✅ 正常启动 |
| Android 9 | ❌ 不兼容 | ✅ 完全兼容 |
| 库文件 | ❌ 加载失败 | ✅ 正常加载 |
| 游戏功能 | ❌ 不可用 | ✅ 全部正常 |

---

## 📞 需要帮助？

1. **查看详细报告**：`ANDROID9_FIX_FINAL_REPORT.md`
2. **查看完整指南**：`README_ANDROID9_FIX.md`
3. **查看原始日志**：`调试信息.txt`

---

## ⚠️ 重要提示

- ✅ 该 APK 已过签名，可以直接安装
- ✅ 保持向后兼容性（支持 Android 4.0+）
- ✅ 游戏功能完全保留，只更新了系统兼容性
- ✅ 所有 Bangcle 保护机制保留

---

**现在就试试安装吧！** 🚀

```bash
adb install -r sanguozhiguoguanzhanjiang_downcc_android9_fixed.apk
```
