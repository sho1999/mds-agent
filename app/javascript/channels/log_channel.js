import consumer from "./consumer"

consumer.subscriptions.create("LogChannel", {
  connected() {
    console.log("Connected to the LogChannel")
  },

  disconnected() {
    console.log("Disconnected from the LogChannel")
  },

  received(data) {
    const logContainer = document.getElementById('log-container')
    logContainer.innerHTML += `<p>${data.message}</p>`;
    logContainer.scrollTop = logContainer.scrollHeight; // 自動的にスクロール
  }
});
