#!/bin/bash

# CLONEMAN - ULTIMATE QUICK START GUIDE
# Complete setup in just 3 commands!

cat << 'EOF'

╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║   🛡️  CLONEMAN - Professional Desktop Application Setup  🛡️      ║
║                                                                    ║
║              Cybersecurity AI Assistant for Kali Linux            ║
║                          v1.0 Professional Edition                ║
║                                                                    ║
║  Now includes:                                                    ║
║  ✅ Persistent File-Based Chat History                           ║
║  ✅ Professional Green Logo                                      ║
║  ✅ Desktop App Integration (Home Screen)                        ║
║  ✅ Automatic Browser Launching                                  ║
║  ✅ Real-Time Server Status                                      ║
║  ✅ Dual Storage System (Browser + Server)                       ║
║  ✅ Professional UI Enhancements                                 ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝

📋 COMPLETE SETUP - 3 SIMPLE STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1️⃣  - INSTALL SYSTEM DEPENDENCIES
─────────────────────────────────────────

Copy and run this command:

    cd ~/Desktop/my\ codes/CLONEMAN
    chmod +x install.sh
    ./install.sh

What this does:
  ✓ Checks your system
  ✓ Updates package manager
  ✓ Installs Python dependencies
  ✓ Creates virtual environment
  ✓ Sets up all requirements

Time: ~2-3 minutes
Status: Fully automated


STEP 2️⃣  - CONFIGURE API KEY
─────────────────────────────────────────

Run this command:

    nano .env

Add your OpenRouter API key:

    OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE

💡 How to get free API key:
   1. Visit: https://openrouter.ai
   2. Sign up (free)
   3. Get your API key
   4. Paste it in .env

Save and exit: Ctrl+X → Y → Enter


STEP 3️⃣  - LAUNCH APPLICATION
─────────────────────────────────────────

Run this command:

    chmod +x launch.sh
    ./launch.sh

What happens:
  ✓ Activates virtual environment
  ✓ Starts Flask server
  ✓ Opens browser automatically
  ✓ Shows startup banner
  ✓ Ready to use!

Result: 🎉 CLONEMAN running at http://127.0.0.1:5000

═══════════════════════════════════════════════════════════════════════

🚀 OPTIONAL: INSTALL AS DESKTOP APPLICATION (Home Screen)
─────────────────────────────────────────────────────────────────

Want to launch from your application menu? Run:

    chmod +x install-app.sh
    ./install-app.sh

What this does:
  ✓ Creates application launcher
  ✓ Installs professional icon
  ✓ Registers with system
  ✓ Makes available on home screen

After installation:
  • Search "CLONEMAN" in app menu
  • Click to launch instantly
  • Automatic browser opening
  • Professional green logo

═══════════════════════════════════════════════════════════════════════

💾 CHAT HISTORY & STORAGE
─────────────────────────

Your conversations are stored in TWO places for safety:

1. Browser Storage (instant)
   └─ Accessed immediately when you open the app
   └─ Synced locally every time

2. Server File Storage (persistent)
   └─ Location: ~/.local/share/cloneman/chat_history.json
   └─ Auto-syncs every 30 seconds
   └─ Can be backed up, exported, shared
   └─ Survives browser clear

View your saved history:

    cat ~/.local/share/cloneman/chat_history.json | jq

Export history from app:
    • Click "📥 Export" button
    • Downloads JSON file to your computer

═══════════════════════════════════════════════════════════════════════

✨ FEATURES YOU NOW HAVE
─────────────────────────

✅ Persistent Chat History
   • Saved automatically to file
   • Survives browser restart
   • Accessible anytime
   • Exportable

✅ Professional Logo
   • Green Kali Linux shield
   • Professional branding
   • Used in app, desktop entry, favicon
   • Scalable SVG + PNG formats

✅ Desktop Integration
   • Application menu launcher
   • One-click startup
   • System integration
   • Professional appearance

✅ Real-Time Status
   • Green indicator = Connected
   • Red indicator = Disconnected
   • Shows in app header
   • Auto-checking every second

✅ Dual Storage
   • Browser + Server protection
   • Automatic syncing
   • No data loss
   • Recovery options

✅ Enhanced UI
   • Professional styling
   • Welcome message
   • Export button
   • Glowing effects
   • Responsive design

✅ Auto-Browser Launch
   • Starts server
   • Opens browser automatically
   • No manual navigation
   • Professional workflow

═══════════════════════════════════════════════════════════════════════

