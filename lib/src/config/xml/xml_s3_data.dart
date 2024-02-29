import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hh_2/src/config/common/var/hh_address.dart';
import 'package:hh_2/src/models/cat_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/price_model.dart';
import 'package:xml/xml.dart' as xml;
import 'package:hh_2/src/config/common/var/hh_globals.dart';
import 'package:http/http.dart' as http;


class XMLS3Data {
  // Note que agora temos uma função auxiliar para carregar o XML a partir de uma URL
  Future<String> _loadXMLFromURL(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load XML from $url');
    }
  }


// GET PRODUCT MODEL VIA XML
  Future<List<EanModel>> getProductModelFromXML(BuildContext context, /*IA*/ String category, /*IA*/ String uf) async {   //, CategoryModel category
    
    String url = "${HHAddress.urlXml}prods/${category}_PRODS.xml"; //IA
    String xmlString = await _loadXMLFromURL(url);
    //String path = "assets/xml/prods/${category}_PRODS.xml"; //IA
    //String xmlString = await DefaultAssetBundle.of(context).loadString(path);
    final raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements("PRODUCT");
    List<PriceModel> filteredPrices = await getFilteredPrices(context, category, uf);//IA
      
    Set<String> eansInFilteredPrices = filteredPrices.map((price) => price.ean).toSet(); // Cria um Set com todos os EANs dos preços filtrados
    
    return elements.map((element){
    String ean = element.findElements("EAN").first.text;
    
    if (eansInFilteredPrices.contains(ean)) {
       List<PriceModel> eanPrices = filteredPrices.where((price) => price.ean == ean).toList();
      eanPrices.sort((a, b) => int.parse(a.atual).compareTo(int.parse(b.atual)));
      //String price = eanPrices.isNotEmpty ? eanPrices.first.price : "0";
      String price = eanPrices.isNotEmpty ? eanPrices.first.price as String : "0";


      return EanModel(
        ean: ean,
        marca: element.findElements("MARCA").first.text,
        link: element.findElements("LINK").first.text,
        imagem: element.findElements("IMAGEM").first.text,
        nome: element.findElements("NOME").first.text,
        sigla: element.findElements("SIGLA").first.text,
        sig0: element.findElements("SIG0").first.text,
        sig1: element.findElements("SIG1").first.text,
        sig2: element.findElements("SIG2").first.text,
        w1: element.findElements("W1").first.text,
        w2: element.findElements("W2").first.text,
        w3: element.findElements("W3").first.text,
        w4: element.findElements("W4").first.text,
        volume: element.findElements("VOLUME").first.text,
        unidade: element.findElements("UNIDADE").first.text,
        preco: price,//IA
      );
    }
    }).where((product) => product != null).map((product) => product!).toList(); // Filtra produtos nulos e remove nulos da lista antes de retorná-la
  }



  // GET PRODUCT PRICE VIA XML
  Future<List<PriceModel>> getProductPriceFromXML(BuildContext context, String category, String uf) async {
 
    String url = "${HHAddress.urlXml}prices/P_${category}_$uf.xml"; //IA
    String xmlString = await _loadXMLFromURL(url);
    //String path = "assets/xml/prices/P_${category}_$uf.xml";
    //String xmlString = await DefaultAssetBundle.of(context).loadString(path);
    final raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements("PRODUCT");
    return elements.map((element){
      String ean = element.findElements("EAN").first.text;
      String price =  element.findElements("PRECO").first.text;
      String atual = element.findElements("ATUALIZACAO").first.text;
      return PriceModel(
        ean: ean,
        price: price,
        uf: uf,//
        atual: atual,
      );
    }).toList();
  }


  // GET FILTERED PRICES VIA XML
  Future<List<PriceModel>> getFilteredPrices(BuildContext context, String category, String uf) async {
    List<PriceModel> prices = await getProductPriceFromXML(context, category, uf);
    List<PriceModel> filteredPrices = prices.where((price) => price.uf == uf).toList(); // Removida a condição price.ean.startsWith(category)
    return filteredPrices;
  }



  Future loadCatModelXml() async {
    String asset = "assets/xml/HH_CAT.xml";
    List<CatModel> listCat = await XMLS3Data().getCatModelAssetXML(asset);
    HHGlobals.listCat = listCat;
  }

