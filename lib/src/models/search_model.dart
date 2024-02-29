import 'package:hh_2/src/models/ean_model.dart';

class SearchModel extends EanModel {
  String searchType;

  SearchModel({
    this.searchType = "", // category, word, brand, product
    String ean = "",
    String marca = "",
    String link = "",
    String imagem = "",
    String nome = "",
    String sigla = "",
    String sig0 = "",
    String sig1 = "",
    String sig2 = "",
    String sig3 = "",
    String w1 = "",
    String w2 = "",
    String w3 = "",
    String w4 = "",
    String volume = "",
    String unidade = "",
    String preco = "",
    int hintStatus = 0,
  }) : super(
        ean: ean,
        marca: marca,
        link: link,
        imagem: imagem,
        nome: nome,
        sigla: sigla,
        sig0: sig0,
        sig1: sig1,
        sig2: sig2,
        sig3: sig3,
        w1: w1,
        w2: w2,
        w3: w3,
        w4: w4,
        volume: volume,
        unidade: unidade,
        preco: preco,
        hintStatus: hintStatus,
      );
      
 @override
  String toString() {
    switch (this.searchType) {
      case "category":
        return "SearchModel(category ==> sigla: $sigla, sig0: $sig0, sig1: $sig1, sig2: $sig2)";
      case "word":
        return "SearchModel(word ==> w1: $w1, w2: $w2, w3: $w3, w4: $w4)";
      case "brand":
        return "SearchModel(brand ==> marca: $marca)";
      case "product":
        return "SearchModel(nome: $nome)";
      case "prod_cat":
        return "SearchModel(nome: $nome, cat: $sigla)";
      default:
        return "SearchModel(nome: $nome)";
    }
  }
}
