import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
//import '../../../../assets/garbage/category_model.dart';
import 'package:hh_2/src/models/ean_model.dart';
import 'package:hh_2/src/models/price_model.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:hh_2/src/config/common/var/hh_globals.dart';
 

/*
  // GET PRODUCT MODEL VIA XML
  Future<List<EanModel>> getProductModelFromXML(BuildContext context, /*IA*/ String category, /*IA*/ String uf) async {   //, CategoryModel category
    
    String path = "assets/xml/prods/${category}_PRODS.xml"; //IA
    String xmlString = await DefaultAssetBundle.of(context).loadString(path);
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
 
    String path = "assets/xml/prices/P_${category}_$uf.xml";
    String xmlString = await DefaultAssetBundle.of(context).loadString(path);
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

*/

  // GET CATEGORY VIA XML
  /*Future<List<CategoryModel>> getCategoryFromXML(BuildContext context) async {
  
    String path = "assets/xml/db/HH_CATEGORIAS.xml";
    String xmlString = await DefaultAssetBundle.of(context).loadString(path);
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


//String price = filteredPrices.firstWhere((price) => price.ean == ean, orElse: () => PriceModel(ean: ean, price: "0", uf: "")).price;
     
//String path = "assets/xml/prods/${HHGlobals.category.sigla}_PRODS.xml"; //Anterior
//String path = "assets/xml/db/B/BA/CG/BBACG_PRODS.xml";
//String path = "C:/Users/MELHOR/Desktop/HH/XML/B/BA/CG/BBACG_PRODS.xml";

 //Future<List<PriceModel>> getProductPriceFromXML(BuildContext context) async {   //, CategoryModel category
//String path = "assets/xml/prices/P_${HHGlobals.category.sigla}_${HHGlobals.uf}.xml";

  /*var valueofevent = document.getElementById('_EVENTVALIDATION').getAttribute('value');
  var lines = document.findAllElements('line')
    .where((line) => line.getAttribute('id') == '2')
    .toList();*/

/*
 // GET CATEGORY VIA XML
    Future<List<Cat0>> getCatFromXML(BuildContext context) async {
    String xmlString = await DefaultAssetBundle.of(context).loadString("assets/xml/HH_CAT_NESTED.xml");
    //print(xmlString);
    
    final document = xml.XmlDocument.parse(xmlString);

    final listNode = document.findElements("CAT0").first;
    final listCat1 = listCAT0.findElements("CAT1");

    print(cat0);
    final cat1 = cat0.findElements('cat0');


    /*return cat0.map((element){
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
    }).toList();*/
  }



  /*final document = xml.XmlDocument.parse(studentXml);
  final studentsNode = document.findElements('students').first;
  final students = studentsNode.findElements('student');
  for (final student in students) {
    final studentName = student.findElements('studentName').first.text;
    final attendance = student.findElements('attendance').first.text;
    dataList.add({'studentName': studentName, 'attendance': attendance});
  }

  setState(() {
    _students = dataList;
  });*/
*/

/*Future<List<PriceModel>> getProductPriceFromXML(BuildContext context, String category, String uf) async {
  String path = "assets/xml/prices/P_${category}_$uf.xml";

  XmlDocument xmlDoc = XmlDocument.parse(await rootBundle.loadString("assets/prices/P_$category.xml"));
  final elements = xmlDoc.findAllElements("PRICE").toList();

  return elements.map((element) {
    String ean = element.findElements("EAN").first.text;
    String price = element.findElements("PRECO").first.text;

    return PriceModel(ean: ean, price: price, uf: "");
  }).toList();
}*/
  
  
  /*Future<List<PriceModel>> getFilteredPrices(BuildContext context, String category, String uf) async {
    List<PriceModel> prices = await getProductPriceFromXML(context, category, uf);
   return prices.where((price) => price.ean.startsWith(category) && price.uf == uf).toList();
  }*/

  /*Future<List<PriceModel>> getFilteredPrices(BuildContext context, String category, String uf) async {
    List<PriceModel> prices = await getProductPriceFromXML(context, category, uf);
    List<PriceModel> filteredPrices = prices.where((price) => price.ean.startsWith(category) && price.uf == uf).toList();

    print('Filtered prices for category $category and UF $uf: $filteredPrices'); // Adicione esta linha

    return filteredPrices;
  }*/