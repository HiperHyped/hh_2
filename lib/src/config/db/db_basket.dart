import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/basket_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/user_model.dart';

class DBBasket {
  final DBService _dbService;

  DBBasket(this._dbService);

  ////////////CREATE BASKET
  Future<void> createBasket(int userId) async {
    var sql = '''
      INSERT INTO Basket (user_id, basket_time, isOrder) VALUES (${HHVar.c}, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'), 0)
    ''';
    
    await _dbService.query(sql, [userId]);
  }

  // QUAL O HORARIO EM QUE FOI CRIADA A ULTIMA BASKET?
  //v2
  Future<DateTime?> getDateTime(int userId) async {
    // Obter a data e hora da cesta que acabou de ser criada
    var sqlDate = 'SELECT basket_time FROM Basket WHERE user_id = ${HHVar.c} ORDER BY basket_time DESC LIMIT 1';
    var result = await _dbService.query(sqlDate, [userId]);

    if (result.isNotEmpty) {
      // Converte a string para DateTime
      //return DateTime.parse(result.first['basket_time']);
      return DateTime.parse(result.first['basket_time']); //return result.first['basket_time'];
    }

    return null;
  }




  //////////GET BASKET ID
  ///
  Future<int?> getLastBasketId(int userId) async {
    var sql = 'SELECT MAX(basket_id) AS last_id FROM Basket WHERE user_id = ${HHVar.c}';
    var result = await _dbService.query(sql, [userId]);
    if (result.isNotEmpty) {
      // Tratar last_id diretamente como um inteiro
      var lastId = result.first['last_id'] as int?;
      return lastId;
    }
    return null;
  }
  /*Future<int?> getLastBasketId(int userId) async {
    var sql = 'SELECT MAX(basket_id) AS last_id FROM Basket WHERE user_id = ${HHVar.c}';
    var result = await _dbService.query(sql, [userId]);
    if (result.isNotEmpty) {
      var lastIdString = result.first['last_id'];
      return lastIdString != null ? int.parse(lastIdString) : null;
    }
    return null;
  }*/


  ///////ADD PRODUCT TO BASKET_LIST
  Future<void> addProduct(EanModel product, int basketId, SourceOrigin sourceOrigin, HintStatus hintStatus) async {
    var sqlCheck = '''
      SELECT prod_qty FROM Basket_List
      WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
    ''';
    
    var result = await _dbService.query(sqlCheck, [basketId, product.ean]);

    if (result.isNotEmpty) {
      // O produto já existe na cesta, então vamos incrementar a quantidade
      var sqlUpdate = '''
        UPDATE Basket_List
        SET prod_qty = prod_qty + 1
        WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
      ''';

      await _dbService.query(sqlUpdate, [basketId, product.ean]);
    } else {
      // O produto não está na cesta, então vamos inserir uma nova linha
      var sqlInsert = '''
        INSERT INTO Basket_List (
          basket_id, 
          prod_ean,
          prod_qty, 
          prod_price,
          basket_list_time,
          prod_origin,
          prod_status)
        VALUES (${HHVar.c}, ${HHVar.c}, 1, ${HHVar.c}, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'), ${HHVar.c}, ${HHVar.c})
      ''';

      print("ADD PRODUCT - SourceOrigin: ${sourceOrigin.toString().split('.').last}");
      print("ADD PRODUCT - HintStatus: ${hintStatus.toString().split('.').last}");
      await _dbService.query(
        sqlInsert, 
        [
          basketId, 
          product.ean, 
          double.parse(product.preco), 
          sourceOrigin.toString().split('.').last,
          hintStatus.toString().split('.').last
        ]);
    }
  }

   /////////REMOVE PRODUCT FROM BASKET LIST / 01/11/23
  Future<void> removeProduct(EanModel product, int basketId) async {
    var sqlCheck = '''
      SELECT prod_qty FROM Basket_List
      WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
    ''';

    var result = await _dbService.query(sqlCheck, [basketId, product.ean]);

    if (result.isNotEmpty) {
      var quantityData = result.first['prod_qty'];
      double quantity;

      if (quantityData is String) {
        // Converte String para double se necessário
        quantity = double.parse(quantityData);
      } else if (quantityData is double) {
        // Se já é double, apenas atribua
        quantity = quantityData;
      } else {
        // Tratar outros tipos conforme necessário
        throw Exception('Unsupported type for prod_qty');
      }

      if (quantity > 1) {
        // Se a quantidade do produto for maior que 1, diminua em uma unidade
        var sqlUpdate = '''
          UPDATE Basket_List
          SET prod_qty = prod_qty - 1
          WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
        ''';

        await _dbService.query(sqlUpdate, [basketId, product.ean]);
      } else {
        // Se a quantidade do produto for igual a 1, delete a linha
        var sqlDelete = '''
          DELETE FROM Basket_List
          WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
        ''';

        await _dbService.query(sqlDelete, [basketId, product.ean]);
      }
    }
  }



  /////REMOVE ALL OF A PRODUCT FROM BASKET
  Future<void> removeAllOfAProduct(EanModel product, int basketId) async {
    var sqlDelete = '''
      DELETE FROM Basket_List
      WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
    ''';

    await _dbService.query(sqlDelete, [basketId, product.ean]);
  }


