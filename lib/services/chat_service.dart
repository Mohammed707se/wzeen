// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatService {
  static const String apiKey = '';
  static const String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(List<ChatMessage> messages) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messages.map((msg) => msg.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('فشل في الاتصال بالخدمة');
      }
    } catch (e) {
      throw Exception('حدث خطأ: $e');
    }
  }
}
