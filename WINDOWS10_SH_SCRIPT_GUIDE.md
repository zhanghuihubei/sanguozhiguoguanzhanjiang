# Windows 10 运行 .sh 文件完整指南

## 概述

本项目包含多个 Bash 脚本（.sh 文件），用于 Android APK 的修复、签名、权限管理等操作。本指南将详细介绍如何在 Windows 10 系统上运行这些脚本。

## 方法一：使用 WSL（Windows Subsystem for Linux）【推荐】

### 1. 安装 WSL

以管理员身份打开 PowerShell，运行：
```powershell
# 启用 WSL 功能
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 启用虚拟机平台
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 重启电脑后，安装 WSL2
wsl --install
```

### 2. 安装 Linux 发行版

从 Microsoft Store 安装 Ubuntu（推荐）或使用 PowerShell：
```powershell
# 下载并安装 Ubuntu
wsl --install -d Ubuntu
```

### 3. 配置 WSL 环境

首次启动 Ubuntu 后，设置用户名和密码：

```bash
# 更新软件包
sudo apt update && sudo apt upgrade -y

# 安装必要的工具
sudo apt install -y python3 python3-pip git curl wget unzip
```

### 4. 安装 Android 工具链

```bash
# 安装 Java SDK
sudo apt install -y openjdk-11-jdk

# 安装 Android 工具
sudo apt install -y android-sdk-build-tools apktool

# 设置 Java 环境变量
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc
```

### 5. 运行项目脚本

```bash
# 进入项目目录
cd /mnt/c/your/project/path  # 替换为实际路径

# 给脚本添加执行权限
chmod +x *.sh

# 运行脚本示例
./advanced_fix.sh
./collect_crash_log.sh
./fix_permissions.sh
```

## 方法二：使用 Git Bash

### 1. 安装 Git for Windows

下载并安装 [Git for Windows](https://git-scm.com/download/win)，安装时选择 "Git Bash Here" 选项。

### 2. 安装必要工具

下载并安装以下工具：
- **Java SDK**: [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) 或 [OpenJDK](https://adoptium.net/)
- **Android SDK**: [Android Studio](https://developer.android.com/studio) 或单独下载 SDK 工具
- **apktool**: [官方下载](https://ibotpeaches.github.io/Apktool/)

### 3. 配置环境变量

在 Windows 系统属性中设置环境变量：
```
JAVA_HOME=C:\Program Files\Java\jdk-11
ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk
PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\build-tools\33.0.0;%PATH%
```

### 4. 运行脚本

在项目文件夹中右键选择 "Git Bash Here"：

```bash
# 运行脚本
bash advanced_fix.sh
bash collect_crash_log.sh
bash fix_permissions.sh
```

## 方法三：使用 Cygwin

### 1. 下载并安装 Cygwin

从 [Cygwin官网](https://www.cygwin.com/) 下载安装程序，安装时选择以下包：
- bash
- python3
- git
- curl
- wget
- unzip

### 2. 配置 Cygwin

运行 Cygwin 终端，安装 Python 包：
```bash
pip3 install --upgrade pip
```

### 3. 运行脚本

```bash
# 进入项目目录
cd /cygdrive/c/your/project/path

# 运行脚本
./advanced_fix.sh
```

## 方法四：使用 Docker

### 1. 安装 Docker Desktop

下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)。

### 2. 创建 Dockerfile

在项目根目录创建 `Dockerfile`：

```dockerfile
FROM ubuntu:20.04

# 避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    android-sdk-build-tools \
    apktool \
    git \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 设置权限
RUN chmod +x *.sh

# 默认命令
CMD ["/bin/bash"]
```

### 3. 构建和运行容器

```bash
# 构建镜像
docker build -t apk-fix-tools .

# 运行容器
docker run -it -v $(pwd):/app apk-fix-tools

# 在容器内运行脚本
./advanced_fix.sh
```

## 项目脚本说明

### 1. advanced_fix.sh
- **用途**: 完整的 APK 修复脚本
- **功能**: 反编译、修复 native 库、重新签名、对齐优化
- **依赖**: apktool, keytool, jarsigner, zipalign

### 2. collect_crash_log.sh
- **用途**: 收集 Android 应用崩溃日志
- **功能**: 连接设备、记录日志、提取错误信息
- **依赖**: adb

### 3. compatibility_launcher.sh
- **用途**: 兼容性启动器
- **功能**: 检查和修复兼容性问题

### 4. fix_permissions.sh
- **用途**: 修复应用权限
- **功能**: 授予存储、网络等必要权限
- **依赖**: pm, appops (Android 工具)

### 5. storage_fix.sh
- **用途**: 存储权限修复
- **功能**: 解决 Android 10+ 存储访问问题

### 6. huawei_sanguo_crash_fix.sh
- **用途**: 华为设备三国游戏闪退修复
- **功能**: 针对特定设备和游戏的修复方案

## 常见问题解决

### 1. 权限错误
```bash
# Linux/WSL 中给脚本添加执行权限
chmod +x script_name.sh
```

### 2. 工具未找到
```bash
# 检查工具安装
which apktool
which java
which adb

# Ubuntu/Debian 安装
sudo apt install apktool android-sdk-build-tools openjdk-11-jdk
```

### 3. Java 版本问题
```bash
# 检查 Java 版本
java -version

# 设置默认 Java
sudo update-alternatives --config java
```

### 4. ADB 设备连接问题
```bash
# 检查设备连接
adb devices

# 重启 ADB 服务
adb kill-server
adb start-server
```

### 5. WSL 文件路径问题
```bash
# Windows 路径转换为 WSL 路径
# C:\Users\Name\Project -> /mnt/c/Users/Name/Project
cd /mnt/c/Users/YourName/Path/To/Project
```

## 推荐方案

对于大多数用户，**推荐使用 WSL + Ubuntu** 的方案，原因如下：

1. **兼容性最好**: 完整的 Linux 环境，支持所有脚本功能
2. **性能优秀**: 直接在 Windows 上运行，性能接近原生 Linux
3. **易于维护**: 标准的包管理，易于安装和更新工具
4. **文件访问方便**: 直接访问 Windows 文件系统
5. **微软官方支持**: 稳定可靠，持续更新

## 快速开始（WSL 方案）

```bash
# 1. 安装 WSL 和 Ubuntu
wsl --install -d Ubuntu

# 2. 配置环境
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-11-jdk android-sdk-build-tools apktool python3 python3-pip

# 3. 进入项目目录
cd /mnt/c/path/to/your/project

# 4. 运行脚本
chmod +x *.sh
./advanced_fix.sh
```

## 注意事项

1. **路径格式**: WSL 中使用 `/mnt/c/` 格式访问 Windows 盘符
2. **权限管理**: 某些操作可能需要管理员权限
3. **设备连接**: USB 调试需要正确配置 Android 设备
4. **依赖工具**: 确保所有必需的工具都已正确安装
5. **版本兼容**: 注意 Java 版本和 Android 工具版本的兼容性

通过以上方法，您可以在 Windows 10 上成功运行项目中的所有 .sh 脚本。