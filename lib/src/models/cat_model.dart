import 'package:flutter/material.dart';
//import 'package:xml/xml.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;


//Versão 2
// IA 13-05 - Adicione um campo 'isExpanded' para controlar a visibilidade das subcategorias.
class CatModel {
  final String nom;
  final String sig;
  final String emj;
  final int ord;
  final Color color;
  final String? sigla;
  final List<CatModel> subCats;
  final int level;
  bool isExpanded; // IA 13-05

  CatModel({
    required this.nom,
    required this.sig,
    required this.emj,
    required this.ord,
    required this.color,
    required this.subCats,
    required this.level,
    this.sigla,
    this.isExpanded = true, // IA 13-05 - Defina 'isExpanded' como verdadeiro por padrão.
  });

  // Função para imprimir os dados do objeto e suas subcategorias
  void printCat() {
    // Imprime os dados da categoria atual
    print('Category: $nom, Sigla: $sig, Emoji: $emj, Order: $ord, Color: $color, Level: $level');

    // Se existirem subcategorias, imprime-as também
    if (subCats.isNotEmpty) {
      print('Subcategories of $nom:');
      for (var subCat in subCats) {
        subCat.printCat(); // Chamada recursiva para imprimir subcategorias
      }
    }
  }

  // Função para encontrar uma categoria pelo código de 5 letras
  static CatModel? findCatBySigla(List<CatModel> categories, String sigla) {
    for (var category in categories) {
      // Verifica se a categoria no nível 0 corresponde à primeira letra da sigla
      if (category.sig == sigla.substring(0, 1)) {
        for (var subCat1 in category.subCats) {
          // Verifica se a subcategoria no nível 1 corresponde às letras 2 e 3 da sigla
          if (subCat1.sig == sigla.substring(1, 3)) {
            for (var subCat2 in subCat1.subCats) {
              // Verifica se a subcategoria no nível 2 corresponde às letras 4 e 5 da sigla
              if (subCat2.sig == sigla.substring(3, 5)) {
                // Retorna a categoria encontrada
                return subCat2;
              }
            }
          }
        }
      }
    }
    // Retorna nulo se não encontrar a categoria
    return null;
  }

}


//Versão 1
/*class Cat {
  final String nom;
  final String sig;
  final String emj;
  final int ord;
  final Color color;
  final String? sigla; // novo campo opcional
  final List<Cat> subCats;
  final int level; // novo campo para identificar o nível

  Cat({
    required this.nom, 
    required  this.sig, 
    required this.emj, 
    required this.ord, 
    required this.color, 
    required this.subCats, 
    required this.level, 
    required this.sigla
  });

  factory Cat.fromXml(XmlElement xmlElement, int level) {
    String cor = xmlElement.findElements('COR').single.text;
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);

    return Cat(
      nom: xmlElement.findElements('NOM${level.toString()}').single.text,
      sig: xmlElement.findElements('SIG${level.toString()}').single.text,
      emj: xmlElement.findElements('EMJ${level.toString()}').single.text,
      ord: int.parse(xmlElement.findElements('ORD${level.toString()}').single.text),
      color: color,
      sigla: level == 2 ? xmlElement.findElements('SIGLA').single.text : null,
      subCats: xmlElement.findElements('CATS${(level + 1).toString()}').isEmpty 
        ? [] 
        : xmlElement.findElements('CATS${(level + 1).toString()}').
            single.findElements('CAT${(level + 1).toString()}').
                map((item) => Cat.fromXml(item, level + 1)).toList(),
      level: level,
    );
  }
}

class CatRoot {
  List<Cat> cats;

  CatRoot({required this.cats});

  factory CatRoot.fromXml(XmlElement xmlElement) {
    return CatRoot(
      cats: xmlElement.findElements('CAT0').map((item) => Cat.fromXml(item, 0)).toList(),
    );
  }
}*/


/*
  factory Cat.fromXml(XmlElement xmlElement, int level) {
    String cor = xmlElement.findElements('COR$level').single.text;
    Color color = Color(int.parse(cor.substring(1, 7), radix: 16) + 0xFF000000);

    return Cat(
      nom: xmlElement.findElements('NOM$level').single.text,
      sig: xmlElement.findElements('SIG$level').single.text,
      emj: xmlElement.findElements('EMJ$level').single.text,
      ord: int.parse(xmlElement.findElements('ORD$level').single.text),
      color: color,
      sigla: level == 2 ? xmlElement.findElements('SIGLA').single.text : null,
      subCats: level < 2 && !xmlElement.findElements('CATS${level + 1}').isEmpty
          ? xmlElement
              .findElements('CATS${level + 1}')
              .single
              .findElements('CAT${level + 1}')
              .map((item) => Cat.fromXml(item, level + 1))
              .toList()
          : [],
      level: level,
    );
  }
}

class CatRoot {
  final List<Cat> cats;

  CatRoot({required this.cats});

  factory CatRoot.fromXml(XmlElement xmlElement) {
    return CatRoot(
      cats: xmlElement.findElements('CAT0').map((item) => Cat.fromXml(item, 0)).toList(),
    );
  }

  static Future<CatRoot> fromUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
      return CatRoot.fromXml(document.findElements('CATS').single);
    } else {
      throw Exception('Failed to load XML data');
    }
  }
}
*/