// GET CATMODEL VIA XML - ASSET(v5)
  Future<List<CatModel>> getCatModelAssetXML(String assetPath) async {
    final xmlString = await rootBundle.loadString(assetPath);
    final raw = xml.XmlDocument.parse(xmlString);
    final elements = raw.findAllElements('CAT0');
    if (elements.isEmpty) {
    }

    List<CatModel> catModels = [];
    for (var element in elements) {
      catModels.add(await _parseCat(element, 0));  /// LOOP HERE
    }
    return catModels;
  }

  Future<CatModel> _parseCat(xml.XmlElement xmlElement, int level, {String? prevColor}) async {
    //print('Parsing CatModel at level $level');

    String nom = xmlElement.findElements('NOM$level').single.text;
    String sig = xmlElement.findElements('SIG$level').single.text;
    String emj = xmlElement.findElements('EMJ$level').single.text;
    int ord = int.parse(xmlElement.findElements('ORD$level').single.text);
    String cor = xmlElement.findElements('COR$level').isEmpty ? prevColor! : xmlElement.findElements('COR$level').single.text;
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);
    String? sigla = level == 2 ? xmlElement.findElements('SIGLA').single.text : null;

    List<CatModel> subCats = [];
    var subElements = xmlElement.findElements('CATS${level + 1}');

    if (subElements.isNotEmpty) {
      var catElements = subElements.single.findElements('CAT${level + 1}');
      for (var subElement in catElements) {
        subCats.add(await _parseCat(subElement, level + 1, prevColor: cor));
      }
    }

    //print('Finished processing all subelements do level ${level + 1}');

    return CatModel(
      nom: nom,
      sig: sig,
      emj: emj,
      ord: ord,
      color: color,
      sigla: sigla,
      subCats: subCats,
      level: level,
    );
  }


}


  // GET CATEGORYMODEL VIA XML (v1)
  /*Future<List<CategoryModel>> getCategoryFromXML(BuildContext context) async {
  
    String url = "${HHAddress.urlXml}db/HH_CATEGORIAS.xml"; //IA
    String xmlString = await _loadXMLFromURL(url);

    //String path = "assets/xml/db/HH_CATEGORIAS.xml";
    //String xmlString = await DefaultAssetBundle.of(context).loadString(path);

    final raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements("CAT");

    return elements.map((element){
      return CategoryModel(
        element.findElements("CAT0").first.text,
        element.findElements("CAT1").first.text,
        element.findElements("CAT2").first.text,
        element.findElements("NMCAT").first.text,
        element.findElements("SIG0").first.text,
        element.findElements("SIG1").first.text,
        element.findElements("SIG2").first.text,
        element.findElements("SIGLA").first.text,
      );
    }).toList();
  }*/


  // GET CATMODEL VIA XML - URL(v2)
  /* Future<List<CatModel>> getCatModelUrlXML(String url) async {
    final response = await http.get(Uri.parse(url));
    final raw = xml.XmlDocument.parse(response.body);
    final elements = raw.findAllElements('CAT0');
    return elements.map((item) => _parseCat(item, 0)).toList();
  }*/

  /*CatModel _parseCat(xml.XmlElement xmlElement, int level) {
    String cor = xmlElement.findElements('COR').single.text;
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);

    return CatModel(
      nom: xmlElement.findElements('NOM${level.toString()}').single.text,
      sig: xmlElement.findElements('SIG${level.toString()}').single.text,
      emj: xmlElement.findElements('EMJ${level.toString()}').single.text,
      ord: int.parse(xmlElement.findElements('ORD${level.toString()}').single.text),
      color: color,
      sigla: level == 2 ? xmlElement.findElements('SIGLA').single.text : null,
      subCats: xmlElement.findElements('CATS${(level + 1).toString()}').isEmpty
        ? []
        : xmlElement.findElements('CATS${(level + 1).toString()}').single.findElements('CAT${(level + 1).toString()}').map((item) => _parseCat(item, level + 1)).toList(),
      level: level,
    );
  }*/

  // GET CATMODEL VIA XML - ASSET(v3)
  /*Future<List<CatModel>> getCatModelAssetXML(String assetPath) async {
    final xmlString = await rootBundle.loadString(assetPath);
    final raw = xml.XmlDocument.parse(xmlString);
    //print(raw);
    final elements = raw.findAllElements('CAT0');
    //print(elements);
    print('Loaded ${elements.length} CAT0 elements');
    return elements.map((item) => _parseCat(item, 0)).toList();
  }

  CatModel _parseCat(xml.XmlElement xmlElement, int level) {
    String cor = xmlElement.findElements('COR').single.text;
    print('LEVEL $level');
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);

    return CatModel(
      nom: xmlElement.findElements('NOM${level.toString()}').single.text,
      sig: xmlElement.findElements('SIG${level.toString()}').single.text,
      emj: xmlElement.findElements('EMJ${level.toString()}').single.text,
      ord: int.parse(xmlElement.findElements('ORD${level.toString()}').single.text),
      color: color,
      sigla: level == 2 ? xmlElement.findElements('SIGLA').single.text : null,
      subCats: xmlElement.findElements('CATS${(level + 1).toString()}').isEmpty
        ? []
        : xmlElement.findElements('CATS${(level + 1).toString()}').single.findElements('CAT${(level + 1).toString()}').map((item) => _parseCat(item, level + 1)).toList(),
      level: level,
    );
  }*/


