import 'package:flutter/material.dart';
import 'package:healthify/chat/model/chat_message_model.dart';
import 'package:healthify/core/theme/pallete.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatBubble({super.key, required this.chatMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          chatMessage.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: chatMessage.isUser ? Pallete.gradient1 : Pallete.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: chatMessage.isUser
                ? const Radius.circular(15)
                : const Radius.circular(0),
            bottomRight: chatMessage.isUser
                ? const Radius.circular(0)
                : const Radius.circular(15),
          ),
        ),
        child: Text(
          chatMessage.message,
          style: const TextStyle(color: Pallete.whiteColor),
        ),
      ),
    );
  }
}
