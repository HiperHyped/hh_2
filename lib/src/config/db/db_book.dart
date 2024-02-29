import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class DBBook {
  final DBService _dbService = DBService();

  Future<List> getSuggestedRecipesByUserId(int userId) async {
    String suggestSql = '''
      SELECT suggest_id, recipe_name, cat_suggest, subcat_suggest, suggest_time
      FROM Suggest
      INNER JOIN Basket ON Suggest.basket_id = Basket.basket_id
      WHERE Basket.user_id = ? AND
            Suggest.user_feedback = 1
      GROUP BY recipe_name
      ORDER BY cat_suggest, subcat_suggest, recipe_name
    ''';
    return await _dbService.query(suggestSql, [userId]);
  }

  Future<List> getProductsBySuggestId(int suggestId, SuggestionModel suggestion) async {
    String productListSql = '''
      SELECT prod_ean, prod_name
      FROM Suggest_List
      WHERE suggest_id = ?
    ''';
    var productListResults = await _dbService.query(productListSql, [suggestId]);
    
    // Adicionando produtos à searchProductList do objeto SuggestionModel.
    for (var productInfo in productListResults) {
      suggestion.searchProductList.add(
        SearchModel(
          searchType: "product",
          nome: productInfo['prod_name'],
        )
      );
    }

    // Gerando resultados da pesquisa no banco de dados.
    await suggestion.generateDBSearchResults();

    return productListResults;
  }

  Future<List> getStepsBySuggestId(int suggestId) async {
    String recipeListSql = '''
      SELECT recipe_step, recipe_item
      FROM Recipe_List
      WHERE suggest_id = ?
      ORDER BY recipe_step
    ''';
    return await _dbService.query(recipeListSql, [suggestId]);
  }

  Future<List<SuggestionModel>> getSuggestionsByUserId(int userId) async {
    List<SuggestionModel> suggestions = [];

    var suggestResults = await getSuggestedRecipesByUserId(userId);

    for (var suggestInfo in suggestResults) {
      int suggestId = int.parse(suggestInfo['suggest_id'].toString());

      var suggestion = SuggestionModel(recipe: suggestInfo['recipe_name']);
      suggestion.recipeModel.catRecipe = suggestInfo['cat_suggest'] ?? '';
      suggestion.recipeModel.subCatRecipe = suggestInfo['subcat_suggest'] ?? '';

      // Chamar o método modificado com o objeto suggestion como argumento.
      await getProductsBySuggestId(suggestId, suggestion);

      // Obter as etapas de Recipe_List
      var recipeListResults = await getStepsBySuggestId(suggestId);
      for (var recipeStepInfo in recipeListResults) {
        suggestion.recipeModel.description.add(recipeStepInfo['recipe_item']);
      }

      suggestions.add(suggestion);
      print(suggestion.toString());
    }

    return suggestions;
  }
}