// GET CATMODEL VIA XML - ASSET(v4)
/*Future<List<CatModel>> getCatModelAssetXML(String assetPath) async {
  print('Loading XML from $assetPath');
  final xmlString = await rootBundle.loadString(assetPath);
  final raw = xml.XmlDocument.parse(xmlString);
  final elements = raw.findAllElements('CAT0');
  print('Found ${elements.length} CAT0 elements');
  if (elements.isEmpty) {
    print('No CAT0 elements found, _parseCat will not be called');
  }
  var catModels = elements.map((item) => _parseCat(item, 0)).toList();
  print('Parsed ${catModels.length} CatModels');
  return catModels;
}

CatModel _parseCat(xml.XmlElement xmlElement, int level) {
  String nom = xmlElement.findElements('NOM$level').single.text;
  String sig = xmlElement.findElements('SIG$level').single.text;
  String emj = xmlElement.findElements('EMJ$level').single.text;
  int ord = int.parse(xmlElement.findElements('ORD$level').single.text);
  String cor = xmlElement.findElements('COR$level').single.text;
  Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);
  String? sigla = level == 2 ? xmlElement.findElements('SIGLA').single.text : null;
  
  List<CatModel> subCats = xmlElement.findElements('CATS${level + 1}').isEmpty
      ? []
      : xmlElement.findElements('CATS${level + 1}').single.findElements('CAT${level + 1}').map((item) => _parseCat(item, level + 1)).toList();

  print('Creating CatModel with values:');
  print('nom: $nom');
  print('sig: $sig');
  print('emj: $emj');
  print('ord: $ord');
  print('color: $color');
  print('sigla: $sigla');
  print('subCats count: ${subCats.length}');
  print('level: $level');

  return CatModel(
    nom: nom,
    sig: sig,
    emj: emj,
    ord: ord,
    color: color,
    sigla: sigla,
    subCats: subCats,
    level: level,
  );
}*/

  //v7
  /*Future<CatModel> _parseCat(xml.XmlElement xmlElement, int level) async {
      print('Parsing CatModel at level $level');

      String nom = xmlElement.findElements('NOM$level').single.text;
      String sig = xmlElement.findElements('SIG$level').single.text;
      String emj = xmlElement.findElements('EMJ$level').single.text;
      int ord = int.parse(xmlElement.findElements('ORD$level').single.text);
      String cor = xmlElement.findElements('COR$level').single.text;
      Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);
      String? sigla = level == 2 ? xmlElement.findElements('SIGLA').single.text : null;

      List<CatModel> subCats = [];
      var subElements = xmlElement.findElements('CATS${level + 1}');

      print('   Creating CatModel with values:');
      print('   nom: $nom');
      print('   sig: $sig');
      print('   emj: $emj');
      print('   ord: $ord');
      print('   color: $color');
      print('   sigla: $sigla');
      print('   level: $level');

      if (subElements.isNotEmpty) {
        print('Found ${subElements.length} CATS${level + 1} elements');
        var catElements = subElements.single.findElements('CAT${level + 1}');
        print('Found ${catElements.length} CAT${level + 1} elements');
        for (var subElement in catElements) {
          print('Processing subelement do level ${level + 1}');
          print('  ${level + 1}: ${subElement.toString()}');
          subCats.add(await _parseCat(subElement, level + 1)); /// LOOP HERE
          print('Finished processing subelement do level ${level + 1}');
        }
        print('Finished processing all subelements do level ${level + 1}');
      }

      print('subCats count: ${subCats.length}');

      return CatModel(
        nom: nom,
        sig: sig,
        emj: emj,
        ord: ord,
        color: color,
        sigla: sigla,
        subCats: subCats,
        level: level,
      );
    }*/
  //v6
  /*Future<CatModel> _parseCat(xml.XmlElement xmlElement, int level) async {
    print('Parsing CatModel at level $level');

    String nom = xmlElement.findElements('NOM$level').single.text;
    String sig = xmlElement.findElements('SIG$level').single.text;
    String emj = xmlElement.findElements('EMJ$level').single.text;
    int ord = int.parse(xmlElement.findElements('ORD$level').single.text);
    String cor = xmlElement.findElements('COR$level').single.text;
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);
    String? sigla = level == 2 ? xmlElement.findElements('SIGLA').single.text : null;

    List<CatModel> subCats = [];
    var subElements = xmlElement.findElements('CATS${level + 1}');

    print('Creating CatModel with values:');
    print('nom: $nom');
    print('sig: $sig');
    print('emj: $emj');
    print('ord: $ord');
    print('color: $color');
    print('sigla: $sigla');

    print('level: $level');


    if (subElements.isNotEmpty) {
      for (var subElement in subElements.single.findElements('CAT${level + 1}')) {
        print('Processing subelement do level ${level + 1}');
        subCats.add(await _parseCat(subElement, level + 1));
        print('Finished processing subelement do level ${level + 1}');
      }
      print('Finished processing all subelements do level ${level + 1}');
    }

    print('subCats count: ${subCats.length}');



    return CatModel(
      nom: nom,
      sig: sig,
      emj: emj,
      ord: ord,
      color: color,
      sigla: sigla,
      subCats: subCats,
      level: level,
    );
  }
*/

 



