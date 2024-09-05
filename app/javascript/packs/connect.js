// // Import ActionCable from the @rails/actioncable package
// import { createConsumer } from "@rails/actioncable";

// // Create a consumer and assign it globally to the window object
// window.ActionCable = createConsumer();

// document.addEventListener("DOMContentLoaded", function () {

//     // Use ActionCable to create a subscription to the LogChannel
//     const cable = window.ActionCable;

//     cable.subscriptions.create("LogChannel", {
//         received(data) {
//             const logContainer = document.getElementById("log-container");
//             const logMessage = document.createElement("p");
//             logMessage.textContent = data.message;

//             // Add this to make the text align to the left
//             logMessage.style.textAlign = "left";

//             logContainer.appendChild(logMessage);
//             logContainer.scrollTop = logContainer.scrollHeight; // Automatically scroll to the bottom
//         },
//     });
// });

