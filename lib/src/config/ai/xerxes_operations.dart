import 'package:hh_2/src/config/ai/ai_xerxes.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/db/db_hint.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/suggestion_model.dart';

class XerxesOperations {
  final Xerxes xerxes = Xerxes();
  final DBHint _dbHint = DBHint();

  Future<void> performOperations() async {

    // IA: 13/06/2023: Pegue a lista atual de produtos e os transforme em uma lista de nomes de produtos
    //List<String> productNames = HHGlobals.HHBasket.value.products.map((product) => product.nome).toList();
    //SuggestionModel suggestion = await xerxes.x1(productNames);
    //List<EanModel> productList = HHGlobals.HHBasket.value.products;
    //SuggestionModel suggestion = await xerxes.x1(HHGlobals.HHBasket.value);
    // XERXES X1
    //BasketModel basket = HHGlobals.HHBasket.value; 

    String X1Response = await xerxes.x1();
    print("X1Response: $X1Response");
    
    // HANDLE X1
    SuggestionModel suggestion = xerxes.hx1(X1Response);
    print("HX1 AFTER: ${suggestion.toString()}");

    // POS x1
    suggestion = await xerxes.px1(suggestion);
    
    if(suggestion.recipe.isNotEmpty || suggestion.suggestProductList.isNotEmpty) {
      print("1o if ok!");

      // Insere a nova sugestão no banco de dados
      await _dbHint.insertSuggest(suggestion, HHGlobals.HHBasket.value.basket_id);
      suggestion.suggest_id = await _dbHint.getLastSuggestId(HHGlobals.HHBasket.value.basket_id) as int;
      print("SUUGGESTION_ID: ${suggestion.suggest_id}");

      // Extrai as receitas da lista de sugestões
      List<String> listaReceitas = HHGlobals.HHSuggestionList.value.map((s) => s.recipeModel.recipeName).toList();
      
      // XERXES ax2_1
      bool similarRecipeExists = await xerxes.ax2_1(suggestion.recipe, listaReceitas);
      await DBHint().updateSimilarRecipeExists(suggestion, similarRecipeExists);
      print("AX2_1 EXISTE?: $similarRecipeExists, RECEITA:  ${suggestion.recipe}, LISTA RECEITAS: $listaReceitas");

      if (!similarRecipeExists) {
         print("2o if ok!");

        // XERXES X2
        suggestion.recipeModel = await xerxes.x2(suggestion);

        // Update em Suggest com as categorias
        await _dbHint.updateCatSuggest(suggestion);

        if(suggestion.recipeModel.description.isNotEmpty) {
           print("3o if ok!");
           print("${suggestion.recipeModel.catRecipe} ; ${suggestion.recipeModel.subCatRecipe}");

           // Insere a nova lista de receitas no banco de dados
           await _dbHint.insertRecipeList(suggestion);
          
          //recipeCount.value++; // Incrementa o contador somente se a resposta não é vazia

          // IA: 13/06/2023: Verifica se ambas as respostas são válidas antes de adicionar à lista global
          if((suggestion.recipe.isNotEmpty || suggestion.suggestProductList.isNotEmpty) && suggestion.recipeModel.description.isNotEmpty) {
            HHNotifiers.increment(CounterType.HintCount);
            HHGlobals.HHSuggestionList.value.add(suggestion);
            // Insere a lista de sugestões no banco de dados
            await _dbHint.insertSuggestList(suggestion);
          }
        }
      }
    } //---- ESSE IF QUEBRA o AWAIT do px1
  }
}
