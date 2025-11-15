@echo off
REM Windows 10 快速启动批处理文件
REM 用于在 Windows 上快速启动 WSL 并运行 APK 修复工具

setlocal enabledelayedexpansion

REM 设置颜色代码
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "CYAN=[96m"
set "NC=[0m"

REM 显示横幅
echo %CYAN%
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                Windows 10 APK 修复工具启动器                    ║
echo ║                      一键启动 WSL 环境                          ║
echo ╚════════════════════════════════════════════════════════════════╝
echo %NC%

REM 检查 WSL 是否安装
echo %BLUE%🔍 检查 WSL 环境...%NC%
wsl --version >nul 2>&1
if errorlevel 1 (
    echo %RED%❌ WSL 未安装%NC%
    echo.
    echo %YELLOW%💡 请先安装 WSL:%NC%
    echo %CYAN%以管理员身份运行 PowerShell 并执行:%NC%
    echo wsl --install
    echo.
    echo %CYAN%或者从 Microsoft Store 安装 Ubuntu%NC%
    pause
    exit /b 1
)

echo %GREEN%✅ WSL 已安装%NC%

REM 检查是否有 Linux 发行版
echo %BLUE%🔍 检查 Linux 发行版...%NC%
wsl -l -q >nul 2>&1
if errorlevel 1 (
    echo %RED%❌ 未找到 Linux 发行版%NC%
    echo.
    echo %YELLOW%💡 请安装 Ubuntu 或其他 Linux 发行版%NC%
    echo %CYAN%从 Microsoft Store 搜索并安装 Ubuntu%NC%
    pause
    exit /b 1
)

echo %GREEN%✅ 找到 Linux 发行版%NC%

REM 获取当前目录
set "CURRENT_DIR=%cd%"
echo %BLUE%📁 当前项目目录:%NC%
echo %CYAN%%CURRENT_DIR%%NC%
echo.

REM 检查是否存在快速启动脚本
set "WSL_PATH=%CURRENT_DIR%"
set "WSL_PATH=!WSL_PATH:\=/!"
set "WSL_PATH=!WSL_PATH:C:=/mnt/c!"
set "WSL_PATH=!WSL_PATH:D:=/mnt/d!"
set "WSL_PATH=!WSL_PATH:E:=/mnt/e!"

echo %BLUE%🔍 检查快速启动脚本...%NC%
wsl -e test -f "%WSL_PATH%/windows10_quick_start.sh"
if errorlevel 1 (
    echo %RED%❌ 快速启动脚本不存在%NC%
    echo %YELLOW%💡 请确保 windows10_quick_start.sh 文件在当前目录中%NC%
    pause
    exit /b 1
)

echo %GREEN%✅ 找到快速启动脚本%NC%
echo.

REM 显示选项菜单
:menu
echo %CYAN%🚀 请选择操作:%NC%
echo.
echo 1) 启动 WSL 并运行 APK 修复工具
echo 2) 启动 WSL 并进入项目目录
echo 3) 安装 WSL (如果未安装)
echo 4) 查看 WSL 状态
echo 5) 打开项目文件夹
echo 0) 退出
echo.
set /p choice=%BLUE%请选择 (0-5): %NC%

if "%choice%"=="1" goto run_apk_tools
if "%choice%"=="2" goto enter_wsl
if "%choice%"=="3" goto install_wsl
if "%choice%"=="4" goto check_wsl_status
if "%choice%"=="5" goto open_folder
if "%choice%"=="0" goto exit
echo %RED%❌ 无效选择，请重试%NC%
goto menu

:run_apk_tools
echo.
echo %GREEN%🚀 启动 WSL 并运行 APK 修复工具...%NC%
echo.
wsl -e bash "%WSL_PATH%/windows10_quick_start.sh"
goto menu

:enter_wsl
echo.
echo %GREEN%🚀 启动 WSL 并进入项目目录...%NC%
echo.
wsl -e bash -c "cd '%WSL_PATH%' && exec bash"
goto menu

:install_wsl
echo.
echo %BLUE%📦 安装 WSL...%NC%
echo.
echo %CYAN%以管理员身份运行以下命令:%NC%
echo wsl --install
echo.
echo %CYAN%或者访问:%NC%
echo https://aka.ms/wsl2
echo.
pause
goto menu

:check_wsl_status
echo.
echo %BLUE%📊 WSL 状态信息:%NC%
echo.
wsl --version
echo.
wsl -l -v
echo.
pause
goto menu

:open_folder
echo.
echo %GREEN%📁 打开项目文件夹...%NC%
explorer "%CURRENT_DIR%"
goto menu

:exit
echo.
echo %GREEN%👋 再见！%NC%
pause
exit /b 0

REM 错误处理
:error
echo.
echo %RED%❌ 发生错误%NC%
echo %YELLOW%错误代码: %errorlevel%%NC%
pause
exit /b %errorlevel%