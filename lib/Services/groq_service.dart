import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  final String apiKey =
      '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';
  final String endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getChatResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama3-8b-8192", // or "llama3-70b-8192"
        "messages": [
          {"role": "user", "content": userMessage}
        ],
        "temperature": 0.7
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch response: ${response.body}');
    }
  }
}
