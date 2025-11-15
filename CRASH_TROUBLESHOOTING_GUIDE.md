# Qoder Go Process Service - Crash Troubleshooting Guide

## Quick Diagnosis

Based on the crash log analysis, here are the most common issues and their solutions:

### Issue 1: Process Cleanup Detection
```
[GoProcessService] Process PID=17376 no longer exists, cleaning up config files only
```

**Symptoms:**
- Process terminates unexpectedly
- Service detects missing PID
- Config files are cleaned up

**Causes:**
- Process crashed due to memory issues
- Process was killed externally
- System resource exhaustion

**Solutions:**
1. **Check System Resources**
   ```bash
   # Monitor memory usage
   tasklist /fi "imagename eq Qoder.exe" /fo table
   
   # Check available memory
   wmic OS get TotalVisibleMemorySize,FreePhysicalMemory
   ```

2. **Enable Process Monitoring**
   - Set up automatic restart on crash
   - Monitor process health every 30 seconds
   - Log process exit codes

3. **Resource Allocation**
   - Increase available memory
   - Close unnecessary applications
   - Check for memory leaks

### Issue 2: Slow Process Startup (10+ seconds)
```
[GoProcessService] Starting go process: C:\Users\zhanghui\AppData\Local\Programs\Qoder\resources\app\resources\bin\x86_64_windows\Qoder.exe start --workDir C:\Users\zhanghui\AppData\Roaming\Qoder\SharedClientCache
```

**Symptoms:**
- 10+ second delay before process responds
- Slow application initialization
- Poor user experience

**Causes:**
- Large cache directories
- Network connectivity issues
- Antivirus scanning delays
- Disk I/O bottlenecks

**Solutions:**
1. **Optimize Cache Directory**
   ```bash
   # Clear cache if too large
   dir "C:\Users\zhanghui\AppData\Roaming\Qoder\SharedClientCache" /s
   
   # Move cache to faster drive (SSD)
   # Configure in Qoder settings
   ```

2. **Check Antivirus Impact**
   - Add Qoder.exe to antivirus exclusions
   - Exclude cache directories from real-time scanning
   - Check Windows Defender performance impact

3. **Network Diagnostics**
   ```bash
   # Test network connectivity
   ping 8.8.8.8
   
   # Check DNS resolution
   nslookup google.com
   
   # Test proxy settings
   netsh winhttp show proxy
   ```

### Issue 3: IPC Connection Issues
```
[GoProcessService] Health check IPC connection created successfully: \\.\pipe\qoder-cc4e6c
```

**Symptoms:**
- Named pipe connection failures
- Communication timeouts
- Health check failures

**Causes:**
- Named pipe permissions issues
- Firewall blocking local connections
- Process privilege problems

**Solutions:**
1. **Check Named Pipe Permissions**
   ```powershell
   # Check pipe status
   Get-ChildItem \\.\pipe\ | Where-Object {$_.Name -like "*qoder*"}
   
   # Test pipe connectivity
   Test-NetConnection -ComputerName localhost -Port 56510
   ```

2. **Firewall Configuration**
   ```bash
   # Check Windows Firewall status
   netsh advfirewall show allprofiles
   
   # Allow local connections
   netsh advfirewall firewall add rule name="Qoder Local" dir=in action=allow protocol=TCP localport=56510
   ```

3. **Process Privileges**
   - Run Qoder as administrator (test only)
   - Check user permissions on cache directory
   - Verify UAC settings

## Step-by-Step Troubleshooting

### Step 1: Gather System Information
```powershell
# System information
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"Total Physical Memory"

# Process information
tasklist /fi "imagename eq Qoder.exe" /v

# Network configuration
ipconfig /all
netstat -an | findstr 56510
```

### Step 2: Check Log Files
```powershell
# Main application log
Get-Content "$env:LOCALAPPDATA\Qoder\logs\*.log" -Tail 50

# Windows Event Log
Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Qoder'} -MaxEvents 20

# System errors
Get-WinEvent -FilterHashtable @{LogName='System'; Level=2} -MaxEvents 10
```

