# PowerShell startup script for Task Scheduler
# Starts the screenshot monitor with proper error handling

$scriptPath = "\\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\auto-clipboard-monitor.ps1"

# Check if WSL is running, if not start it
$wslStatus = wsl.exe --list --running
if ($wslStatus -notmatch "Ubuntu") {
    Write-Host "Starting WSL Ubuntu..."
    wsl.exe -d Ubuntu -e echo "WSL Started"
    Start-Sleep -Seconds 2
}

# Kill any existing monitors
Get-Process | Where-Object {$_.ProcessName -eq "powershell" -and $_.MainWindowTitle -match "auto-clipboard-monitor"} | Stop-Process -Force -ErrorAction SilentlyContinue

# Start the screenshot monitor
try {
    if (Test-Path $scriptPath) {
        Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`"" -WindowStyle Hidden
        Write-Host "Screenshot monitor started successfully"
    } else {
        Write-Host "Error: Script not found at $scriptPath"
    }
} catch {
    Write-Host "Error starting screenshot monitor: $_"
}