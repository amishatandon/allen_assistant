import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:allen_assistant/secrets.dart';

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
                  'Does this message want to generate an AI picture, image, art, or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        }),
      );

      if (res.statusCode == 200) {
        final responseJson = jsonDecode(res.body);
        final message = responseJson['choices'][0]['message']['content'].trim();

        switch (message.toLowerCase()) {
          case 'yes':
            return await dallEAPI(prompt);
          default:
            return await chatGPTAPI(prompt);
        }
      }

      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    List<Map<String, String>> messages = []; // Initialize messages list locally

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
              'content': prompt,
            }
          ],
        }),
      );

      if (res.statusCode == 200) {
        final responseJson = jsonDecode(res.body);
        final message = responseJson['choices'][0]['message']['content'];
        final content = message.trim();

        messages.add({
          'role': 'user',
          'content': prompt,
        });

        messages.add({
          'role': 'assistant',
          'content': content,
        });

        return content;
      }

      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    return 'DALL-E';
  }
}