  ////CLEAN BASKET
  Future<void> clearBasket(int basketId) async {
    var sqlDelete = '''
      DELETE FROM Basket_List
      WHERE basket_id = ${HHVar.c}
    ''';

    await _dbService.query(sqlDelete, [basketId]);
  }

}

  //v1
  /*Future<DateTime?> getDateTime(int userId) async {
    // Obter a data e hora da cesta que acabou de ser criada
    var sqlDate = 'SELECT basket_time FROM Basket WHERE user_id = ${HHVar.c} ORDER BY basket_time DESC LIMIT 1';
    var result = await _dbService.query(sqlDate, [userId]);

    if (result.isNotEmpty) {
      return result.first['basket_time'] as DateTime;
    }

    return null;
  }*/
  //v0
  /*Future<DateTime?> getDateTime(int userId) async {
      // Obter a data e hora da cesta que acabou de ser criada
      var sqlDate = 'SELECT basket_time FROM Basket WHERE user_id = ? ORDER BY basket_time DESC LIMIT 1';
      var result = await _dbService.query(sqlDate, [userId]);
      
      if (result.isNotEmpty) {
        return DateTime.parse(result.first['basket_time']);
      }

      return null;
  }*/
  
  /////////REMOVE PRODUCT FROM BASKET LIST  31/10/23
  /*
  Future<void> removeProduct(EanModel product, int basketId) async {
    var sqlCheck = '''
      SELECT prod_qty FROM Basket_List
      WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
    ''';

    var result = await _dbService.query(sqlCheck, [basketId, product.ean]);

    if (result.isNotEmpty) {
      double quantity = result.first['prod_qty'] as double;

      if (quantity > 1) {
        // Se a quantidade do produto for maior que 1, diminua em uma unidade
        var sqlUpdate = '''
          UPDATE Basket_List
          SET prod_qty = prod_qty - 1
          WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
        ''';

        await _dbService.query(sqlUpdate, [basketId, product.ean]);
      } else {
        // Se a quantidade do produto for igual a 1, delete a linha
        var sqlDelete = '''
          DELETE FROM Basket_List
          WHERE basket_id = ${HHVar.c} AND prod_ean = ${HHVar.c}
        ''';

        await _dbService.query(sqlDelete, [basketId, product.ean]);
      }
    }
    
  }*/
  
  /*
  // Note que estou assumindo que sua tabela Basket_List tem um campo 'prod_qty' que representa a quantidade do produto
  // Para os métodos addProductToBasket, removeProductFromBasket e removeAllOfProductFromBasket, eu preciso do id da cesta para realizar as operações.

  Future<void> addProductToBasket(int basketId, EanModel product) async {
    var sql = '''
      UPDATE Basket_List SET prod_qty = prod_qty + 1 WHERE basket_id = ? AND prod_id = ?
    ''';
    await _dbService.query(sql, [basketId, product.ean]);
  }

  Future<void> removeProductFromBasket(int basketId, EanModel product) async {
    var sql = '''
      UPDATE Basket_List SET prod_qty = prod_qty - 1 WHERE basket_id = ? AND prod_id = ?
    ''';
    await _dbService.query(sql, [basketId, product.ean]);
  }

  Future<void> removeAllOfProductFromBasket(int basketId, EanModel product) async {
    var sql = 'DELETE FROM Basket_List WHERE basket_id = ? AND prod_id = ?';
    await _dbService.query(sql, [basketId, product.ean]);
  }

  Future<void> clearBasket(int basketId) async {
    var sql = 'DELETE FROM Basket_List WHERE basket_id = ?';
    await _dbService.query(sql, [basketId]);
  }

  Future<Map<EanModel, int>> getBasketProducts(int basketId) async {
    var sql = 'SELECT * FROM Basket_List WHERE basket_id = ?';
    var results = await _dbService.query(sql, [basketId]);
    Map<EanModel, int> productCountMap = {};
    for (var row in results) {
      var product = EanModel(
        ean: row['prod_id'],
        preco: (row['prod_price'] as num).toString(),
      );
      productCountMap[product] = row['prod_qty'] as int? ?? 0;
    }
    return productCountMap;
  }
  
}*/


/*class DBBasket {
  final DBService _dbService;

  DBBasket(this._dbService);

  Future<void> createBasket(int userId) async {
    var sql = '''
      INSERT INTO Basket (
        user_id,
        basket_time, 
        isOrder) 
        VALUES (?, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'), 0)
    ''';

    await _dbService.query(sql, [userId]);
  }

  Future<int?> getLastBasketId(int userId) async {
    var sql = 'SELECT MAX(basket_id) AS last_id FROM Basket WHERE user_id = ?';
    var result = await _dbService.query(sql, [userId]);

    if (result.isNotEmpty) {
      return result.first['last_id'] as int?;
    }

    return null;
  }

  Future<void> addProductToBasket(int basketId, EanModel product, int quantity) async {
    var sql = '''
      INSERT INTO Basket_List (
        basket_id, 
        prod_id, 
        prod_qty, 
        prod_price) 
        VALUES (?, ?, ?, ?)
    ''';

    await _dbService.query(sql, [basketId, product.ean, quantity, double.parse(product.preco)]);
  }

  Future<void> removeProductFromBasket(int basketId, EanModel product) async {
    var sql = 'DELETE FROM Basket_List WHERE basket_id = ? AND prod_id = ? LIMIT 1';

    await _dbService.query(sql, [basketId, product.ean]);
  }

  Future<void> clearBasket(int basketId) async {
    var sql = 'DELETE FROM Basket_List WHERE basket_id = ?';

    await _dbService.query(sql, [basketId]);
  }

  Future<Map<EanModel, int>> getBasketProducts(int basketId) async {
    var sql = 'SELECT * FROM Basket_List WHERE basket_id = ?';
    var results = await _dbService.query(sql, [basketId]);

    Map<EanModel, int> productCountMap = {};

    for (var row in results) {
      var product = EanModel(
        ean: row['prod_id'],
        preco: (row['prod_price'] as num).toString(),
      );

      productCountMap[product] = row['prod_qty'] as int? ?? 0;
    }

    return productCountMap;
  }
}*/
