#!/bin/bash

# CLONEMAN - Professional Application Launcher
# Starts Flask server and opens in browser automatically

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

HOST="127.0.0.1"
PORT="5000"
URL="http://${HOST}:${PORT}"
VENV_PATH="$SCRIPT_DIR/venv"
LOG_FILE="/tmp/cloneman_app.log"
PID_FILE="/tmp/cloneman_app.pid"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

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

check_port() {
    if lsof -Pi :${PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

open_browser() {
    sleep 3
    if curl -fsS "${URL}/api/status" >/dev/null 2>&1; then
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
    else
        echo -e "${YELLOW}[⚠️] Server is not ready yet. Please wait a few seconds and load $URL${NC}"
    fi
}

need_install() {
    if [ ! -d "$VENV_PATH" ] || [ ! -f "$VENV_PATH/bin/python" ]; then
        return 0
    fi
    return 1
}

if check_port; then
    echo -e "${YELLOW}[⚠️] Port $PORT is already in use${NC}"
    if curl -fsS "${URL}/api/status" >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] CLONEMAN is already running at $URL${NC}"
        open_browser &
        exit 0
    fi

    echo -e "${RED}[✗] Port $PORT is occupied by another process.${NC}"
    echo -e "${YELLOW}[!] Please stop the conflicting process or change the port in app.py${NC}"
    exit 1
fi

if need_install; then
    echo -e "${BLUE}[*] Virtual environment missing. Installing dependencies...${NC}"
    bash "$SCRIPT_DIR/install.sh"
fi

if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo -e "${RED}[✗] .env file not found${NC}"
    cat > "$SCRIPT_DIR/.env" << 'ENV_EOF'
# CLONEMAN Configuration
# Get API key from: https://openrouter.ai
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
ENV_EOF
    echo -e "${YELLOW}[!] Created a .env template. Add your key and rerun.${NC}"
    exit 1
fi

if ! grep -q "sk-or-v1-" "$SCRIPT_DIR/.env"; then
    echo -e "${RED}[✗] Invalid or missing API key in .env${NC}"
    echo -e "${YELLOW}[!] Please add: OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] Configuration verified${NC}"
mkdir -p ~/.local/share/cloneman /tmp/cloneman_data

source "$VENV_PATH/bin/activate"

rm -f "$PID_FILE"
nohup python3 app.py > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"

for _ in $(seq 1 30); do
    if curl -fsS "${URL}/api/status" >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] CLONEMAN is running at $URL${NC}"
        echo -e "${GREEN}[✓] Status endpoint: ${URL}/api/status${NC}"
        echo -e "${GREEN}[✓] Logs: /tmp/cloneman_app.log${NC}"
        open_browser &
        exit 0
    fi
    sleep 1
done

echo -e "${RED}[✗] CLONEMAN did not start successfully.${NC}"
echo -e "${YELLOW}[!] Recent log output:${NC}"
tail -n 40 "$LOG_FILE" || true
exit 1
