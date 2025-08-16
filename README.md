# Windows-to-WSL2 Screenshot Bridge

🚀 **Seamlessly paste Windows screenshots into Claude Code running in WSL2**

This tool solves the frustrating workflow of getting Windows screenshots into Claude Code (or any WSL2 application). Take a screenshot with Win+Shift+S and instantly paste the file path with Ctrl+V - no manual saving or copying required!

## ✨ Features

- 📸 **Automatic screenshot capture** from Windows clipboard
- 💾 **Auto-saves** to `~/.screenshots/` in WSL2
- 📋 **Auto-copies** WSL path to clipboard
- 🚀 **Windows startup integration** - runs automatically on login
- 🎯 **Zero friction** - just screenshot and paste!

## 🎬 Demo

![Screenshot showing the tool in action](demo-screenshot.png)

*Take a screenshot → Instantly paste the path into Claude Code!*

## 🚀 Quick Start (30 seconds!)

```bash
# Clone the repository
git clone https://github.com/yourusername/windows-to-wsl2-screenshots.git
cd windows-to-wsl2-screenshots

# Run the automated setup
./setup.sh
```

That's it! The setup script handles everything:
- ✅ Creates necessary directories
- ✅ Configures your shell environment
- ✅ Starts the screenshot monitor
- ✅ Prepares Windows autostart files

To enable automatic startup on Windows login, follow the instructions shown after setup.

## 📸 How to Use

1. **Take a screenshot** with `Win+Shift+S`
2. **Paste in Claude Code** with `Ctrl+V`
3. That's it! The path is automatically inserted

## 🛠️ Commands

After setup, these commands are available anywhere in your terminal:

```bash
check-screenshot-monitor    # Check if monitor is running
list-screenshots           # List all captured screenshots  
copy-latest-screenshot     # Re-copy the latest screenshot path
stop-screenshot-monitor    # Stop the automation
~/start-screenshots.sh     # Restart the monitor anytime
```

## 🎯 Perfect For

- 🤖 **Claude Code** - Share UI screenshots for development
- 📝 **VS Code** - Document visual bugs or features
- 🔧 **Any WSL2 app** - Get Windows screenshots into Linux tools
- 🎨 **UI Development** - Rapidly iterate on designs with AI assistance

## 📋 Requirements

- Windows 10/11 with WSL2
- Any WSL2 distribution (Ubuntu, Debian, etc.)
- PowerShell (included with Windows)

## 🔧 Manual Installation (Advanced)

If you prefer manual setup over the automated script:

```bash
# Clone and enter directory
git clone https://github.com/yourusername/windows-to-wsl2-screenshots.git
cd windows-to-wsl2-screenshots

# Source the functions
source screenshot-functions.sh

# Start the monitor
start-screenshot-monitor
```

To add to your `.bashrc` for permanent access:
```bash
echo "source $(pwd)/screenshot-functions.sh" >> ~/.bashrc
```

## 🚦 Windows Autostart Setup

The setup script creates files for Windows Task Scheduler integration. To enable:

1. Navigate to the cloned directory in Windows Explorer
2. Double-click `install-windows-autostart.bat`
3. Accept the UAC prompt

Or manually through Task Scheduler:
1. Open Task Scheduler (Win+R, type `taskschd.msc`)
2. Import the provided `WSL-Screenshot-Monitor.xml`

## 🐛 Troubleshooting

**Monitor not starting?**
```bash
# Check the log
cat ~/.screenshots/monitor.log
```

**Clipboard not working?**
- Use Windows Terminal instead of the basic WSL terminal
- Ensure you're using `Ctrl+V` to paste (not right-click)

**Screenshots not appearing?**
- Make sure the monitor is running: `check-screenshot-monitor`
- Try restarting: `~/start-screenshots.sh`

## 🤝 Contributing

Found a bug or have a feature request? Please open an issue!

## 📄 License

MIT License - feel free to use this in your own projects!

## 🙏 Credits

Created with ❤️ for the Claude Code community

Special thanks to the original [jddev273/windows-to-wsl2-screenshots](https://github.com/jddev273/windows-to-wsl2-screenshots) project by Johann Döwa for inspiration.
