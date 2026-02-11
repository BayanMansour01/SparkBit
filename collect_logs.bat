@echo off
echo [*] Waiting for logs from Android... (Press Ctrl+C to stop)
adb logcat -v time -s flutter | findstr "GLOBAL_LOG" >> logs\api_logs.txt
