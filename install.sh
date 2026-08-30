#!/bin/bash

# CLONEMAN Installation Script for Kali Linux
# This script sets up the cybersecurity AI assistant for Kali Linux

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║          CLONEMAN - Installation for Kali Linux           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check if running on Kali Linux or compatible Debian
if ! grep -iq "kali" /etc/os-release && ! grep -iq "debian" /etc/os-release; then
    echo "[⚠️] Warning: This system may not be Kali Linux"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 1: Update system
echo "[*] Step 1/5: Updating system packages..."
sudo apt-get update -qq
echo "[✓] System updated"

# Step 2: Install Python3 and pip
echo "[*] Step 2/5: Installing Python3 and pip..."
sudo apt-get install -y -qq python3 python3-pip python3-venv > /dev/null 2>&1
echo "[✓] Python3 and pip installed"

# Step 3: Create virtual environment
echo "[*] Step 3/5: Creating Python virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "[✓] Virtual environment created"
else
    echo "[✓] Virtual environment already exists"
fi

# Step 4: Activate venv and install dependencies
echo "[*] Step 4/5: Installing Python dependencies..."
source venv/bin/activate
pip install -q -r requirements.txt
echo "[✓] Dependencies installed"

# Step 5: Verify .env file
echo "[*] Step 5/5: Checking configuration..."
if [ ! -f ".env" ]; then
    echo "[⚠️] .env file not found!"
    echo "Please create .env file with:"
    echo "OPENROUTER_API_KEY=your_api_key_here"
    exit 1
else
    if grep -q "OPENROUTER_API_KEY=sk-or" .env; then
        echo "[✓] API key configured"
    else
        echo "[⚠️] .env file exists but API key may be invalid"
    fi
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              Installation Complete! ✓                     ║"
echo "║                                                           ║"
echo "║  To run CLONEMAN, execute:                               ║"
echo "║  $ ./run.sh                                              ║"
echo "║                                                           ║"
echo "║  Then open browser: http://127.0.0.1:5000                ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
