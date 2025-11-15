# Windows 10 安装和配置指南

## 🎯 快速开始（3分钟搞定）

如果您是 Windows 10 用户，想要快速运行项目中的 .sh 脚本，请按以下步骤操作：

### 第一步：安装 WSL（1分钟）

1. **以管理员身份打开 PowerShell**
   - 在开始菜单搜索 "PowerShell"
   - 右键点击 "Windows PowerShell"
   - 选择 "以管理员身份运行"

2. **运行安装命令**
   ```powershell
   wsl --install
   ```

3. **重启电脑**（如果提示）

4. **设置 Ubuntu**
   - 安装完成后会自动打开 Ubuntu
   - 设置用户名和密码（记住密码）

### 第二步：配置环境（1分钟）

在 Ubuntu 终端中运行：
```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装必要工具
sudo apt install -y openjdk-11-jdk android-sdk-build-tools apktool python3 python3-pip

# 进入项目目录（替换为您的实际路径）
cd /mnt/c/Users/您的用户名/Downloads/项目文件夹名

# 运行快速启动脚本
./windows10_quick_start.sh
```

### 第三步：运行脚本（30秒）

使用数字键选择要运行的脚本，例如：
- 按 `1` 运行完整的 APK 修复
- 按 `2` 收集崩溃日志
- 按 `3` 修复应用权限

---

## 📋 详细安装说明

### 方法一：WSL + Ubuntu（推荐）

#### 1. 系统要求
- Windows 10 版本 2004 或更高
- 或者 Windows 11

#### 2. 安装步骤

**方式A：一键安装**
```powershell
# 管理员 PowerShell 中运行
wsl --install -d Ubuntu
```

**方式B：手动安装**
```powershell
# 启用 WSL 功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 启用虚拟机平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 重启后安装 WSL2
wsl --set-default-version 2
```

#### 3. 配置 Ubuntu

首次启动后的配置：
```bash
# 更新软件包
sudo apt update && sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl wget git unzip zip

# 安装 Java 和 Android 工具
sudo apt install -y openjdk-11-jdk android-sdk-build-tools apktool

# 安装 Python 工具
sudo apt install -y python3 python3-pip

# 设置环境变量
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export ANDROID_HOME=/usr/lib/android-sdk' >> ~/.bashrc
source ~/.bashrc
```

#### 4. 访问项目文件

在 WSL 中访问 Windows 文件：
```bash
# C盘路径格式
cd /mnt/c/Users/YourUsername/Downloads/project-name

# 或者使用 Windows 文件资源管理器
# 在地址栏输入: \\wsl$\Ubuntu\home\username
```

### 方法二：Git Bash（备选）

#### 1. 安装 Git for Windows
- 下载地址：https://git-scm.com/download/win
- 下载并运行安装程序
- 选择 "Git Bash Here" 选项

#### 2. 安装依赖工具

**Java SDK**
- 下载：https://adoptium.net/
- 安装后设置环境变量

**Android SDK**
- 下载 Android Studio：https://developer.android.com/studio
- 或单独下载 SDK 工具

**apktool**
- 下载：https://ibotpeaches.github.io/Apktool/
- 解压到系统 PATH 目录

#### 3. 配置环境变量

在 Windows 系统属性中：
```
变量名: JAVA_HOME
变量值: C:\Program Files\Eclipse Adoptium\jdk-11.0.x.x-hotspot

变量名: ANDROID_HOME  
变量值: C:\Users\YourName\AppData\Local\Android\Sdk

变量名: PATH
添加: %JAVA_HOME%\bin;%ANDROID_HOME%\build-tools\33.0.0
```

### 方法三：Docker（高级用户）

#### 1. 安装 Docker Desktop
- 下载：https://www.docker.com/products/docker-desktop
- 安装并启动服务

#### 2. 使用项目 Dockerfile
```bash
# 在项目目录中
docker build -t apk-fix-tools .

# 运行容器
docker run -it -v $(pwd):/app apk-fix-tools
```

---

## 🔧 常见问题解决

### 问题1：WSL 安装失败

**解决方案：**
```powershell
# 手动启用功能
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

# 重启后重试
```

### 问题2：工具找不到

**解决方案：**
```bash
# 检查工具安装
which java
which apktool
which zipalign

# 重新安装
sudo apt install --reinstall openjdk-11-jdk android-sdk-build-tools apktool
```

### 问题3：权限错误

**解决方案：**
```bash
# 给脚本添加执行权限
chmod +x *.sh

# 检查文件权限
ls -la *.sh
```

### 问题4：ADB 设备连接问题

**解决方案：**
```bash
# 检查设备连接
adb devices

# 重启 ADB 服务
adb kill-server
adb start-server

# 检查 USB 调试设置
# 确保手机已开启 USB 调试
```

### 问题5：Java 版本不兼容

**解决方案：**
```bash
# 检查 Java 版本
java -version

# 切换 Java 版本（如果有多个版本）
sudo update-alternatives --config java

# 设置 JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

---

## 🚀 快速测试

安装完成后，运行以下命令测试环境：

```bash
# 测试 Java
java -version

# 测试 apktool
apktool --version

# 测试项目脚本
./windows10_quick_start.sh

# 或直接运行
./advanced_fix.sh
```

---

## 📞 获取帮助

如果遇到问题：

1. **查看详细指南**：`WINDOWS10_SH_SCRIPT_GUIDE.md`
2. **运行诊断脚本**：`./windows10_quick_start.sh` → 选择 `7` 检查依赖
3. **查看日志**：检查脚本输出的错误信息
4. **重新安装**：如果问题持续，可以重置 WSL：
   ```powershell
   wsl --unregister Ubuntu
   wsl --install -d Ubuntu
   ```

---

## 🎉 成功标志

当您看到以下输出时，说明环境配置成功：

```
✅ 所有依赖工具已安装
✅ 脚本权限已正确设置
🚀 APK 修复工具已就绪
```

现在您可以开始使用所有 .sh 脚本了！