#!/bin/bash
###############################################################################
# Windows 10 快速启动脚本 - 用于在 WSL 环境中运行 APK 修复工具
# 
# 使用方法:
#   1. 在 Windows 10 上安装 WSL 和 Ubuntu
#   2. 将此脚本复制到项目目录
#   3. 在 WSL 中运行: bash windows10_quick_start.sh
###############################################################################

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="APK 修复工具集"
VERSION="1.0"

# 显示横幅
show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    Windows 10 APK 修复工具                      ║"
    echo "║                      快速启动脚本 v$VERSION                       ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 检查是否在 WSL 环境中
check_wsl() {
    if ! grep -q Microsoft /proc/version 2>/dev/null; then
        echo -e "${YELLOW}⚠️  警告: 检测到您可能不在 WSL 环境中${NC}"
        echo -e "${BLUE}💡 如果您在 WSL 中运行此脚本，请忽略此警告${NC}"
        echo ""
    else
        echo -e "${GREEN}✅ 检测到 WSL 环境${NC}"
    fi
}

# 检查依赖工具
check_dependencies() {
    echo -e "${BLUE}🔍 检查依赖工具...${NC}"
    
    local missing_tools=()
    
    # 检查基本工具
    for tool in python3 java apktool zipalign; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        else
            echo -e "  ${GREEN}✅${NC} $tool: $(command -v "$tool")"
        fi
    done
    
    # 检查 Java 工具
    for tool in keytool jarsigner; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        else
            echo -e "  ${GREEN}✅${NC} $tool: $(command -v "$tool")"
        fi
    done
    
    # 检查 Android 工具
    if command -v adb &> /dev/null; then
        echo -e "  ${GREEN}✅${NC} adb: $(command -v adb)"
    else
        echo -e "  ${YELLOW}⚠️${NC} adb: 未安装（可选，用于设备交互）"
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo ""
        echo -e "${RED}❌ 缺少以下工具:${NC}"
        for tool in "${missing_tools[@]}"; do
            echo -e "  ${RED}•${NC} $tool"
        done
        echo ""
        echo -e "${BLUE}💡 安装命令:${NC}"
        echo -e "${YELLOW}sudo apt update && sudo apt install -y openjdk-11-jdk android-sdk-build-tools apktool${NC}"
        echo ""
        return 1
    fi
    
    echo -e "${GREEN}✅ 所有依赖工具已安装${NC}"
    return 0
}

# 显示可用脚本
show_available_scripts() {
    echo -e "${BLUE}📋 可用的脚本:${NC}"
    echo ""
    
    local scripts=(
        "advanced_fix.sh:完整的 APK 修复脚本（推荐）"
        "collect_crash_log.sh:收集应用崩溃日志"
        "fix_permissions.sh:修复应用权限"
        "storage_fix.sh:修复存储权限"
        "compatibility_launcher.sh:兼容性启动器"
        "huawei_sanguo_crash_fix.sh:华为设备专用修复"
    )
    
    for script in "${scripts[@]}"; do
        local name=$(echo "$script" | cut -d':' -f1)
        local desc=$(echo "$script" | cut -d':' -f2)
        
        if [ -f "$name" ]; then
            if [ -x "$name" ]; then
                echo -e "  ${GREEN}[✓]${NC} $name - $desc"
            else
                echo -e "  ${YELLOW}[? ]${NC} $name - $desc (需要执行权限)"
            fi
        else
            echo -e "  ${RED}[✗]${NC} $name - $desc (文件不存在)"
        fi
    done
    echo ""
}

# 设置脚本权限
setup_permissions() {
    echo -e "${BLUE}🔧 设置脚本执行权限...${NC}"
    
    local fixed=0
    for script in *.sh; do
        if [ -f "$script" ] && [ ! -x "$script" ]; then
            chmod +x "$script"
            echo -e "  ${GREEN}✅${NC} $script"
            ((fixed++))
        fi
    done
    
    if [ $fixed -eq 0 ]; then
        echo -e "  ${GREEN}✅${NC} 所有脚本权限已正确设置"
    else
        echo -e "  ${GREEN}✅${NC} 已修复 $fixed 个脚本的权限"
    fi
    echo ""
}

