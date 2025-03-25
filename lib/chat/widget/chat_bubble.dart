// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:healthify/chat/model/chat_message_model.dart';
// import 'package:healthify/core/theme/pallete.dart';

// class ChatBubble extends StatelessWidget {
//   final ChatMessage chatMessage;

//   const ChatBubble({super.key, required this.chatMessage});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment:
//           chatMessage.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         onLongPress: () {
//           Clipboard.setData(ClipboardData(text: chatMessage.message));
//           Fluttertoast.showToast(
//               msg: "This is Center Short Toast",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0);
//           Fluttertoast.showToast(
//               msg: "Copied to clipboard",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.red,
//               textColor: Colors.white,
//               fontSize: 16.0);
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.75,
//           ),
//           decoration: BoxDecoration(
//             color: chatMessage.isUser ? Pallete.gradient1 : Pallete.cardColor,
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(15),
//               topRight: const Radius.circular(15),
//               bottomLeft: chatMessage.isUser
//                   ? const Radius.circular(15)
//                   : const Radius.circular(0),
//               bottomRight: chatMessage.isUser
//                   ? const Radius.circular(0)
//                   : const Radius.circular(15),
//             ),
//           ),
//           child: Text(
//             chatMessage.message,
//             style: const TextStyle(color: Pallete.whiteColor),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthify/chat/model/chat_message_model.dart';
import 'package:healthify/core/theme/pallete.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  const ChatBubble({super.key, required this.chatMessage});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Align(
          alignment:
              widget.chatMessage.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: widget.chatMessage.message));
              Fluttertoast.showToast(
                msg: "Copied to clipboard",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: widget.chatMessage.isUser ? Pallete.gradient1 : Pallete.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: widget.chatMessage.isUser
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: widget.chatMessage.isUser
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                ),
              ),
              child: Text(
                widget.chatMessage.message,
                style: const TextStyle(color: Pallete.whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
