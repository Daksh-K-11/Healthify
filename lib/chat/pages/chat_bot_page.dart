// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:healthify/chat/providers/chat_providers.dart';
// import 'package:healthify/chat/widget/chat_bubble.dart';
// import 'package:healthify/core/theme/pallete.dart';

// class ChatBotPage extends ConsumerStatefulWidget {
//   const ChatBotPage({super.key});

//   @override
//   ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
// }

// class _ChatBotPageState extends ConsumerState<ChatBotPage> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//     await ref.read(chatProvider.notifier).sendMessage(text.trim());
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messages = ref.watch(chatProvider);
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               return ChatBubble(chatMessage: messages[index]);
//             },
//           ),
//         ),
//         const Divider(height: 1),
//         Container(
//           color: Theme.of(context).cardColor,
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: "Ask a question...",
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 15,
//                       horizontal: 20,
//                     ),
//                   ),
//                   onSubmitted: (text) => _sendMessage(text),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 backgroundColor: Pallete.gradient1,
//                 child: IconButton(
//                   icon: const Icon(Icons.send, color: Colors.white),
//                   onPressed: () => _sendMessage(_controller.text),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/chat/providers/chat_providers.dart';
import 'package:healthify/chat/widget/chat_bubble.dart';
import 'package:healthify/core/theme/pallete.dart';

class ChatBotPage extends ConsumerStatefulWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    await ref.read(chatProvider.notifier).sendMessage(text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatBubble(chatMessage: messages[index]);
            },
          ),
        ),
        const Divider(height: 1),
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: FadeInUp(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask a question...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Pallete.gradient1,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
