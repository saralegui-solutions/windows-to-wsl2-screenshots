@echo off
REM Windows batch file to start the screenshot monitor
REM This can be added to Windows startup or Task Scheduler

echo Starting WSL2 Screenshot Monitor...

REM Start the PowerShell script with the correct WSL path
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& {Start-Process powershell -ArgumentList '-WindowStyle Hidden -ExecutionPolicy Bypass -File \\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\auto-clipboard-monitor.ps1' -WindowStyle Hidden}"

echo Screenshot monitor started in background