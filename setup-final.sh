#!/bin/bash

# CLONEMAN - Final Setup & Validation Script
# Verifies all components and makes everything executable

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   🛡️  CLONEMAN - Final Setup & Validation  🛡️          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Make all shell scripts executable
echo "[*] Making shell scripts executable..."
chmod +x "$SCRIPT_DIR/install.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/run.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/launch.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/install-app.sh" 2>/dev/null || true
chmod +x "$SCRIPT_DIR/QUICKSTART.sh" 2>/dev/null || true
echo "[✓] Scripts are executable"

# Step 2: Verify project structure
echo "[*] Verifying project structure..."
FILES_TO_CHECK=(
    "app.py"
    "requirements.txt"
    "templates/index.html"
    "static/app.js"
    "static/style.css"
    "static/logo.svg"
    ".gitignore"
    "README.md"
    "QUICKSTART.sh"
    "APP_SETUP.md"
    "CHANGES_SUMMARY.md"
    "install.sh"
    "run.sh"
    "launch.sh"
    "install-app.sh"
    "cloneman.desktop"
    "cloneman.service"
)

MISSING=0
for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$SCRIPT_DIR/$file" ] || [ -d "$SCRIPT_DIR/$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file (MISSING)"
        MISSING=$((MISSING+1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "[✓] All files present"
else
    echo "[⚠️] $MISSING files missing"
fi

# Step 3: Check .env file
echo "[*] Checking configuration..."
if [ -f "$SCRIPT_DIR/.env" ]; then
    if grep -q "OPENROUTER_API_KEY" "$SCRIPT_DIR/.env"; then
        echo "[✓] .env file configured"
    else
        echo "[⚠️] .env exists but missing API key"
    fi
else
    echo "[⚠️] .env file not found - will be created on first run"
fi

# Step 4: Check Python
echo "[*] Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "[✓] $PYTHON_VERSION"
else
    echo "[✗] Python3 not found"
    echo "    Install with: sudo apt-get install python3"
fi

# Step 5: Summary
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║              Setup Verification Complete! ✓              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

echo "📋 Next Steps:"
echo ""
echo "1️⃣  Install CLONEMAN (one-time setup):"
echo "   $ chmod +x install.sh && ./install.sh"
echo ""
echo "2️⃣  Configure API Key:"
echo "   $ nano .env"
echo "   Add: OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY"
echo ""
echo "3️⃣  Launch Application:"
echo "   $ chmod +x launch.sh && ./launch.sh"
echo ""
echo "4️⃣  (Optional) Install as Desktop App:"
echo "   $ chmod +x install-app.sh && ./install-app.sh"
echo ""

echo "📁 Project Structure:"
echo "CLONEMAN/"
echo "├── Backend: app.py"
echo "├── Frontend: templates/index.html, static/"
echo "├── Config: .env, requirements.txt"
echo "├── Scripts: install.sh, run.sh, launch.sh, install-app.sh"
echo "├── Documentation: README.md, APP_SETUP.md, QUICKSTART.sh"
echo "├── Assets: static/logo.svg"
echo "└── System: cloneman.desktop, cloneman.service"
echo ""

echo "💾 Storage Locations:"
echo "├── Browser Storage: localStorage"
echo "├── Server Storage: ~/.local/share/cloneman/chat_history.json"
echo "├── Application Logs: /tmp/cloneman.log"
echo "└── Desktop Entry: ~/.local/share/applications/cloneman.desktop"
echo ""

echo "🎨 Features:"
echo "✅ File-based persistent chat history"
echo "✅ Dual storage (browser + server)"
echo "✅ Professional green logo"
echo "✅ Desktop app integration"
echo "✅ Real-time status monitoring"
echo "✅ Image & code analysis"
echo "✅ Export/Import capabilities"
echo "✅ Comprehensive logging"
echo ""

echo "🚀 Start Command:"
echo "   $ ./launch.sh"
echo ""

echo "🛡️ Ready to secure! Type: ./launch.sh to begin"
