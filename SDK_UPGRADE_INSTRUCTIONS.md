# APK SDK版本升级说明

## 问题分析
- 原始APK: targetSdkVersion=14 (Android 4.0)
- 现代Android系统要求更高的SDK版本
- 错误: "此应用SDK版本过低, 无法正常运行"

## 执行的升级
- minSdkVersion: 8 → 19 (Android 4.4)
- targetSdkVersion: 14 → 28 (Android 9)
- 添加兼容性配置
- 重新签名APK

## 输出文件
- 升级后的APK: `sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk`
- 工作目录: `sdk_upgrade_work`

## 安装测试
```bash
# 卸载旧版本
adb uninstall com.idealdimension.EmpireAttack

# 安装升级版本
adb install sanguozhiguoguanzhanjiang_downcc_sdk_upgraded.apk

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
