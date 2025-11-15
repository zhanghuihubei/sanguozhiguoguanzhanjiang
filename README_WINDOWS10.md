# 🚀 Windows 10 用户快速指南

## 🎯 一句话总结
**在 Windows 10 上运行 .sh 脚本的最佳方案是使用 WSL + Ubuntu**

## ⚡ 3分钟快速开始

### 1️⃣ 安装 WSL（管理员 PowerShell）
```powershell
wsl --install
```

### 2️⃣ 配置环境（Ubuntu 终端）
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-11-jdk android-sdk-build-tools apktool python3 python3-pip
```

### 3️⃣ 运行脚本
```bash
# 进入项目目录（替换路径）
cd /mnt/c/Users/您的用户名/Downloads/项目文件夹

# 运行快速启动器
./windows10_quick_start.sh

# 或直接运行脚本
./advanced_fix.sh
```

---

## 📁 项目文件说明

### 主要脚本文件
- `advanced_fix.sh` - 完整的 APK 修复脚本 ⭐
- `collect_crash_log.sh` - 收集崩溃日志
- `fix_permissions.sh` - 修复应用权限
- `storage_fix.sh` - 修复存储权限
- `huawei_sanguo_crash_fix.sh` - 华为设备专用

### Windows 辅助文件
- `windows10_quick_start.sh` - WSL 快速启动器
- `启动WSL工具.bat` - Windows 批处理启动器
- `WINDOWS10_INSTALL_GUIDE.md` - 详细安装指南
- `WINDOWS10_SH_SCRIPT_GUIDE.md` - 完整使用指南

---

## 🛠️ 两种启动方式

### 方式一：双击批处理文件
1. 双击 `启动WSL工具.bat`
2. 选择 `1` 启动 APK 修复工具

### 方式二：命令行启动
1. 打开 Ubuntu 终端
2. 进入项目目录
3. 运行 `./windows10_quick_start.sh`

---

## ❓ 常见问题

**Q: WSL 安装失败？**
A: 确保是 Windows 10 版本 2004+，以管理员身份运行 PowerShell

**Q: 找不到 apktool？**
A: 运行 `sudo apt install apktool`

**Q: 脚本没有执行权限？**
A: 运行 `chmod +x *.sh`

**Q: 如何访问 Windows 文件？**
A: C盘路径是 `/mnt/c/`，用户目录是 `/mnt/c/Users/用户名/`

---

## 📞 需要帮助？

- 📖 详细指南：`WINDOWS10_INSTALL_GUIDE.md`
- 🔧 完整文档：`WINDOWS10_SH_SCRIPT_GUIDE.md`
- 🚀 快速启动：`./windows10_quick_start.sh`

---

## ✅ 检查安装是否成功

运行以下命令，如果都有输出说明安装成功：

```bash
java -version          # 应显示 Java 版本
apktool --version      # 应显示 apktool 版本
./windows10_quick_start.sh  # 应显示菜单界面
```

---

**🎉 恭喜！现在您可以在 Windows 10 上运行所有 .sh 脚本了！**