#!/bin/bash

# CLONEMAN - Professional Application Launcher
# Starts Flask server and opens in browser automatically

set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Configuration
HOST="127.0.0.1"
PORT="5000"
URL="http://${HOST}:${PORT}"
VENV_PATH="$SCRIPT_DIR/venv"
LOG_FILE="/tmp/cloneman_app.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
clear
echo -e "${CYAN}"
cat << 'EOF'
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║     ███████████████████████████████████████████████████████████ ║
║     █                                                           █ ║
║     █  🛡️  CLONEMAN - Cybersecurity AI Assistant  🛡️          █ ║
║     █                                                           █ ║
║     █     Powered by Kali Linux & OpenRouter API               █ ║
║     █     Professional Desktop Application v1.0                █ ║
║     █                                                           █ ║
║     ███████████████████████████████████████████████████████████ ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Function to check if port is in use
check_port() {
    if lsof -Pi :${PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to open browser
open_browser() {
    sleep 3  # Wait for server to start
    
    # Try different browser commands
    if command -v xdg-open &> /dev/null; then
        xdg-open "$URL" > /dev/null 2>&1 &
        echo -e "${GREEN}[✓] Browser opened (xdg-open)${NC}"
    elif command -v firefox &> /dev/null; then
        firefox "$URL" > /dev/null 2>&1 &
        echo -e "${GREEN}[✓] Browser opened (Firefox)${NC}"
    elif command -v chromium &> /dev/null; then
        chromium "$URL" > /dev/null 2>&1 &
        echo -e "${GREEN}[✓] Browser opened (Chromium)${NC}"
    elif command -v google-chrome &> /dev/null; then
        google-chrome "$URL" > /dev/null 2>&1 &
        echo -e "${GREEN}[✓] Browser opened (Google Chrome)${NC}"
    else
        echo -e "${YELLOW}[⚠️] Could not find a browser. Open manually: $URL${NC}"
    fi
}

# Step 1: Check if port is available
echo -e "${BLUE}[*] Checking if port $PORT is available...${NC}"
if check_port; then
    echo -e "${YELLOW}[⚠️] Port $PORT is already in use${NC}"
    read -p "Do you want to kill the existing process? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pkill -f "python.*app.py" || true
        sleep 1
        if check_port; then
            echo -e "${RED}[✗] Could not free port $PORT${NC}"
            exit 1
        fi
        echo -e "${GREEN}[✓] Existing process terminated${NC}"
    else
        echo -e "${YELLOW}[!] Using existing instance at $URL${NC}"
        sleep 1
        open_browser &
        exit 0
    fi
else
    echo -e "${GREEN}[✓] Port $PORT is available${NC}"
fi

# Step 2: Check virtual environment
echo -e "${BLUE}[*] Checking virtual environment...${NC}"
if [ ! -d "$VENV_PATH" ]; then
    echo -e "${YELLOW}[!] Virtual environment not found${NC}"
    echo -e "${BLUE}[*] Running installation...${NC}"
    bash "$SCRIPT_DIR/install.sh"
    echo -e "${GREEN}[✓] Installation complete${NC}"
fi

# Step 3: Check .env file
echo -e "${BLUE}[*] Checking configuration...${NC}"
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo -e "${RED}[✗] .env file not found${NC}"
    echo -e "${YELLOW}[!] Creating .env template...${NC}"
    cat > "$SCRIPT_DIR/.env" << 'ENV_EOF'
# CLONEMAN Configuration
# Get API key from: https://openrouter.ai
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
ENV_EOF
    echo -e "${YELLOW}[!] Please edit .env and add your OpenRouter API key${NC}"
    echo -e "${YELLOW}[!] File: $SCRIPT_DIR/.env${NC}"
    read -p "Press Enter after updating .env... "
fi

# Verify API key
if ! grep -q "sk-or-v1-" "$SCRIPT_DIR/.env"; then
    echo -e "${RED}[✗] Invalid or missing API key in .env${NC}"
    echo -e "${YELLOW}[!] Please add: OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY${NC}"
    echo -e "${YELLOW}[!] Get key from: https://openrouter.ai${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] Configuration verified${NC}"

# Step 4: Create necessary directories
echo -e "${BLUE}[*] Setting up application directories...${NC}"
mkdir -p ~/.local/share/cloneman
mkdir -p /tmp/cloneman_data
echo -e "${GREEN}[✓] Directories ready${NC}"

# Step 5: Activate venv and start app
echo -e "${BLUE}[*] Starting CLONEMAN...${NC}"
echo ""

# Start Flask in background and open browser
source "$VENV_PATH/bin/activate"

# Open browser in background
open_browser &

# Start Flask server (this will run in foreground)
python3 app.py 2>&1 | tee -a "$LOG_FILE"
