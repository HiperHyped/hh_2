/*import 'package:http/http.dart' as http;
import 'dart:convert';


///NOT USED
class APIAIService {
  final String _apiUrl = 'https://api.openai.com/v1/engines/gpt-3.5-turbo/completions';
  final String _apiKey ="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";


   //openai.organization = "org-2YkkE6qieHaCmPXsYoFecOsw"

  APIAIService();

  Future<String> generateText(String prompt, int maxTokens) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    var body = json.encode({
      'prompt': prompt,
      'max_tokens': maxTokens,
    });

    var response = await http.post(_apiUrl as Uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      print('Erro ao fazer a requisição: ${response.statusCode}');
      return "";
    }
  }
}
*/