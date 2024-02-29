import 'package:hh_2/src/config/ai/ai_xerxes.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/recipe_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class SuggestionModel {
  int suggest_id = 0;
  String recipe = '';
  List<EanModel> initialProductList = []; //String
  List<String> suggestProductList = [];
  List<String> totalProductList = [];
  List<SearchModel> searchProductList = [];
  List<EanModel> dbSearchResultList = [];  
  final DBSearch _dbSearch = DBSearch(); 
  RecipeModel recipeModel = RecipeModel();
  int? userFeedback;
  int? cartLastPressed;

  SuggestionModel({this.recipe = '', this.suggestProductList = const []});


  
  Future<void> toSearchModelList() async {
    Xerxes x = Xerxes();
    
    // Limpa searchProductList antes de começar a adicionar novos itens.
    searchProductList.clear();
    
    print('Início do método toSearchModelList');
    
    List<Future<SearchModel>> futureList = [];
    
    print('Iterando por suggestProductList');
    for (var product in suggestProductList) {
      

      futureList.add(() async {
        String sigla = await x.ax3(product);
        print('Produto: $product');
        print('Sigla obtida: $sigla');
        
        return SearchModel(
          searchType: "prod_cat",
          nome: product,
          sigla: sigla,
        );
      }());
    }

    // Espera todos os Futures serem completados
    List<SearchModel> results = await Future.wait(futureList);
    
    print('Todos os Futures estão completos');
    
    // Adiciona os resultados à lista searchProductList
    searchProductList.addAll(results);
    
    print('searchProductList atualizada');
  }

  // Método para criar a lista totalProductList
  /*void createTotalProductList(List<String> products) {
    totalProductList = List<String>.from(basketProductList);
  }*/

  void createTotalProductList() {
    //totalProductList = [...initialProductList, ...suggestProductList];
    totalProductList = [...initialProductList.map((product) => product.nome), ...suggestProductList];
  }

  // Método que realiza a pesquisa no banco de dados para cada item em searchProductList
  Future<void> generateDBSearchResults() async {
    print("SEARCHPORDUCT LIST:  $searchProductList");
    for (var searchProduct in searchProductList) {
      print("SuggestModel DB SEARCHPRODUCT:  ${searchProduct.searchType} ==> ${searchProduct.nome}");
      var searchResult = await _dbSearch.searchProductV2(searchProduct, 1);  //somente a 1a resposta
      dbSearchResultList.addAll(searchResult);
    }
  }
  
  @override
  String toString() {
    return 'SuggestionModel{'
      'recipe: $recipe, '
      'initialProductList: ${initialProductList.map((product) => product.nome).join(', ')}, '
      'suggestProductList: $suggestProductList, '
      'totalProductList: $totalProductList, '
      //'searchProductList: ${_listToString(searchProductList)}, '
      'dbSearchResultList: ${dbSearchResultList.map((product) => product.nome).join(', ')}, '
      'recipeModel: $recipeModel'
    '}';
  }

  String _listToString(List list) {
    return list.map((item) => item.toString()).join(', ');
  }
}

// Método que transforma a productList em uma lista de SearchModel
  /*Future<void> toSearchModelList() async {
    Xerxes x = Xerxes();
    searchProductList = [];
    
    // Cria uma lista de Futures para esperar
    List<Future<SearchModel>> futureList = [];
    
    for (var product in suggestProductList) {
      // Adicione cada future na lista
      futureList.add(() async {
        String sigla = await x.ax3(product);
        return SearchModel(
          searchType: "prod_cat",
          nome: product,
          sigla: sigla,
        );
      }());
    }

    // Espere até que todos os futures sejam concluídos
    List<SearchModel> results = await Future.wait(futureList);
    
    // Adicione os resultados à lista searchProductList
    searchProductList.addAll(results);
  }*/

   //FIRST funcionando
  /*void toSearchModelList() async {
    //Xerxes x = Xerxes();
    searchProductList = suggestProductList.map((product) {
      return SearchModel(
        searchType: "product",  
        nome: product,
      );
    }).toList();
  }*/

  /*Future<void> toSearchModelList() async {
    Xerxes x = Xerxes();
    searchProductList = [];

    for (var product in suggestProductList) {
      String sigla = await x.ax3(product);
      SearchModel searchModel = SearchModel(
        searchType: "prod_cat",
        nome: product,
        sigla: sigla,
      );
      print("SEARCHMODEL:::  ${searchModel.toString()}");
      searchProductList.add(searchModel);
    }
  }*/

  


