import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:hh_2/src/config/common/var/hh_var.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/search_model.dart';

class DBSearch {
  final DBService _dbService = DBService();

  ///////////////////
  //SEARCH BY ALL
  Future<List<SearchModel>> searchByAll(String term) async {

    //await insertTerm(term, "");
    
    List<SearchModel> resultList = [];

    // 1- Buscar por categorias
    List<SearchModel> categoryResults = await searchCategory(term);
    resultList.addAll(categoryResults);

    // 2- Buscar por palavras-chave
    List<SearchModel> wordResults = await searchWords(term);
    resultList.addAll(wordResults);

    // 3- Buscar por palavras-chave
    List<SearchModel> brandResults = await searchBrands(term);
    resultList.addAll(brandResults);

    // 4- Buscar por produtos
    //List<SearchModel> productResults = await searchProducts(term);
    //resultList.addAll(productResults);

    return resultList;
  }


  /////////////////////
  // 1- SEARCH CATEGORIES
  Future<List<SearchModel>> searchCategory(String term) async {
    var sql = '''
      SELECT sigla, cat0, cat1, cat2
      FROM Cat_VW 
      WHERE LOWER(cat0) LIKE (${HHVar.c}) OR LOWER(cat1) LIKE LOWER(${HHVar.c}) OR LOWER(cat2) LIKE LOWER(${HHVar.c})
      ''';
    String searchWithWildcards = '%$term%';
    List<String> arguments = List.filled(3, searchWithWildcards);
    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
    for (var row in results) {
      SearchModel searchModel = SearchModel(
        sigla: row['sigla'].toString(),
        sig0: row['cat0'].toString(),
        sig1: row['cat1'].toString(),
        sig2: row['cat2'].toString(),
        searchType: "category",
      );
      resultList.add(searchModel);
    }

    return resultList;
  }


  ////////////////////
  // 2- SEARCH WORDS
  Future<List<SearchModel>> searchWords(String term) async {
    var sql = '''
      SELECT prod_word1
      FROM ProdWord_VW 
      WHERE LOWER(prod_word1) LIKE LOWER(${HHVar.c})
      ''';
    String searchWithWildcards = '%$term%';
    List<String> arguments = [searchWithWildcards];
    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
    for (var row in results) {
      SearchModel searchModel = SearchModel(
        w1: row['prod_word1'].toString(),
        searchType: "word"
      );
      resultList.add(searchModel);
    }

    return resultList;
  }


  ////////////////////
  // 3- SEARCH BRANDS
  Future<List<SearchModel>> searchBrands(String term) async {
    var sql = '''
      SELECT prod_brand
      FROM ProdBrand_VW 
      WHERE LOWER(prod_brand) LIKE LOWER(${HHVar.c})
      ''';
    String searchWithWildcards = '%$term%';
    List<String> arguments = [searchWithWildcards];
    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
    for (var row in results) {
      SearchModel searchModel = SearchModel(
        marca: row['prod_brand'].toString(),
        searchType: "brand",
      );
      resultList.add(searchModel);
    }

    return resultList;
  }

  ////////////////////////
  // 4- SEARCH PRODUCTS BY NAME
  Future<List<SearchModel>> searchProductsByName(String term, int limit) async {
    var sql = '''
      SELECT 
        prod_ean, prod_name, prod_image, prod_brand, prod_unit, prod_vol, 
        prod_word1, prod_word2, prod_word3, prod_word4, sigla, cat0, cat1, cat2, hint_status
      FROM 
        ProdCat_VW 
      WHERE 
        image_valid = 1 AND
        LOWER(prod_name) LIKE LOWER(${HHVar.c}) 
      ORDER BY 
        prod_name
      LIMIT ${HHVar.c};
      ''';

    String searchWithWildcards = '$term%';

    List<String> arguments = [searchWithWildcards, limit.toString()];

    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
    for (var row in results) {
      SearchModel searchModel = SearchModel(
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
        sig0: row['cat0'].toString(),
        sig1: row['cat1'].toString(),
        sig2: row['cat2'].toString(),
        hintStatus: int.parse(row['hint_status'].toString()),
        searchType: "product",
        // Assume que 'preco' e 'link' são preenchidos em outro lugar
        preco: "",  
        link: "",
      );
      resultList.add(searchModel);
    }

    return resultList;
  }

