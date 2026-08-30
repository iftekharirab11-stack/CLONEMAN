import os
import sys
import json
import logging
import requests
from flask import Flask, request, jsonify, render_template
from dotenv import load_dotenv
from datetime import datetime
from pathlib import Path

# Storage paths
APP_DATA_DIR = Path.home() / '.local' / 'share' / 'cloneman'
CHAT_HISTORY_FILE = APP_DATA_DIR / 'chat_history.json'
APP_DATA_DIR.mkdir(parents=True, exist_ok=True)

# Configure logging for Kali Linux
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - CLONEMAN - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/tmp/cloneman.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Initialize environment and app
load_dotenv()
app = Flask(__name__)

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
if not OPENROUTER_API_KEY:
    logger.error("CRITICAL: Missing OPENROUTER_API_KEY in .env file. Exiting.")
    sys.exit(1)

# Core OPSEC & Persona directive
SYSTEM_PROMPT = {
    "role": "system",
    "content": (
        "You are an elite, no-sugarcoating cybersecurity AI assistant. "
        "Provide precise, strategic, and highly technical solutions. "
        "Focus on OPSEC, vulnerability analysis, secure coding, and threat intelligence. "
        "If provided with an image (code snippet, network diagram, log file), analyze it strictly for security implications. "
        "Do not guess. If you do not know, state exactly what information is missing."
    )
}

# ============= CHAT HISTORY MANAGEMENT =============

def load_chat_history():
    """Load chat history from file storage"""
    try:
        if CHAT_HISTORY_FILE.exists():
            with open(CHAT_HISTORY_FILE, 'r') as f:
                return json.load(f)
    except Exception as e:
        logger.error(f"Error loading chat history: {e}")
    return []

def save_chat_history(history):
    """Save chat history to file storage"""
    try:
        with open(CHAT_HISTORY_FILE, 'w') as f:
            json.dump(history, f, indent=2)
        logger.info(f"Chat history saved. Entries: {len(history)}")
        return True
    except Exception as e:
        logger.error(f"Error saving chat history: {e}")
        return False

def clear_chat_history():
    """Clear chat history file"""
    try:
        if CHAT_HISTORY_FILE.exists():
            CHAT_HISTORY_FILE.unlink()
        logger.info("Chat history cleared")
        return True
    except Exception as e:
        logger.error(f"Error clearing chat history: {e}")
        return False

def export_chat_history(format_type='json'):
    """Export chat history in specified format"""
    try:
        history = load_chat_history()
        if format_type == 'txt':
            # Export as readable text
            content = "CLONEMAN - Chat History Export\n"
            content += f"Exported: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
            content += "=" * 60 + "\n\n"
            for i, msg in enumerate(history, 1):
                if msg.get('role') != 'system':
                    role = msg.get('role', 'unknown').upper()
                    if isinstance(msg.get('content'), list):
                        content_text = msg['content'][0].get('text', '[Image]')
                    else:
                        content_text = msg.get('content', '')
                    content += f"{i}. [{role}] {content_text[:100]}...\n\n"
            return content
        else:  # json
            return json.dumps(history, indent=2)
    except Exception as e:
        logger.error(f"Error exporting chat history: {e}")
        return None

@app.route('/api/status', methods=['GET'])
def status():
    """Health check endpoint"""
    return jsonify({
        "status": "operational",
        "version": "1.0-kali-pro",
        "timestamp": datetime.now().isoformat(),
        "storage_path": str(CHAT_HISTORY_FILE),
        "storage_available": CHAT_HISTORY_FILE.parent.exists()
    })

