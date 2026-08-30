# 🛡️ CLONEMAN - Cybersecurity AI Assistant for Kali Linux

## Overview

**CLONEMAN** is a powerful cybersecurity AI assistant built specifically for **Kali Linux**. It provides advanced security analysis, OPSEC guidance, vulnerability assessment, and code review capabilities through an intuitive web interface.

### Key Features

✅ **AI-Powered Security Analysis** - Leverages OpenRouter API for deep security insights
✅ **Image Analysis** - Analyze code snippets, network diagrams, log files, and security screenshots
✅ **Local Privacy** - All chat history stored locally in browser (no cloud sync)
✅ **OPSEC Focused** - System designed with operational security best practices
✅ **Kali Linux Optimized** - Native integration with Kali Linux tools and workflows
✅ **Dark Terminal UI** - Professional hacker-style interface with green-on-black theme
✅ **No Authentication Required** - Local deployment for maximum privacy
✅ **Real-time Logging** - All activities logged to `/tmp/cloneman.log`

---

## 📋 System Requirements

- **OS**: Kali Linux 2024.x or compatible Debian-based system
- **Python**: 3.8 or higher
- **Internet**: Required for OpenRouter AI API
- **Port**: 5000 (localhost only)
- **RAM**: Minimum 512MB
- **Storage**: 500MB for dependencies

---

## 🚀 Quick Start

### 1. Clone/Download the Project

```bash
cd ~/Desktop/my\ codes/CLONEMAN
```

### 2. Run Installation

```bash
chmod +x install.sh
./install.sh
```

This will:
- Update system packages
- Install Python3 and pip
- Create Python virtual environment
- Install all dependencies from `requirements.txt`
- Verify configuration

### 3. Configure API Key

Edit `.env` file:

```bash
nano .env
```

Add your OpenRouter API key:

```
OPENROUTER_API_KEY=sk-or-v1-YOUR_API_KEY_HERE
```

**Get free API key**: Visit https://openrouter.ai

### 4. Start CLONEMAN

```bash
chmod +x run.sh
./run.sh
```

You'll see:

```
╔═══════════════════════════════════════════════════════════╗
║      🛡️  CLONEMAN - Cybersecurity AI Assistant  🛡️       ║
║                  Kali Linux Edition                       ║
║                    v1.0                                   ║
╚═══════════════════════════════════════════════════════════╝

[✓] Configuration verified
[*] Starting CLONEMAN...
[✓] Server running at: http://127.0.0.1:5000
```

### 5. Access the Interface

Open your browser and navigate to:

```
http://127.0.0.1:5000
```

---

## 📁 Project Structure

```
CLONEMAN/
├── app.py                 # Flask backend application
├── requirements.txt       # Python dependencies
├── .env                   # Configuration (API keys)
├── run.sh                 # Quick launcher script
├── install.sh             # Installation script
├── cloneman.service       # SystemD service file
├── README.md              # This file
├── templates/
│   └── index.html         # Web interface template
└── static/
    ├── app.js             # Frontend JavaScript logic
    └── style.css          # Kali Linux themed styles
```

---

## 🎯 Usage Examples

### 1. **Security Code Review**

Ask CLONEMAN to analyze code for vulnerabilities:

```
Request: "Review this Python code for SQL injection vulnerabilities"
Then: Paste or upload code snippet as image
Response: Detailed vulnerability analysis and recommendations
```

### 2. **OPSEC Guidance**

```
Request: "What OPSEC considerations should I follow for pentesting?"
Response: Comprehensive operational security checklist
```

### 3. **Log Analysis**

```
Request: "Analyze this network log for suspicious activity"
Action: Upload network capture or log file as image
Response: Threat assessment and indicators of compromise
```

### 4. **Vulnerability Research**

```
Request: "Explain CVE-2024-1234 and exploitation techniques"
Response: In-depth technical analysis
```

---

## 🔧 Configuration & Advanced

### Running as SystemD Service

Install as user service (optional):

```bash
mkdir -p ~/.config/systemd/user
cp cloneman.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable cloneman
systemctl --user start cloneman
```

Check status:

```bash
systemctl --user status cloneman
```

View logs:

```bash
journalctl --user -u cloneman -f
```

### View Application Logs

```bash
tail -f /tmp/cloneman.log
```

### Custom Configuration

Edit `app.py` to modify:

- **Port**: Change line `app.run(host='127.0.0.1', port=5000)`
- **AI Model**: Change line `"model": "openrouter/free"`
- **System Prompt**: Edit `SYSTEM_PROMPT` dictionary

---

## 🔐 Security Considerations

### Privacy & OPSEC