### Step 3: Verify Installation
```powershell
# Check executable integrity
Get-FileHash "C:\Users\zhanghui\AppData\Local\Programs\Qoder\resources\app\resources\bin\x86_64_windows\Qoder.exe"

# Verify directory permissions
Get-Acl "C:\Users\zhanghui\AppData\Roaming\Qoder" | Format-List

# Check disk space
Get-PSDrive C | Select-Object Name, @{Name="Used (GB)"; Expression={[math]::Round($_.Used/1GB,2)}}, @{Name="Free (GB)"; Expression={[math]::Round($_.Free/1GB,2)}}
```

### Step 4: Test Manual Startup
```powershell
# Kill existing process
taskkill /f /im Qoder.exe

# Clean up old pipes
Get-ChildItem \\.\pipe\ | Where-Object {$_.Name -like "*qoder*"} | Remove-Item

# Start manually with verbose logging
& "C:\Users\zhanghui\AppData\Local\Programs\Qoder\resources\app\resources\bin\x86_64_windows\Qoder.exe" start --workDir "C:\Users\zhanghui\AppData\Roaming\Qoder\SharedClientCache" --verbose
```

## Common Error Scenarios

### Scenario 1: Memory Exhaustion
**Error:** Process terminates after startup
**Solution:** 
1. Close unnecessary applications
2. Increase virtual memory
3. Check for memory leaks in Qoder
4. Restart system

### Scenario 2: Antivirus Interference
**Error:** Slow startup or connection failures
**Solution:**
1. Add Qoder to antivirus exclusions
2. Temporarily disable real-time protection (test)
3. Update antivirus definitions
4. Contact antivirus vendor

### Scenario 3: Network Configuration Issues
**Error:** IPC connection timeouts
**Solution:**
1. Reset network configuration
2. Disable proxy temporarily
3. Check DNS settings
4. Reset Windows Firewall

### Scenario 4: Permission Issues
**Error:** Access denied errors
**Solution:**
1. Run as administrator (test)
2. Repair user profile
3. Reset folder permissions
4. Reinstall application

## Preventive Measures

### Regular Maintenance
1. **Clear Cache Weekly**
   ```powershell
   Remove-Item "C:\Users\zhanghui\AppData\Roaming\Qoder\SharedClientCache\*" -Recurse -Force
   ```

2. **Monitor System Resources**
   - Set up performance monitoring
   - Alert on high memory usage
   - Track startup times

3. **Keep Application Updated**
   - Enable automatic updates
   - Check for new versions regularly
   - Review release notes

### Configuration Optimization
1. **Cache Settings**
   - Limit cache size (e.g., 1GB max)
   - Set cache cleanup interval
   - Use SSD for cache location

2. **Performance Settings**
   - Adjust process priority
   - Configure memory limits
   - Enable performance logging

## Emergency Recovery

### Quick Restart Procedure
```powershell
# Emergency restart script
Stop-Process -Name "Qoder" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Remove-Item "\\.\pipe\qoder-*" -ErrorAction SilentlyContinue
Start-Process "C:\Users\zhanghui\AppData\Local\Programs\Qoder\Qoder.exe"
```

### Complete Reset
```powershell
# Full application reset (backup first!)
Stop-Process -Name "Qoder" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\zhanghui\AppData\Roaming\Qoder" -Recurse -Force
Remove-Item "C:\Users\zhanghui\AppData\Local\Qoder" -Recurse -Force
# Reinstall application
```

## Contact Support

When contacting support, provide:
1. System information (OS version, memory, etc.)
2. Complete crash logs
3. Steps to reproduce the issue
4. Troubleshooting steps already attempted
5. Timestamp of the issue

**Support Information:**
- Application Version: Check Help → About
- Crash Log Location: `%LOCALAPPDATA%\Qoder\logs\`
- System Info: Run `systeminfo > system_info.txt`

---

*This guide is based on analysis of the provided crash log. For specific issues not covered here, please refer to the main documentation or contact technical support.*