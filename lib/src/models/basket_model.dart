import 'package:flutter/material.dart';
//import 'package:hh_2/src/config/ai/ai_xerxes.dart';
import 'package:hh_2/src/config/common/var/hh_notifiers.dart';
import 'package:hh_2/src/config/db/db_basket.dart';
import 'package:hh_2/src/config/db/db_service.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:flutter/foundation.dart';


enum SourceOrigin {
  G, //grid
  S, //search
  R, //recipe
  H, //historic
  B, //book
  P, //periodic
  F, //foto (photo)
  // add more as necessary
}

enum HintStatus {
  I, // initial (potential for recipe)
  S, // suggested (came as a suggested ingredient)
  N, // not in list (not a ingredient)
  U, // used (initial product in recipe)
  // add more as necessary
}

class EanInfo {
  SourceOrigin sourceOrigin;
  HintStatus hintStatus;

  EanInfo({required this.sourceOrigin, required this.hintStatus});
}


class BasketModel extends ChangeNotifier{
  List<EanModel> products = [];
  Map<EanModel, int> productQuantities = {};
  Map<EanModel, EanInfo> productInfo = {};
  Function(double)? _onBasketChanged;
  ValueNotifier<double> totalPriceNotifier = ValueNotifier<double>(0);
  int basket_id = 0;
  int user_id = 0;
  int? cartLastPressed;
  DateTime? basketTime;

  // Adicione uma instância de DBBasket
  final DBBasket _dbBasket = DBBasket(DBService());
  //final Xerxes xerxes = Xerxes();

  BasketModel();

  @override
  String toString() {
    return 'BasketModel('
      'products: [${products.map((product) => '${product.nome} (SourceOrigin: ${productInfo[product]?.sourceOrigin}, HintStatus: ${productInfo[product]?.hintStatus})').join(', ')}], '
      'basket_id: $basket_id, '
      'user_id: $user_id, '
      'cartLastPressed: $cartLastPressed, '
      'basketTime: $basketTime'
    ')';
  }

  bool containsProduct(EanModel prodContains) {

    for (EanModel product in products){
      if(product.ean == prodContains.ean) return true;
    }
    return false;
    //return products.contains(product);
  }

  EanInfo getProductInfo(EanModel product) {
    return productInfo[product]!;
  }

  bool get isNotEmpty {
    return products.isNotEmpty;
  }


  /// CLEAR BASKET
  void clearBasket() async {
    products.clear();
    // Chamando função de DBBasket
    print("CLEAR BASKET");
    await _dbBasket.clearBasket(basket_id);
    _updateTotalPrice();
    groupProducts();
  }


  //ADD PRODUCT v5
  Future<void> addProduct(EanModel product, SourceOrigin sourceOrigin) async { 
    // Define hintStatus diretamente baseado no valor de hintStatus do produto
    HintStatus hintStatus = product.hintStatus == 1 ? HintStatus.I : HintStatus.N;

    // Se sourceOrigin for H, B ou R, hintStatus será S
    if (sourceOrigin == SourceOrigin.H || sourceOrigin == SourceOrigin.B || sourceOrigin == SourceOrigin.R) {
      hintStatus = HintStatus.S;
    }

    // Verifica se o produto já está na lista, se sim adiciona, senão insere no início
    if (containsProduct(product)) {
      products.add(product);
    } else {
      products.insert(0, product); // Adicione o produto no início da lista
    }

    // Atualiza ou insere EanInfo com os valores determinados acima
    productInfo[product] = EanInfo(
      sourceOrigin: sourceOrigin, 
      hintStatus: hintStatus,
    );

    // Outputs para depuração ou confirmação de processos
    print("ADD PRODUCT");
    print(product.toString());

    // Atualiza o preço total e outros estados necessários
    _updateTotalPrice();
    groupProducts();
    _updateBasketCount();
    notifyListeners();

    // Chama a função para armazenar o produto e suas informações no banco de dados
    await _dbBasket.addProduct(
      product, 
      basket_id, 
      productInfo[product]!.sourceOrigin, 
      productInfo[product]!.hintStatus
    );
  }

