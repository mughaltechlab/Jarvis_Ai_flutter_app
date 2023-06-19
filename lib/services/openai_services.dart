import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jarvis/secrets/secret.dart';

class OpenAiServices {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptApi(String prompt) async {
    try {
      // url
      Uri uri = Uri.parse('https://api.openai.com/v1/chat/completions');

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.",
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim(); //it will remove spaces that content have.

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
          case 'YES':
          case 'YES.':
            final res = await dallEApi(prompt);
            return res;

          default:
            final res = await chatGptApi(prompt);
            return res;
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGptApi(String prompt) async {
    // storing messages whatever user say
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      // url
      Uri uri = Uri.parse('https://api.openai.com/v1/chat/completions');

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim(); //it will remove spaces that content have.

        // storing chatgpt messages
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

  Future<String> dallEApi(String prompt) async {
    // storing messages whatever user say
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      // url
      Uri uri = Uri.parse('https://api.openai.com/v1/images/generations');

      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey'
        },
        body: jsonEncode({
          "prompt": prompt,
          'n': 1, //number of images
        }),
      );

      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim(); //it will remove spaces that content have.

        // storing chatgpt messages
        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
