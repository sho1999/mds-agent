
import ActionCable from '@rails/actioncable';

console.log("ahhh");

document.addEventListener("DOMContentLoaded", function () {
    console.log("hiii");

    const cable = ActionCable.createConsumer();

    cable.subscriptions.create("LogChannel", {
        received(data) {
            console.log(data);
            const logContainer = document.getElementById("log-container");
            const logMessage = document.createElement("p");
            logMessage.textContent = data.message;
            logContainer.appendChild(logMessage);
            logContainer.scrollTop = logContainer.scrollHeight; // 自動でスクロール
        },
    });
});