  //ADD PRODUCT v4
  /*Future<void> addProduct(EanModel product, SourceOrigin sourceOrigin) async { 
    
    // Chame a função ax1 aqui para verificar o status do produto
    String result = await xerxes.ax1(product.nome);
    HintStatus hintStatus;
    
    // Condicional para determinar HintStatus baseado no resultado de ax1
    if (result == 'I') {
      hintStatus = HintStatus.I; // Inicial, potencial para receita
    } else {
      hintStatus = HintStatus.N; // Não é um ingrediente
    }

      // Se sourceOrigin for H, B ou R, hintStatus será S
    if (sourceOrigin == SourceOrigin.H || sourceOrigin == SourceOrigin.B || sourceOrigin == SourceOrigin.R) {
      hintStatus = HintStatus.S;
    }

    if (containsProduct(product)) {
      products.add(product);
    } else {
      products.insert(0, product); // Adicione o produto no início da lista
    }

    // Atualize ou insira EanInfo
    productInfo[product] = EanInfo(
      sourceOrigin: sourceOrigin, 
      hintStatus: hintStatus, // Use o valor determinado acima
    );

    print("ADD PRODUCT");

    
    // Atualize o preço total e outros estados, se necessário
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
    }
    _updateTotalPrice();
    groupProducts();
    _updateBasketCount();
    notifyListeners();

    // Chame o DB para armazenar o produto e suas informações
    await _dbBasket.
          addProduct(
            product, 
            basket_id, 
            productInfo[product]!.sourceOrigin, 
            productInfo[product]!.hintStatus
          );
  }*/



  // Adiciona uma lista de produtos EanModel
  Future<void> addProductList(List<EanModel> productList, SourceOrigin sourceOrigin) async {
    for (EanModel product in productList) {
      print(product.toString());
      addProduct(product, sourceOrigin); // Chamamos a função addProduct já existente para adicionar cada produto
    }
  }

  //REMOVE PRODUCT v3
  Future<void> removeProduct(EanModel product) async {
    int lastIndex = products.lastIndexOf(product);
    if (lastIndex != -1) {
      products.removeAt(lastIndex);
      // Chamando função de DBBasket
      print("REMOVE PRODUCT v2");
      
      if (_onBasketChanged != null) {
        _onBasketChanged!(totalPrice());
      }
      _updateTotalPrice();
      groupProducts();
      _updateBasketCount();
      notifyListeners();
       
      // ultima coisa: DB!
      await _dbBasket.removeProduct(product, basket_id);
    }
  }


  //GROUP PRODUCTS

  //v1
  Map<EanModel, int> groupProducts() {
    productQuantities = {};
    for (EanModel product in products) {
      int index = productQuantities.keys.toList().indexWhere((item) => item.ean == product.ean);
      if (index != -1) {
        EanModel existingProduct = productQuantities.keys.toList()[index];
        productQuantities[existingProduct] = productQuantities[existingProduct]! + 1;
      } else {
        productQuantities[product] = 1;
      }
    }
    //HHNotifiers.counter[CounterType.BasketCount]!.value = productQuantities.length;
    return productQuantities;
  }

