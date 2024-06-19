import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:hh_2/src/config/ai/ai_xerxes.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:hh_2/src/config/log/log_service.dart';

const apiKey = "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";
const organizationId = "org-2YkkE6qieHaCmPXsYoFecOsw";
const assistantId = "asst_9Qz6mjZbvu2pezAV4fuvjyYp";

class AIFunctions {
  static void initLog() {
    LogService.init();
  }

  static Future<String> uploadImage(File image) async {
    print("Uploading image...");

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

    return uploadedFile['id'];
  }

  static Future<String> uploadImageBytes(Uint8List imageBytes) async {
    print("Uploading image...");

    var uploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.openai.com/v1/files'),
    )
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..headers['OpenAI-Organization'] = organizationId
      ..fields['purpose'] = 'assistants'
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

    var uploadResponse = await uploadRequest.send();
    if (uploadResponse.statusCode != 200) {
      var responseBody = await uploadResponse.stream.bytesToString();
      
      print("Failed to upload image: $responseBody");
      throw Exception('Failed to upload image: $responseBody');
    }

    var uploadResponseBody = await http.Response.fromStream(uploadResponse);
    var uploadedFile = json.decode(uploadResponseBody.body);
    print("Image uploaded successfully: $uploadedFile");

    return uploadedFile['id'];
  }

  static Future<String> createThread() async {
    var threadResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/threads'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Beta': 'assistants=v2',
        'OpenAI-Organization': organizationId,
        'Content-Type': 'application/json'
      },
      body: json.encode({}),
    );

    if (threadResponse.statusCode != 200) {
      print("THREAD: ${threadResponse.statusCode}, ${threadResponse.request}");
      print("Failed to create thread: ${threadResponse.body}");
      throw Exception('Failed to create thread: ${threadResponse.body}');
    }

    var threadData = json.decode(threadResponse.body);
    print("Thread created successfully: $threadData");

    return threadData['id'];
  }

  static Future<String> createMessage(String threadId, String fileId) async {
    var messageResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/threads/$threadId/messages'), 
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': organizationId,
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'messages': [
          {'role': 'user', 'content': 'Analyze this image.', 'files': [fileId]}
        ]
      }),
    );

    if (messageResponse.statusCode != 201) {
      print("Failed to create message: ${messageResponse.body}");
      throw Exception('Failed to create message: ${messageResponse.body}');
    }

    var messageData = json.decode(messageResponse.body);
    print("Message created successfully: $messageData");

    return messageData['id'];
  }

  static Future<String> createRun(String threadId, String messageId) async {
    var runResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/assistants/$assistantId/threads/$threadId/runs'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': organizationId,
        'Content-Type': 'application/json'
      },
      body: json.encode({'message_id': messageId}),
    );

    if (runResponse.statusCode != 200) {
      print("Failed to create run: ${runResponse.body}");
      throw Exception('Failed to create run: ${runResponse.body}');
    }

    var runData = json.decode(runResponse.body);
    print("Run created successfully: $runData");

    return runData['id'];
  }

  static Future<Map<String, String>> createThreadAndRun(String fileId) async {
    var runResponse = await http.post(
      Uri.parse('https://api.openai.com/v1/threads/runs'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': organizationId,
        'Content-Type': 'application/json',
        'OpenAI-Beta': 'assistants=v2'
      },
      body: json.encode({
        'assistant_id': assistantId,
        'thread': {
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Analyze this image.'
                },
                {
                  'type': 'image_file',
                  'image_file': {
                    'file_id': fileId,
                    'detail': 'high'
                  }
                }
              ]
            }
          ]
        }
      }),
    );

    if (runResponse.statusCode != 200) {
      print("Failed to create thread and run: ${runResponse.body}");
      throw Exception('Failed to create thread and run: ${runResponse.body}');
    }

    var runData = json.decode(runResponse.body);
    //print("Thread and run created successfully: $runData");

    return {
      'thread_id': runData['thread_id'],
      'run_id': runData['id'],
    };
  }



  static Future<void> pollRunStatus(String threadId, String runId) async {
    String runStatus;
    int count = 0;
    int maxAttempts = 20; // Defina um número máximo de tentativas para evitar loops infinitos

    do {
      await Future.delayed(const Duration(seconds: 3));

      var runStatusResponse = await http.get(
        Uri.parse('https://api.openai.com/v1/threads/$threadId/runs/$runId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'OpenAI-Organization': organizationId,
          'OpenAI-Beta': 'assistants=v2'
        },
      );

      if (runStatusResponse.statusCode != 200) {
        print("Failed to retrieve run status: ${runStatusResponse.body}");
        throw Exception('Failed to retrieve run status: ${runStatusResponse.body}');
      }

      var runData = json.decode(runStatusResponse.body);
      print("COUNT: $count: ${runData['status']}");
      count++;
      runStatus = runData['status'];

      if (count >= maxAttempts) {
        throw Exception('Run status polling exceeded maximum attempts');
      }
    } while (runStatus != 'completed' && runStatus != 'failed');

    print("FIM DA RUN: $runStatus");

    if (runStatus != 'completed') {
      throw Exception('Run did not complete successfully: $runStatus');
    }
  }

  
  /*static Future<String> fetchMessages(String threadId, String runId) async {
    var messagesResponse = await http.get(
      Uri.parse('https://api.openai.com/v1/threads/$threadId/messages'), 
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': organizationId,
        'OpenAI-Beta': 'assistants=v2'
      },
    );


    if (messagesResponse.statusCode != 200) {
      print("Failed to retrieve messages: ${messagesResponse.body}");
      throw Exception('Failed to retrieve messages: ${messagesResponse.body}');
    }

    var messagesData = json.decode(utf8.decode(messagesResponse.bodyBytes));
    
    print("Assistant response: ${messagesData}");
 

    return messagesData;
  }*/

