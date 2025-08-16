#!/bin/bash

# Windows-to-WSL2 Screenshot Automation - One-Click Setup Script
# This script automatically sets up everything needed for screenshot automation

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Windows-to-WSL2 Screenshot Automation Setup           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to check if running in WSL
check_wsl() {
    if ! grep -q Microsoft /proc/version; then
        echo -e "${RED}❌ This script must be run in WSL2${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ WSL2 environment detected${NC}"
}

# Function to create screenshots directory
create_directories() {
    echo -e "${YELLOW}📁 Creating directories...${NC}"
    mkdir -p "$HOME/.screenshots"
    echo -e "${GREEN}✓ Created ~/.screenshots directory${NC}"
}

# Function to add to bashrc
setup_bashrc() {
    echo -e "${YELLOW}🔧 Configuring shell environment...${NC}"
    
    # Check if already added
    if grep -q "Windows-to-WSL2 Screenshot Automation" "$HOME/.bashrc" 2>/dev/null; then
        echo -e "${GREEN}✓ Shell configuration already exists${NC}"
    else
        # Add to bashrc
        cat >> "$HOME/.bashrc" << EOF

# Windows-to-WSL2 Screenshot Automation
if [ -f "$SCRIPT_DIR/screenshot-functions.sh" ]; then
    source "$SCRIPT_DIR/screenshot-functions.sh"
fi
EOF
        echo -e "${GREEN}✓ Added to ~/.bashrc${NC}"
    fi
}

# Function to setup Windows autostart
setup_windows_autostart() {
    echo -e "${YELLOW}🚀 Setting up Windows autostart...${NC}"
    
    # Get WSL distro name
    WSL_DISTRO=$(wsl.exe -l -q | head -n1 | tr -d '\r\n\0')
    echo -e "   Detected WSL distribution: ${BLUE}$WSL_DISTRO${NC}"
    
    # Update the PowerShell script with correct paths
    sed -i "s|\\\\wsl.localhost\\\\Ubuntu\\\\|\\\\wsl.localhost\\\\$WSL_DISTRO\\\\|g" "$SCRIPT_DIR/startup-task.ps1" 2>/dev/null || true
    sed -i "s|\\\\wsl.localhost\\\\Ubuntu\\\\|\\\\wsl.localhost\\\\$WSL_DISTRO\\\\|g" "$SCRIPT_DIR/WSL-Screenshot-Monitor.xml" 2>/dev/null || true
    
    # Create a setup batch file for Windows
    cat > "$SCRIPT_DIR/install-windows-autostart.bat" << 'EOF'
@echo off
echo Setting up Windows Task Scheduler...

REM Get the directory of this batch file
set SCRIPT_DIR=%~dp0

REM Import the task to Task Scheduler
schtasks /create /xml "%SCRIPT_DIR%WSL-Screenshot-Monitor.xml" /tn "WSL Screenshot Monitor" /f

if %ERRORLEVEL% == 0 (
    echo [SUCCESS] Task created successfully!
    echo.
    echo The screenshot monitor will start automatically on next login.
    echo You can also start it now by running: schtasks /run /tn "WSL Screenshot Monitor"
) else (
    echo [ERROR] Failed to create task. Please run this as Administrator.
)

pause
EOF
    
    # Convert path for Windows
    WIN_PATH=$(wslpath -w "$SCRIPT_DIR")
    
    echo -e "${GREEN}✓ Windows autostart files created${NC}"
    echo
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚠️  To enable automatic startup on Windows login:${NC}"
    echo
    echo -e "   ${BLUE}Option 1: Automatic (Recommended)${NC}"
    echo -e "   1. Open Windows File Explorer"
    echo -e "   2. Navigate to: ${GREEN}$WIN_PATH${NC}"
    echo -e "   3. Double-click: ${GREEN}install-windows-autostart.bat${NC}"
    echo -e "   4. Click 'Yes' if prompted by User Account Control"
    echo
    echo -e "   ${BLUE}Option 2: Manual Task Scheduler${NC}"
    echo -e "   1. Open Task Scheduler (Win+R, type: taskschd.msc)"
    echo -e "   2. Action → Import Task"
    echo -e "   3. Browse to: ${GREEN}$WIN_PATH\\WSL-Screenshot-Monitor.xml${NC}"
    echo -e "   4. Click OK"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to start the monitor
start_monitor() {
    echo
    echo -e "${YELLOW}🎯 Starting screenshot monitor...${NC}"
    
    # Source the functions
    source "$SCRIPT_DIR/screenshot-functions.sh"
    
    # Check if already running
    if pgrep -f "auto-clipboard-monitor" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Screenshot monitor is already running!${NC}"
    else
        start-screenshot-monitor
    fi
}

# Function to create desktop shortcut
create_shortcuts() {
    echo
    echo -e "${YELLOW}🔗 Creating convenient shortcuts...${NC}"
    
    # Create a start script in home directory
    cat > "$HOME/start-screenshots.sh" << EOF
#!/bin/bash
source "$SCRIPT_DIR/screenshot-functions.sh"
if pgrep -f "auto-clipboard-monitor" > /dev/null 2>&1; then
    echo "✅ Screenshot automation is already running!"
    check-screenshot-monitor
else
    start-screenshot-monitor
fi
EOF
    chmod +x "$HOME/start-screenshots.sh"
    
    echo -e "${GREEN}✓ Created ~/start-screenshots.sh for quick access${NC}"
}

# Main setup flow
main() {
    echo -e "${YELLOW}Starting setup...${NC}"
    echo
    
    check_wsl
    create_directories
    setup_bashrc
    create_shortcuts
    setup_windows_autostart
    start_monitor
    
    echo
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               🎉 Setup Complete! 🎉                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${BLUE}📸 How to use:${NC}"
    echo -e "   1. Take a screenshot with ${YELLOW}Win+Shift+S${NC}"
    echo -e "   2. Paste the path in Claude Code with ${YELLOW}Ctrl+V${NC}"
    echo
    echo -e "${BLUE}🛠️  Useful commands:${NC}"
    echo -e "   ${GREEN}check-screenshot-monitor${NC} - Check if running"
    echo -e "   ${GREEN}list-screenshots${NC}        - List captured screenshots"
    echo -e "   ${GREEN}stop-screenshot-monitor${NC}  - Stop the monitor"
    echo -e "   ${GREEN}~/start-screenshots.sh${NC}   - Restart the monitor"
    echo
    echo -e "${YELLOW}⚠️  Don't forget to set up Windows autostart (instructions above)${NC}"
    echo
}

# Run main function
main "$@"