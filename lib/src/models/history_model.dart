
import 'package:hh_2/src/models/basket_model.dart';


class HistoryModel {
  int user_id = 0;
  List<BasketModel> basketHistory = [];
  
}

  /*
  // fetchHistory irá pegar o histórico de cestas do banco de dados
  Future<void> fetchHistory() async {
    // Preparando a query SQL para buscar cestas
    String sql = "SELECT * FROM Basket WHERE user_id = ?";

    // Executando a query SQL com o user_id como parâmetro
    var results = await _dbService.query(sql, [this.user_id]);

    // Limpando o histórico de cestas atual
    this.basketHistory.clear();

    // Iterando sobre os resultados e adicionando cada cesta no histórico de cestas
    for (var row in results) {
      var basket = BasketModel();

      basket.basket_id = row['basket_id'];
      basket.user_id = row['user_id'];
      basket.basketTime = row['basket_time'];

      String sqlProducts = "SELECT * FROM Basket_List WHERE basket_id = ?";

      var resultsProducts = await _dbService.query(sqlProducts, [basket.basket_id]);
      if (resultsProducts.isNotEmpty) {
        for (var rowProduct in resultsProducts) {
          String ean = rowProduct['prod_ean'].toString();
          //print(ean);
          // Buscando o produto pelo EAN
          List<SearchModel> searchResults = await _dbSearch.searchProductsbyEan(ean, 1);

          if (searchResults.isNotEmpty) {
            var searchModel = searchResults[0];

            var product = EanModel(
              ean: searchModel.ean,
              marca: searchModel.marca,
              link: searchModel.link,
              preco: searchModel.preco,
              nome: searchModel.nome,
              imagem: searchModel.imagem,
              unidade: searchModel.unidade,
              volume: searchModel.volume,
              sigla: searchModel.sigla,
              sig0: searchModel.sig0,
              sig1:searchModel.sig1,
              sig2: searchModel.sig2,
              w1: searchModel.w1,
              w2: searchModel.w2,
              w3: searchModel.w3,
              w4: searchModel.w4,
            );

            // Adicionando o produto na cesta
            basket.products.add(product);
          }
        }
        // Adicionando a cesta ao histórico de cestas se ela contém produtos
        this.basketHistory.add(basket);
      }
    }
  }
}*/

/*class HistoryModel {
  int user_id;
  List<BasketModel> basketHistory = [];
  final DBService _dbService = DBService();
  final DBSearch _dbSearch = DBSearch();

  HistoryModel({required this.user_id});

  // fetchHistory irá pegar o histórico de cestas do banco de dados
  Future<void> fetchHistory() async {
    // Preparando a query SQL para buscar cestas
    String sql = "SELECT * FROM Basket WHERE user_id = ?";

    // Executando a query SQL com o user_id como parâmetro
    var results = await _dbService.query(sql, [this.user_id]);

    // Limpando o histórico de cestas atual
    this.basketHistory.clear();

    // Iterando sobre os resultados e adicionando cada cesta no histórico de cestas
    for (var row in results) {
      var basket = BasketModel();

      basket.basket_id = row['basket_id'];
      basket.user_id = row['user_id'];
      basket.basketTime = row['basket_time'];
      print("**************TIME : ${basket.basketTime}");
      this.basketHistory.add(basket);

      String sqlProducts = "SELECT * FROM Basket_List WHERE basket_id = ?";

      var resultsProducts = await _dbService.query(sqlProducts, [basket.basket_id]);
      for (var rowProduct in resultsProducts) {
        String ean = rowProduct['prod_ean'].toString();

        // Buscando o produto pelo EAN
        List<SearchModel> searchResults = await _dbSearch.searchProductsbyEan(ean, 1);

        if (searchResults.isNotEmpty) {
          var searchModel = searchResults[0];

        var product = EanModel(
          ean: searchModel.ean,
          marca: searchModel.marca,
          link: searchModel.link,
          preco: searchModel.preco,
          nome: searchModel.nome,
          imagem: searchModel.imagem,
          unidade: searchModel.unidade,
          volume: searchModel.volume,
          sigla: searchModel.sigla,
          sig0: searchModel.sig0,
          sig1:searchModel.sig1,
          sig2: searchModel.sig2,
          w1: searchModel.w1,
          w2: searchModel.w2,
          w3: searchModel.w3,
          w4: searchModel.w4,
        );

          // Adicionando o produto na cesta
          basket.products.add(product);
        }
      }
    }
  }
}
*/