  ////////////////////////
  // 5- SEARCH PRODUCTS BY EAN
  Future<List<EanModel>> searchProductsbyEan(String term, int limit) async {
    var sql = '''
      SELECT 
        prod_ean, prod_name, prod_image, prod_brand, prod_unit, prod_vol, 
        prod_word1, prod_word2, prod_word3, prod_word4, sigla, cat0, cat1, cat2, hint_status
      FROM 
        ProdCat_VW 
      WHERE 
        image_valid = 1 AND
        LOWER(prod_ean) LIKE LOWER(${HHVar.c}) 
      ORDER BY 
        prod_name
      LIMIT ${HHVar.c};
      ''';

    String searchWithWildcards = '$term%';

    List<String> arguments = [searchWithWildcards, limit.toString()];

    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
    for (var row in results) {
      SearchModel searchModel = SearchModel(
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
        sig0: row['cat0'].toString(),
        sig1: row['cat1'].toString(),
        sig2: row['cat2'].toString(),
        hintStatus: int.parse(row['hint_status'].toString()),
        searchType: "product",
        // Assume que 'preco' e 'link' são preenchidos em outro lugar
        preco: "",  
        link: "",
      );
      resultList.add(searchModel);
    }

    return resultList;
  }

  //QUASE IGUAL A FUNÇÂO DE DBGRID: getProductsForGrid
  // A mudar ainda
  // Aqui vai entrar a função de distancia 

  Future<List<EanModel>> searchProduct(SearchModel searchProduct) async {
    String whereClause;
    List<String> whereArg;

    //print("**SEARCH: ${searchProduct.searchType}");

    switch (searchProduct.searchType) {
      case 'category':
        //print("**CAT: ${searchProduct.sigla}");
        whereClause = "LOWER(P.sigla) = LOWER(${HHVar.c})";
        whereArg = [searchProduct.sigla, HHGlobals.HHUser.uf,];
        break;
      case 'brand':
        //print("**BRAND: ${searchProduct.marca}");
        whereClause = "LOWER(P.prod_brand) = LOWER(${HHVar.c})";
        whereArg = [searchProduct.marca, HHGlobals.HHUser.uf,];
        break;
      case 'word':
        //print("**WORD: ${searchProduct.w1}");
        whereClause = "LOWER(P.prod_word1) = LOWER(${HHVar.c})";
        whereArg = [searchProduct.w1, HHGlobals.HHUser.uf,];
        break;
      case 'product': 
        //print("**PRODUCT: ${searchProduct.w1}");
        List<String> palavras = searchProduct.nome.split(' ');
        whereClause = "LOWER(P.prod_name) LIKE LOWER(${HHVar.c})";
        String nomeArg = palavras.map((palavra) => '$palavra%').join();
        whereArg = [nomeArg, HHGlobals.HHUser.uf,];
        //print("WHEREARGS: $whereArg");
        break;
      case 'ean':
        whereClause = "LOWER(P.prod_ean) = LOWER(${HHVar.c})";
        whereArg = [searchProduct.ean, HHGlobals.HHUser.uf,];
        break;
      case 'prod_cat':
        whereClause =  "LOWER(P.prod_name) LIKE LOWER(${HHVar.c})  AND P.sigla LIKE ${HHVar.c}";
        List<String> palavras = searchProduct.nome.split(' ');
        String nomeArg = palavras.map((palavra) => '$palavra%').join();
        String siglaArg = '${searchProduct.sigla[0]}%';  ///ATENÇÃO: CATEGORIA: H% E% P% ...
        whereArg = [nomeArg, siglaArg, HHGlobals.HHUser.uf,];
        break;
      default:
        throw Exception("Invalid search type: ${searchProduct.searchType}");
    }

    String sqlQuery = """
      SELECT 
          P.prod_ean,  P.prod_name, P.prod_image,  P.prod_brand, P.sigla, P.prod_unit, 
          P.prod_vol, P.prod_word1, P.prod_word2, P.prod_word3, P.prod_word4, P.hint_status
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
          AND P.image_valid = 1
      ORDER BY P.prod_name 
      LIMIT 1;
    """;
    //////////////////////////////////////
    // AQUI VAI ESTAR O SEGREDO 
    //////////////////////////////////

    var results = await _dbService.query(sqlQuery, whereArg);

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
        hintStatus: int.parse(row['hint_status'].toString()),
        link: "", // Assume que 'link' é preenchido em outro lugar
        //searchType: searchProduct.searchType,
      );
      //print(eanModel.toString());
      productList.add(eanModel);
    }

    return productList;
  }



