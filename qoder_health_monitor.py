#!/usr/bin/env python3
"""
Qoder Health Monitor
Monitors Qoder Go Process Service health and provides automated diagnostics.
"""

import os
import sys
import time
import json
import subprocess
import psutil
import logging
from datetime import datetime, timedelta
from pathlib import Path
import argparse

class QoderHealthMonitor:
    def __init__(self, config_file=None):
        self.setup_logging()
        self.config = self.load_config(config_file)
        self.state_file = Path(self.config.get('state_file', 'qoder_monitor_state.json'))
        self.state = self.load_state()
        
    def setup_logging(self):
        """Setup logging configuration"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('qoder_health_monitor.log'),
                logging.StreamHandler(sys.stdout)
            ]
        )
        self.logger = logging.getLogger(__name__)
        
    def load_config(self, config_file):
        """Load configuration from file or use defaults"""
        default_config = {
            'process_name': 'Qoder.exe',
            'startup_timeout': 30,  # seconds
            'health_check_interval': 60,  # seconds
            'max_retries': 3,
            'retry_delay': 10,  # seconds
            'cache_max_size_mb': 1024,  # 1GB
            'memory_threshold_mb': 512,  # Minimum free memory required
            'executable_path': r'C:\Users\zhanghui\AppData\Local\Programs\Qoder\resources\app\resources\bin\x86_64_windows\Qoder.exe',
            'cache_dir': r'C:\Users\zhanghui\AppData\Roaming\Qoder\SharedClientCache',
            'log_dir': r'C:\Users\zhanghui\AppData\Local\Qoder\logs'
        }
        
        if config_file and Path(config_file).exists():
            try:
                with open(config_file, 'r') as f:
                    user_config = json.load(f)
                default_config.update(user_config)
            except Exception as e:
                self.logger.warning(f"Failed to load config file {config_file}: {e}")
                
        return default_config
        
    def load_state(self):
        """Load monitoring state from file"""
        if self.state_file.exists():
            try:
                with open(self.state_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                self.logger.warning(f"Failed to load state file: {e}")
                
        return {
            'last_restart': None,
            'restart_count': 0,
            'last_health_check': None,
            'issues_detected': []
        }
        
    def save_state(self):
        """Save monitoring state to file"""
        try:
            with open(self.state_file, 'w') as f:
                json.dump(self.state, f, indent=2, default=str)
        except Exception as e:
            self.logger.error(f"Failed to save state file: {e}")
            
    def check_process_running(self):
        """Check if Qoder process is running"""
        try:
            for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
                if proc.info['name'] == self.config['process_name']:
                    return {
                        'running': True,
                        'pid': proc.info['pid'],
                        'cmdline': proc.info['cmdline'],
                        'memory_mb': proc.memory_info().rss / 1024 / 1024,
                        'cpu_percent': proc.cpu_percent(),
                        'create_time': datetime.fromtimestamp(proc.create_time())
                    }
        except Exception as e:
            self.logger.error(f"Error checking process: {e}")
            
        return {'running': False}
        
    def check_system_resources(self):
        """Check system resource availability"""
        try:
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage(Path(self.config['cache_dir']).anchor)
            
            return {
                'memory_available_mb': memory.available / 1024 / 1024,
                'memory_percent_used': memory.percent,
                'disk_free_gb': disk.free / 1024 / 1024 / 1024,
                'disk_percent_used': (disk.used / disk.total) * 100,
                'cpu_percent': psutil.cpu_percent(interval=1)
            }
        except Exception as e:
            self.logger.error(f"Error checking system resources: {e}")
            return {}
            
    def check_cache_size(self):
        """Check cache directory size"""
        try:
            cache_path = Path(self.config['cache_dir'])
            if not cache_path.exists():
                return {'size_mb': 0, 'file_count': 0}
                
            total_size = 0
            file_count = 0
            for root, dirs, files in os.walk(cache_path):
                for file in files:
                    file_path = Path(root) / file
                    total_size += file_path.stat().st_size
                    file_count += 1
                    
            return {
                'size_mb': total_size / 1024 / 1024,
                'file_count': file_count,
                'exceeds_limit': total_size / 1024 / 1024 > self.config['cache_max_size_mb']
            }
        except Exception as e:
            self.logger.error(f"Error checking cache size: {e}")
            return {}
            
    def check_ipc_connection(self):
        """Check IPC named pipe connection"""
        try:
            # Check for Qoder named pipes
            result = subprocess.run(['powershell', '-Command', 
                'Get-ChildItem \\\\.\\pipe\\ | Where-Object {$_.Name -like "*qoder*"} | Select-Object Name'],
                capture_output=True, text=True, timeout=10)
                
            if result.returncode == 0:
                pipes = [line.strip() for line in result.stdout.split('\n') if line.strip() and 'Name' not in line]
                return {'pipes_found': len(pipes), 'pipe_names': pipes}
            else:
                return {'pipes_found': 0, 'error': result.stderr}
        except Exception as e:
            self.logger.error(f"Error checking IPC connection: {e}")
            return {'pipes_found': 0, 'error': str(e)}
            
    def check_recent_logs(self, hours=1):
        """Check recent log files for errors"""
        try:
            log_dir = Path(self.config['log_dir'])
            if not log_dir.exists():
                return {'errors_found': 0, 'recent_errors': []}
                
            cutoff_time = datetime.now() - timedelta(hours=hours)
            recent_errors = []
            
            for log_file in log_dir.glob('*.log'):
                try:
                    stat = log_file.stat()
                    if stat.st_mtime > cutoff_time.timestamp():
                        # Read recent log entries
                        with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
                            lines = f.readlines()[-100:]  # Last 100 lines
                            for line in lines:
                                if any(keyword in line.lower() for keyword in ['error', 'failed', 'crashed', 'exception']):
                                    recent_errors.append({
                                        'file': log_file.name,
                                        'line': line.strip(),
                                        'timestamp': datetime.fromtimestamp(stat.st_mtime)
                                    })
                except Exception as e:
                    self.logger.warning(f"Error reading log file {log_file}: {e}")
                    
            return {
                'errors_found': len(recent_errors),
                'recent_errors': recent_errors[-10:]  # Last 10 errors
            }
        except Exception as e:
            self.logger.error(f"Error checking recent logs: {e}")
            return {'errors_found': 0, 'error': str(e)}
            
    def restart_process(self):
        """Attempt to restart Qoder process"""
        try:
            self.logger.info("Attempting to restart Qoder process...")
            
            # Kill existing process
            subprocess.run(['taskkill', '/f', '/im', self.config['process_name']], 
                         capture_output=True, timeout=10)
            time.sleep(2)
            
            # Clean up named pipes
            subprocess.run(['powershell', '-Command', 
                'Get-ChildItem \\\\.\\pipe\\ | Where-Object {$_.Name -like "*qoder*"} | Remove-Item -Force'],
                capture_output=True, timeout=10)
            time.sleep(1)
            
            # Start new process
            executable = self.config['executable_path']
            work_dir = self.config['cache_dir']
            
            if Path(executable).exists():
                subprocess.Popen([executable, 'start', '--workDir', work_dir],
                                creationflags=subprocess.CREATE_NEW_CONSOLE)
                
                self.state['last_restart'] = datetime.now().isoformat()
                self.state['restart_count'] += 1
                self.save_state()
                
                self.logger.info("Process restart initiated successfully")
                return True
            else:
                self.logger.error(f"Executable not found: {executable}")
                return False
                
        except Exception as e:
            self.logger.error(f"Error restarting process: {e}")
            return False
            
    def cleanup_cache(self):
        """Clean up cache directory if it exceeds size limit"""
        try:
            cache_info = self.check_cache_size()
            if cache_info.get('exceeds_limit', False):
                self.logger.info(f"Cache size {cache_info['size_mb']:.1f}MB exceeds limit {self.config['cache_max_size_mb']}MB, cleaning up...")
                
                cache_path = Path(self.config['cache_dir'])
                # Remove old files (older than 7 days)
                cutoff_time = time.time() - (7 * 24 * 60 * 60)  # 7 days ago
                
                removed_count = 0
                for root, dirs, files in os.walk(cache_path):
                    for file in files:
                        file_path = Path(root) / file
                        if file_path.stat().st_mtime < cutoff_time:
                            try:
                                file_path.unlink()
                                removed_count += 1
                            except Exception as e:
                                self.logger.warning(f"Failed to remove {file_path}: {e}")
                                
                self.logger.info(f"Cache cleanup completed, removed {removed_count} files")
                return True
        except Exception as e:
            self.logger.error(f"Error during cache cleanup: {e}")
            
        return False
        
    def perform_health_check(self):
        """Perform comprehensive health check"""
        health_status = {
            'timestamp': datetime.now().isoformat(),
            'overall_status': 'healthy',
            'issues': [],
            'recommendations': []
        }
        
        # Check process status
        process_info = self.check_process_running()
        health_status['process'] = process_info
        
        if not process_info['running']:
            health_status['overall_status'] = 'unhealthy'
            health_status['issues'].append('Qoder process is not running')
            health_status['recommendations'].append('Restart Qoder process')
        else:
            # Check process memory usage
            if process_info.get('memory_mb', 0) > 1000:  # More than 1GB
                health_status['issues'].append(f"High memory usage: {process_info['memory_mb']:.1f}MB")
                health_status['recommendations'].append('Monitor for memory leaks')
                
        # Check system resources
        resources = self.check_system_resources()
        health_status['system_resources'] = resources
        
        if resources.get('memory_available_mb', 0) < self.config['memory_threshold_mb']:
            health_status['overall_status'] = 'degraded'
            health_status['issues'].append(f"Low available memory: {resources['memory_available_mb']:.1f}MB")
            health_status['recommendations'].append('Free up system memory')
            
        # Check cache size
        cache_info = self.check_cache_size()
        health_status['cache'] = cache_info
        
        if cache_info.get('exceeds_limit', False):
            health_status['overall_status'] = 'degraded'
            health_status['issues'].append(f"Cache size exceeds limit: {cache_info['size_mb']:.1f}MB")
            health_status['recommendations'].append('Clean up cache directory')
            
        # Check IPC connection
        ipc_info = self.check_ipc_connection()
        health_status['ipc'] = ipc_info
        
        if ipc_info.get('pipes_found', 0) == 0 and process_info['running']:
            health_status['overall_status'] = 'degraded'
            health_status['issues'].append('No IPC pipes found')
            health_status['recommendations'].append('Restart process to re-establish IPC')
            
        # Check recent logs for errors
        log_info = self.check_recent_logs()
        health_status['logs'] = log_info
        
        if log_info.get('errors_found', 0) > 5:
            health_status['overall_status'] = 'degraded'
            health_status['issues'].append(f"Multiple errors in recent logs: {log_info['errors_found']}")
            health_status['recommendations'].append('Review log files for recurring issues')
            
        self.state['last_health_check'] = datetime.now().isoformat()
        self.save_state()
        
        return health_status
        
    def run_continuous_monitoring(self):
        """Run continuous monitoring with automatic recovery"""
        self.logger.info("Starting continuous health monitoring...")
        
        consecutive_failures = 0
        
        while True:
            try:
                health_status = self.perform_health_check()
                
                self.logger.info(f"Health check completed: {health_status['overall_status']}")
                
                if health_status['overall_status'] != 'healthy':
                    self.logger.warning(f"Issues detected: {', '.join(health_status['issues'])}")
                    
                    # Attempt automatic recovery
                    if not health_status['process']['running']:
                        if self.restart_process():
                            consecutive_failures = 0
                        else:
                            consecutive_failures += 1
                    else:
                        # Try cache cleanup if needed
                        if health_status['cache'].get('exceeds_limit', False):
                            self.cleanup_cache()
                            
                        consecutive_failures = 0
                else:
                    consecutive_failures = 0
                    self.logger.info("All systems healthy")
                    
                # If too many consecutive failures, stop monitoring
                if consecutive_failures >= self.config['max_retries']:
                    self.logger.error(f"Too many consecutive failures ({consecutive_failures}), stopping monitoring")
                    break
                    
                time.sleep(self.config['health_check_interval'])
                
            except KeyboardInterrupt:
                self.logger.info("Monitoring stopped by user")
                break
            except Exception as e:
                self.logger.error(f"Error in monitoring loop: {e}")
                time.sleep(self.config['retry_delay'])
                
    def run_single_check(self):
        """Run a single health check and report results"""
        health_status = self.perform_health_check()
        
        print("\n" + "="*60)
        print("QODER HEALTH CHECK REPORT")
        print("="*60)
        print(f"Timestamp: {health_status['timestamp']}")
        print(f"Overall Status: {health_status['overall_status'].upper()}")
        print()
        
        if health_status['issues']:
            print("ISSUES FOUND:")
            for issue in health_status['issues']:
                print(f"  ❌ {issue}")
            print()
            
        if health_status['recommendations']:
            print("RECOMMENDATIONS:")
            for rec in health_status['recommendations']:
                print(f"  💡 {rec}")
            print()
            
        print("DETAILED STATUS:")
        print(f"  Process Running: {'Yes' if health_status['process']['running'] else 'No'}")
        if health_status['process']['running']:
            print(f"  Process PID: {health_status['process'].get('pid', 'N/A')}")
            print(f"  Memory Usage: {health_status['process'].get('memory_mb', 0):.1f}MB")
            print(f"  CPU Usage: {health_status['process'].get('cpu_percent', 0):.1f}%")
            
        print(f"  Available Memory: {health_status['system_resources'].get('memory_available_mb', 0):.1f}MB")
        print(f"  Cache Size: {health_status['cache'].get('size_mb', 0):.1f}MB")
        print(f"  IPC Pipes: {health_status['ipc'].get('pipes_found', 0)}")
        print(f"  Recent Log Errors: {health_status['logs'].get('errors_found', 0)}")
        print("="*60)
        
        return health_status['overall_status'] == 'healthy'

def main():
    parser = argparse.ArgumentParser(description='Qoder Health Monitor')
    parser.add_argument('--config', help='Configuration file path')
    parser.add_argument('--continuous', action='store_true', help='Run continuous monitoring')
    parser.add_argument('--check', action='store_true', help='Run single health check')
    parser.add_argument('--restart', action='store_true', help='Restart Qoder process')
    parser.add_argument('--cleanup-cache', action='store_true', help='Clean up cache directory')
    
    args = parser.parse_args()
    
    monitor = QoderHealthMonitor(args.config)
    
    if args.restart:
        success = monitor.restart_process()
        sys.exit(0 if success else 1)
    elif args.cleanup_cache:
        success = monitor.cleanup_cache()
        sys.exit(0 if success else 1)
    elif args.check:
        success = monitor.run_single_check()
        sys.exit(0 if success else 1)
    elif args.continuous:
        monitor.run_continuous_monitoring()
    else:
        parser.print_help()

if __name__ == '__main__':
    main()