✓ **Local Storage Only** - Chat history saved in browser localStorage
✓ **No Account Required** - Completely anonymous, no registration
✓ **Localhost Binding** - Only accessible from your machine (127.0.0.1)
✓ **HTTPS Optional** - Can add SSL certificate for network deployment
✓ **API Key Protection** - Never exposed to frontend, server-side only

### Recommended Security Practices

1. **Keep API Key Secret**
   ```bash
   chmod 600 .env  # Restrict .env file permissions
   ```

2. **Update Dependencies Regularly**
   ```bash
   source venv/bin/activate
   pip install --upgrade flask requests python-dotenv
   ```

3. **Use Dedicated VirtualEnv**
   - Virtual environment isolates dependencies
   - Always activate before running

4. **Monitor Logs for Errors**
   ```bash
   grep ERROR /tmp/cloneman.log
   ```

---

## 🛠️ Troubleshooting

### Issue: "API key not found"

**Solution**: Ensure `.env` file exists and contains valid key:

```bash
cat .env
# Should show: OPENROUTER_API_KEY=sk-or-v1-...
```

### Issue: "Connection refused"

**Solution**: Check if Flask is running:

```bash
lsof -i :5000
# If empty, start with: ./run.sh
```

### Issue: "Virtual environment not found"

**Solution**: Reinstall:

```bash
rm -rf venv
./install.sh
```

### Issue: "Module not found errors"

**Solution**: Ensure virtual environment is activated:

```bash
source venv/bin/activate
python3 -m pip install -r requirements.txt
```

### Issue: "Timeout errors from API"

**Solution**: Check internet connection and try again:

```bash
ping openrouter.ai
# If fails, check network connectivity
```

---

## 📊 Performance & Resource Usage

| Resource | Usage |
|----------|-------|
| CPU | Low (idle ~2%) |
| Memory | ~80-120MB |
| Storage | ~200MB (venv + logs) |
| Network | Only for API calls |
| Port | 5000 (localhost) |

---

## 🔄 Updates & Maintenance

### Check for Updates

```bash
git pull origin main  # If using git
```

### Clear Old Logs

```bash
rm /tmp/cloneman.log
```

### Clear Chat History

```bash
# In web interface: Click "Clear" button
# Or manually clear browser storage
```

### Update Dependencies

```bash
source venv/bin/activate
pip install --upgrade -r requirements.txt
```

---

## 📝 API Endpoints

### Base URL
```
http://127.0.0.1:5000
```

### Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/` | GET | Main web interface |
| `/api/chat` | POST | Process chat messages |
| `/api/status` | GET | Health check |

### Status Check

```bash
curl http://127.0.0.1:5000/api/status
```

Response:
```json
{
  "status": "operational",
  "version": "1.0-kali",
  "timestamp": "2024-08-30T14:23:45.123456"
}
```

---

## 🤝 Support & Contributions

### Getting Help

1. Check `/tmp/cloneman.log` for error details
2. Visit OpenRouter documentation: https://openrouter.ai/docs
3. Review Flask documentation: https://flask.palletsprojects.com/

### Bug Reports

Report issues with:
- Screenshots of error
- Relevant logs from `/tmp/cloneman.log`
- Steps to reproduce

---

## 📜 License

This project is for educational and authorized security testing purposes only. Ensure you have proper authorization before conducting security assessments.

**Disclaimer**: Users are responsible for complying with all applicable laws and regulations when using this tool.

---

## 🎓 Technologies Used

- **Backend**: Python 3, Flask
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **API**: OpenRouter (OpenAI, Claude, Gemini, etc.)
- **OS**: Kali Linux / Debian
- **Storage**: Browser localStorage (encrypted)
- **Deployment**: SystemD (optional)

---

## 📞 Contact & Resources

- **OpenRouter API**: https://openrouter.ai
- **Kali Linux**: https://www.kali.org
- **Flask Documentation**: https://flask.palletsprojects.com/
- **Security Best Practices**: https://owasp.org

---

**Version**: 1.0 - Kali Linux Edition  
**Last Updated**: 2024-08-30  
**Status**: ✅ Production Ready

---

## Quick Reference

```bash
# Installation
./install.sh

# Run application
./run.sh

# View logs
tail -f /tmp/cloneman.log

# Check status
curl http://127.0.0.1:5000/api/status

# Stop server
Ctrl+C (in terminal)

# Update API key
nano .env

# System service (optional)
systemctl --user start cloneman
systemctl --user stop cloneman
systemctl --user status cloneman
```

---

🛡️ **Stay Secure. Stay Ethical. Stay in Control.** 🛡️
