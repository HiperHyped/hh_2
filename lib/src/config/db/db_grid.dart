import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class DBGrid {
  final DBService _dbService = DBService();

  Future<List<EanModel>> getProductsForGridV3(SearchModel searchProduct) async {
    List<dynamic> arguments = [
      searchProduct.sigla,  // sigla é o parâmetro necessário
      HHVar.GridLimit,       // limite de resultados (exemplo)
      HHGlobals.HHUser.userId  // fornecendo o valor para price_uf

    ];

    
    // Chamar a procedure diretamente
    var results = await _dbService.query('CALL GetClosestProductsAndPriceByUserAndCategory(?, ?, ?)', arguments);

    List<EanModel> productList = [];
    for (var row in results) {
      EanModel eanModel = EanModel(
        ean: row['prod_ean'].toString(),
        nome: row['prod_name'].toString(),
        imagem: row['prod_image'].toString(),
        marca: row['prod_brand'].toString(),
        unidade: row['prod_unit'].toString(),
        volume: row['prod_vol'].toString(),
        w1: row['prod_word1'].toString(),
        w2: row['prod_word2'].toString(),
        w3: row['prod_word3'].toString(),
        w4: row['prod_word4'].toString(),
        sigla: row['sigla'].toString(),
        sig3: row['sig3'].toString(),
        preco: row['prod_price'].toString(),
        link: "", // Assume que 'link' é preenchido em outro lugar
        hintStatus: int.parse(row['hint_status'].toString()),
        //searchType: searchProduct.searchType,
      );
      productList.add(eanModel);
    }

    //_dbService.query('CALL CalculateAllUserProfiles()', []);

    //_dbService.query('CALL CalculateWeightedUserProfiles(?, ?, ?, ?)', [1,0.5,0.5,0.5]);

    _dbService.query('CALL CalculateUserProfileForSpecificUser(?);', [HHGlobals.HHUser.userId]);

    return productList;
}



  Future<void> insertTerm(String term, String searchType) async {
    var sql = '''
      INSERT INTO Term(user_id, basket_id, term_string, term_date, search_type)
      VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'), ${HHVar.c})
    ''';
    //DateTime now = DateTime.now(); // Obter a data e hora atuais
    List<dynamic> arguments = [HHGlobals.HHUser.userId, HHGlobals.HHBasket.value.basket_id, term, searchType];
    await _dbService.query(sql, arguments);
  }


}


  /*Future<List<EanModel>> getProductsForGrid(SearchModel searchProduct) async {
    String whereClause;
    String whereArg;

    //print("**SEARCH: ${searchProduct.searchType}");

    switch (searchProduct.searchType) {
      case 'category':
        //print("**CAT: ${searchProduct.sigla}");
        whereClause = "LOWER(P.sigla) = LOWER(${HHVar.c})";
        whereArg = searchProduct.sigla;
        break;
      case 'brand':
        //print("**BRAND: ${searchProduct.marca}");
        whereClause = "LOWER(P.prod_brand) = LOWER(${HHVar.c})";
        whereArg = searchProduct.marca;
        break;
      case 'word':
        //print("**WORD: ${searchProduct.w1}");
        whereClause = "LOWER(P.prod_word1) = LOWER(${HHVar.c})";
        whereArg = searchProduct.w1;
        break;
      case 'product':
        //print("**PRODUCT: ${searchProduct.w1}");
        whereClause = "LOWER(P.prod_ean) = LOWER(${HHVar.c})";
        whereArg = searchProduct.w1;
        break;
      default:
        throw Exception("Invalid search type: ${searchProduct.searchType}");
    }
    
    await insertTerm(whereArg, searchProduct.searchType);

    String sqlQuery = """
      SELECT 
          P.prod_ean,  P.prod_name, P.prod_image,  P.prod_brand, P.sigla, P.prod_unit, 
          P.prod_vol, P.prod_word1, P.prod_word2, P.prod_word3, P.prod_word4, 
          PR.prod_price
      FROM 
          Product AS P
      INNER JOIN (
          SELECT prod_ean, prod_price, price_uf, MIN(price_atual) as min_price_atual
          FROM  Price
          GROUP BY  prod_ean, price_uf
      ) AS PR ON P.prod_ean = PR.prod_ean
      WHERE 
          $whereClause
          AND PR.price_uf = ${HHVar.c}
          AND P.image_valid = 1;
    """;

    List<String> arguments = [
      whereArg,
      HHGlobals.HHUser.uf,
    ];

    var results = await _dbService.query(sqlQuery, arguments);

    List<EanModel> productList = [];
    for (var row in results) {
      EanModel eanModel = EanModel(
        ean: row['prod_ean'].toString(),
        nome: row['prod_name'].toString(),
        imagem: row['prod_image'].toString(),
        marca: row['prod_brand'].toString(),
        unidade: row['prod_unit'].toString(),
        volume: row['prod_vol'].toString(),
        w1: row['prod_word1'].toString(),
        w2: row['prod_word2'].toString(),
        w3: row['prod_word3'].toString(),
        w4: row['prod_word4'].toString(),
        sigla: row['sigla'].toString(),
        preco: row['prod_price'].toString(),
        link: "", // Assume que 'link' é preenchido em outro lugar
        //searchType: searchProduct.searchType,
      );
      productList.add(eanModel);
    }

    return productList;
  }*/


  /*Future<List<EanModel>> getProductsForGridV2(SearchModel searchProduct) async {
    List<dynamic> arguments = [
      searchProduct.sigla,  // sigla é o parâmetro necessário
      HHGlobals.HHUser.uf,  // fornecendo o valor para price_uf
      HHVar.GridLimit       // limite de resultados (exemplo)
    ];

    // Chamar a procedure diretamente
    var results = await _dbService.query('CALL GetProductsForGrid(?, ?, ?)', arguments);

    List<EanModel> productList = [];
    for (var row in results) {
      EanModel eanModel = EanModel(
        ean: row['prod_ean'].toString(),
        nome: row['prod_name'].toString(),
        imagem: row['prod_image'].toString(),
        marca: row['prod_brand'].toString(),
        unidade: row['prod_unit'].toString(),
        volume: row['prod_vol'].toString(),
        w1: row['prod_word1'].toString(),
        w2: row['prod_word2'].toString(),
        w3: row['prod_word3'].toString(),
        w4: row['prod_word4'].toString(),
        sigla: row['sigla'].toString(),
        preco: row['prod_price'].toString(),
        link: "", // Assume que 'link' é preenchido em outro lugar
        //searchType: searchProduct.searchType,
      );
      productList.add(eanModel);
    }

    return productList;
}*/