🎯 QUICK COMMANDS REFERENCE
─────────────────────────────

# First time setup (ONCE)
./install.sh

# Configure API key (ONCE)
nano .env

# Launch app (EVERY TIME)
./launch.sh

# Install as desktop app (OPTIONAL)
./install-app.sh

# View chat history
cat ~/.local/share/cloneman/chat_history.json | jq

# Check server status
curl http://127.0.0.1:5000/api/status | jq

# View application logs
tail -f /tmp/cloneman.log

# Check if port is free
lsof -i :5000

# Uninstall app (if needed)
rm ~/.local/share/applications/cloneman.desktop
rm ~/.local/share/pixmaps/cloneman*

═══════════════════════════════════════════════════════════════════════

📂 FILES & DIRECTORIES
────────────────────────

Application files:
  ~/Desktop/my\ codes/CLONEMAN/
    ├── app.py                  ← Flask backend
    ├── launch.sh               ← Use this to start
    ├── install.sh              ← Use for setup
    ├── install-app.sh          ← Use for desktop app
    └── static/logo.svg         ← Professional logo

Chat history:
  ~/.local/share/cloneman/chat_history.json    ← Your conversations

Application launcher:
  ~/.local/share/applications/cloneman.desktop ← Desktop entry

Icon files:
  ~/.local/share/pixmaps/cloneman.*            ← App icon

Logs:
  /tmp/cloneman.log                            ← Debugging
  /tmp/cloneman_app.log                        ← Launch logs

═══════════════════════════════════════════════════════════════════════

🎓 TROUBLESHOOTING
───────────────────

Problem: Port 5000 already in use
Solution: The script will detect and ask to kill the process
  OR manually: pkill -f "python.*app.py"

Problem: API key not working
Solution: 
  1. Make sure it starts with: sk-or-v1-
  2. No extra spaces in .env
  3. Restart app after editing .env

Problem: Can't find app in application menu
Solution: Run install-app.sh again
  OR search your app launcher for "CLONEMAN"

Problem: Chat history not saving
Solution:
  1. Check directory exists: ls -la ~/.local/share/cloneman/
  2. Check permissions: chmod 644 ~/.local/share/cloneman/chat_history.json
  3. Check logs: tail /tmp/cloneman.log

Problem: Browser doesn't open automatically
Solution: Manually open: http://127.0.0.1:5000
  OR check if browser is installed: which firefox

═══════════════════════════════════════════════════════════════════════

🔐 SECURITY & PRIVACY
──────────────────────

✅ Your data stays LOCAL
   • No cloud sync
   • No data collection
   • No tracking

✅ Chat history file-based
   • In your home directory
   • Full user control
   • Can be backed up
   • Can be deleted anytime

✅ API key protected
   • Only used server-side
   • Never sent to browser
   • Secure HTTPS to OpenRouter

✅ Localhost only
   • Not accessible remotely
   • Only you can access
   • Secure by default

═══════════════════════════════════════════════════════════════════════

📞 SUPPORT & DOCUMENTATION
────────────────────────────

Read these files for more info:

1. README.md
   └─ Complete feature documentation
   └─ All capabilities explained
   └─ API endpoints listed
   └─ Performance details

2. APP_SETUP.md
   └─ Desktop app specific guide
   └─ Installation instructions
   └─ Configuration options
   └─ Advanced features

3. DESKTOP_APP_SUMMARY.md
   └─ Technical implementation details
   └─ What was added/changed
   └─ Architecture overview
   └─ File structure reference

4. QUICKSTART.sh
   └─ Quick reference card
   └─ Common commands
   └─ Keyboard shortcuts

═══════════════════════════════════════════════════════════════════════

🎉 YOU'RE READY!
─────────────────

Your CLONEMAN application is now:

✅ Fully Installed
✅ Professional Quality
✅ Desktop Integrated (optional)
✅ Ready to Use
✅ Persistent Storage
✅ Secure & Private

═══════════════════════════════════════════════════════════════════════

🚀 NOW GO START CLONEMAN!

    cd ~/Desktop/my\ codes/CLONEMAN && chmod +x launch.sh && ./launch.sh

═══════════════════════════════════════════════════════════════════════

Questions? Check the detailed documentation files included!

Version: 1.0 - Kali Linux Professional Edition
Status: ✅ Production Ready
Last Updated: 2024-08-30

🛡️ Stay Secure. Stay Ethical. Stay in Control. 🛡️

EOF