  ///REMOVE ALL OF A PRODUCT FROM BASKET
  void removeAllOfProduct(EanModel product) async {
    products.removeWhere((element) => element == product);
    // Chamando função de DBBasket
    print("REMOVE ALL OF A  PRODUCT");
    await _dbBasket.removeAllOfAProduct(product, basket_id);
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
    }
    _updateTotalPrice();
    groupProducts();
    _updateBasketCount();
  }

    // Adiciona uma lista de produtos EanModel
  void removeAllOfProductList(List<EanModel> productList) async {
    for (EanModel product in productList) {
      removeAllOfProduct(product); // Chamamos a função addProduct já existente para adicionar cada produto
    }
  }

  /// CALCUL OF TOTAL PRICE
  double totalPrice() {
    double total = 0;
    Map<EanModel, int> productCountMap = groupProducts();
    for (EanModel product in productCountMap.keys) {
      int count = productCountMap[product]!;
      total += double.parse(product.preco) * count;
    }
    print("TOTAL: $total");
    return total;
  }

  void _updateTotalPrice() {
    totalPriceNotifier.value = totalPrice();
  }

  void _updateBasketCount() {
    HHNotifiers.counter[CounterType.BasketCount]!.value = productQuantities.length;
  }

  void setOnBasketChangedCallback(Function(double) callback) {
    _onBasketChanged = callback;
  }
}


  /*Map<EanModel, int> groupProducts() {
    Map<EanModel, int> productCountMap = {};
    //print("PRODUCTS: $products");
    for (EanModel product in products) {
      if (productCountMap.containsKey(product)) {
        productCountMap[product] = productCountMap[product]! + 1;
      } else {
        productCountMap[product] = 1;
      }
    }
    //print("GROUPPRODUCTS: $productCountMap");
    return productCountMap;
  }*/

  // ... Código existente em BasketModel
  //ADD PRODUCT v3
  /*void addProduct(EanModel product, SourceOrigin sourceOrigin) async {
    if (containsProduct(product)) {
      products.add(product);
    } else {
      products.insert(0, product); // Adicione o produto no início da lista
    }
    // Adicionar SourceOrigin no Map productInfo
    productInfo[product] = EanInfo(
      sourceOrigin: sourceOrigin, // Inclui HHGlobal.HHProdOrigin aqui
      hintStatus: HintStatus.I, // Um valor padrão, altere conforme necessário
    );

    print("ADD PRODUCT v2");
    await _dbBasket.addProduct(product, basket_id, productInfo[product]!.sourceOrigin);
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
    }
    _updateTotalPrice();
    groupProducts();
    _updateBasketCount();
  }*/

  //ADD PRODUCT v2
  /*void addProduct(EanModel product) async {
    containsProduct(product)? 
      products.add(product):
      products.insert(0, product); // Adicione o produto no início da lista
    // Chamando função de DBBasket
    print("ADD PRODUCT v2");
    await _dbBasket.addProduct(product, basket_id);
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
      
    }
    _updateTotalPrice();
    groupProducts();
    _updateBasketCount();
  } */


/*
class BasketModel {
  List<EanModel> products = [];
  Function(double)? _onBasketChanged;
  ValueNotifier<double> totalPriceNotifier = ValueNotifier<double>(0);
  int basket_id = 0;
  int user_id = 0;


  bool containsProduct(EanModel product) {
    return products.contains(product);
  }

  bool get isNotEmpty {
    return products.isNotEmpty;
  }

  /// CLEAR BASKET
  void clearBasket() {
    products.clear();
    _updateTotalPrice();
  }

  //ADD PRODUCT v2
  void addProduct(EanModel product) {
    containsProduct(product)? 
      products.add(product):
      products.insert(0, product); // Adicione o produto no início da lista
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
      
    }
    _updateTotalPrice();
  } /////// NOVO: fila para a esquerda



  //REMOVE PRODUCT v2
  void removeProduct(EanModel product) {
  int lastIndex = products.lastIndexOf(product);
  if (lastIndex != -1) {
    products.removeAt(lastIndex);
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
    }
    _updateTotalPrice();
    }
  }

  //GROUP PRODUCTS
  Map<EanModel, int> groupProducts() {
    Map<EanModel, int> productCountMap = {};
    for (EanModel product in products) {
      if (productCountMap.containsKey(product)) {
        productCountMap[product] = productCountMap[product]! + 1;
      } else {
        productCountMap[product] = 1;
      }
    }
    return productCountMap;
  }


  ///REMOVE ALL OF A PRODUCT FROM BASKET
  void removeAllOfProduct(EanModel product) {
    products.removeWhere((element) => element == product);
    if (_onBasketChanged != null) {
      _onBasketChanged!(totalPrice());
    }
  }

  /// CALCUL OF TOTAL PRICE
  double totalPrice() {
    double total = 0;
    Map<EanModel, int> productCountMap = groupProducts();
    for (EanModel product in productCountMap.keys) {
      int count = productCountMap[product]!;
      total += double.parse(product.preco) * count;
    }
    print("TOTAL: $total");
    return total;
  }

   void _updateTotalPrice() {
    totalPriceNotifier.value = totalPrice();
  }

  void setOnBasketChangedCallback(Function(double) callback) {
    _onBasketChanged = callback;
}

}*/
