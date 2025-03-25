import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatBotPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Chat Bot"),
    );
  }
}
