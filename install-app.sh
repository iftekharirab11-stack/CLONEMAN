#!/bin/bash

# CLONEMAN - Desktop Application Installation Script
# Installs CLONEMAN as a professional Kali Linux desktop application
# Makes it available on home screen / application menu

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_NAME="CLONEMAN"
APP_VERSION="1.0"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/pixmaps"
SHARE_DIR="$HOME/.local/share/cloneman"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   🛡️  CLONEMAN - Desktop Application Installation  🛡️     ║"
echo "║              Kali Linux Professional Edition              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Create directories
echo -e "${BLUE}[*] Step 1/5: Creating application directories...${NC}"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$ICON_DIR"
mkdir -p "$SHARE_DIR"
echo -e "${GREEN}[✓] Directories created${NC}"

# Step 2: Copy and setup logo/icon
echo -e "${BLUE}[*] Step 2/5: Installing application icon...${NC}"
if [ -f "$SCRIPT_DIR/static/logo.svg" ]; then
    cp "$SCRIPT_DIR/static/logo.svg" "$ICON_DIR/cloneman.svg"
    echo -e "${GREEN}[✓] Logo installed (SVG)${NC}"
    
    # Try to create PNG version if ImageMagick is available
    if command -v convert &> /dev/null; then
        convert "$ICON_DIR/cloneman.svg" -resize 128x128 "$ICON_DIR/cloneman.png" 2>/dev/null || true
        echo -e "${GREEN}[✓] PNG icon created (128x128)${NC}"
    fi
else
    echo -e "${YELLOW}[⚠️] Logo file not found, using default${NC}"
fi

# Step 3: Create desktop entry file
echo -e "${BLUE}[*] Step 3/5: Creating desktop application entry...${NC}"
cat > "$DESKTOP_DIR/cloneman.desktop" << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=CLONEMAN
Comment=Cybersecurity AI Assistant for Kali Linux
Exec=sh -c 'cd "/home/irab/Desktop/my codes/CLONEMAN" && source venv/bin/activate && python3 app.py & sleep 2 && xdg-open http://127.0.0.1:5000'
Icon=cloneman
Terminal=false
Categories=Development;Utility;Security;System;
StartupNotify=true
Keywords=cybersecurity;ai;kali;penetration;testing;opsec;vulnerability;threat;analysis;

X-GNOME-SingleWindow=true
X-KDE-StartupWMClass=CLONEMAN
GenericName=Security Analysis Tool
X-GNOME-Autostart-enabled=true
MimeType=text/plain;text/x-python;image/png;image/jpeg;

# Custom fields
X-CLONEMAN-Version=1.0
X-CLONEMAN-Author=Security Researcher
X-CLONEMAN-License=Educational Use Only
DESKTOP_EOF

chmod 644 "$DESKTOP_DIR/cloneman.desktop"
echo -e "${GREEN}[✓] Desktop entry created${NC}"

# Step 4: Update desktop database
echo -e "${BLUE}[*] Step 4/5: Registering application with system...${NC}"
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
    echo -e "${GREEN}[✓] Application registered${NC}"
fi

# Step 5: Verify installation
echo -e "${BLUE}[*] Step 5/5: Verifying installation...${NC}"
if [ -f "$DESKTOP_DIR/cloneman.desktop" ]; then
    echo -e "${GREEN}[✓] Desktop file verified${NC}"
else
    echo -e "${RED}[✗] Desktop file verification failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete! ✓                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}📍 Installation Details:${NC}"
echo -e "   Desktop File: ${BLUE}$DESKTOP_DIR/cloneman.desktop${NC}"
echo -e "   Icon: ${BLUE}$ICON_DIR/cloneman{.svg,.png}${NC}"
echo -e "   Share Dir: ${BLUE}$SHARE_DIR${NC}"
echo ""

echo -e "${YELLOW}🚀 How to Launch CLONEMAN:${NC}"
echo -e "   ${GREEN}Option 1${NC}: Click 'CLONEMAN' in your application menu/drawer"
echo -e "   ${GREEN}Option 2${NC}: Run: ${BLUE}xdg-open /home/irab/Desktop/my\\ codes/CLONEMAN/cloneman.desktop${NC}"
echo -e "   ${GREEN}Option 3${NC}: Search for 'CLONEMAN' in your app launcher"
echo ""

echo -e "${YELLOW}ℹ️  What happens when you launch:${NC}"
echo -e "   1. Virtual environment is activated"
echo -e "   2. Flask server starts (http://127.0.0.1:5000)"
echo -e "   3. Browser opens automatically"
echo -e "   4. Chat interface is ready to use"
echo ""

echo -e "${YELLOW}📂 Chat History Location:${NC}"
echo -e "   ${BLUE}$HOME/.local/share/cloneman/chat_history.json${NC}"
echo ""

echo -e "${YELLOW}🔧 To Uninstall:${NC}"
echo -e "   ${BLUE}rm $DESKTOP_DIR/cloneman.desktop${NC}"
echo -e "   ${BLUE}rm $ICON_DIR/cloneman*${NC}"
echo ""

echo -e "${GREEN}✨ CLONEMAN is now available as a desktop application!${NC}"
echo ""
