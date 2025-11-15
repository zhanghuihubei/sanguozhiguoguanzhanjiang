#!/bin/bash
# 崩溃日志收集脚本

echo "开始收集崩溃日志..."
echo "请确保手机已连接并开启USB调试"

# 检查设备连接
adb devices

echo "按回车键开始记录日志，然后启动游戏等待闪退..."
read

# 清空现有日志
adb logcat -c

# 开始记录日志
echo "正在记录日志... 闪退后按Ctrl+C停止"
adb logcat > game_crash_log.txt

echo "日志已保存到 game_crash_log.txt"

# 分析关键错误
echo "分析关键错误..."
grep -E "(FATAL|AndroidRuntime|Exception|Error|三国)" game_crash_log.txt > crash_errors.txt

echo "错误信息已提取到 crash_errors.txt"
