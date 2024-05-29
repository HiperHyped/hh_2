import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:mysql1/src/single_connection.dart';

class DBHint {
  final DBService _dbService = DBService();

// Método para inserir dados na tabela Suggest
Future<void> insertSuggest(SuggestionModel suggestionModel, int basketId) async {
  String sql = '''
    INSERT INTO Suggest (recipe_name, basket_id, suggest_time) 
    VALUES (${HHVar.c}, ${HHVar.c}, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'))
  ''';

  List<dynamic> values = [suggestionModel.recipe, basketId];

  await _dbService.query(sql, values);
}


// Método para atualizar dados na tabela Suggest
Future<void> updateCatSuggest(SuggestionModel suggestionModel) async {
  String sql = '''
    UPDATE Suggest
    SET cat_suggest = ${HHVar.c}, subcat_suggest = ${HHVar.c}
    WHERE suggest_id = ${HHVar.c}
  ''';

  List<dynamic> values = [suggestionModel.recipeModel.catRecipe, suggestionModel.recipeModel.subCatRecipe, suggestionModel.suggest_id];

  await _dbService.query(sql, values);
}

  // Método para buscar a data e hora da última sugestão criada
  Future<DateTime?> getLastSuggestTime(int basketId) async {
    String sql = '''
      SELECT suggest_time FROM Suggest
      WHERE basket_id = ${HHVar.c}
      ORDER BY suggest_time DESC LIMIT 1
    ''';

    List<dynamic> values = [basketId];
    var result = await _dbService.query(sql, values);

    if (result.isNotEmpty) {
      return DateTime.parse(result.first['suggest_time']);
    }
    return null;
  }

  // Método para buscar o último suggest_id criado para um basket_id específico
  Future<int?> getLastSuggestId(int basketId) async {
    String sql = '''
      SELECT MAX(suggest_id) AS last_id FROM Suggest
      WHERE basket_id = ${HHVar.c}
    ''';

    List<dynamic> values = [basketId];

    var result = await _dbService.query(sql, values);

    if (result.isNotEmpty) {
      return result.first['last_id'] as int?;
    }
    return null;

  }


  // Método para inserir dados na tabela Suggest_List
  Future<void> insertSuggestList(SuggestionModel suggestion) async {
    // Insere os produtos iniciais (INITIAL = I)
    for (var product in suggestion.initialProductList) {
      String sql = '''
        INSERT INTO Suggest_List (suggest_id, prod_ean, prod_name, prod_qty, prod_status) 
        VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c})
      ''';

      List<dynamic> values = [suggestion.suggest_id, product.ean, product.nome, 1, 'I'];

      await _dbService.query(sql, values);
    }

    // Insere os produtos das sugestoes (SUGGEST = S)
    for (var product in suggestion.dbSearchResultList) {
      String sql = '''
        INSERT INTO Suggest_List (suggest_id, prod_ean, prod_name, prod_qty, prod_status) 
        VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c})
      ''';

      List<dynamic> values = [suggestion.suggest_id, product.ean, product.nome, 1, 'S'];

      await _dbService.query(sql, values);
    }
  }



  // Método para inserir dados na tabela Recipe_List
  Future<void> insertRecipeList(SuggestionModel suggestion) async {
    for (var step in  suggestion.recipeModel.description) {
      String sql = '''
        INSERT INTO Recipe_List (suggest_id, recipe_step, recipe_item) 
        VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c})
      ''';

      List<dynamic> values = [suggestion.suggest_id, suggestion.recipeModel.description.indexOf(step), step];

      await _dbService.query(sql, values);
    }
  }

  // Método para buscar dados da tabela Suggest
  Future<List> selectSuggest(int suggestId) async {
    String sql = '''
      SELECT * FROM Suggest
      WHERE suggest_id = ${HHVar.c}
    ''';

    List<dynamic> values = [suggestId];

    return await _dbService.query(sql, values);
  }

  // Método para buscar dados da tabela Suggest_List
  Future<List> selectSuggestList(int suggestId) async {
    String sql = '''
      SELECT * FROM Suggest_List
      WHERE suggest_id = ${HHVar.c}
    ''';

    List<dynamic> values = [suggestId];

    return await _dbService.query(sql, values);
  }

  // Método para buscar dados da tabela Recipe_List
  Future<List> selectRecipeList(int suggestId) async {
    String sql = '''
      SELECT * FROM Recipe_List
      WHERE suggest_id = ${HHVar.c}
    ''';

    List<dynamic> values = [suggestId];

    return await _dbService.query(sql, values);
  }

  // Método para atualizar o feedback do usuário na tabela Suggest
  Future<void> updateUserFeedback(SuggestionModel suggestion, int user_feedback) async {
    String sql = '''
      UPDATE Suggest 
      SET user_feedback = ${HHVar.c}
      WHERE suggest_id = ${HHVar.c}
    ''';

    List<dynamic> values = [user_feedback, suggestion.suggest_id];
    print("${sql} , VALUES: ${values[0]}, ${values[1]} ");

    await _dbService.query(sql, values);
  }

  // Método para atualizar a existência de uma receita similar na tabela Suggest
  Future<void> updateSimilarRecipeExists(SuggestionModel suggestion, bool similarRecipeExists) async {
    String sql = '''
      UPDATE Suggest 
      SET similar_recipe = ${HHVar.c}
      WHERE suggest_id = ${HHVar.c}
    ''';

    List<dynamic> values = [similarRecipeExists ? 1 : 0, suggestion.suggest_id];

    await _dbService.query(sql, values);
  }

   /*Future<List<SuggestionModel>> getSuggestions(int basketId) async {
    String sql = '''
      SELECT recipe_name, cat_suggest, subcat_suggest 
      FROM Suggest 
      WHERE basket_id = ${HHVar.c}
    ''';

    List<dynamic> values = [basketId];
    var results = await _dbService.query(sql, values);

    List<SuggestionModel> suggestions = [];
    for (var row in results) {
      SuggestionModel suggestion = SuggestionModel(
        recipe: row['recipe_name'],
        recipeModel: RecipeModel(
          catRecipe: row['cat_suggest'],
          subCatRecipe: row['subcat_suggest']
        ),
        // Outros campos que você precisa mapear, se necessário
      );
      suggestions.add(suggestion);
    }
    return suggestions;
  }*/

}

  /*Future<void> insertSuggestList(SuggestionModel suggestion) async {
    for (var product in suggestion.basketProductList) {
      String sql = '''
        INSERT INTO Suggest_List (suggest_id, prod_name, prod_qty, prod_status) 
        VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, ${HHVar.c})
      ''';

      List<dynamic> values = [suggestion.suggest_id, product, 0, 'available'];

      await _dbService.query(sql, values);
    }
  }*/