////////////////////////////////////////////////////////
//////// NOVA SEARCH com PROCEDURES --- 24/11/23
///////////////////////////////////////////////////////
Future<List<EanModel>> searchProductV2(SearchModel searchProduct, int inputLimit) async {
    final List<dynamic> arguments;

     // Verificando o tipo de pesquisa e configurando os argumentos
    if (searchProduct.searchType == 'prod_cat') {
        arguments = [
            HHGlobals.HHUser.userId,
            searchProduct.searchType,
            searchProduct.nome, // Nome do produto
            searchProduct.sigla, // Categoria do produto
            inputLimit
        ];
    } else {
        // Adicionando um valor secundário padrão como string vazia para garantir que sempre enviamos 5 argumentos
        arguments = [
            HHGlobals.HHUser.userId,
            searchProduct.searchType,
            searchProduct.searchType == 'ean' ? searchProduct.ean :
            searchProduct.searchType == 'product' ? searchProduct.nome :
            searchProduct.searchType == 'category' ? searchProduct.sigla :
            searchProduct.searchType == 'brand' ? searchProduct.marca :
            searchProduct.searchType == 'word' ? searchProduct.w1 :
            "", // valor padrão
            "", // valor secundário padrão
            inputLimit // limite padrão
        ];
    }

    //print("SEARCHPRODUCTV2:::  ${searchProduct.searchType} ==> $arguments");

    // Chamar a procedure diretamente
    final results = await _dbService.query('CALL GetClosestProductsByCriteriaV2(?, ?, ?, ?, ?)', arguments);

  

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
            hintStatus: int.parse(row['hint_status'].toString()),
            link: "", // Assume que 'link' é preenchido em outro lugar
            //searchType: searchProduct.searchType, // Removido pois não estava no modelo EanModel fornecido
        );
        //print("SEARCHRESULT:: ${eanModel.toString()}");
        productList.add(eanModel);
    }

  
    _dbService.query('CALL CalculateUserProfileForSpecificUser(?);', [HHGlobals.HHUser.userId]);
    //_dbService.query('CALL CalculateAllUserProfiles()', []);
    //_dbService.query('CALL CalculateWeightedUserProfiles(?, ?, ?, ?)', [2,0.5,0.5,0.5]);

    return productList;
}



