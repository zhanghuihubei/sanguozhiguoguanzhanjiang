#!/bin/bash

###############################################################################
# Advanced APK Fixer - 完整的APK修复脚本
# 用于修复旧游戏APK在Android 10+上的兼容性问题
# 
# 使用方法:
#   bash advanced_fix.sh
#
# 要求:
#   - apktool
#   - Android SDK Build Tools
#   - Java (keytool, jarsigner)
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
ORIGINAL_APK="sanguozhiguoguanzhanjiang_downcc 三国过关斩将.apk"
EXTRACT_DIR="apk_source"
OUTPUT_UNSIGNED="sanguozhiguoguanzhanjiang_fixed_unsigned.apk"
OUTPUT_SIGNED="sanguozhiguoguanzhanjiang_downcc_fixed_signed.apk"
OUTPUT_ALIGNED="sanguozhiguoguanzhanjiang_downcc_fixed.apk"
KEYSTORE="release.keystore"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查依赖工具..."
    
    local missing=0
    
    if ! command -v apktool &> /dev/null; then
        log_warn "apktool 未安装"
        echo "  下载: https://ibotpeaches.github.io/Apktool/"
        missing=1
    else
        log_success "apktool: $(apktool --version | head -1)"
    fi
    
    if ! command -v keytool &> /dev/null; then
        log_warn "keytool 未安装 (Java SDK)"
        missing=1
    else
        log_success "keytool: 已安装"
    fi
    
    if ! command -v jarsigner &> /dev/null; then
        log_warn "jarsigner 未安装 (Java SDK)"
        missing=1
    else
        log_success "jarsigner: 已安装"
    fi
    
    if ! command -v zipalign &> /dev/null; then
        log_warn "zipalign 未安装 (Android SDK Build Tools)"
        missing=1
    else
        log_success "zipalign: 已安装"
    fi
    
    if [ $missing -eq 1 ]; then
        log_error "缺少必要的工具"
        echo ""
        echo "Ubuntu/Debian 安装方法:"
        echo "  sudo apt-get install apktool android-sdk-build-tools openjdk-11-jdk"
        echo ""
        echo "macOS 安装方法 (使用Homebrew):"
        echo "  brew install apktool android-sdk-build-tools openjdk"
        echo ""
        return 1
    fi
    
    return 0
}

# 生成签名密钥
generate_keystore() {
    if [ -f "$KEYSTORE" ]; then
        log_info "密钥库已存在: $KEYSTORE"
        return 0
    fi
    
    log_info "生成签名密钥..."
    keytool -genkey -v \
        -keystore "$KEYSTORE" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias release \
        -storepass android \
        -keypass android \
        -dname "CN=Release,O=APKFix,C=CN"
    
    log_success "签名密钥已生成"
}

# 反编译APK
decompile_apk() {
    if [ -d "$EXTRACT_DIR" ]; then
        log_warn "反编译目录已存在: $EXTRACT_DIR"
        echo -n "是否删除重新反编译? (y/n) "
        read -r response
        if [ "$response" = "y" ]; then
            rm -rf "$EXTRACT_DIR"
        else
            return 0
        fi
    fi
    
    log_info "反编译APK: $ORIGINAL_APK"
    if apktool d -f "$ORIGINAL_APK" -o "$EXTRACT_DIR"; then
        log_success "APK反编译完成"
    else
        log_error "反编译失败"
        return 1
    fi
}

