const chatBox = document.getElementById('chat-box');
const inputField = document.getElementById('chat-input');
const imageInput = document.getElementById('image-input');
const sendBtn = document.getElementById('send-btn');
const clearBtn = document.getElementById('clear-btn');
const fileLabel = document.querySelector('.file-label');

// Load history from browser local storage to prevent cloud data leakage
let chatHistory = JSON.parse(localStorage.getItem('cybersec_chat_history')) || [];

function saveHistory() {
    localStorage.setItem('cybersec_chat_history', JSON.stringify(chatHistory));
}

function renderChat() {
    chatBox.innerHTML = '';
    chatHistory.forEach(msg => {
        if (msg.role === 'system') return; // Hide system prompt from UI
        
        const div = document.createElement('div');
        div.className = `message ${msg.role}`;
        
        // Handle multimodal content structure vs standard text
        let text = "";
        if (Array.isArray(msg.content)) {
            text = msg.content.find(c => c.type === 'text')?.text || "[Image Processed]";
        } else {
            text = msg.content;
        }
        
        // Use textContent to prevent XSS injection via chat
        div.textContent = text;
        chatBox.appendChild(div);
    });
    chatBox.scrollTop = chatBox.scrollHeight;
}

// Convert image to Base64 for OpenRouter Vision API
async function getBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
    });
}

// Update UI when file is selected
imageInput.addEventListener('change', () => {
    if (imageInput.files.length > 0) {
        fileLabel.textContent = `[1] ${imageInput.files[0].name.substring(0, 10)}...`;
        fileLabel.style.color = "var(--accent)";
    } else {
        fileLabel.textContent = "[+] Image";
        fileLabel.style.color = "inherit";
    }
});

async function sendMessage() {
    const text = inputField.value.trim();
    const file = imageInput.files[0];

    if (!text && !file) return;

    let messageContent = [];

    // OpenRouter multimodal formatting
    if (text) {
        messageContent.push({ type: "text", text: text });
    } else if (file) {
        messageContent.push({ type: "text", text: "Analyze this image for security implications." });
    }

    if (file) {
        const base64Image = await getBase64(file);
        messageContent.push({
            type: "image_url",
            image_url: { url: base64Image }
        });
    }

    const userMsg = { role: "user", content: messageContent };
    chatHistory.push(userMsg);
    renderChat();

    // Reset inputs
    inputField.value = '';
    imageInput.value = '';
    fileLabel.textContent = "[+] Image";
    fileLabel.style.color = "inherit";

    // Disable input while processing
    sendBtn.disabled = true;
    sendBtn.textContent = "Processing...";

    try {
        const response = await fetch('/api/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ messages: chatHistory })
        });

        const data = await response.json();
        
        if (data.choices && data.choices.length > 0) {
            const aiMsg = data.choices[0].message;
            chatHistory.push(aiMsg);
            saveHistory();
            renderChat();
        } else {
            console.error("API Error", data);
            alert("Execution failed. Check console logs.");
        }
    } catch (err) {
        console.error("Network Error", err);
    } finally {
        sendBtn.disabled = false;
        sendBtn.textContent = "Execute";
    }
}

clearBtn.addEventListener('click', () => {
    if(confirm("Purge local chat data?")) {
        localStorage.removeItem('cybersec_chat_history');
        chatHistory = [];
        renderChat();
    }
});

sendBtn.addEventListener('click', sendMessage);
inputField.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage();
});

// Initial render
renderChat();