////////////////////////////////////////////////////////
//////// NOVA SEARCH com PROCEDURES --- 24/08/23
///////////////////////////////////////////////////////
/*Future<List<EanModel>> searchProductV2(SearchModel searchProduct, int inputLimit) async {
    List<dynamic> arguments = [
        HHGlobals.HHUser.userId,
        searchProduct.searchType,
        // Dependendo do tipo de pesquisa, o valor do critério pode variar
        (searchProduct.searchType == 'ean') ? searchProduct.ean :
        (searchProduct.searchType == 'product') ? searchProduct.nome :
        (searchProduct.searchType == 'category') ? searchProduct.sigla :
        (searchProduct.searchType == 'brand') ? searchProduct.marca :
        (searchProduct.searchType == 'word') ? searchProduct.w1 :
        (searchProduct.searchType == 'prod_cat') ? '${searchProduct.nome},${searchProduct.sigla}' :
        "", // valor padrão
        inputLimit // limite padrão; você pode alterar conforme necessário
    ];

    //print("SEARCHPRODUCTV2:::  ${searchProduct.searchType} ==> $arguments");

    // Chamar a procedure diretamente
    var results = await _dbService.query('CALL GetClosestProductsByCriteria(?, ?, ?, ?)', arguments);

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
            hintStatus: int.parse(row['hint_status'].toString()),
            link: "", // Assume que 'link' é preenchido em outro lugar
            //searchType: searchProduct.searchType, // Removido pois não estava no modelo EanModel fornecido
        );
        //print("SEARCHRESULT:: ${eanModel.toString()}");
        productList.add(eanModel);
    }

  
    _dbService.query('CALL CalculateUserProfileForSpecificUser(?);', [HHGlobals.HHUser.userId]);
    //_dbService.query('CALL CalculateAllUserProfiles()', []);
    //_dbService.query('CALL CalculateWeightedUserProfiles(?, ?, ?, ?)', [2,0.5,0.5,0.5]);

    return productList;
}
*/


  Future<void> insertTerm(String term, String search_type) async {
    var sql = '''
      INSERT INTO Term(user_id, basket_id, term_string, term_date, search_type)
      VALUES (${HHVar.c}, ${HHVar.c}, ${HHVar.c}, CONVERT_TZ(UTC_TIMESTAMP(), '+00:00', '-03:00'), ${HHVar.c})
    ''';
    DateTime now = DateTime.now(); // Obter a data e hora atuais
    List<dynamic> arguments = [HHGlobals.HHUser.userId, HHGlobals.HHBasket.value.basket_id, term, search_type];
    await _dbService.query(sql, arguments);
  }


}

  //v3 
  /*
  Future<List<SearchModel>> searchSearchModelList(String searchString) async {
    List<SearchModel> list = [];

    // Split the search string into words
    List<String> terms = searchString.split(" ");

    String sql = '''
    SELECT 
      prod_ean, prod_name, prod_image, prod_brand, prod_unit, prod_vol, 
      prod_word1, prod_word2, prod_word3, prod_word4, sigla, cat0, cat1, cat2
    FROM 
      ProdCat_VW
    WHERE
    ''';

    // Dynamically construct the WHERE clause
    String whereClause = "";
    for (var term in terms) {
      whereClause += '''
      "(LOWER(prod_name) LIKE LOWER('%$term%') OR LOWER(prod_brand) LIKE LOWER('%$term%') OR 
        LOWER(cat0) LIKE LOWER('%$term%') OR LOWER(cat1) LIKE LOWER('%$term%') OR 
        LOWER(cat2) LIKE LOWER('%$term%') OR LOWER(prod_word1) LIKE LOWER('%$term%') OR 
        LOWER(prod_word2) LIKE LOWER('%$term%') OR LOWER(prod_word3) LIKE LOWER('%$term%') OR 
        LOWER(prod_word4) LIKE LOWER('%$term%')) AND
      ''';
    }
    // Remove the last "AND "
    whereClause = whereClause.substring(0, whereClause.length - 4);

    // Complete the SQL statement
    sql += whereClause;
    sql += '''
    ORDER BY 
      (CASE 
        WHEN LOWER(cat0) LIKE LOWER('%$searchString%') THEN 1
        WHEN LOWER(cat1) LIKE LOWER('%$searchString%') THEN 2
        WHEN LOWER(cat2) LIKE LOWER('%$searchString%') THEN 3
        WHEN LOWER(prod_word1) LIKE LOWER('%$searchString%') THEN 4
        WHEN LOWER(prod_brand) LIKE LOWER('%$searchString%') THEN 5
        WHEN LOWER(prod_name) LIKE '$searchString' THEN 6
        WHEN LOWER(prod_name) LIKE LOWER('%$searchString%') THEN 7
        ELSE 8 
      END),
      prod_name
    ''';

    print(sql);

    var results = await _dbService.rawQuery(sql);

    List<SearchModel> resultList = [];
        for (var row in results) {
          SearchModel searchModel = SearchModel(
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
            sig0: row['cat0'].toString(),
            sig1: row['cat1'].toString(),
            sig2: row['cat2'].toString(),
            // Assume que 'preco' e 'link' são preenchidos em outro lugar
            preco: "",  
            link: "",
          );
          resultList.add(searchModel);
        }

    print(resultList.length);
    print(resultList);
    return resultList;
  }
*/

  //v2
  /*Future<List<SearchModel>> searchProducts(String term) async {
    var sql = '''
    SELECT 
      prod_ean, prod_name, prod_image, prod_brand, prod_unit, prod_vol, 
      prod_word1, prod_word2, prod_word3, prod_word4, sigla, cat0, cat1, cat2,
      ((cat0 LIKE ?) +
      (cat1 LIKE ?) +
      (cat2 LIKE ?) +
      (prod_word1 LIKE ?) +
      (prod_brand LIKE ?) +
      (prod_name LIKE ?) +
      (prod_name LIKE ?)) as relevance
    FROM 
      ProdCat_VW 
    WHERE 
      prod_name LIKE ? OR prod_brand LIKE ? OR cat0 LIKE ? OR cat1 LIKE ? OR cat2 LIKE ?
      OR prod_word1 LIKE ? OR prod_word2 LIKE ? OR prod_word3 LIKE ? OR prod_word4 LIKE ?
    ORDER BY 
      relevance DESC,
      (CASE 
        WHEN cat0 LIKE ? THEN 1
        WHEN cat1 LIKE ? THEN 2
        WHEN cat2 LIKE ? THEN 3
        WHEN prod_word1 LIKE ? THEN 4
        WHEN prod_brand LIKE ? THEN 5
        WHEN prod_name LIKE ? THEN 6
        WHEN prod_name LIKE ? THEN 7
        ELSE 8 
      END),
      prod_name;
    ''';

    String searchWithWildcards = '%$term%';
    String searchExact = 'term';

    List<String> arguments = List.filled(23, searchWithWildcards);
    arguments[5] = arguments[21] = searchExact;

    var results = await _dbService.query(sql, arguments);

    List<SearchModel> resultList = [];
        for (var row in results) {
          SearchModel searchModel = SearchModel(
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
            sig0: row['cat0'].toString(),
            sig1: row['cat1'].toString(),
            sig2: row['cat2'].toString(),
            // Assume que 'preco' e 'link' são preenchidos em outro lugar
            preco: "",  
            link: "",
          );
          resultList.add(searchModel);
        }

    print(resultList.length);
    print(resultList);
    return resultList;
  }
  */

  //v1
  /*
  Future<List<EanModel>> searchEanModelList(String term) async {
    final result = await _dbService.query('''
      SELECT * 
      FROM ProdCat_VW
      WHERE prod_name LIKE ? 
        OR prod_brand LIKE ? 
        OR cat0 LIKE ? 
        OR cat1 LIKE ? 
        OR cat2 LIKE ? 
        OR prod_word1 LIKE ? 
        OR prod_word2 LIKE ? 
        OR prod_word3 LIKE ? 
        OR prod_word4 LIKE ?
      ''', ['%$term%', '%$term%', '%$term%', '%$term%', '%$term%', '%$term%', '%$term%', '%$term%', '%$term%']);
    
    List<EanModel> resultList = [];
    for (var row in result) {
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
        sig0: row['cat0'].toString(),
        sig1: row['cat1'].toString(),
        sig2: row['cat2'].toString(),
        // Assume que 'preco' e 'link' são preenchidos em outro lugar
        preco: "",  
        link: "",
      );
      resultList.add(eanModel);
    }

    print(resultList.length);
    print(resultList);
    return resultList;
  }
  */

  //v0
  /*
  Future<List<Map<int, dynamic>>> search(String term) async {
    term = '%$term%'; // Prepara o termo para busca por qualquer parte da string
    
    // Cria a consulta
    var sql = '''
    SELECT *
    FROM ProdCat_VW
    WHERE prod_name LIKE ? OR prod_brand LIKE ? OR cat0 LIKE ? OR cat1 LIKE ? OR cat2 LIKE ? OR prod_word1 LIKE ? OR prod_word2 LIKE ? OR prod_word3 LIKE ? OR prod_word4 LIKE ?
    ''';

    // Realiza a consulta

    var result = await _dbService.query(sql, [term, term, term, term, term, term, term, term, term]);

    // Transforma o resultado em uma lista de mapas
    var list = result.map((row) => row.asMap()).toList();

    print(list.length);
    print(list);

    return list;
  }
*/




