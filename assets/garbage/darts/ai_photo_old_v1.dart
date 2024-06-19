/*import 'package:flutter/material.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIPhoto extends StatefulWidget {
  final File image;

  AIPhoto({required this.image}) {
    LogService.init();
  }

  @override
  _AIPhotoState createState() => _AIPhotoState();
}

class _AIPhotoState extends State<AIPhoto> {
  late Future<List<dynamic>> _response;

  @override
  void initState() {
    super.initState();
    _response = analyzeImage(widget.image);
  }

  Future<List<dynamic>> analyzeImage(File image) async {
    const apiKey = "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";
    const organizationId = "org-2YkkE6qieHaCmPXsYoFecOsw";
    const assistantId = "asst_9Qz6mjZbvu2pezAV4fuvjyYp";

    try {
      print("Uploading image...");

      // Faz o upload da imagem
      var uploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/files'),
      )
        ..headers['Authorization'] = 'Bearer $apiKey'
        ..headers['OpenAI-Organization'] = organizationId
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

      // Cria a thread com a mensagem inicial
      var threadResponse = await http.post(
        Uri.parse('https://api.openai.com/v1/assistants/$assistantId/threads'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Organization': organizationId,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'messages': [
            {'role': 'user', 'content': 'Analyze this image.'}
          ],
          'files': [uploadedFile['id']]
        }),
      );

      if (threadResponse.statusCode != 201) {
        print("Failed to create thread: ${threadResponse.body}");
        throw Exception('Failed to create thread: ${threadResponse.body}');
      }

      var threadData = json.decode(threadResponse.body);
      var threadId = threadData['id'];
      print("Thread created successfully: $threadData");

      // Cria a execução
      var runResponse = await http.post(
        Uri.parse('https://api.openai.com/v1/assistants/$assistantId/threads/$threadId/runs'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Organization': organizationId,
          'Content-Type': 'application/json'
        },
        body: json.encode({}),
      );

      if (runResponse.statusCode != 201) {
        print("Failed to create run: ${runResponse.body}");
        throw Exception('Failed to create run: ${runResponse.body}');
      }

      var runData = json.decode(runResponse.body);
      var runId = runData['id'];
      print("Run created successfully: $runData");

      // Polling até a execução ser concluída
      var runStatus = runData['status'];
      while (runStatus != 'completed' && runStatus != 'failed') {
        await Future.delayed(const Duration(seconds: 5)); // Aguarda 5 segundos antes de checar novamente

        var runStatusResponse = await http.get(
          Uri.parse('https://api.openai.com/v1/assistants/$assistantId/threads/$threadId/runs/$runId'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'OpenAI-Organization': organizationId,
          },
        );

        if (runStatusResponse.statusCode != 200) {
          print("Failed to retrieve run status: ${runStatusResponse.body}");
          throw Exception('Failed to retrieve run status: ${runStatusResponse.body}');
        }

        runData = json.decode(runStatusResponse.body);
        runStatus = runData['status'];
      }

      if (runStatus != 'completed') {
        throw Exception('Run did not complete successfully: $runStatus');
      }

      // Obtém as mensagens da thread após a execução
      var messagesResponse = await http.get(
        Uri.parse('https://api.openai.com/v1/assistants/$assistantId/threads/$threadId/messages'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Organization': organizationId,
        },
      );

      if (messagesResponse.statusCode != 200) {
        print("Failed to retrieve messages: ${messagesResponse.body}");
        throw Exception('Failed to retrieve messages: ${messagesResponse.body}');
      }

      var messagesData = json.decode(messagesResponse.body);
      print("Assistant response: ${messagesData['messages']}");
      return messagesData['messages'];
    } catch (e) {
      print("Error in analyzeImage: $e");
      throw Exception("Error in analyzeImage: $e");
    }
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
            child: FutureBuilder<List<dynamic>>(
              future: _response,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index]['content'];
                      return ListTile(
                        title: Text(message),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Nenhuma mensagem encontrada.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/