@app.route('/api/history', methods=['GET'])
def get_history():
    """Retrieve chat history from file storage"""
    try:
        history = load_chat_history()
        logger.info(f"Retrieved {len(history)} messages from storage")
        return jsonify({
            "success": True,
            "history": history,
            "count": len(history),
            "storage_location": str(CHAT_HISTORY_FILE)
        })
    except Exception as e:
        logger.error(f"Error retrieving history: {e}")
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/history/clear', methods=['POST'])
def clear_history():
    """Clear all chat history"""
    try:
        if clear_chat_history():
            return jsonify({"success": True, "message": "Chat history cleared"})
        else:
            return jsonify({"success": False, "error": "Failed to clear history"}), 500
    except Exception as e:
        logger.error(f"Error clearing history: {e}")
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/history/export', methods=['GET'])
def export_history():
    """Export chat history in requested format"""
    try:
        format_type = request.args.get('format', 'json')
        export_data = export_chat_history(format_type)
        
        if export_data is None:
            return jsonify({"success": False, "error": "Export failed"}), 500
        
        logger.info(f"Chat history exported as {format_type}")
        
        if format_type == 'txt':
            return export_data, 200, {'Content-Disposition': 'attachment; filename=cloneman_history.txt'}
        else:
            return jsonify({"success": True, "data": export_data})
    except Exception as e:
        logger.error(f"Error exporting history: {e}")
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/api/history/save', methods=['POST'])
def save_history():
    """Explicitly save chat history (for manual backups)"""
    try:
        data = request.json
        history = data.get('history', [])
        
        if save_chat_history(history):
            return jsonify({"success": True, "message": "History saved successfully"})
        else:
            return jsonify({"success": False, "error": "Failed to save history"}), 500
    except Exception as e:
        logger.error(f"Error saving history: {e}")
        return jsonify({"success": False, "error": str(e)}), 500

@app.route('/')
def index():
    logger.info("User accessing main interface")
    return render_template('index.html')

@app.route('/api/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        user_messages = data.get('messages', [])
        
        if not user_messages:
            logger.warning("Empty message received")
            return jsonify({"error": "No messages provided"}), 400

        # Prepend the system prompt to the conversation history
        messages = [SYSTEM_PROMPT] + user_messages
        logger.info(f"Processing chat request with {len(user_messages)} user messages")

        headers = {
            "Authorization": f"Bearer {OPENROUTER_API_KEY}",
            "Content-Type": "application/json",
            "HTTP-Referer": "http://localhost:5000",
            "X-Title": "CLONEMAN-KaliLinux-Pro"
        }

        payload = {
            "model": "openrouter/free", 
            "messages": messages
        }
        
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=payload,
            timeout=30
        )
        response.raise_for_status()
        logger.info("API request successful")
        
        # Save conversation to file storage
        save_chat_history(user_messages)
        
        return jsonify(response.json())
        
    except requests.exceptions.Timeout:
        logger.error("API request timeout")
        return jsonify({"error": "Request timeout. Try again."}), 504
    except requests.exceptions.RequestException as e:
        logger.error(f"API request failed: {str(e)}")
        return jsonify({"error": str(e), "details": response.text if response else ""}), 500
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return jsonify({"error": "Internal server error"}), 500

if __name__ == '__main__':
    # Banner for Kali Linux
    banner = """
    ╔═══════════════════════════════════════════════════════════╗
    ║      🛡️  CLONEMAN - Cybersecurity AI Assistant  🛡️      ║
    ║        Powered by Kali Linux & OpenRouter (PRO)           ║
    ║               v1.0 - Desktop Application                 ║
    ╚═══════════════════════════════════════════════════════════╝
    """
    print(banner)
    logger.info("=" * 60)
    logger.info("CLONEMAN Starting - Cybersecurity AI Assistant")
    logger.info(f"Environment: Kali Linux - Desktop Application")
    logger.info(f"Start Time: {datetime.now()}")
    logger.info(f"Access at: http://127.0.0.1:5000")
    logger.info(f"Status Check: http://127.0.0.1:5000/api/status")
    logger.info(f"Chat History Storage: {CHAT_HISTORY_FILE}")
    logger.info(f"Application Logs: /tmp/cloneman.log")
    logger.info("=" * 60)
    
    # Running locally only - Kali Linux loopback
    app.run(host='127.0.0.1', port=5000, debug=False)

