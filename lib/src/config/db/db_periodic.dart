import 'package:hh_2/src/config/common/var/hh_enum.dart';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/common/var/hh_settings.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_search.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/config/log/log_service.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/periodic_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class DBPeriodic {
  final DBService _dbService = DBService();
  final DBSearch _dbSearch = DBSearch();

  DBPeriodic() {LogService.init();}

  
  void loadPeriodicOnce() async {
    HHGlobals.isProcessing[Functions.periodic]?.value = true;
    try {
      List<PeriodicModel> periodicHistory = await getPeriodicHistory(HHGlobals.HHUser.userId);
      /*for (var periodic in periodicHistory) {
        await getPeriodicDetails(periodic.periodicId, periodicHistory);
        
      }*/
      HHGlobals.HHPeriodicLists.value = periodicHistory;
      HHNotifiers.counter[CounterType.PeriodicCount]!.value = periodicHistory.length;
    } catch (e) {
      print('Erro ao carregar as listas periódicas: $e');
    }
    HHGlobals.isProcessing[Functions.periodic]?.value = false;
  }

  // Função para obter o histórico de listas periódicas do usuário
  Future<List<PeriodicModel>> getPeriodicHistory(int userId) async {
    List<PeriodicModel> periodicHistory = [];

    String sql =
    """
    SELECT * FROM Periodic WHERE user_id = ${HHVar.c} ORDER BY periodic_time DESC LIMIT ${HHSettings.historyLimit}
    """;

    var results = await _dbService.query(sql, [userId]);

    // Iterando sobre os resultados e adicionando cada lista periódica no histórico
    for (var row in results) {
      var periodic = PeriodicModel(
        periodicId: row['periodic_id'],
        userId: row['user_id'],
        periodicTime: DateTime.parse(row['periodic_time']),
        listName: row['list_name'],
        periodType: PeriodType.values.firstWhere((e) => e.toString() == 'PeriodType.${row['period_type']}'),
        weeklyDays: row['weekly_days'],
        monthlyDay: row['montly_day'],
        basketList: [],
      );

      String sqlProducts = "SELECT * FROM Periodic_List WHERE periodic_id = ${HHVar.c}";

      var resultsProducts = await _dbService.query(sqlProducts, [periodic.periodicId]);
      if (resultsProducts.isNotEmpty) {
        for (var rowProduct in resultsProducts) {
          String ean = rowProduct['prod_ean'].toString();
          double quantity = double.parse(rowProduct['prod_qty']);

          // Buscando o produto pelo EAN
          List<EanModel> eanResults = await _dbSearch.searchProductV2(SearchModel(ean: ean, searchType: "ean"), 1);

          if (eanResults.isNotEmpty) {
            var product = eanResults[0];

            // Adicionando o produto na cesta quantity vezes
            var basket = BasketModel();
            for (int i = 0; i < quantity; i++) {
              basket.products.add(product);
            }
            basket.groupProducts();
            periodic.basketList.add(basket);
          }
        }
      }

      periodicHistory.add(periodic);
    }

    return periodicHistory;
  }

  // Função para obter os detalhes de uma lista periódica específica
  Future<void> getPeriodicDetails(int periodicId, List<PeriodicModel> periodicHistory) async {
    String sql = "SELECT * FROM Periodic_List WHERE periodic_id = ?";

    var results = await _dbService.query(sql, [periodicId]);

    PeriodicModel? periodic = periodicHistory.firstWhere((p) => p.periodicId == periodicId);

    if (periodic != null && results.isNotEmpty) {
      for (var rowProduct in results) {
        String ean = rowProduct['prod_ean'].toString();
        double quantity = double.parse(rowProduct['prod_qty']);

        List<EanModel> eanResults = await _dbSearch.searchProductV2(SearchModel(ean: ean, searchType: "ean"), 1);

        if (eanResults.isNotEmpty) {
          var product = eanResults[0];
          var basket = BasketModel();
          for (int i = 0; i < quantity; i++) {
            basket.products.add(product);
          }
          basket.groupProducts();
          periodic.basketList.add(basket);
        }
      }
    }
  }


  Future<void> addPeriodic(PeriodicModel periodic) async {
  var sqlInsertPeriodic = '''
    INSERT INTO Periodic (user_id, list_name, period_type, weekly_days, montly_day, periodic_time) 
    VALUES (?, ?, ?, ?, ?, ?)
  ''';

  // Prepare the values
  var userId = periodic.userId;
  var listName = periodic.listName;
  var periodType = periodic.periodType.toString().split('.').last;
  var weeklyDays = periodic.weeklyDays;
  var monthlyDay = periodic.monthlyDay;
  var periodicTime = periodic.periodicTime.toIso8601String().replaceAll('T', ' ');

  // Print the SQL with values interpolated
  String sqlWithValues = '''
    INSERT INTO Periodic (user_id, list_name, period_type, weekly_days, montly_day, periodic_time) 
    VALUES ($userId, '$listName', '$periodType', '$weeklyDays', ${monthlyDay ?? 'NULL'}, '$periodicTime')
  ''';

  print('Executing SQL: $sqlWithValues');

  // Prepare the parameters list, handling the NULL case for monthlyDay
  var params = [
    userId,
    listName,
    periodType,
    weeklyDays,
    monthlyDay ?? 0,
    periodicTime
  ];

  var result = await _dbService.query(sqlInsertPeriodic, params);
}

  // Função para obter o último periodic_id inserido para um usuário
  Future<int?> getLastPeriodicId(int userId) async {
    var sqlGetLastId = '''
      SELECT MAX(periodic_id) AS last_id 
      FROM Periodic 
      WHERE user_id = ?
    ''';
    var result = await _dbService.query(sqlGetLastId, [userId]);

    if (result.isNotEmpty) {
      return result.first['last_id'];
    }
    return null;
  }

   // Função para inserir um produto em uma lista periódica (PL)
  Future<void> addProductToList(EanModel product, int periodicId, int quantity, double price) async {
    var sqlInsertProduct = '''
      INSERT INTO Periodic_List (periodic_id, prod_ean, prod_qty, prod_price, periodic_list_time) 
      VALUES (?, ?, ?, ?, ?)
    ''';
    var result = await _dbService.query(sqlInsertProduct, [
      periodicId,
      product.ean,
      quantity,
      price,
      DateTime.now().toIso8601String()
    ]);
  }

  // Função para selecionar todas as listas de um usuário (P)
  Future<List<PeriodicModel>> getPeriodicLists(int userId) async {
    var sqlGetPeriodic = '''
      SELECT periodic_id, user_id, list_name, period_type, weekly_days, montly_day, periodic_time 
      FROM Periodic 
      WHERE user_id = ?
    ''';
    var results = await _dbService.query(sqlGetPeriodic, [userId]);
    List<PeriodicModel> periodicLists = [];

    for (var row in results) {
      var periodType = PeriodType.values.firstWhere((e) => e.toString() == 'PeriodType.${row['period_type']}');
      periodicLists.add(PeriodicModel(
        periodicId: row['periodic_id'],
        userId: row['user_id'],
        periodicTime: DateTime.parse(row['periodic_time']),
        listName: row['list_name'],
        periodType: periodType,
        weeklyDays: row['weekly_days'],
        monthlyDay: row['montly_day'],
        basketList: [], // Inicialmente vazio, será preenchido depois
      ));
    }

    return periodicLists;
  }


  // Função para selecionar os produtos de uma determinada lista (PL)
  Future<List<BasketModel>> getProductsFromList(int periodicId) async {
    var sqlGetProducts = '''
      SELECT prod_ean, prod_qty, prod_price 
      FROM Periodic_List 
      WHERE periodic_id = ?
    ''';
    var productResults = await _dbService.query(sqlGetProducts, [periodicId]);
    print("Product results: $productResults");
    List<BasketModel> basketList = [];
    var basket = BasketModel();
    for (var productRow in productResults) {
      var product = EanModel(
        ean: productRow['prod_ean'].toString(),
        preco: productRow['prod_price'].toString(),
      );
      basket.products.add(product);
      basket.productQuantities[product] = int.parse(productRow['prod_qty'].toString());

    }
    basketList.add(basket);

    return basketList;
  }


  // Função para alterar a quantidade de um produto de uma lista (PL)
  Future<void> alterQtyProduct(int periodicId, EanModel product, int newQuantity) async {
    var sqlUpdateProduct = '''
      UPDATE Periodic_List 
      SET prod_qty = ? 
      WHERE periodic_id = ? AND prod_ean = ?
    ''';
    await _dbService.query(sqlUpdateProduct, [newQuantity, periodicId, product.ean]);
  }

  // Função para alterar alguma informação da lista periódica (P)
  Future<void> alterPeriodicList(PeriodicModel periodic) async {
    var sqlUpdatePeriodic = '''
      UPDATE Periodic 
      SET list_name = ?, period_type = ?, weekly_days = ?, montly_day = ?, periodic_time = ? 
      WHERE periodic_id = ?
    ''';
    await _dbService.query(sqlUpdatePeriodic, [
      periodic.listName,
      periodic.periodType.toString().split('.').last,
      periodic.weeklyDays,
      periodic.monthlyDay,
      periodic.periodicTime.toIso8601String(),
      periodic.periodicId
    ]);
  }

  // Função para apagar determinada lista de um usuário (P)
  Future<void> deletePeriodicList(int periodicId) async {
    var sqlDeletePeriodicList = '''
      DELETE FROM Periodic_List 
      WHERE periodic_id = ?
    ''';
    await _dbService.query(sqlDeletePeriodicList, [periodicId]);

    var sqlDeletePeriodic = '''
      DELETE FROM Periodic 
      WHERE periodic_id = ?
    ''';
    await _dbService.query(sqlDeletePeriodic, [periodicId]);
  }

  // Função para apagar determinado produto de uma determinada lista (PL)
  Future<void> deleteProductFromList(int periodicId, EanModel product) async {
    var sqlDeleteProduct = '''
      DELETE FROM Periodic_List 
      WHERE periodic_id = ? AND prod_ean = ?
    ''';
    await _dbService.query(sqlDeleteProduct, [periodicId, product.ean]);
  }

  // Função para apagar todos os produtos de uma determinada lista (PL)
  Future<void> deleteAllProductsFromList(int periodicId) async {
    var sqlDeleteAllProducts = '''
      DELETE FROM Periodic_List 
      WHERE periodic_id = ?
    ''';
    await _dbService.query(sqlDeleteAllProducts, [periodicId]);
  }

  // Função para apagar todas as listas do usuário (PL primeiro e depois P)
  Future<void> deleteAllLists(int userId) async {
    var sqlGetAllPeriodicIds = '''
      SELECT periodic_id 
      FROM Periodic 
      WHERE user_id = ?
    ''';
    var results = await _dbService.query(sqlGetAllPeriodicIds, [userId]);

    for (var row in results) {
      int periodicId = row['periodic_id'];
      await deleteAllProductsFromList(periodicId);
      await deletePeriodicList(periodicId);
    }
  }
}


  /*void loadPeriodicListsOnce() async {
    List<PeriodicModel> periodicLists = await _dbPeriodic.getPeriodicLists(HHGlobals.HHUser.userId);
    for (var periodic in periodicLists) {
      periodic.basketList = await _dbPeriodic.getProductsFromList(periodic.periodicId);
      print("PERIODIC LIST #${periodic.periodicId}");
    }
    HHGlobals.HHPeriodicLists.value = periodicLists;
    HHNotifiers.counter[CounterType.PeriodicCount]!.value = periodicLists.length;
  }*/