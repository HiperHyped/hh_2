import 'dart:typed_data';
import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/picture_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'ai_functions.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart'; // Importar HHGlobals

class AIPhoto {
  final Uint8List imageBytes;

  AIPhoto({required this.imageBytes}) {
    AIFunctions.initLog();
  }

  final DBSearch _dbSearch = DBSearch();

  Future<void> analyzeImage(Uint8List imageBytes) async {
    try {
      // Indicar que AIPhoto está em processamento
      HHGlobals.isProcessing[Functions.image]?.value = true;

      String fileId = await AIFunctions.uploadImageBytes(imageBytes);
      Map<String, String> ids = await AIFunctions.createThreadAndRun(fileId);
      
      // Verificar se ids['thread_id'] e ids['run_id'] não são nulos
      if (ids['thread_id'] == null || ids['run_id'] == null) {
        throw Exception('Thread ID or Run ID is null');
      }

      await AIFunctions.pollRunStatus(ids['thread_id']!, ids['run_id']!);
      List<SearchModel> searchProductList = await AIFunctions.fetchMessages(ids['thread_id']!, ids['run_id']!);

      BasketModel basket = BasketModel();
      for (SearchModel searchModel in searchProductList) {
        List<EanModel> results = await _dbSearch.searchProductWithScore(searchModel, 1);
        for (var result in results) {
          basket.products.add(result);
        }
      }

      // Criar e adicionar PictureModel a HHPictureList
      PictureModel pictureModel = PictureModel(
        basket: basket,
        searchProductList: searchProductList,
        image: imageBytes,
        imageRedux: HHGlobals.pictureFileBytes, // Utilize a imagem reduzida
        threadId: ids['thread_id']!,
        runId: ids['run_id']!,
      );

      HHGlobals.HHPictureList.value.add(pictureModel);
      HHGlobals.HHPictureList.notifyListeners(); // Notificar os listeners
    } catch (e) {
      throw Exception("Error in analyzeImage: $e");
    } finally {
      // Indicar que AIPhoto terminou o processamento
      HHGlobals.isProcessing[Functions.image]?.value = false;
    }
  }
}
