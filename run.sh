#!/bin/bash

# CLONEMAN Launcher Script for Kali Linux
# Quick start script for the cybersecurity AI assistant

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
clear
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║      🛡️  CLONEMAN - Cybersecurity AI Assistant  🛡️       ║"
echo "║                  Kali Linux Edition                       ║"
echo "║                    v1.0                                   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${RED}[✗] Virtual environment not found!${NC}"
    echo -e "${YELLOW}[*] Running installation first...${NC}"
    bash install.sh
fi

# Activate virtual environment
echo -e "${BLUE}[*] Activating virtual environment...${NC}"
source venv/bin/activate

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${RED}[✗] .env file not found!${NC}"
    echo -e "${YELLOW}[*] Creating .env template...${NC}"
    cat > .env << 'EOF'
# CLONEMAN Configuration
# Get your API key from: https://openrouter.ai
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
EOF
    echo -e "${YELLOW}Please edit .env and add your OpenRouter API key${NC}"
    echo ""
    read -p "Press Enter after configuring .env... "
fi

# Verify API key
if ! grep -q "sk-or-v1-" .env; then
    echo -e "${RED}[✗] Invalid or missing API key in .env${NC}"
    echo -e "${YELLOW}Please update OPENROUTER_API_KEY in .env file${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] Configuration verified${NC}"
echo ""

# Get the host and port
HOST="127.0.0.1"
PORT="5000"

echo -e "${BLUE}[*] Starting CLONEMAN...${NC}"
echo -e "${GREEN}[✓] Server running at: http://${HOST}:${PORT}${NC}"
echo -e "${GREEN}[✓] Status endpoint: http://${HOST}:${PORT}/api/status${NC}"
echo -e "${GREEN}[✓] Logs available at: /tmp/cloneman.log${NC}"
echo ""
echo -e "${YELLOW}[*] Press Ctrl+C to stop the server${NC}"
echo ""

# Start the Flask application
python3 app.py
