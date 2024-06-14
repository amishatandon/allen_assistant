import 'dart:convert';

import 'package:allen_assistant/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIAPIKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo-16k",
            "messages": [
              {
                'role': 'user',
                'content':
                    'Does ths message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
              }
            ],
          }));
      if (res.statusCode == 200) {
        final responseJson = jsonDecode(res.body);
        final message = responseJson['choices'][0]['message']['content'].trim();
        switch (message) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    return 'CHATGPT';
  }

  Future<String> dallEAPI(String prompt) async {
    return 'DALL-E';
  }
}