# 显示快速操作菜单
show_menu() {
    echo -e "${PURPLE}🚀 快速操作菜单:${NC}"
    echo ""
    echo "1) 运行完整 APK 修复 (advanced_fix.sh)"
    echo "2) 收集崩溃日志 (collect_crash_log.sh)"
    echo "3) 修复应用权限 (fix_permissions.sh)"
    echo "4) 修复存储权限 (storage_fix.sh)"
    echo "5) 华为设备修复 (huawei_sanguo_crash_fix.sh)"
    echo "6) 显示所有脚本"
    echo "7) 检查依赖工具"
    echo "8) 安装缺失依赖"
    echo "9) 设置脚本权限"
    echo "0) 退出"
    echo ""
}

# 运行选定的脚本
run_script() {
    local script_name="$1"
    
    if [ ! -f "$script_name" ]; then
        echo -e "${RED}❌ 脚本不存在: $script_name${NC}"
        return 1
    fi
    
    if [ ! -x "$script_name" ]; then
        echo -e "${YELLOW}⚠️  脚本没有执行权限，正在设置...${NC}"
        chmod +x "$script_name"
    fi
    
    echo -e "${GREEN}🚀 运行脚本: $script_name${NC}"
    echo -e "${BLUE}按回车键继续，或 Ctrl+C 取消...${NC}"
    read -r
    
    # 运行脚本
    ./"$script_name"
    
    echo ""
    echo -e "${GREEN}✅ 脚本执行完成${NC}"
}

# 安装依赖工具
install_dependencies() {
    echo -e "${BLUE}📦 安装依赖工具...${NC}"
    echo -e "${YELLOW}这将需要管理员权限${NC}"
    echo ""
    
    # 更新软件包列表
    echo -e "${BLUE}更新软件包列表...${NC}"
    sudo apt update
    
    # 安装工具
    echo -e "${BLUE}安装 Android 工具链...${NC}"
    sudo apt install -y \
        openjdk-11-jdk \
        android-sdk-build-tools \
        apktool \
        python3 \
        python3-pip \
        zipalign
    
    echo -e "${GREEN}✅ 依赖工具安装完成${NC}"
}

# 显示 Windows 路径提示
show_windows_path_info() {
    echo -e "${CYAN}📁 Windows 路径访问提示:${NC}"
    echo ""
    echo "在 WSL 中访问 Windows 文件系统:"
    echo "  C盘: /mnt/c/"
    echo "  D盘: /mnt/d/"
    echo "  用户目录: /mnt/c/Users/YourUsername/"
    echo ""
    echo "当前项目目录: $(pwd)"
    echo "Windows 路径: $(wslpath -w "$(pwd)")"
    echo ""
}

# 主函数
main() {
    show_banner
    echo ""
    
    # 检查环境
    check_wsl
    echo ""
    
    # 显示路径信息
    show_windows_path_info
    
    # 检查依赖
    if ! check_dependencies; then
        echo ""
    fi
    
    # 设置权限
    setup_permissions
    
    # 显示可用脚本
    show_available_scripts
    
    # 交互式菜单
    while true; do
        show_menu
        echo -n -e "${BLUE}请选择操作 (0-9): ${NC}"
        read -r choice
        echo ""
        
        case $choice in
            1)
                run_script "advanced_fix.sh"
                ;;
            2)
                run_script "collect_crash_log.sh"
                ;;
            3)
                run_script "fix_permissions.sh"
                ;;
            4)
                run_script "storage_fix.sh"
                ;;
            5)
                run_script "huawei_sanguo_crash_fix.sh"
                ;;
            6)
                show_available_scripts
                ;;
            7)
                check_dependencies
                ;;
            8)
                install_dependencies
                ;;
            9)
                setup_permissions
                ;;
            0)
                echo -e "${GREEN}👋 再见！${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ 无效选择，请重新输入${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${BLUE}按回车键继续...${NC}"
        read -r
    done
}

# 错误处理
trap 'echo -e "${RED}❌ 脚本被中断${NC}"; exit 1' INT TERM

# 运行主函数
main "$@"