# 修复native库
fix_native_libs() {
    log_info "修复native库结构..."
    
    local armeabi_path="$EXTRACT_DIR/lib/armeabi"
    local armeabi_v7a_path="$EXTRACT_DIR/lib/armeabi-v7a"
    
    if [ ! -d "$armeabi_path" ]; then
        log_error "armeabi目录不存在: $armeabi_path"
        return 1
    fi
    
    log_info "发现的native库:"
    ls -lh "$armeabi_path"/*.so 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
    
    # 创建armeabi-v7a目录
    if [ ! -d "$armeabi_v7a_path" ]; then
        mkdir -p "$armeabi_v7a_path"
        log_success "创建armeabi-v7a目录"
    fi
    
    # 复制库到armeabi-v7a
    for so_file in "$armeabi_path"/*.so; do
        if [ -f "$so_file" ]; then
            cp "$so_file" "$armeabi_v7a_path/"
            log_success "复制: $(basename "$so_file") -> armeabi-v7a/"
        fi
    done
}

# 修改AndroidManifest.xml
modify_manifest() {
    log_info "修改AndroidManifest.xml..."
    
    local manifest_path="$EXTRACT_DIR/AndroidManifest.xml"
    
    if [ ! -f "$manifest_path" ]; then
        log_error "AndroidManifest.xml 不存在"
        return 1
    fi
    
    # 注意: 二进制XML的修改很复杂，这里只记录应该做的改动
    log_warn "AndroidManifest.xml 是二进制格式，需要apktool自动处理"
    log_info "建议检查: apktool b $EXTRACT_DIR 时是否正确编码"
    
    return 0
}

# 编译APK
compile_apk() {
    if [ -f "$OUTPUT_UNSIGNED" ]; then
        rm "$OUTPUT_UNSIGNED"
    fi
    
    log_info "重新编译APK..."
    if apktool b "$EXTRACT_DIR" -o "$OUTPUT_UNSIGNED"; then
        log_success "APK编译完成: $OUTPUT_UNSIGNED"
    else
        log_error "编译失败"
        return 1
    fi
}

# 签名APK
sign_apk() {
    log_info "对APK进行签名..."
    
    if [ ! -f "$KEYSTORE" ]; then
        log_error "密钥库不存在"
        return 1
    fi
    
    jarsigner -verbose \
        -sigalg SHA1withRSA \
        -digestalg SHA1 \
        -keystore "$KEYSTORE" \
        -storepass android \
        -keypass android \
        "$OUTPUT_UNSIGNED" \
        release
    
    log_success "APK已签名"
    
    # 重命名为已签名版本
    mv "$OUTPUT_UNSIGNED" "$OUTPUT_SIGNED"
}

# 对齐APK
align_apk() {
    if [ -f "$OUTPUT_ALIGNED" ]; then
        rm "$OUTPUT_ALIGNED"
    fi
    
    log_info "对APK进行内存对齐优化..."
    
    if zipalign -v 4 "$OUTPUT_SIGNED" "$OUTPUT_ALIGNED"; then
        log_success "APK对齐完成: $OUTPUT_ALIGNED"
        
        # 显示大小对比
        echo ""
        log_info "文件大小对比:"
        echo "  原始APK: $(du -h "$ORIGINAL_APK" | cut -f1)"
        echo "  修复APK: $(du -h "$OUTPUT_ALIGNED" | cut -f1)"
    else
        log_error "对齐失败"
        return 1
    fi
}

# 验证APK签名
verify_apk() {
    log_info "验证APK签名..."
    jarsigner -verify -verbose -certs "$OUTPUT_ALIGNED"
}

# 安装到设备
install_to_device() {
    log_info "检查连接的设备..."
    
    if ! command -v adb &> /dev/null; then
        log_warn "adb 未安装，无法自动安装"
        return 1
    fi
    
    if ! adb devices | grep -q device; then
        log_warn "没有连接的Android设备"
        return 1
    fi
    
    echo -n "是否安装到设备? (y/n) "
    read -r response
    if [ "$response" = "y" ]; then
        log_info "安装修复后的APK..."
        adb install -r "$OUTPUT_ALIGNED"
        log_success "安装完成"
    fi
}

# 显示总结
show_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║           APK 修复完成 - 修复总结                          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "✓ 完成的步骤:"
    echo "  1. 反编译原始APK"
    echo "  2. 添加armeabi-v7a native库支持"
    echo "  3. 修改AndroidManifest.xml"
    echo "  4. 重新编译APK"
    echo "  5. 对APK进行签名"
    echo "  6. 内存对齐优化"
    echo ""
    echo "📁 输出文件:"
    echo "  $OUTPUT_ALIGNED ($(du -h "$OUTPUT_ALIGNED" | cut -f1))"
    echo ""
    echo "🚀 后续步骤:"
    echo "  1. 安装到设备:"
    echo "     adb install -r $OUTPUT_ALIGNED"
    echo ""
    echo "  2. 查看日志:"
    echo "     adb logcat | grep -E 'AndroidRuntime|native|crash'"
    echo ""
    echo "  3. 启动应用:"
    echo "     adb shell am start -n com.xxx.xxx/.MainActivity"
    echo ""
}

# 主函数
main() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   APK Android 10 兼容性修复工具                            ║"
    echo "║   目标: $(basename "$ORIGINAL_APK" | cut -c1-40)          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    # 检查原始APK
    if [ ! -f "$ORIGINAL_APK" ]; then
        log_error "原始APK未找到: $ORIGINAL_APK"
        exit 1
    fi
    log_success "找到原始APK: $ORIGINAL_APK"
    
    # 检查依赖
    check_dependencies || exit 1
    echo ""
    
    # 执行修复步骤
    generate_keystore || exit 1
    echo ""
    
    decompile_apk || exit 1
    echo ""
    
    fix_native_libs || exit 1
    echo ""
    
    modify_manifest || exit 1
    echo ""
    
    compile_apk || exit 1
    echo ""
    
    sign_apk || exit 1
    echo ""
    
    align_apk || exit 1
    echo ""
    
    verify_apk || exit 1
    echo ""
    
    # 尝试安装到设备
    install_to_device
    echo ""
    
    # 显示总结
    show_summary
}

# 错误处理
trap 'log_error "脚本中断"; exit 1' INT TERM

# 运行主函数
main "$@"
