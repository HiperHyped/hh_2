import 'package:flutter/material.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIPhoto extends StatefulWidget {
  final File image;

  AIPhoto({required this.image}) {LogService.init();}

  @override
  _AIPhotoState createState() => _AIPhotoState();
}

class _AIPhotoState extends State<AIPhoto> {
  late Future<Map<String, dynamic>> _response;

  @override
  void initState() {
    super.initState();
    _response = analyzeImage(widget.image);
  }

  Future<Map<String, dynamic>> analyzeImage(File image) async {
    const apiKey = "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";
    //const assistantId = 'asst_44H2MSuSxxEloH60cR2Xwd7i'; //PhotoProd_v1 com gpt-4o

    const assistantId = "asst_9Qz6mjZbvu2pezAV4fuvjyYp"; //PhotoProd_v0 com gpt-4-turbo
    const organizationId = "org-2YkkE6qieHaCmPXsYoFecOsw";

    try {
      print("Uploading image...");

      // Faz o upload da imagem
      var uploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/files'),
      )
        ..headers['Authorization'] = 'Bearer $apiKey'
        ..headers['OpenAI-Organization'] = organizationId
        ..headers['OpenAI-Beta'] = 'assistants=v1' // 'assistants=v2' // Para o caso de PhotoProd_v1 IDK
        ..fields['purpose'] = 'assistants'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      var uploadResponse = await uploadRequest.send();
      if (uploadResponse.statusCode != 200) {
        var responseBody = await uploadResponse.stream.bytesToString();
        print("Failed to upload image: $responseBody");
        throw Exception('Failed to upload image: $responseBody');
      }

      var uploadResponseBody = await http.Response.fromStream(uploadResponse);
      var uploadedFile = json.decode(uploadResponseBody.body);
      print("Image uploaded successfully: $uploadedFile");

      // Cria o prompt para o assistant
      var messages = [
        {
          'role': 'system',
          'content': ""  //"Você vai receber uma imagem e deve identificar os produtos nela."
        },
        {
          'role': 'user',
          'content': "",  //Analyze this image.",
          'attachment': {'type': 'image', 'file': uploadedFile['id']}
        }
      ];

      print("Sending request to assistant...");
      print("Messages: $messages");

      // Faz a chamada ao assistente
      var assistantResponse = await _postWithRedirect(
        'https://api.openai.com/v1/assistants/$assistantId/',
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Organization': organizationId,
          'OpenAI-Beta': "assistants=v1", // 'assistants=v2' // Para o caso de PhotoProd_v1 IDK
          'Content-Type': 'application/json'
        },
        body: json.encode({'messages': messages}),
      );

      if (assistantResponse.statusCode != 200) {
        print("Failed to analyze image: ${assistantResponse.body}");
        throw Exception('Failed to analyze image: ${assistantResponse.body}');
      }

      var responseData = json.decode(assistantResponse.body);
      print("Assistant response: $responseData");

      return responseData;
    } catch (e) {
      print("Error in analyzeImage: $e");
      throw Exception("Error in analyzeImage: $e");
    }
  }

  Future<http.Response> _postWithRedirect(String url, {Map<String, String>? headers, dynamic body}) async {
    var response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 307) {
      var redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        print("Redirecting to $redirectUrl");
        response = await http.post(Uri.parse(redirectUrl), headers: headers, body: body);
      } else {
        throw Exception('Redirect without Location header');
      }
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Análise')),
      body: Column(
        children: [
          // Exibe a imagem primeiro
          Container(
            height: 300, // Ajuste o tamanho conforme necessário
            child: Image.file(widget.image),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _response,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data['choices'].length,
                    itemBuilder: (context, index) {
                      final product = data['choices'][index]['text'];
                      return ListTile(
                        title: Text(product),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
