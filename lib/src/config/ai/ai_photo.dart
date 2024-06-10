import 'package:flutter/material.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:hh_2/src/pages/photo/photo_bar.dart';
import 'dart:io';
import 'ai_functions.dart';

class AIPhoto extends StatefulWidget {
  final File image;

  AIPhoto({required this.image}) {
    AIFunctions.initLog();
  }

  @override
  _AIPhotoState createState() => _AIPhotoState();
}

class _AIPhotoState extends State<AIPhoto> {
  late Future<List<EanModel>> _response;
  final DBSearch _dbSearch = DBSearch();

  @override
  void initState() {
    super.initState();
    _response = analyzeImage(widget.image);
  }

  Future<List<EanModel>> analyzeImage(File image) async {
    try {
      String fileId = await AIFunctions.uploadImage(image);
      Map<String, String> ids = await AIFunctions.createThreadAndRun(fileId);
      await AIFunctions.pollRunStatus(ids['thread_id']!, ids['run_id']!);
      List<SearchModel> searchProductList = await AIFunctions.fetchMessages(ids['thread_id']!, ids['run_id']!);

      // Chamar a função searchProductV2 para cada item da lista de SearchModel
      List<EanModel> finalResults = [];
      for (SearchModel searchModel in searchProductList) {
        List<EanModel> results = await _dbSearch.searchProductV2(searchModel, 1);
        finalResults.addAll(results);
      }

      return finalResults;
    } catch (e) {
      throw Exception("Error in analyzeImage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado da Análise')),
      body: Column(
        children: [
          Container(
            height: 300,
            child: Image.file(widget.image),
          ),
          Expanded(
            child: FutureBuilder<List<EanModel>>(
              future: _response,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final eanProductList = snapshot.data!;
                  return PhotoBar(eanProductList: eanProductList);
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
