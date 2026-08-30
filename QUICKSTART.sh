#!/bin/bash

# CLONEMAN - Quick Reference Guide
# Fast reference for common operations

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════╗
║                  🛡️  CLONEMAN Quick Reference  🛡️              ║
║              Cybersecurity AI Assistant for Kali Linux           ║
╚══════════════════════════════════════════════════════════════════╝

┌─ INSTALLATION ──────────────────────────────────────────────────┐
│                                                                 │
│  First time setup:                                              │
│    $ chmod +x install.sh                                        │
│    $ ./install.sh                                               │
│                                                                 │
│  Edit .env and add your API key:                               │
│    $ nano .env                                                  │
│    OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ RUNNING ───────────────────────────────────────────────────────┐
│                                                                 │
│  Start the application:                                         │
│    $ chmod +x run.sh                                            │
│    $ ./run.sh                                                   │
│                                                                 │
│  Access in browser:                                             │
│    http://127.0.0.1:5000                                       │
│                                                                 │
│  Stop server:                                                   │
│    Ctrl+C (in terminal)                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ USAGE EXAMPLES ────────────────────────────────────────────────┐
│                                                                 │
│  1. Security Code Review                                        │
│     "Analyze this code for SQL injection vulnerabilities"       │
│     → Upload code as image or paste text                        │
│                                                                 │
│  2. OPSEC Guidance                                              │
│     "What are the OPSEC best practices for pentesting?"         │
│                                                                 │
│  3. Vulnerability Analysis                                      │
│     "Explain CVE-2024-XXXX and how to exploit it"              │
│                                                                 │
│  4. Log File Analysis                                           │
│     "Analyze this network log for suspicious activity"          │
│     → Upload log file as image                                  │
│                                                                 │
│  5. Network Diagram Review                                      │
│     "Review this network topology for security issues"          │
│     → Upload diagram as image                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ TROUBLESHOOTING ───────────────────────────────────────────────┐
│                                                                 │
│  Check server status:                                           │
│    $ curl http://127.0.0.1:5000/api/status                     │
│                                                                 │
│  View application logs:                                         │
│    $ tail -f /tmp/cloneman.log                                  │
│                                                                 │
│  Check if port 5000 is in use:                                 │
│    $ lsof -i :5000                                             │
│                                                                 │
│  Verify API key:                                                │
│    $ grep OPENROUTER_API_KEY .env                              │
│                                                                 │
│  Reinstall dependencies:                                        │
│    $ source venv/bin/activate                                  │
│    $ pip install --upgrade -r requirements.txt                 │
│                                                                 │
│  Clear chat history:                                            │
│    → Click "Clear" button in web interface                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ FILE STRUCTURE ────────────────────────────────────────────────┐
│                                                                 │
│  CLONEMAN/                                                      │
│  ├── app.py              Main Flask application                 │
│  ├── requirements.txt    Python dependencies                    │
│  ├── .env                API key configuration                  │
│  ├── run.sh              Launcher script                        │
│  ├── install.sh          Installation script                    │
│  ├── README.md           Full documentation                     │
│  ├── cloneman.service    SystemD service file                   │
│  ├── templates/                                                 │
│  │   └── index.html      Web interface                          │
│  ├── static/                                                    │
│  │   ├── app.js          Frontend JavaScript                    │
│  │   └── style.css       Kali Linux theme                       │
│  └── venv/               Python virtual environment             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ ADVANCED FEATURES ─────────────────────────────────────────────┐
│                                                                 │
│  SystemD Service (optional):                                    │
│    $ mkdir -p ~/.config/systemd/user                           │
│    $ cp cloneman.service ~/.config/systemd/user/               │
│    $ systemctl --user daemon-reload                            │
│    $ systemctl --user enable cloneman                          │
│    $ systemctl --user start cloneman                           │
│                                                                 │
│  View service logs:                                             │
│    $ journalctl --user -u cloneman -f                          │
│                                                                 │
│  Custom AI Model (edit app.py):                                │
│    "model": "openrouter/auto"  # Use best available model      │
│    "model": "openrouter/free"  # Use free tier                 │
│                                                                 │
│  Change port (edit app.py line end):                           │
│    app.run(host='127.0.0.1', port=8000)  # Use port 8000       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ API REFERENCE ─────────────────────────────────────────────────┐
│                                                                 │
│  Base URL: http://127.0.0.1:5000                               │
│                                                                 │
│  GET /                     Main web interface                   │
│  GET /api/status           Health check endpoint                │
│  POST /api/chat            Process chat messages                │
│                                                                 │
│  Example Status Check:                                          │
│    curl http://127.0.0.1:5000/api/status                       │
│                                                                 │
│  Response:                                                      │
│    {                                                            │
│      "status": "operational",                                   │
│      "version": "1.0-kali",                                     │
│      "timestamp": "2024-08-30T14:23:45"                         │
│    }                                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ KEYBOARD SHORTCUTS ────────────────────────────────────────────┐
│                                                                 │
│  Enter                Send message (when in text field)         │
│  Ctrl+A               Select all chat                           │
│  Ctrl+L               Clear browser console (debugging)         │
│                                                                 │
│  Browser Tools:                                                 │
│  F12                  Open Developer Console                    │
│  Ctrl+Shift+K         Open Console Tab                          │
│  Ctrl+Shift+I         Toggle Inspector                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ SECURITY NOTES ────────────────────────────────────────────────┐
│                                                                 │
│  ✓ Chat history stored LOCALLY in browser (no cloud sync)       │
│  ✓ API key only used server-side (never sent to browser)        │
│  ✓ Localhost-only access (not accessible over network)          │
│  ✓ All conversations are private and anonymous                 │
│  ✓ No account or authentication required                        │
│                                                                 │
│  Best Practices:                                                │
│    • Keep .env file with restricted permissions (chmod 600)     │
│    • Use in trusted network environment                         │
│    • Clear chat history if dealing with sensitive information   │
│    • Update dependencies regularly                              │
│    • Monitor /tmp/cloneman.log for suspicious activity          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─ GETTING HELP ──────────────────────────────────────────────────┐
│                                                                 │
│  1. Read full documentation:                                    │
│     $ cat README.md                                             │
│                                                                 │
│  2. Check logs for errors:                                      │
│     $ tail -50 /tmp/cloneman.log                                │
│                                                                 │
│  3. Verify configuration:                                       │
│     $ ./run.sh                                                  │
│     (will show detailed startup info)                           │
│                                                                 │
│  4. Test API connectivity:                                      │
│     $ ping openrouter.ai                                        │
│     $ curl -I https://openrouter.ai/api/v1                      │
│                                                                 │
│  5. View application status:                                    │
│     $ curl http://127.0.0.1:5000/api/status | jq               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Quick Start (30 seconds):

  1. $ chmod +x install.sh && ./install.sh
  2. $ nano .env
     (Add: OPENROUTER_API_KEY=sk-or-v1-YOUR_KEY)
  3. $ chmod +x run.sh && ./run.sh
  4. Open: http://127.0.0.1:5000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Version: 1.0 - Kali Linux Edition
Status: ✅ Production Ready
Support: Check README.md for full documentation

🛡️ Stay Secure. Stay Ethical. Stay in Control. 🛡️

EOF
