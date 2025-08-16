# Setting Up Automatic Startup for WSL Screenshot Monitor

## Method 1: Task Scheduler (Recommended)

### Option A: Import the XML file (Easiest)
1. Open Task Scheduler (Win + R, type `taskschd.msc`)
2. Click "Action" → "Import Task..."
3. Browse to: `\\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\WSL-Screenshot-Monitor.xml`
4. Click OK to import
5. Enter your Windows password if prompted
6. The task will run automatically on next login

### Option B: Create manually
1. Open Task Scheduler (Win + R, type `taskschd.msc`)
2. Click "Create Basic Task..."
3. Name: "WSL Screenshot Monitor"
4. Trigger: "When I log on"
5. Action: "Start a program"
6. Program: `powershell.exe`
7. Arguments: `-WindowStyle Hidden -ExecutionPolicy Bypass -File "\\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\startup-task.ps1"`
8. Check "Open Properties dialog" and click Finish
9. In Properties:
   - Check "Run with highest privileges"
   - Under "Conditions" tab, uncheck "Start only if on AC power"
   - Click OK

## Method 2: Windows Startup Folder

1. Press Win + R, type: `shell:startup`
2. Copy this file to the startup folder:
   `\\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\start-screenshot-monitor.bat`

## Method 3: Registry (Advanced)

1. Press Win + R, type: `regedit`
2. Navigate to: `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run`
3. Right-click → New → String Value
4. Name: "WSLScreenshotMonitor"
5. Value: `powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "\\wsl.localhost\Ubuntu\home\ben\claude-research\windows-to-wsl2-screenshots\startup-task.ps1"`

## Testing the Autostart

1. Run the task manually first:
   - In Task Scheduler, right-click the task and select "Run"
   - Check if the monitor is running: In WSL terminal, run:
     ```bash
     source ~/claude-research/windows-to-wsl2-screenshots/screenshot-functions.sh
     check-screenshot-monitor
     ```

2. Restart your computer to test automatic startup

## Troubleshooting

If the autostart doesn't work:

1. Check the log file:
   ```bash
   cat ~/.screenshots/monitor.log
   ```

2. Ensure WSL starts automatically:
   - In Task Scheduler, add a 30-60 second delay to the task trigger

3. Make sure the paths are correct:
   - The scripts reference: `\\wsl.localhost\Ubuntu\`
   - If your WSL distro is different, update the paths

4. Check Windows Event Viewer for any PowerShell errors:
   - Event Viewer → Windows Logs → Application

## Disabling Autostart

To stop automatic startup:
- **Task Scheduler**: Disable or delete the "WSL Screenshot Monitor" task
- **Startup Folder**: Remove the .bat file
- **Registry**: Delete the "WSLScreenshotMonitor" entry