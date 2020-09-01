import consumer from "./consumer";
// import { scrollLastMessageIntoView } from "./scroll";

const initChatroomCable = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId;

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        messagesContainer.insertAdjacentHTML('beforeend', data);

        const inputMessage = document.getElementById('message_content');
        inputMessage.value = "";
        // scrollLastMessageIntoView();
      },
    });
  }
}

export { initChatroomCable };
