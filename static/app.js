const chatBox = document.getElementById('chat-box');
const inputField = document.getElementById('chat-input');
const imageInput = document.getElementById('image-input');
const sendBtn = document.getElementById('send-btn');
const clearBtn = document.getElementById('clear-btn');
const fileLabel = document.querySelector('.file-label');
const statusIndicator = document.getElementById('status-indicator');
const historyBtn = document.getElementById('history-btn');
const statusText = document.getElementById('status-text');

// Load history from browser local storage + server file storage
let chatHistory = JSON.parse(localStorage.getItem('cybersec_chat_history')) || [];
let serverStorageAvailable = false;

// ============= STORAGE MANAGEMENT =============

function saveHistoryLocal() {
    localStorage.setItem('cybersec_chat_history', JSON.stringify(chatHistory));
}

function saveHistoryToServer() {
    // Also save to server file storage
    fetch('/api/history/save', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ history: chatHistory })
    }).catch(err => console.warn('Server history save failed:', err));
}

function saveHistory() {
    saveHistoryLocal();
    saveHistoryToServer();
}

async function loadHistoryFromServer() {
    try {
        const response = await fetch('/api/history');
        if (response.ok) {
            const data = await response.json();
            if (data.success && data.history && data.history.length > 0) {
                console.log(`Loaded ${data.count} messages from server storage`);
                // Merge server history with local if different
                if (data.history.length > chatHistory.length) {
                    chatHistory = data.history;
                    saveHistoryLocal();
                }
                serverStorageAvailable = true;
            }
        }
    } catch (err) {
        console.warn('Could not load server history:', err);
    }
}

// ============= SERVER STATUS CHECK =============

async function checkServerStatus() {
    try {
        const response = await fetch('/api/status');
        if (response.ok) {
            const status = await response.json();
            statusIndicator.classList.add('connected');
            statusIndicator.style.backgroundColor = '#33ff33';
            statusText.textContent = 'Connected';
            statusText.style.color = '#33ff33';
            console.log('Server status: OK', status);
            
            // Try to load history from server
            await loadHistoryFromServer();
        } else {
            statusIndicator.classList.remove('connected');
            statusIndicator.style.backgroundColor = '#ff3333';
            statusText.textContent = 'Disconnected';
            statusText.style.color = '#ff3333';
        }
    } catch (err) {
        statusIndicator.classList.remove('connected');
        statusIndicator.style.backgroundColor = '#ff3333';
        statusText.textContent = 'Error';
        statusText.style.color = '#ff3333';
        console.warn('Server status check failed');
    }
}

// ============= CHAT RENDERING =============

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

// ============= IMAGE HANDLING =============

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

// ============= MESSAGE SENDING =============

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
        
        if (response.ok && data.choices && data.choices.length > 0) {
            const aiMsg = data.choices[0].message;
            chatHistory.push(aiMsg);
            saveHistory();
            renderChat();
        } else if (data.error) {
            const errorMsg = {
                role: 'assistant',
                content: `[ERROR] ${data.error}\n\nMake sure:\n- API key is valid in .env\n- Internet connection is active\n- OpenRouter service is available`
            };
            chatHistory.push(errorMsg);
            saveHistory();
            renderChat();
            console.error("API Error", data);
        } else {
            alert("Execution failed. Check console logs.");
            console.error("Unexpected response:", data);
        }
    } catch (err) {
        const errorMsg = {
            role: 'assistant',
            content: `[NETWORK ERROR] ${err.message}\n\nCheck:\n- Server is running\n- Network connection\n- Browser console for details`
        };
        chatHistory.push(errorMsg);
        saveHistory();
        renderChat();
        console.error("Network Error", err);
    } finally {
        sendBtn.disabled = false;
        sendBtn.textContent = "Execute";
    }
}

// ============= HISTORY MANAGEMENT =============

function exportHistory() {
    const dataStr = JSON.stringify(chatHistory, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(dataBlob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `cloneman_history_${new Date().getTime()}.json`;
    link.click();
    console.log('History exported to file');
}

clearBtn.addEventListener('click', () => {
    if(confirm("Purge local chat data? This cannot be undone.")) {
        // Clear from server
        fetch('/api/history/clear', { method: 'POST' })
            .then(r => r.json())
            .then(d => console.log('Server history cleared:', d))
            .catch(err => console.warn('Server clear failed:', err));
        
        // Clear from local storage
        localStorage.removeItem('cybersec_chat_history');
        chatHistory = [];
        renderChat();
        console.log('Local history cleared');
    }
});

// ============= EVENT LISTENERS =============

sendBtn.addEventListener('click', sendMessage);
inputField.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage();
});

if (historyBtn) {
    historyBtn.addEventListener('click', exportHistory);
}

// ============= INITIALIZATION =============

// Initial render and status check
renderChat();
checkServerStatus();

// Periodically sync with server (every 30 seconds)
setInterval(() => {
    if (serverStorageAvailable && chatHistory.length > 0) {
        saveHistoryToServer();
    }
}, 30000);

// Save history before leaving page
window.addEventListener('beforeunload', () => {
    saveHistory();
});

console.log('CLONEMAN Chat Application Loaded');
console.log('Storage: Local browser + Server file-based');
console.log('History auto-saves every 30 seconds');
