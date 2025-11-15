# APK证书问题解决报告

## 问题描述
用户报告安装 `sanguozhiguoguanzhanjiang_downcc_resigned_final.apk` 时报错：
**"该安装包未包含任何证书"**

## 问题分析

### 1. 初步调查
- 检查了两个APK文件：
  - `sanguozhiguoguanzhanjiang_downcc_resigned.apk` (43.7MB)
  - `sanguozhiguoguanzhanjiang_downcc_resigned_final.apk` (43.7MB, 小16KB)

### 2. 签名验证结果
使用 `jarsigner -verify` 验证：
- 两个文件都显示 "jar verified"
- 但有警告：签名算法不兼容

### 3. 根本原因发现
使用 `apksigner verify --verbose` 发现关键错误：
```
DOES NOT VERIFY
ERROR: JAR signer RELEASE.RSA: JAR signature META-INF/RELEASE.RSA uses digest algorithm SHA-256 and signature algorithm RSA which is not supported on API Level(s) 9-17 for which this APK is being verified
```

**问题根源**：
- APK的 `targetSdkVersion: 14` (Android 4.0)
- 但使用了SHA-256签名算法
- SHA-256在API Level 9-17上不支持

## 解决方案

### 1. 修改签名算法
将签名脚本从SHA-256改为SHA-1：
```python
# 原来的配置（不兼容）
"-sigalg", "SHA256withRSA",
"-digestalg", "SHA256",

# 修改后的配置（兼容）
"-sigalg", "SHA1withRSA",
"-digestalg", "SHA1",
```

### 2. 重新签名
运行修改后的签名脚本：
```bash
python3 resign_apk.py
```

### 3. 验证修复结果
新文件：`sanguozhiguoguanzhanjiang_downcc_resigned_fixed.apk`

验证结果：
```bash
$ apksigner verify --verbose sanguozhiguoguanzhanjiang_downcc_resigned_fixed.apk
Verifies
Verified using v1 scheme (JAR signing): true
Verified using v2 scheme (APK Signature Scheme v2): false
Verified using v3 scheme (APK Signature Scheme v3): false
Verified using v4 scheme (APK Signature Scheme v4): false
Verified for SourceStamp: false
Number of signers: 1
```

## 技术细节

### 签名方案兼容性
| 签名方案 | 最低API Level | 状态 |
|---------|--------------|------|
| v1 (JAR) | 1+           | ✅ 使用 |
| v2 (APK) | 24+          | ❌ 不支持 |
| v3 (APK) | 28+          | ❌ 不支持 |
| v4 (APK) | 30+          | ❌ 不支持 |

### 算法兼容性
| 算法 | 最低API Level | 使用情况 |
|------|--------------|----------|
| SHA1withRSA | 1+ | ✅ 当前使用 |
| SHA256withRSA | 18+ | ❌ 不兼容targetSdkVersion=14 |

## 最终结果

### 正确的APK文件
- **文件名**: `sanguozhiguoguanzhanjiang_downcc_resigned_fixed.apk`
- **大小**: 41.7MB
- **签名算法**: SHA1withRSA
- **签名方案**: v1 (JAR签名)
- **兼容性**: Android 2.3+ (API Level 9+)

### 安装验证
该APK现在应该可以在所有Android设备上正常安装，包括：
- Android 4.0+ (原始target)
- Android 10+ (通过armeabi-v7a库支持)

## 经验教训

1. **签名算法必须与targetSdkVersion兼容**
   - targetSdkVersion < 18 需要使用SHA1
   - targetSdkVersion ≥ 18 可以使用SHA256

2. **验证工具的重要性**
   - `jarsigner` 可能给出误导性的"verified"结果
   - `apksigner` 是Android官方推荐的验证工具

3. **兼容性考虑**
   - 旧APK需要保持其原始的兼容性要求
   - 不能盲目使用"更安全"的现代算法

## 文件更新

已更新以下文件：
- `最终APK说明.md` - 指向正确的APK文件
- `resign_apk.py` - 使用兼容的SHA1签名算法
- 本报告 - 记录完整的问题解决过程