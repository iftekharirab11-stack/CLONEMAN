import os
import requests
from flask import Flask, request, jsonify, render_template
from dotenv import load_dotenv

# Initialize environment and app
load_dotenv()
app = Flask(__name__)

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
if not OPENROUTER_API_KEY:
    raise ValueError("Missing OPENROUTER_API_KEY in .env file.")

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

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/chat', methods=['POST'])
def chat():
    data = request.json
    user_messages = data.get('messages', [])

    # Prepend the system prompt to the conversation history
    messages = [SYSTEM_PROMPT] + user_messages

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "http://localhost:5000",
        "X-Title": "CyberSec Local AI"
    }

    payload = {
        "model": "openai/gpt-4o", # High-tier multimodal model
        "messages": messages
    }

    try:
        response = requests.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers=headers,
            json=payload
        )
        response.raise_for_status()
        return jsonify(response.json())
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e), "details": response.text if response else ""}), 500

if __name__ == '__main__':
    # Running locally only. 
    app.run(host='127.0.0.1', port=5000, debug=True)

