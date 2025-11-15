#!/bin/bash
# 三国志官斩华为闪退一键修复脚本
# 自动按顺序执行所有修复步骤

echo "🎮 三国志官斩华为闪退一键修复工具"
echo "=================================="
echo "设备: 华为畅享60 Android 10"
echo "问题: 启动图标生成时闪退"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查脚本文件是否存在
check_script() {
    local script=$1
    local description=$2
    
    if [ -f "$script" ]; then
        echo -e "${GREEN}✅ 找到 $description${NC}"
        return 0
    else
        echo -e "${RED}❌ 缺少 $description: $script${NC}"
        return 1
    fi
}

# 执行修复脚本
run_fix_script() {
    local script=$1
    local description=$2
    
    echo ""
    echo -e "${BLUE}🚀 执行 $description...${NC}"
    echo "=================================="
    
    if [ -x "$script" ]; then
        bash "$script"
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}✅ $description 执行完成${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️ $description 执行出现问题 (退出码: $exit_code)${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ $script 不可执行${NC}"
        return 1
    fi
}

# 检查修复结果
check_fix_result() {
    local package="com.idealdimension.EmpireAttack"
    
    echo ""
    echo -e "${BLUE}🔍 检查修复结果...${NC}"
    
    # 检查应用是否仍在运行
    sleep 3
    if adb shell ps | grep -q "$package"; then
        echo -e "${GREEN}🎉 应用正在运行！修复成功！${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️ 应用仍然停止运行，需要进一步修复${NC}"
        return 1
    fi
}

# 显示生成的日志文件
show_log_files() {
    echo ""
    echo -e "${BLUE}📋 生成的日志文件:${NC}"
    
    local log_files=(
        "enhanced_diagnosis_report.txt:详细诊断报告"
        "crash_log.txt:崩溃日志"
        "success_log.txt:成功运行日志"
        "app_launch_log.txt:完整启动日志"
        "bangcle_compatibility_solutions.md:Bangcle解决方案"
    )
    
    for log_info in "${log_files[@]}"; do
        local file=$(echo "$log_info" | cut -d: -f1)
        local desc=$(echo "$log_info" | cut -d: -f2)
        
        if [ -f "$file" ]; then
            echo -e "  ${GREEN}✅${NC} $file - $desc"
        else
            echo -e "  ${YELLOW}⚠️${NC} $file - $desc (未生成)"
        fi
    done
}

# 主修复流程
main_fix_flow() {
    echo -e "${BLUE}🔧 开始执行修复流程...${NC}"
    
    # 步骤1: 检查必要文件
    echo ""
    echo -e "${BLUE}📋 检查修复工具...${NC}"
    
    local all_files_exist=true
    
    check_script "huawei_sanguo_crash_fix_enhanced.sh" "增强版修复脚本" || all_files_exist=false
    check_script "bangcle_compatibility_fix.sh" "Bangcle兼容性修复脚本" || all_files_exist=false
    check_script "advanced_diagnosis.sh" "高级诊断工具" || all_files_exist=false
    
    if [ "$all_files_exist" = false ]; then
        echo ""
        echo -e "${RED}❌ 缺少必要的修复文件${NC}"
        echo -e "${YELLOW}💡 请先运行以下命令生成修复工具:${NC}"
        echo "   python3 bangcle_compatibility_fix.py"
        echo ""
        echo -e "${YELLOW}💡 或者确保所有脚本文件都在当前目录中${NC}"
        return 1
    fi
    
    # 步骤2: 执行增强版修复
    echo ""
    echo -e "${BLUE}📍 步骤1: 执行增强版修复${NC}"
    run_fix_script "huawei_sanguo_crash_fix_enhanced.sh" "增强版修复脚本"
    enhanced_fix_result=$?
    
    # 检查第一步的结果
    if [ $enhanced_fix_result -eq 0 ]; then
        echo -e "${BLUE}🔍 检查第一步修复结果...${NC}"
        
        # 询问用户应用是否正常
        echo ""
        read -p "第一步修复完成，应用是否能正常启动？(y/n): " user_response
        
        if [[ "$user_response" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}🎉 恭喜！修复成功！${NC}"
            show_log_files
            return 0
        fi
    fi
    
    # 步骤3: 执行Bangcle兼容性修复
    echo ""
    echo -e "${BLUE}📍 步骤2: 执行Bangcle兼容性修复${NC}"
    run_fix_script "bangcle_compatibility_fix.sh" "Bangcle兼容性修复脚本"
    bangcle_fix_result=$?
    
    # 检查第二步的结果
    if [ $bangcle_fix_result -eq 0 ]; then
        echo -e "${BLUE}🔍 检查第二步修复结果...${NC}"
        
        # 询问用户应用是否正常
        echo ""
        read -p "第二步修复完成，应用是否能正常启动？(y/n): " user_response
        
        if [[ "$user_response" =~ ^[Yy]$ ]]; then
            echo -e "${GREEN}🎉 恭喜！修复成功！${NC}"
            show_log_files
            return 0
        fi
    fi
    
    # 步骤4: 执行高级诊断
    echo ""
    echo -e "${BLUE}📍 步骤3: 执行高级诊断${NC}"
    run_fix_script "advanced_diagnosis.sh" "高级诊断工具"
    
    # 显示最终建议
    echo ""
    echo -e "${YELLOW}⚠️ 自动修复未能完全解决问题${NC}"
    echo ""
    echo -e "${BLUE}📋 下一步建议:${NC}"
    echo "1. 查看生成的日志文件，特别是 enhanced_diagnosis_report.txt"
    echo "2. 查看 bangcle_compatibility_solutions.md 了解手动修复方法"
    echo "3. 按照 HUAWEI_SANGUO_FIX_GUIDE.md 进行手动修复"
    echo "4. 联系技术支持并提供日志文件"
    
    show_log_files
    
    return 1
}

# 显示使用说明
show_usage() {
    echo "使用方法:"
    echo "  $0              - 执行完整修复流程"
    echo "  $0 --help       - 显示此帮助信息"
    echo "  $0 --check      - 仅检查工具文件"
    echo ""
    echo "修复流程:"
    echo "  1. 增强版修复脚本"
    echo "  2. Bangcle兼容性修复"
    echo "  3. 高级诊断工具"
    echo ""
    echo "生成的文件:"
    echo "  - enhanced_diagnosis_report.txt"
    echo "  - crash_log.txt"
    echo "  - bangcle_compatibility_solutions.md"
    echo "  - HUAWEI_SANGUO_FIX_GUIDE.md"
}

# 检查工具文件
check_tools_only() {
    echo -e "${BLUE}📋 检查修复工具文件...${NC}"
    
    local tools=(
        "huawei_sanguo_crash_fix_enhanced.sh:增强版修复脚本"
        "bangcle_compatibility_fix.sh:Bangcle兼容性修复脚本"
        "advanced_diagnosis.sh:高级诊断工具"
        "HUAWEI_SANGUO_FIX_GUIDE.md:修复指南"
        "bangcle_compatibility_solutions.md:解决方案文档"
    )
    
    local all_exist=true
    
    for tool_info in "${tools[@]}"; do
        local file=$(echo "$tool_info" | cut -d: -f1)
        local desc=$(echo "$tool_info" | cut -d: -f2)
        
        if [ -f "$file" ]; then
            echo -e "  ${GREEN}✅${NC} $file - $desc"
        else
            echo -e "  ${RED}❌${NC} $file - $desc"
            all_exist=false
        fi
    done
    
    if [ "$all_exist" = true ]; then
        echo ""
        echo -e "${GREEN}✅ 所有工具文件都存在，可以开始修复${NC}"
        return 0
    else
        echo ""
        echo -e "${YELLOW}⚠️ 缺少部分工具文件${NC}"
        echo "请运行 python3 bangcle_compatibility_fix.py 生成缺失的工具"
        return 1
    fi
}

# 主入口函数
main() {
    case "${1:-}" in
        --help|-h)
            show_usage
            exit 0
            ;;
        --check|-c)
            check_tools_only
            exit $?
            ;;
        "")
            main_fix_flow
            exit $?
            ;;
        *)
            echo -e "${RED}❌ 未知参数: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
}

# 检查ADB连接
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}❌ 未检测到ADB设备连接${NC}"
    echo "请确保："
    echo "1. 已开启USB调试模式"
    echo "2. 已连接USB线"
    echo "3. 已授权此计算机"
    exit 1
fi

# 运行主函数
main "$@"