static Future<List<SearchModel>> fetchMessages(String threadId, String runId) async {
    var messagesResponse = await http.get(
      Uri.parse('https://api.openai.com/v1/threads/$threadId/messages'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'OpenAI-Organization': organizationId,
        'OpenAI-Beta': 'assistants=v2'
      },
    );

    if (messagesResponse.statusCode != 200) {
      print("Failed to retrieve messages: ${messagesResponse.body}");
      throw Exception('Failed to retrieve messages: ${messagesResponse.body}');
    }

    var messagesData = json.decode(utf8.decode(messagesResponse.bodyBytes));
    //print("Assistant response: ${messagesData}");

    // Processar as mensagens para criar uma lista de SearchModel
    List<SearchModel> searchProductList = [];
    for (var message in messagesData['data']) {
      if (message['role'] == 'assistant' && message['content'] is List) {
        for (var content in message['content']) {
          if (content['type'] == 'text') {
            var textValue = content['text']['value'];
            var productData = json.decode(textValue);
            print("PRODUCT DATA: \n ${productData['Produtos']}");
            for (var product in productData['Produtos']) {
              print("PRODUCT: $product");
              searchProductList.add(SearchModel(
                searchType: 'product',
                nome: product['Produto'] ?? '', // Verificação de nulo
                marca: product['Marca'] ?? '', // Verificação de nulo
                volume: product['Quantidade'] ?? '', // Verificação de nulo
                unidade: product['Unidade'] ?? '', // Verificação de nulo
              ));
            }
          }
        }
      }
    }
    print("FIM DO FETCH!!");
    return searchProductList;
  }


static Future<List<SearchModel>> fetchMessagesV2(String threadId, String runId) async {
  var messagesResponse = await http.get(
    Uri.parse('https://api.openai.com/v1/threads/$threadId/messages'),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'OpenAI-Organization': organizationId,
      'OpenAI-Beta': 'assistants=v2'
    },
  );

  if (messagesResponse.statusCode != 200) {
    print("Failed to retrieve messages: ${messagesResponse.body}");
    throw Exception('Failed to retrieve messages: ${messagesResponse.body}');
  }

  var messagesData = json.decode(utf8.decode(messagesResponse.bodyBytes));

  // Processar as mensagens para criar uma lista de SearchModel
  List<SearchModel> searchProductList = [];
  Xerxes xerxes = Xerxes(); // Instância de Xerxes para chamar ax3

  for (var message in messagesData['data']) {
    if (message['role'] == 'assistant' && message['content'] is List) {
      for (var content in message['content']) {
        if (content['type'] == 'text') {
          var textValue = content['text']['value'];
          var productData = json.decode(textValue);

          for (var product in productData['Produtos']) {
            print("PRODUCT: $product");
            String sigla = await xerxes.ax3(product['Produto'] ?? '');
            searchProductList.add(SearchModel(
              searchType: 'prod_cat',
              nome: product['Produto'] ?? '',
              sigla: sigla,
              marca: product['Marca'] ?? '',
              volume: product['Quantidade'] ?? '',
              unidade: product['Unidade'] ?? '',
            ));
          }
        }
      }
    }
  }

  print("FIM DO FETCH!!");
  return searchProductList;
}



}
