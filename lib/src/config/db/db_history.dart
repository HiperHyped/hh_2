import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/history_model.dart';
import 'package:hh_2/src/models/search_model.dart';
import 'package:hh_2/src/models/user_model.dart';

class DBHistory {

  final DBService _dbService = DBService();
  final DBSearch _dbSearch = DBSearch();

  //FUNÇÂO ORIGINAL
  // fetchHistory irá pegar o histórico de cestas do banco de dados
  Future<HistoryModel> getBasketHistory(int userId) async {

    HistoryModel history = HistoryModel();

    String sql =
    """
    SELECT Basket.* FROM Basket WHERE user_id = ${HHVar.c} AND EXISTS 
    (SELECT 1 FROM Basket_List WHERE Basket_List.basket_id = Basket.basket_id ) 
    ORDER BY basket_time DESC LIMIT ${HHSettings.historyLimit}
    """;
     
    //"SELECT * FROM Basket WHERE user_id = ? ORDER BY basket_time DESC LIMIT 10"
    // "SELECT * FROM Basket WHERE user_id = ?";
    var results = await _dbService.query(sql, [userId]);
    history.basketHistory.clear();

    // Iterando sobre os resultados e adicionando cada cesta no histórico de cestas
    for (var row in results) {
      var basket = BasketModel();

      basket.basket_id = int.parse(row['basket_id']);
      basket.user_id = int.parse(row['user_id']);
      // Convert the string to DateTime
      basket.basketTime = DateTime.parse(row['basket_time']);
      //basket.basketTime = row['basket_time'];

      String sqlProducts = "SELECT * FROM Basket_List WHERE basket_id = ${HHVar.c}";

      var resultsProducts = await _dbService.query(sqlProducts, [basket.basket_id]);
      if (resultsProducts.isNotEmpty) {
        for (var rowProduct in resultsProducts) {
          String ean = rowProduct['prod_ean'].toString();
          double quantity = double.parse(rowProduct['prod_qty']);
          //print(ean);
          // Buscando o produto pelo EAN
          List<EanModel> eanResults = await _dbSearch.searchProductV2(SearchModel(ean: ean, searchType: "ean"), 1);

          if (eanResults.isNotEmpty) {
            var product = eanResults[0];

            // Adicionando o produto na cesta quantity vezes
            //print("History: Ean: ${product.toString()}");
            for (int i = 0; i < quantity; i++) { basket.products.add(product);} ///sem usar o basket.addProduct
          }
        }
        // Adicionando a cesta ao histórico de cestas se ela contém produtos
        basket.groupProducts();
        history.basketHistory.add(basket);
      }
      
    }
    //HHNotifiers.counter['historyCount']!.value = history.basketHistory.length;

    return history;
  }

  // Função A
  Future<HistoryModel> getBasketSummary(int userId) async {
    HistoryModel history = HistoryModel();
    history.user_id = userId;

    String sql = """
    SELECT Basket.basket_id, Basket.basket_time, COUNT(Basket_List.basket_list_id) as num_products
    FROM Basket
    INNER JOIN Basket_List ON Basket.basket_id = Basket_List.basket_id
    WHERE Basket.user_id = ?
    GROUP BY Basket.basket_id
    ORDER BY Basket.basket_time DESC
    LIMIT ${HHVar.HistoryLimit}
    """;

    var results = await _dbService.query(sql, [userId]);
    history.basketHistory.clear();

    for (var row in results) {
      var basket = BasketModel();
      basket.basket_id = int.parse(row['basket_id']);
      basket.user_id = userId;
      basket.basketTime = DateTime.parse(row['basket_time']);
      // Você pode usar row['num_products'] para ter o número de produtos no cesto
      history.basketHistory.add(basket);
    }

    return history;
  }

  // Função B
  Future<void> getBasketDetails(int basketId, HistoryModel history) async {
    String sql = "SELECT * FROM Basket_List WHERE basket_id = ?";

    var results = await _dbService.query(sql, [basketId]);

    BasketModel? basket = history.basketHistory.firstWhere((b) => b.basket_id == basketId);

    if (basket != null && results.isNotEmpty) {
      for (var rowProduct in results) {
        String ean = rowProduct['prod_ean'].toString();
        double quantity = double.parse(rowProduct['prod_qty']);

        List<EanModel> eanResults = await _dbSearch.searchProductV2(SearchModel(ean: ean, searchType: "ean"), 1);

        if (eanResults.isNotEmpty) {
          var product = eanResults[0];
          for (int i = 0; i < quantity; i++) {
            basket.products.add(product);
          }
        }
      }
    }
  }
}