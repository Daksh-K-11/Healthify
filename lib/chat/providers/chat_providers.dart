import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthify/chat/model/chat_message_model.dart';
import 'package:healthify/core/constant.dart';
import 'package:http/http.dart' as http;

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  Future<void> sendMessage(String question) async {
    
    state = [...state, ChatMessage(message: question, isUser: true)];

    final url = Uri.parse("$baseUrl/auth/health-chat/");
    try {
      final response = await http.post(
        url,
        headers: headersForAuth,
        body: jsonEncode({"question": question}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['health_report'] ?? "No answer available.";
        state = [...state, ChatMessage(message: answer, isUser: false)];
      } else {
        state = [
          ...state,
          ChatMessage(message: "Error: ${response.statusCode}", isUser: false)
        ];
      }
    } catch (e) {
      state = [...state, ChatMessage(message: "Error: $e", isUser: false)];
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});
